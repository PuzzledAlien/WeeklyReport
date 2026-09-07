USE Enterprise;

-- Drop procedure if exists
DROP PROCEDURE IF EXISTS ReportBySumbit;

-- Create stored procedure for MySQL 5.7 (without recursive CTE)
-- Note: MySQL 8.0+ can use WITH RECURSIVE syntax
DELIMITER $$

CREATE PROCEDURE ReportBySumbit(
    IN domainId VARCHAR(36),
    IN organizationId VARCHAR(36),
    IN yearVal INT,
    IN weekOfYearVal INT
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
        WHERE Domain = domainId
        AND Year = yearVal AND WeekOfYear = weekOfYearVal
    ) tWeeklyReport
    RIGHT JOIN `User` ON `User`.Id = tWeeklyReport.User
    INNER JOIN Organization org ON `User`.Organization = org.Id
    WHERE `User`.Domain = domainId
    AND `User`.Removed = 0
    ORDER BY org.Sort ASC;
END$$

DELIMITER ;