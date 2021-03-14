USE master

GO
DROP TRIGGER IF EXISTS trg_NoNuevoLogin
GO
-- Deshabilitar nuevos logins en una instancia
CREATE OR ALTER TRIGGER trg_NoNuevoLogin
ON ALL SERVER
FOR CREATE_LOGIN -- Setnencia a controlar (Puede haber más de una)
AS
	PRINT 'No se puede crear login'
	ROLLBACK TRAN --Cancela la acción, si no hubiese un rollback, se podría crear igual aunque saliese el mensaje
GO

USE TiendaDeInstrumentos
GO

CREATE OR ALTER TRIGGER trg_PrevenidoBorrado
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
	RAISERROR('No se puede borrar o modificar tablas',16,3)
	ROLLBACK TRAN;
GO

DROP TABLE EnReparacion
GO

USE TiendaDeInstrumentos
GO

CREATE OR ALTER TRIGGER tr_Gui
ON EnReparacion
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS	(SELECT Nombre
				FROM Inserted
				WHERE LEFT(Nombre, 3) = 'Gui'
				)

		INSERT INTO EnReparacion
			(ID, Nombre, F_Inicio, F_Final,Reparadores_ID)
			SELECT ID, REPLACE(Nombre, 'Gui', 'Guitarra'), F_Inicio, F_Final,Reparadores_ID
			FROM Inserted
	ELSE
		INSERT INTO EnReparacion
			(ID, Nombre, F_Inicio, F_Final,Reparadores_ID)
			SELECT ID, Nombre, F_Inicio, F_Final,Reparadores_ID
			FROM Inserted
END
GO

DECLARE @Reparadores uniqueidentifier
SET @Reparadores = (SELECT ID
FROM Reparadores
WHERE Nombre = 'Carlos')

INSERT INTO EnReparacion
(ID,Nombre,F_Inicio,F_Final,Reparadores_ID)
VALUES
(NEWID(),'Gui Espanola', '2019-03-03', '2019-04-04',@Reparadores)
GO

SELECT * FROM EnReparacion
GO