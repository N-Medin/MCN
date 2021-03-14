--

ALTER DATABASE TiendaDeInstrumentos
SET COMPATIBILITY_LEVEL = 140;
GO

ALTER DATABASE TiendaDeInstrumentos
SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON;
GO

ALTER DATABASE TiendaDeInstrumentos
ADD FILEGROUP EnMemoria CONTAINS MEMORY_OPTIMIZED_DATA;
go

ALTER DATABASE TiendaDeInstrumentos
ADD FILE 
	(name='EnMemoria', 
	filename='c:\data\TiendaDeInstrumentos')
	TO FILEGROUP EnMemoria
go

DROP TABLE IF EXISTS EnMemoria
GO

CREATE TABLE EnMemoria
    (
        ID   INTEGER   NOT NULL
            PRIMARY KEY NONCLUSTERED,
		Nombre VARCHAR(50) NOT NULL,
		Apellidos VARCHAR(50) NOT NULL,
		Edad INT NOT NULL
    )
        WITH
            (MEMORY_OPTIMIZED = ON,
            DURABILITY = SCHEMA_AND_DATA);
GO

INSERT INTO EnMemoria
(ID,Nombre, Apellidos,Edad)
VALUES
(6, 'Glenn','Doe',25)
GO