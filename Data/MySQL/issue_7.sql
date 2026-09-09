USE Enterprise;

-- Drop procedure if exists
DROP PROCEDURE IF EXISTS ReportBySumbit;
DROP PROCEDURE IF EXISTS GetAuthorizationListByUser;
DROP PROCEDURE IF EXISTS GetRoleListByUser;
DROP PROCEDURE IF EXISTS GetWeeklyReport;
DROP PROCEDURE IF EXISTS GetWeeklyReportListByPerson;
DROP PROCEDURE IF EXISTS GetWeeklyReportListByWorkType;
DROP PROCEDURE IF EXISTS GetWeeklyReportListByOrganization;
DROP PROCEDURE IF EXISTS GetWeeklyReportForCheck;
DROP PROCEDURE IF EXISTS ReportByOrganization;
DROP PROCEDURE IF EXISTS GetUser;
DROP PROCEDURE IF EXISTS GetUserList;
DROP PROCEDURE IF EXISTS GetUserWrapperList;
DROP PROCEDURE IF EXISTS GetCheckRelationList;
DROP PROCEDURE IF EXISTS GetCheckStaffList;
DROP PROCEDURE IF EXISTS GetUserListByRoleId;

-- Create stored procedure for MySQL 5.7 (without recursive CTE)
-- Note: MySQL 8.0+ can use WITH RECURSIVE syntax
DELIMITER $$

CREATE PROCEDURE ReportBySumbit(
    IN domainId VARCHAR(36),
    IN organizationId VARCHAR(36),
    IN `year` INT,
    IN weekOfYear INT
)
BEGIN
    -- Use nested queries instead of recursive CTE (MySQL 5.7 compatible)
    SELECT
        `User`.Id,
        `User`.Name,
        org.Name AS OrganizationName,
        org.Id AS OrganizationId,
        tWeeklyReport.Id AS WeeklyReportId
    FROM (
        SELECT * FROM WeeklyReport
        WHERE Domain = BINARY domainId
        AND Year = `year` AND WeekOfYear = weekOfYear
    ) tWeeklyReport
    RIGHT JOIN `User` ON `User`.Id = tWeeklyReport.User
    INNER JOIN Organization org ON `User`.Organization = org.Id
    WHERE `User`.Domain = BINARY domainId
    AND `User`.Removed = 0
    ORDER BY org.Sort ASC;
END$$

-- GetAuthorizationListByUser - 获取用户权限列表
-- 修复字符集问题，使用 BINARY 强制二进制比较
CREATE PROCEDURE GetAuthorizationListByUser(
    IN userId VARCHAR(36)
)
BEGIN
    SELECT DISTINCT ra.AuthorizationKey
    FROM RoleAuthorization ra
    INNER JOIN RoleUser ru ON ra.Role = ru.Role AND ra.Domain = ru.Domain
    WHERE BINARY ru.User = userId;
END$$

-- GetRoleListByUser - 获取用户角色列表
CREATE PROCEDURE GetRoleListByUser(
    IN userId VARCHAR(36)
)
BEGIN
    SELECT r.Id, r.Domain, r.Name
    FROM Role r
    INNER JOIN RoleUser ru ON r.Id = ru.Role AND r.Domain = ru.Domain
    WHERE BINARY ru.User = userId;
END$$

-- GetWeeklyReport - 获取周报及其明细
-- 返回两个结果集：第一个是周报主表，第二个是周报明细
CREATE PROCEDURE GetWeeklyReport(
    IN `user` CHAR(36),
    IN `year` INT,
    IN weekOfYear INT
)
BEGIN
    -- 第一个结果集：周报主表
    SELECT Id, Domain, User, Year, Month, WeekOfYear, Monday, Sunday, Checked, Checker, CheckRemark
    FROM WeeklyReport
    WHERE User = BINARY `user` AND Year = `year` AND WeekOfYear = weekOfYear;

    -- 第二个结果集：周报明细
    SELECT Id, Domain, Organization, User, Year, Month, WeekOfYear, Monday, Sunday,
           WeeklyReport, WorkType, WorkTask, Content, Status, Time, Date, Remark, Sort
    FROM WeeklyReportItem
    WHERE User = BINARY `user` AND Year = `year` AND WeekOfYear = weekOfYear
    ORDER BY Sort ASC;
END$$

-- GetWeeklyReportListByPerson - 按人员获取周报列表
CREATE PROCEDURE GetWeeklyReportListByPerson(
    IN userId CHAR(36),
    IN startYear INT,
    IN startMonth INT,
    IN endYear INT,
    IN endMonth INT
)
BEGIN
    SELECT Id, Domain, User, Year, Month, WeekOfYear, Monday, Sunday, Checked, Checker, CheckRemark
    FROM WeeklyReport
    WHERE User = BINARY userId
    AND ((Year = startYear AND Month >= startMonth) OR Year > startYear)
    AND ((Year = endYear AND Month <= endMonth) OR Year < endYear)
    ORDER BY Year DESC, Month DESC, WeekOfYear DESC;
END$$

-- GetWeeklyReportListByWorkType - 按工作类型获取周报列表
CREATE PROCEDURE GetWeeklyReportListByWorkType(
    IN domainId CHAR(36),
    IN workType CHAR(36),
    IN workTask CHAR(36),
    IN `year` INT,
    IN weekOfYear INT
)
BEGIN
    SET @sql = 'SELECT wr.Id, wr.Domain, wr.User, wr.Year, wr.Month, wr.WeekOfYear, wr.Monday, wr.Sunday, wr.Checked, wr.Checker, wr.CheckRemark
                FROM WeeklyReport wr
                INNER JOIN WeeklyReportItem wri ON wr.Id = wri.WeeklyReport
                WHERE wr.Domain = BINARY domainId AND wr.Year = `year` AND wr.WeekOfYear = weekOfYear';

    IF workType IS NOT NULL AND workType != '' THEN
        SET @sql = CONCAT(@sql, ' AND wri.WorkType = BINARY workType');
    END IF;

    IF workTask IS NOT NULL AND workTask != '' THEN
        SET @sql = CONCAT(@sql, ' AND wri.WorkTask = BINARY workTask');
    END IF;

    SET @sql = CONCAT(@sql, ' GROUP BY wr.Id ORDER BY wr.User');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

-- GetWeeklyReportListByOrganization - 按组织获取周报列表
-- 返回两个结果集：第一个是周报主表，第二个是周报明细
CREATE PROCEDURE GetWeeklyReportListByOrganization(
    IN domainId CHAR(36),
    IN organizationId CHAR(36),
    IN `year` INT,
    IN weekOfYear INT
)
BEGIN
    -- 第一个结果集：周报主表
    SELECT DISTINCT wr.Id, wr.Domain, wr.User, wr.Year, wr.Month, wr.WeekOfYear, wr.Monday, wr.Sunday, wr.Checked, wr.Checker, wr.CheckRemark
    FROM WeeklyReport wr
    INNER JOIN WeeklyReportItem wri ON wr.Id = wri.WeeklyReport
    WHERE wr.Domain = BINARY domainId AND wr.Year = `year` AND wr.WeekOfYear = weekOfYear
    AND wri.Organization = BINARY organizationId
    ORDER BY wr.User;

    -- 第二个结果集：周报明细
    SELECT wri.Id, wri.Domain, wri.Organization, wri.User, wri.Year, wri.Month, wri.WeekOfYear, wri.Monday, wri.Sunday,
           wri.WeeklyReport, wri.WorkType, wri.WorkTask, wri.Content, wri.Status, wri.Time, wri.Date, wri.Remark, wri.Sort
    FROM WeeklyReportItem wri
    INNER JOIN WeeklyReport wr ON wri.WeeklyReport = wr.Id
    WHERE wr.Domain = BINARY domainId AND wr.Year = `year` AND wr.WeekOfYear = weekOfYear
    AND wri.Organization = BINARY organizationId
    ORDER BY wri.Sort ASC;
END$$

-- GetWeeklyReportForCheck - 获取待审核周报列表
-- 返回两个结果集：第一个是周报主表，第二个是周报明细
CREATE PROCEDURE GetWeeklyReportForCheck(
    IN domainId CHAR(36),
    IN checkerId CHAR(36),
    IN `year` INT,
    IN weekOfYear INT,
    IN checked INT
)
BEGIN
    -- 第一个结果集：周报主表
    SELECT DISTINCT wr.Id, wr.Domain, wr.User, wr.Year, wr.Month, wr.WeekOfYear, wr.Monday, wr.Sunday, wr.Checked, wr.Checker, wr.CheckRemark
    FROM WeeklyReport wr
    INNER JOIN WeeklyReportItem wri ON wr.Id = wri.WeeklyReport
    WHERE wr.Domain = BINARY domainId AND wr.Year = `year` AND wr.WeekOfYear = weekOfYear;

    -- 第二个结果集：周报明细
    SELECT wri.Id, wri.Domain, wri.Organization, wri.User, wri.Year, wri.Month, wri.WeekOfYear, wri.Monday, wri.Sunday,
           wri.WeeklyReport, wri.WorkType, wri.WorkTask, wri.Content, wri.Status, wri.Time, wri.Date, wri.Remark, wri.Sort
    FROM WeeklyReportItem wri
    INNER JOIN WeeklyReport wr ON wri.WeeklyReport = wr.Id
    WHERE wr.Domain = BINARY domainId AND wr.Year = `year` AND wr.WeekOfYear = weekOfYear
    ORDER BY wri.User, wri.Sort ASC;
END$$

-- ReportByOrganization - 按组织汇总周报
CREATE PROCEDURE ReportByOrganization(
    IN domainId CHAR(36),
    IN organizationId CHAR(36),
    IN startYear INT,
    IN startMonth INT,
    IN endYear INT,
    IN endMonth INT
)
BEGIN
    SELECT wr.Year, wr.Month, wr.WeekOfYear,
           wri.Organization, wri.WorkType, wri.WorkTask,
           COUNT(DISTINCT wr.User) AS UserCount,
           SUM(wri.Time) AS TotalTime
    FROM WeeklyReport wr
    INNER JOIN WeeklyReportItem wri ON wr.Id = wri.WeeklyReport
    WHERE wr.Domain = BINARY domainId
    AND wri.Organization = BINARY organizationId
    AND ((wr.Year = startYear AND wr.Month >= startMonth) OR wr.Year > startYear)
    AND ((wr.Year = endYear AND wr.Month <= endMonth) OR wr.Year < endYear)
    GROUP BY wr.Year, wr.Month, wr.WeekOfYear, wri.Organization, wri.WorkType, wri.WorkTask
    ORDER BY wr.Year DESC, wr.Month DESC, wr.WeekOfYear DESC;
END$$

-- GetUser - 获取用户信息
CREATE PROCEDURE GetUser(
    IN id CHAR(36)
)
BEGIN
    SELECT Id, Domain, Organization, Account, Password, Name, Email, Cellphone AS Phone, Removed, NOW() AS CreateTime
    FROM User
    WHERE Id = BINARY id;
END$$

-- GetUserList - 获取用户列表（分页）
-- 参数名必须与 C# 代码传入的一致
-- 返回两个结果集：第一个是用户列表，第二个是总数
CREATE PROCEDURE GetUserList(
    IN domain CHAR(36),
    IN page INT,
    IN pageSize INT,
    IN name VARCHAR(100),
    IN organizationId CHAR(36),
    IN searchOrganization VARCHAR(100)
)
BEGIN
    SET @offset = (page - 1) * pageSize;
    
    -- 第一个结果集：用户列表
    SET @sql = CONCAT('SELECT u.Id, u.Domain, u.Organization, u.Account, u.Name, u.Email, u.Cellphone AS Phone, u.Removed, NOW() AS CreateTime,
                       o.Name AS OrganizationName
                FROM User u
                LEFT JOIN Organization o ON u.Organization = o.Id
                WHERE u.Domain = ''', domain, ''' AND u.Removed = 0');
    
    IF name IS NOT NULL AND name != '' THEN
        SET @sql = CONCAT(@sql, ' AND u.Name LIKE ''%', name, '%''');
    END IF;
    
    IF organizationId IS NOT NULL AND organizationId != '' THEN
        SET @sql = CONCAT(@sql, ' AND u.Organization = ''', organizationId, '''');
    END IF;
    
    SET @sql = CONCAT(@sql, ' ORDER BY u.Account LIMIT ', @offset, ', ', pageSize);
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 第二个结果集：总数
    SET @count_sql = CONCAT('SELECT COUNT(*) FROM User u WHERE u.Domain = ''', domain, ''' AND u.Removed = 0');
    
    IF name IS NOT NULL AND name != '' THEN
        SET @count_sql = CONCAT(@count_sql, ' AND u.Name LIKE ''%', name, '%''');
    END IF;
    
    IF organizationId IS NOT NULL AND organizationId != '' THEN
        SET @count_sql = CONCAT(@count_sql, ' AND u.Organization = ''', organizationId, '''');
    END IF;
    
    PREPARE count_stmt FROM @count_sql;
    EXECUTE count_stmt;
    DEALLOCATE PREPARE count_stmt;
END$$

-- GetUserWrapperList - 获取用户数据包装列表（分页）
-- 返回两个结果集
CREATE PROCEDURE GetUserWrapperList(
    IN domain CHAR(36),
    IN page INT,
    IN pageSize INT,
    IN name VARCHAR(100),
    IN organizationId CHAR(36),
    IN searchOrganization VARCHAR(100)
)
BEGIN
    SET @offset = (page - 1) * pageSize;
    
    -- 第一个结果集：用户列表
    SET @sql = CONCAT('SELECT u.Id, u.Domain, u.Organization, u.Account, u.Name, u.Email, u.Cellphone AS Phone, u.Removed, NOW() AS CreateTime,
                       o.Name AS OrganizationName
                FROM User u
                LEFT JOIN Organization o ON u.Organization = o.Id
                WHERE u.Domain = ''', domain, ''' AND u.Removed = 0');
    
    IF name IS NOT NULL AND name != '' THEN
        SET @sql = CONCAT(@sql, ' AND u.Name LIKE ''%', name, '%''');
    END IF;
    
    IF organizationId IS NOT NULL AND organizationId != '' THEN
        SET @sql = CONCAT(@sql, ' AND u.Organization = ''', organizationId, '''');
    END IF;
    
    SET @sql = CONCAT(@sql, ' ORDER BY u.Account LIMIT ', @offset, ', ', pageSize);
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 第二个结果集：总数
    SET @count_sql = CONCAT('SELECT COUNT(*) FROM User u WHERE u.Domain = ''', domain, ''' AND u.Removed = 0');
    
    IF name IS NOT NULL AND name != '' THEN
        SET @count_sql = CONCAT(@count_sql, ' AND u.Name LIKE ''%', name, '%''');
    END IF;
    
    IF organizationId IS NOT NULL AND organizationId != '' THEN
        SET @count_sql = CONCAT(@count_sql, ' AND u.Organization = ''', organizationId, '''');
    END IF;
    
    PREPARE count_stmt FROM @count_sql;
    EXECUTE count_stmt;
    DEALLOCATE PREPARE count_stmt;
END$$

-- GetCheckRelationList - 获取审核关系列表
CREATE PROCEDURE GetCheckRelationList(
    IN domainId CHAR(36)
)
BEGIN
    SELECT cr.Checker, u.Name AS CheckerName, cr.Staff, us.Name AS StaffName
    FROM CheckRelation cr
    INNER JOIN User u ON cr.Checker = u.Id
    INNER JOIN User us ON cr.Staff = us.Id
    WHERE cr.Domain = BINARY domainId;
END$$

-- GetCheckStaffList - 获取审核员的员工列表
CREATE PROCEDURE GetCheckStaffList(
    IN checkerId CHAR(36)
)
BEGIN
    SELECT cr.Staff AS Id, u.Name AS StaffName, u.Organization
    FROM CheckRelation cr
    INNER JOIN User u ON cr.Staff = u.Id
    WHERE cr.Checker = BINARY checkerId AND u.Removed = 0;
END$$

-- GetUserListByRoleId - 获取角色下的用户列表
CREATE PROCEDURE GetUserListByRoleId(
    IN `role` CHAR(36)
)
BEGIN
    SELECT u.Id, u.Domain, u.Organization, u.Account, u.Name, u.Email, u.Cellphone AS Phone, u.Removed, NOW() AS CreateTime
    FROM User u
    INNER JOIN RoleUser ru ON u.Id = ru.User
    WHERE ru.Role = BINARY `role` AND u.Removed = 0;
END$$

DELIMITER ;