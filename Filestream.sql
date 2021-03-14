EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO

USE TiendaDeInstrumentos
go

--ALTER DATABASE TiendaDeInstrumentos
--REMOVE FILEGROUP [PRIMARY_FILESTREAM]
--GO

--ALTER DATABASE TiendaDeInstrumentos
--REMOVE FILE Imagenes_Productos
--GO

ALTER DATABASE TiendaDeInstrumentos 
	ADD FILEGROUP [PRIMARY_FILESTREAM] 
	CONTAINS FILESTREAM 
GO
ALTER DATABASE TiendaDeInstrumentos
       ADD FILE (
             NAME = 'Imagenes_Productos',
             FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Imagenes_Productos'
       )
       TO FILEGROUP [PRIMARY_FILESTREAM]
GO
USE TiendaDeInstrumentos
GO
DROP TABLE IF EXISTS ImagenesProductos
GO
CREATE TABLE ImagenesProductos(
       id uniqueidentifier ROWGUIDCOL NOT NULL UNIQUE,
       imagen VARBINARY(MAX) FILESTREAM,
	   --CONSTRAINT id PRIMARY KEY NONCLUSTERED (id),
	   --CONSTRAINT ID_Producto FOREIGN KEY (id)
	   --REFERENCES Producto (ID)
	   --ON DELETE CASCADE
	   --ON UPDATE CASCADE 


);
GO

INSERT INTO ImagenesProductos(id, imagen)
		SELECT NEWID(), BulkColumn
		FROM OPENROWSET(BULK 'C:\Imagenes_Productos\GibsonLesPaul.jpg', SINGLE_BLOB) as f;
GO