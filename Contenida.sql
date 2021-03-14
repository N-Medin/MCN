USE master
GO

EXEC sp_configure 'show advanced options', 1
GO

RECONFIGURE
GO

EXEC sp_configure 'contained database authentication', 1
GO
RECONFIGURE
GO

DROP DATABASE IF EXISTS ContenidaMCN
GO
CREATE DATABASE ContenidaMCN
CONTAINMENT=PARTIAL
GO

USE ContenidaMCN
GO

DROP USER IF EXISTS MCN
GO
CREATE USER MCN
	WITH PASSWORD='abcd1234.',
	DEFAULT_SCHEMA=[dbo]
GO

--EXEC sp_addrolemember 'db_owner', 'MCN'
--GO

ALTER ROLE db_owner
ADD MEMBER MCN
GO

