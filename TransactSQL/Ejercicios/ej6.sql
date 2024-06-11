
/*  ===========================================================================
								 EJERCICIO 6: 
		Eliminar la relacion entre las tablas Asignatura y Matricula. 
		Crear un  desencadenador asociado a las inserciones o modificaciones
		de la tabla Matricula, de manera que si no existe la Asignatura
		especificada, no nos permite realizar la accion (Rollback transaction) 
		y nos lo indica con un mensaje.
    =========================================================================== */

	ALTER TABLE matricula 
	DROP CONSTRAINT FK_matricula_asignatura
	 

	-- creacion del trigger para la insercion y actualizacion de la tabla
	-- matricula, para que no pueda a�adir asignaturas inexistentes
	IF OBJECT_ID ('trigger2') IS NOT NULL
	   DROP TRIGGER trigger2
	GO

	CREATE TRIGGER trigger2
	   ON  matricula
	   AFTER INSERT, UPDATE
	AS
		BEGIN
			DECLARE @contador smallint
			-- Ejercicio aqui
			SELECT @contador=COUNT(asignatura.id_asignatura)
			FROM asignatura JOIN inserted
			ON asignatura.id_asignatura = inserted.id_asignatura

			IF (@contador != 0)
				PRINT 'introduciendo las asignaturas'
			ELSE 
				BEGIN
					PRINT 'no existe la asignatura que desea insertar'
					ROLLBACK 
				END
		END
		
/* =========================================================================================
	   							AMPLIACION DEL EJERCICIO 6:
		creacion del trigger para la actualizacion y eliminacion en la tabla asignatura,
		para que no se puedan borrar o editar asignaturas que ya existan en otras tablas.
	========================================================================================*/

	IF OBJECT_ID ('trigger3') IS NOT NULL
	   DROP TRIGGER trigger3
	GO

	CREATE TRIGGER trigger3
	   ON  asignatura
	   AFTER DELETE, UPDATE
	AS
		BEGIN
			DECLARE @contador smallint
			-- Ejercicio aqu�
			SELECT @contador=COUNT(matricula.id_asignatura)
			FROM matricula JOIN deleted
			ON matricula.id_asignatura = deleted.id_asignatura

			IF (@contador != 0)
				BEGIN
				PRINT 'la asignatura ya se esta impartiendo, no se puede borrar'
				ROLLBACK
				END
			ELSE 
				BEGIN
					PRINT 'borrando asignaturas'
				END
		END
