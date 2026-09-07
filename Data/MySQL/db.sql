-- MySQL Database Schema for WeeklyReport
-- Compatible with MySQL 5.7+

-- Create database
CREATE DATABASE IF NOT EXISTS Enterprise DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE Enterprise;

-- Drop tables if exists (in reverse order due to foreign keys)
DROP TABLE IF EXISTS WeeklyReportCheckList;
DROP TABLE IF EXISTS WeeklyReportItem;
DROP TABLE IF EXISTS WeeklyReport;
DROP TABLE IF EXISTS UserWorkType;
DROP TABLE IF EXISTS RoleUser;
DROP TABLE IF EXISTS RoleAuthorization;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS CheckPointItem;
DROP TABLE IF EXISTS CheckRelation;
DROP TABLE IF EXISTS CheckPoint;
DROP TABLE IF EXISTS WorkTask;
DROP TABLE IF EXISTS WorkType;
DROP TABLE IF EXISTS WorkStatus;
DROP TABLE IF EXISTS JobLevel;
DROP TABLE IF EXISTS JobTitle;
DROP TABLE IF EXISTS OfficeLocation;
DROP TABLE IF EXISTS Organization;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Domain;

-- Create tables
CREATE TABLE Domain (
    Id CHAR(36) NOT NULL,
    PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE CheckPoint (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE CheckPointItem (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    CheckPoint CHAR(36) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Score INT NOT NULL DEFAULT 0,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_checkpoint (CheckPoint)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE CheckRelation (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Checker CHAR(36) NOT NULL,
    Staff CHAR(36) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_checker (Checker),
    INDEX idx_staff (Staff)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Feedback (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    User CHAR(36) NOT NULL,
    IP VARCHAR(50) NOT NULL,
    Time DATETIME NOT NULL,
    Name VARCHAR(50) DEFAULT NULL,
    Contact VARCHAR(100) DEFAULT NULL,
    Content VARCHAR(2000) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_user (User)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE JobLevel (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE JobTitle (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE OfficeLocation (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Organization (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Parent CHAR(36) DEFAULT NULL,
    Name VARCHAR(100) NOT NULL,
    Telphone VARCHAR(100) DEFAULT NULL,
    Sort INT NOT NULL DEFAULT 0,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_parent (Parent)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Role (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE RoleAuthorization (
    Domain CHAR(36) NOT NULL,
    Role CHAR(36) NOT NULL,
    AuthorizationKey VARCHAR(100) NOT NULL,
    INDEX idx_domain (Domain),
    INDEX idx_role (Role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE RoleUser (
    Domain CHAR(36) NOT NULL,
    Role CHAR(36) NOT NULL,
    User CHAR(36) NOT NULL,
    INDEX idx_domain (Domain),
    INDEX idx_role (Role),
    INDEX idx_user (User)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE User (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Organization CHAR(36) NOT NULL,
    Account VARCHAR(100) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Number VARCHAR(50) DEFAULT NULL,
    JobTitle CHAR(36) DEFAULT NULL,
    JobLevel CHAR(36) DEFAULT NULL,
    OfficeLocation CHAR(36) DEFAULT NULL,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(200) DEFAULT NULL,
    ExtTelphone VARCHAR(100) DEFAULT NULL,
    Telphone VARCHAR(100) DEFAULT NULL,
    Cellphone VARCHAR(100) DEFAULT NULL,
    Notify TINYINT(1) NOT NULL DEFAULT 0,
    Removed TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_organization (Organization),
    INDEX idx_account (Account)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE UserWorkType (
    Domain CHAR(36) NOT NULL,
    User CHAR(36) NOT NULL,
    WorkType CHAR(36) NOT NULL,
    INDEX idx_domain (Domain),
    INDEX idx_user (User),
    INDEX idx_worktype (WorkType)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE WeeklyReport (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    User CHAR(36) NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    WeekOfYear INT NOT NULL,
    Monday DATETIME NOT NULL,
    Sunday DATETIME NOT NULL,
    Checked TINYINT(1) NOT NULL DEFAULT 0,
    Checker CHAR(36) DEFAULT NULL,
    CheckRemark TEXT DEFAULT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_user (User),
    INDEX idx_year_month_week (Year, Month, WeekOfYear)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE WeeklyReportCheckList (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    User CHAR(36) NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    WeekOfYear INT NOT NULL,
    Monday DATETIME NOT NULL,
    Sunday DATETIME NOT NULL,
    WeeklyReport CHAR(36) NOT NULL,
    CheckPoint CHAR(36) NOT NULL,
    Value CHAR(36) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_user (User),
    INDEX idx_year_month_week (Year, Month, WeekOfYear),
    INDEX idx_weeklyreport (WeeklyReport)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE WeeklyReportItem (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Organization CHAR(36) DEFAULT NULL,
    User CHAR(36) NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    WeekOfYear INT NOT NULL,
    Monday DATETIME NOT NULL,
    Sunday DATETIME NOT NULL,
    WeeklyReport CHAR(36) NOT NULL,
    WorkType CHAR(36) NOT NULL,
    WorkTask CHAR(36) NOT NULL,
    Content TEXT DEFAULT NULL,
    Status CHAR(36) NOT NULL,
    Time DOUBLE NOT NULL,
    Date DATETIME DEFAULT NULL,
    Remark TEXT DEFAULT NULL,
    Sort INT NOT NULL DEFAULT 0,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_user (User),
    INDEX idx_year_month_week (Year, Month, WeekOfYear),
    INDEX idx_weeklyreport (WeeklyReport),
    INDEX idx_worktype (WorkType),
    INDEX idx_worktask (WorkTask),
    INDEX idx_status (Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE WorkStatus (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Sort INT NOT NULL DEFAULT 0,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE WorkTask (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    WorkType CHAR(36) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain),
    INDEX idx_worktype (WorkType)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE WorkType (
    Id CHAR(36) NOT NULL,
    Domain CHAR(36) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id),
    INDEX idx_domain (Domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;