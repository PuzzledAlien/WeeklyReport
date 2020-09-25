USE [Enterprise]
GO
/****** Object:  StoredProcedure [dbo].[ReportBySumbit]    Script Date: 2020/9/24 17:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReportBySumbit]
	-- Add the parameters for the stored procedure here
	@domainId uniqueidentifier,
	@organizationId uniqueidentifier,
	@year int,
	@weekOfYear int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	;with cte_Organization(Id,Name,parent,Sort,level)
	as
	(
		--起始条件
		select Id,Name,parent,Sort,0 as level
		from dbo.Organization
		where id = @organizationId
		union all
		--递归条件
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