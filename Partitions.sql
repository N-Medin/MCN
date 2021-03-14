use master
GO


--ALTER DATABASE TiendaDeInstrumentos REMOVE FILEGROUP [FG_Archivo] 
GO 
ALTER DATABASE TiendaDeInstrumentos ADD FILEGROUP [FG_Archivo] 
GO 
ALTER DATABASE TiendaDeInstrumentos ADD FILEGROUP [FG_2019] 
GO 
ALTER DATABASE TiendaDeInstrumentos ADD FILEGROUP [FG_2020] 
GO 
ALTER DATABASE TiendaDeInstrumentos ADD FILEGROUP [FG_2021]
GO

USE TiendaDeInstrumentos
GO

select * from sys.filegroups
GO

--ALTER DATABASE TiendaDeInstrumentos REMOVE FILE Reparaciones_Archivo 
GO

ALTER DATABASE TiendaDeInstrumentos ADD FILE ( NAME = 'Reparaciones_Archivo', FILENAME = 'c:\DATA\Reparaciones_Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_Archivo] 
GO
ALTER DATABASE TiendaDeInstrumentos ADD FILE ( NAME = 'Reparaciones_2019', FILENAME = 'c:\DATA\Reparaciones_2019.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2019] 
GO
ALTER DATABASE TiendaDeInstrumentos ADD FILE ( NAME = 'Reparaciones_2020', FILENAME = 'c:\DATA\Reparaciones_2020.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2020] 
GO
ALTER DATABASE TiendaDeInstrumentos ADD FILE ( NAME = 'Reparaciones_2021', FILENAME = 'c:\DATA\Reparaciones_2021.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2021] 
GO


CREATE PARTITION FUNCTION FN_Reparacion_Fecha (datetime) 
AS RANGE RIGHT 
	FOR VALUES ('2019-01-01','2020-01-01')
GO

CREATE PARTITION SCHEME Reparaciones_Fecha 
AS PARTITION FN_Reparacion_Fecha 
	TO (FG_Archivo,FG_2019,FG_2020,FG_2021) 
GO


DROP TABLE IF EXISTS EnReparacion
GO

CREATE TABLE EnReparacion 
    (
     ID UNIQUEIDENTIFIER NOT NULL , 
     Nombre VARCHAR (50) NOT NULL , 
     F_Inicio DATETIME NOT NULL , 
     F_Final DATETIME NOT NULL , 
     Reparadores_ID UNIQUEIDENTIFIER NOT NULL 
    )
	ON Reparaciones_Fecha -- Schema Partition
		(F_Inicio) -- Columna (en este caso de fecha) para aplicar la función
GO


--Insertar datos

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacion
(ID,Nombre,F_Inicio,F_Final,Reparadores_ID)
VALUES
(NEWID(),'Guitarra Frankenstrat', '2019-03-03', '2019-04-04',@Reparadores)
GO

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacion
(ID,Nombre,F_Inicio,F_Final,Reparadores_ID)
VALUES
(NEWID(),'Guitarra Stratocaster', '2018-03-03', '2018-04-04',@Reparadores)
GO

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacion
(ID,Nombre,F_Inicio,F_Final,Reparadores_ID)
VALUES
(NEWID(),'Guitarra Superstrat', '2020-03-03', '2020-04-04',@Reparadores)
GO

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacion
(ID,Nombre,F_Inicio,F_Final,Reparadores_ID)
VALUES
(NEWID(),'Guitarra Semihueca', '2021-03-03', '2021-04-04',@Reparadores)
GO


SELECT *,$Partition.FN_Reparacion_Fecha(F_Inicio) AS Partition
FROM EnReparacion
GO

--Split

ALTER PARTITION FUNCTION FN_Reparacion_Fecha()
	SPLIT RANGE ('2021-01-01'); 
GO

--Merge

ALTER PARTITION FUNCTION FN_Reparacion_Fecha ()
 MERGE RANGE ('2019-01-01'); 
 GO

 --Switch

ALTER DATABASE TiendaDeInstrumentos ADD FILEGROUP [FG_Archivo2] 
GO 

ALTER DATABASE TiendaDeInstrumentos ADD FILE ( NAME = 'Reparaciones_Archivo2', FILENAME = 'c:\DATA\Reparaciones_Archivo2.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_Archivo2] 
GO

DROP TABLE if exists Archivo_Antiguo
GO

CREATE TABLE Archivo_Antiguo 
    (
     ID UNIQUEIDENTIFIER NOT NULL , 
     Nombre VARCHAR (50) NOT NULL , 
     F_Inicio DATETIME NOT NULL , 
     F_Final DATETIME NOT NULL , 
     Reparadores_ID UNIQUEIDENTIFIER NOT NULL 
    )ON FG_Archivo
GO



 ALTER TABLE EnReparacion 
	SWITCH Partition 1 to Archivo_Antiguo
go

SELECT * FROM EnReparacion
GO

DECLARE @TableName NVARCHAR(200) = N'EnReparacion' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--Truncate

TRUNCATE TABLE EnReparacion
	WITH (PARTITIONS (3));
go

