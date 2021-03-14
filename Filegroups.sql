USE TiendaDeInstrumentos
GO

ALTER DATABASE TiendaDeInstrumentos
MODIFY FILE
(Name = FGGrupo1File1_dat,
SIZE = 20MB);
GO 

ALTER DATABASE TiendaDeInstrumentos
ADD FILEGROUP FGGrupo3;
GO

ALTER DATABASE TiendaDeInstrumentos
ADD file
( Name = FGGrupo3File1_dat,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\FGGrupo3File1_dat.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB ),
( Name = FGGrupo3File2_dat,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\FGGrupo3File2_dat.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB )
TO FILEGROUP FGGrupo3;
GO

ALTER DATABASE TiendaDeInstrumentos
REMOVE FILEGROUP FGGrupo3
GO 

ALTER DATABASE TiendaDeInstrumentos
REMOVE FILE FGGrupo3File1_dat
GO
ALTER DATABASE TiendaDeInstrumentos
REMOVE FILE FGGrupo3File2_dat
GO