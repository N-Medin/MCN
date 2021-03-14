USE TiendaDeInstrumentos
GO

INSERT INTO ContinenteFabricacion
(ID, Nombre)
VALUES
(NEWID(),'America')
GO

DECLARE @ContinenteFabricacion uniqueidentifier
SET @ContinenteFabricacion = (SELECT ID
FROM ContinenteFabricacion
WHERE Nombre = 'America')

INSERT INTO PaisFabricacion
(ID, Nombre, ContinenteFabricacion_ID)
VALUES
(NEWID(),'EEUU', @ContinenteFabricacion)
GO

DECLARE @PaisFabricacion uniqueidentifier
SET @PaisFabricacion = (SELECT ID
FROM PaisFabricacion
WHERE Nombre = 'EEUU')

INSERT INTO Marca
(ID,Nombre,PaisFabricacion_ID)
VALUES
(NEWID(),'Gibson',@PaisFabricacion)
GO

INSERT INTO Vendedores
(ID,Nombre,Salario)
VALUES
(NEWID(),'Juan',1200)
GO

INSERT INTO Reparadores
(ID,Nombre,Salario,Puesto)
VALUES
(NEWID(),'Carlos',1500,'Luthier')
GO

INSERT INTO Familia
(ID,Nombre)
VALUES
(NEWID(),'Cuerda pulsada')
GO

INSERT INTO Familia
(ID,Nombre)
VALUES
(NEWID(),'Viento metal')
GO


DECLARE @Familia uniqueidentifier
SET @Familia = (SELECT ID
FROM Familia
WHERE Nombre = 'Cuerda pulsada')

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')


INSERT INTO FamiliaReparadores
(Familia_ID,Reparadores_ID)
VALUES
(@Familia, @Reparadores)
GO


DECLARE @Familia uniqueidentifier
SET @Familia = (SELECT ID
FROM Familia
WHERE Nombre = 'Cuerda pulsada')

DECLARE @Marca uniqueidentifier
SET @Marca = (SELECT ID
FROM Marca
WHERE Nombre = 'Gibson')

INSERT INTO Producto
(ID,Nombre,Precio,Tipo,Marca_ID,Familia_ID)
VALUES
(NEWID(),'SG',1000,'Instrumento',@Marca,@Familia)
GO

DECLARE @Vendedores uniqueidentifier
SET @Vendedores = (SELECT ID
FROM Vendedores
WHERE Nombre = 'Juan')

DECLARE @Producto uniqueidentifier
SET @Producto = (SELECT ID
FROM Producto
WHERE Nombre = 'SG')

INSERT INTO VendedoresProducto
(Producto_ID,Vendedores_ID)
VALUES
(@Producto,@Vendedores)
GO

