USE [master]
GO
/****** Object:  Database [Enterprise]    Script Date: 2017/3/28 9:57:52 ******/
CREATE DATABASE [Enterprise]
GO
ALTER DATABASE [Enterprise] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Enterprise].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Enterprise] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [Enterprise] SET ANSI_NULLS OFF
GO
ALTER DATABASE [Enterprise] SET ANSI_PADDING OFF
GO
ALTER DATABASE [Enterprise] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [Enterprise] SET ARITHABORT OFF
GO
ALTER DATABASE [Enterprise] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [Enterprise] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [Enterprise] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [Enterprise] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [Enterprise] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [Enterprise] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [Enterprise] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [Enterprise] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [Enterprise] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [Enterprise] SET  DISABLE_BROKER
GO
ALTER DATABASE [Enterprise] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [Enterprise] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [Enterprise] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [Enterprise] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [Enterprise] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [Enterprise] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [Enterprise] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [Enterprise] SET RECOVERY FULL
GO
ALTER DATABASE [Enterprise] SET  MULTI_USER
GO
ALTER DATABASE [Enterprise] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [Enterprise] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'Enterprise', N'ON'
GO
USE [Enterprise]
GO
/****** Object:  Table [dbo].[CheckPoint]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckPoint](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CheckPoint] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CheckPointItem]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckPointItem](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[CheckPoint] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Score] [int] NOT NULL,
 CONSTRAINT [PK_CheckPointItem] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CheckRelation]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckRelation](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Checker] [uniqueidentifier] NOT NULL,
	[Staff] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CheckRelation] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Domain]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Domain](
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Domain] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Feedback]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedback](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[User] [uniqueidentifier] NOT NULL,
	[IP] [varchar](50) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Name] [varchar](50) NULL,
	[Contact] [varchar](100) NULL,
	[Content] [varchar](2000) NOT NULL,
 CONSTRAINT [PK_Feedback] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JobLevel]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobLevel](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_JobLevel] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JobTitle]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobTitle](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_JobTitle] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OfficeLocation]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OfficeLocation](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_OfficeLocation] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Organization]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Parent] [uniqueidentifier] NULL,
	[Name] [varchar](100) NOT NULL,
	[Telphone] [varchar](100) NULL,
	[Sort] [int] NOT NULL,
 CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Role]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoleAuthorization]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleAuthorization](
	[Domain] [uniqueidentifier] NOT NULL,
	[Role] [uniqueidentifier] NOT NULL,
	[AuthorizationKey] [varchar](100) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoleUser]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleUser](
	[Domain] [uniqueidentifier] NOT NULL,
	[Role] [uniqueidentifier] NOT NULL,
	[User] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Organization] [uniqueidentifier] NOT NULL,
	[Account] [varchar](100) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Number] [varchar](50) NULL,
	[JobTitle] [uniqueidentifier] NULL,
	[JobLevel] [uniqueidentifier] NULL,
	[OfficeLocation] [uniqueidentifier] NULL,
	[Name] [varchar](50) NOT NULL,
	[Email] [varchar](200) NULL,
	[ExtTelphone] [varchar](100) NULL,
	[Telphone] [varchar](100) NULL,
	[Cellphone] [varchar](100) NULL,
	[Notify] [bit] NOT NULL,
	[Removed] [bit] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserWorkType]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserWorkType](
	[Domain] [uniqueidentifier] NOT NULL,
	[User] [uniqueidentifier] NOT NULL,
	[WorkType] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WeeklyReport]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeeklyReport](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[User] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[WeekOfYear] [int] NOT NULL,
	[Monday] [smalldatetime] NOT NULL,
	[Sunday] [smalldatetime] NOT NULL,
	[Checked] [bit] NOT NULL,
	[Checker] [uniqueidentifier] NULL,
	[CheckRemark] [varchar](max) NULL,
 CONSTRAINT [PK_WeekLog] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WeeklyReportCheckList]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeeklyReportCheckList](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[User] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[WeekOfYear] [int] NOT NULL,
	[Monday] [smalldatetime] NOT NULL,
	[Sunday] [smalldatetime] NOT NULL,
	[WeeklyReport] [uniqueidentifier] NOT NULL,
	[CheckPoint] [uniqueidentifier] NOT NULL,
	[Value] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_WeekLogCheckList] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WeeklyReportItem]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeeklyReportItem](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Organization] [uniqueidentifier] NULL,
	[User] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[WeekOfYear] [int] NOT NULL,
	[Monday] [smalldatetime] NOT NULL,
	[Sunday] [smalldatetime] NOT NULL,
	[WeeklyReport] [uniqueidentifier] NOT NULL,
	[WorkType] [uniqueidentifier] NOT NULL,
	[WorkTask] [uniqueidentifier] NOT NULL,
	[Content] [varchar](max) NULL,
	[Status] [uniqueidentifier] NOT NULL,
	[Time] [float] NOT NULL,
	[Date] [smalldatetime] NULL,
	[Remark] [varchar](max) NULL,
	[Sort] [int] NOT NULL,
 CONSTRAINT [PK_WeekLogItem] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkStatus]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Sort] [int] NOT NULL,
 CONSTRAINT [PK_WorkStatus] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkTask]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkTask](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[WorkType] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_WorkTask] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkType]    Script Date: 2017/3/28 9:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkType](
	[Id] [uniqueidentifier] NOT NULL,
	[Domain] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_WorkType] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[CheckPoint] ADD  CONSTRAINT [DF_CheckPoint_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[CheckPointItem] ADD  CONSTRAINT [DF_CheckPointItem_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[CheckPointItem] ADD  CONSTRAINT [DF_CheckPointItem_Score]  DEFAULT ((0)) FOR [Score]
GO
ALTER TABLE [dbo].[CheckRelation] ADD  CONSTRAINT [DF_CheckRelation_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Domain] ADD  CONSTRAINT [DF_Domain_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Feedback] ADD  CONSTRAINT [DF_Feedback_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[JobTitle] ADD  CONSTRAINT [DF_JobTitle_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Organization] ADD  CONSTRAINT [DF_Organization_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Organization] ADD  CONSTRAINT [DF_Organization_Sort]  DEFAULT ((0)) FOR [Sort]
GO
ALTER TABLE [dbo].[Role] ADD  CONSTRAINT [DF_Role_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_Notify]  DEFAULT ((0)) FOR [Notify]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_Removed]  DEFAULT ((0)) FOR [Removed]
GO
ALTER TABLE [dbo].[WeeklyReport] ADD  CONSTRAINT [DF_WeekLog_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[WeeklyReport] ADD  CONSTRAINT [DF_WeekLog_Checked]  DEFAULT ((0)) FOR [Checked]
GO
ALTER TABLE [dbo].[WeeklyReportCheckList] ADD  CONSTRAINT [DF_WeekLogCheckList_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[WeeklyReportItem] ADD  CONSTRAINT [DF_WeeklyReportItem_Sort]  DEFAULT ((0)) FOR [Sort]
GO
ALTER TABLE [dbo].[WorkStatus] ADD  CONSTRAINT [DF_WorkStatus_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[WorkStatus] ADD  CONSTRAINT [DF_WorkStatus_Sort]  DEFAULT ((0)) FOR [Sort]
GO
ALTER TABLE [dbo].[WorkTask] ADD  CONSTRAINT [DF_WorkTask_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[WorkType] ADD  CONSTRAINT [DF_WorkType_Id]  DEFAULT (newid()) FOR [Id]
GO
USE [master]
GO
ALTER DATABASE [Enterprise] SET  READ_WRITE
GO