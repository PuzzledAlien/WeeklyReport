USE [Enterprise]
GO
/****** Object:  StoredProcedure [dbo].[ReportBySumbit]    Script Date: 2020/9/24 17:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ReportBySumbit]
	@domainId uniqueidentifier,
	@organizationId uniqueidentifier,
	@year int,
	@weekOfYear int
AS
BEGIN
	SET NOCOUNT ON;

	;with cte_Organization(Id,Name,parent,Sort,level)
	as
	(
		select Id,Name,parent,Sort,0 as level
		from dbo.Organization
		where id = @organizationId
		union all
		select a.Id,a.Name,a.parent,a.Sort,level+1
		from Organization a
		inner join
		cte_Organization b
		on ( a.parent=b.id)
	)

   SELECT [User].[Id],[User].[Name],
	cte_Organization.[Name] AS [OrganizationName],cte_Organization.[Id] AS [OrganizationId],
	tWeeklyReport.[Id] AS [WeeklyReportId]  FROM(
		SELECT * FROM [WeeklyReport]
		WHERE [Domain]=@domainId
		AND [YEAR] = @year AND [WeekOfYear] = @weekOfYear
	) tWeeklyReport
	RIGHT JOIN [User]
	ON [User].[Id] = tWeeklyReport.[User]
	INNER JOIN cte_Organization
	ON [User].[Organization]= cte_Organization.[Id]
	WHERE [User].[Domain]=@domainId
	AND [User].[Removed]=0
ORDER BY cte_Organization.Sort ASC
END
GO

-- =============================================
-- GetAuthorizationListByUser - 获取用户权限列表
-- =============================================
ALTER PROCEDURE [dbo].[GetAuthorizationListByUser]
	@userId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT ra.AuthorizationKey
	FROM RoleAuthorization ra
	INNER JOIN RoleUser ru ON ra.Role = ru.Role AND ra.Domain = ru.Domain
	WHERE ru.User = @userId;
END
GO

-- =============================================
-- GetRoleListByUser - 获取用户角色列表
-- =============================================
ALTER PROCEDURE [dbo].[GetRoleListByUser]
	@userId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	SELECT r.Id, r.Domain, r.Name
	FROM Role r
	INNER JOIN RoleUser ru ON r.Id = ru.Role AND r.Domain = ru.Domain
	WHERE ru.User = @userId;
END
GO

-- =============================================
-- GetWeeklyReport - 获取周报及其明细
-- 返回两个结果集：第一个是周报主表，第二个是周报明细
-- =============================================
ALTER PROCEDURE [dbo].[GetWeeklyReport]
	@user uniqueidentifier,
	@year int,
	@weekOfYear int
AS
BEGIN
	SET NOCOUNT ON;

	-- 第一个结果集：周报主表
	SELECT Id, Domain, User, Year, Month, WeekOfYear, Monday, Sunday, Checked, Checker, CheckRemark
	FROM WeeklyReport
	WHERE [User] = @user AND Year = @year AND WeekOfYear = @weekOfYear;

	-- 第二个结果集：周报明细
	SELECT Id, Domain, Organization, User, Year, Month, WeekOfYear, Monday, Sunday,
		   WeeklyReport, WorkType, WorkTask, Content, Status, Time, Date, Remark, Sort
	FROM WeeklyReportItem
	WHERE [User] = @user AND Year = @year AND WeekOfYear = @weekOfYear
	ORDER BY Sort ASC;
END
GO

-- =============================================
-- GetWeeklyReportListByPerson - 按人员获取周报列表
-- =============================================
ALTER PROCEDURE [dbo].[GetWeeklyReportListByPerson]
	@userId uniqueidentifier,
	@startYear int,
	@startMonth int,
	@endYear int,
	@endMonth int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Id, Domain, User, Year, Month, WeekOfYear, Monday, Sunday, Checked, Checker, CheckRemark
	FROM WeeklyReport
	WHERE [User] = @userId
	AND ((Year = @startYear AND Month >= @startMonth) OR Year > @startYear)
	AND ((Year = @endYear AND Month <= @endMonth) OR Year < @endYear)
	ORDER BY Year DESC, Month DESC, WeekOfYear DESC;
END
GO

-- =============================================
-- GetWeeklyReportListByWorkType - 按工作类型获取周报列表
-- =============================================
ALTER PROCEDURE [dbo].[GetWeeklyReportListByWorkType]
	@domainId uniqueidentifier,
	@workType uniqueidentifier,
	@workTask uniqueidentifier,
	@year int,
	@weekOfYear int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT wr.Id, wr.Domain, wr.User, wr.Year, wr.Month, wr.WeekOfYear, wr.Monday, wr.Sunday, wr.Checked, wr.Checker, wr.CheckRemark
	FROM WeeklyReport wr
	INNER JOIN WeeklyReportItem wri ON wr.Id = wri.WeeklyReport
	WHERE wr.Domain = @domainId AND wr.Year = @year AND wr.WeekOfYear = @weekOfYear
	AND (@workType IS NULL OR wri.WorkType = @workType)
	AND (@workTask IS NULL OR wri.WorkTask = @workTask)
	GROUP BY wr.Id, wr.Domain, wr.User, wr.Year, wr.Month, wr.WeekOfYear, wr.Monday, wr.Sunday, wr.Checked, wr.Checker, wr.CheckRemark
	ORDER BY wr.User;
END
GO

-- =============================================
-- GetWeeklyReportListByOrganization - 按组织获取周报列表
-- 返回两个结果集：第一个是周报主表，第二个是周报明细
-- =============================================
ALTER PROCEDURE [dbo].[GetWeeklyReportListByOrganization]
	@domainId uniqueidentifier,
	@organizationId uniqueidentifier,
	@year int,
	@weekOfYear int
AS
BEGIN
	SET NOCOUNT ON;

	-- 第一个结果集：周报主表
	SELECT DISTINCT wr.Id, wr.Domain, wr.User, wr.Year, wr.Month, wr.WeekOfYear, wr.Monday, wr.Sunday, wr.Checked, wr.Checker, wr.CheckRemark
	FROM WeeklyReport wr
	INNER JOIN WeeklyReportItem wri ON wr.Id = wri.WeeklyReport
	WHERE wr.Domain = @domainId AND wr.Year = @year AND wr.WeekOfYear = @weekOfYear
	AND wri.Organization = @organizationId
	ORDER BY wr.User;

	-- 第二个结果集：周报明细
	SELECT wri.Id, wri.Domain, wri.Organization, wri.User, wri.Year, wri.Month, wri.WeekOfYear, wri.Monday, wri.Sunday,
		   wri.WeeklyReport, wri.WorkType, wri.WorkTask, wri.Content, wri.Status, wri.Time, wri.Date, wri.Remark, wri.Sort
	FROM WeeklyReportItem wri
	INNER JOIN WeeklyReport wr ON wri.WeeklyReport = wr.Id
	WHERE wr.Domain = @domainId AND wr.Year = @year AND wr.WeekOfYear = @weekOfYear
	AND wri.Organization = @organizationId
	ORDER BY wri.Sort ASC;
END
GO

-- =============================================
-- GetWeeklyReportForCheck - 获取待审核周报列表
-- 返回两个结果集：第一个是周报主表，第二个是周报明细
-- =============================================
ALTER PROCEDURE [dbo].[GetWeeklyReportForCheck]
	@domainId uniqueidentifier,
	@checkerId uniqueidentifier,
	@year int,
	@weekOfYear int,
	@checked int
AS
BEGIN
	SET NOCOUNT ON;

	-- 第一个结果集：周报主表
	SELECT DISTINCT wr.Id, wr.Domain, wr.User, wr.Year, wr.Month, wr.WeekOfYear, wr.Monday, wr.Sunday, wr.Checked, wr.Checker, wr.CheckRemark
	FROM WeeklyReport wr
	INNER JOIN WeeklyReportItem wri ON wr.Id = wri.WeeklyReport
	WHERE wr.Domain = @domainId AND wr.Year = @year AND wr.WeekOfYear = @weekOfYear;

	-- 第二个结果集：周报明细
	SELECT wri.Id, wri.Domain, wri.Organization, wri.User, wri.Year, wri.Month, wri.WeekOfYear, wri.Monday, wri.Sunday,
		   wri.WeeklyReport, wri.WorkType, wri.WorkTask, wri.Content, wri.Status, wri.Time, wri.Date, wri.Remark, wri.Sort
	FROM WeeklyReportItem wri
	INNER JOIN WeeklyReport wr ON wri.WeeklyReport = wr.Id
	WHERE wr.Domain = @domainId AND wr.Year = @year AND wr.WeekOfYear = @weekOfYear
	ORDER BY wri.User, wri.Sort ASC;
END
GO

-- =============================================
-- ReportByOrganization - 按组织汇总周报
-- =============================================
ALTER PROCEDURE [dbo].[ReportByOrganization]
	@domainId uniqueidentifier,
	@organizationId uniqueidentifier,
	@startYear int,
	@startMonth int,
	@endYear int,
	@endMonth int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT wr.Year, wr.Month, wr.WeekOfYear,
		   wri.Organization, wri.WorkType, wri.WorkTask,
		   COUNT(DISTINCT wr.User) AS UserCount,
		   SUM(wri.Time) AS TotalTime
	FROM WeeklyReport wr
	INNER JOIN WeeklyReportItem wri ON wr.Id = wri.WeeklyReport
	WHERE wr.Domain = @domainId
	AND wri.Organization = @organizationId
	AND ((wr.Year = @startYear AND wr.Month >= @startMonth) OR wr.Year > @startYear)
	AND ((wr.Year = @endYear AND wr.Month <= @endMonth) OR wr.Year < @endYear)
	GROUP BY wr.Year, wr.Month, wr.WeekOfYear, wri.Organization, wri.WorkType, wri.WorkTask
	ORDER BY wr.Year DESC, wr.Month DESC, wr.WeekOfYear DESC;
END
GO

-- =============================================
-- GetUser - 获取用户信息
-- =============================================
ALTER PROCEDURE [dbo].[GetUser]
	@id uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Id, Domain, Organization, Account, Password, Name, Email, Cellphone AS Phone, Removed, GETDATE() AS CreateTime
	FROM [User]
	WHERE Id = @id;
END
GO

-- =============================================
-- GetUserList - 获取用户列表（分页）
-- 返回两个结果集：第一个是用户列表，第二个是总数
-- =============================================
ALTER PROCEDURE [dbo].[GetUserList]
	@domain uniqueidentifier,
	@page int,
	@pageSize int,
	@name varchar(100),
	@organizationId uniqueidentifier,
	@searchOrganization varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	-- 第一个结果集：用户列表
	SELECT u.Id, u.Domain, u.Organization, u.Account, u.Name, u.Email, u.Cellphone AS Phone, u.Removed, GETDATE() AS CreateTime,
		   o.Name AS OrganizationName
	FROM [User] u
	LEFT JOIN Organization o ON u.Organization = o.Id
	WHERE u.Domain = @domain AND u.Removed = 0
	AND (@name IS NULL OR @name = '' OR u.Name LIKE '%' + @name + '%')
	AND (@organizationId IS NULL OR u.Organization = @organizationId)
	ORDER BY u.Account
	OFFSET (@page - 1) * @pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;

	-- 第二个结果集：总数
	SELECT COUNT(*) AS Total
	FROM [User] u
	WHERE u.Domain = @domain AND u.Removed = 0
	AND (@name IS NULL OR @name = '' OR u.Name LIKE '%' + @name + '%')
	AND (@organizationId IS NULL OR u.Organization = @organizationId);
END
GO

-- =============================================
-- GetUserWrapperList - 获取用户数据包装列表（分页）
-- 返回两个结果集
-- =============================================
ALTER PROCEDURE [dbo].[GetUserWrapperList]
	@domain uniqueidentifier,
	@page int,
	@pageSize int,
	@name varchar(100),
	@organizationId uniqueidentifier,
	@searchOrganization varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	-- 第一个结果集：用户列表
	SELECT u.Id, u.Domain, u.Organization, u.Account, u.Name, u.Email, u.Cellphone AS Phone, u.Removed, GETDATE() AS CreateTime,
		   o.Name AS OrganizationName
	FROM [User] u
	LEFT JOIN Organization o ON u.Organization = o.Id
	WHERE u.Domain = @domain AND u.Removed = 0
	AND (@name IS NULL OR @name = '' OR u.Name LIKE '%' + @name + '%')
	AND (@organizationId IS NULL OR u.Organization = @organizationId)
	ORDER BY u.Account
	OFFSET (@page - 1) * @pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;

	-- 第二个结果集：总数
	SELECT COUNT(*) AS Total
	FROM [User] u
	WHERE u.Domain = @domain AND u.Removed = 0
	AND (@name IS NULL OR @name = '' OR u.Name LIKE '%' + @name + '%')
	AND (@organizationId IS NULL OR u.Organization = @organizationId);
END
GO

-- =============================================
-- GetCheckRelationList - 获取审核关系列表
-- =============================================
ALTER PROCEDURE [dbo].[GetCheckRelationList]
	@domainId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	SELECT cr.Checker, u.Name AS CheckerName, cr.Staff, us.Name AS StaffName
	FROM CheckRelation cr
	INNER JOIN [User] u ON cr.Checker = u.Id
	INNER JOIN [User] us ON cr.Staff = us.Id
	WHERE cr.Domain = @domainId;
END
GO

-- =============================================
-- GetCheckStaffList - 获取审核员的员工列表
-- =============================================
ALTER PROCEDURE [dbo].[GetCheckStaffList]
	@checkerId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	SELECT cr.Staff AS Id, u.Name AS StaffName, u.Organization
	FROM CheckRelation cr
	INNER JOIN [User] u ON cr.Staff = u.Id
	WHERE cr.Checker = @checkerId AND u.Removed = 0;
END
GO

-- =============================================
-- GetUserListByRoleId - 获取角色下的用户列表
-- =============================================
ALTER PROCEDURE [dbo].[GetUserListByRoleId]
	@role uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	SELECT u.Id, u.Domain, u.Organization, u.Account, u.Name, u.Email, u.Cellphone AS Phone, u.Removed, GETDATE() AS CreateTime
	FROM [User] u
	INNER JOIN RoleUser ru ON u.Id = ru.User
	WHERE ru.Role = @role AND u.Removed = 0;
END
GO