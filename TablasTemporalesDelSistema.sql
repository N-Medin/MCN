

--ALTER TABLE EnReparacionTemp SET (SYSTEM_VERSIONING = OFF)
--GO

--ALTER TABLE EnReparacionTemp DROP PERIOD FOR SYSTEM_TIME
--GO

--DROP TABLE IF EXISTS EnReparacionTemp
--GO
--
--DROP TABLE EnReparacionHistory
--GO

CREATE TABLE EnReparacionTemp
(
	 ID UNIQUEIDENTIFIER PRIMARY KEY NOT NULL , 
     Nombre VARCHAR (50) NOT NULL , 
     Reparadores_ID UNIQUEIDENTIFIER NOT NULL,
	 Reparando bit NOT NULL,
	 F_Inicio datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
     F_Final datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
     PERIOD FOR SYSTEM_TIME (F_Inicio, F_Final)
)
WITH
(
	SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EnReparacionHistory)
);
GO


DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacionTemp
(ID,Nombre,Reparadores_ID,Reparando)
VALUES
(NEWID(),'Guitarra Frankenstrat',@Reparadores,0)
GO

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacionTemp
(ID,Nombre,Reparadores_ID,Reparando)
VALUES
(NEWID(),'Guitarra Stratocaster',@Reparadores,0)
GO

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacionTemp
(ID,Nombre,Reparadores_ID,Reparando)
VALUES
(NEWID(),'Guitarra Superstrat',@Reparadores,0)
GO

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacionTemp
(ID,Nombre,Reparadores_ID,Reparando)
VALUES
(NEWID(),'Guitarra Semihueca',@Reparadores,0)
GO

SELECT * FROM EnReparacionHistory
GO

UPDATE EnReparacionTemp SET Reparando = 0 WHERE Nombre = 'Guitarra Superstrat'
GO

