
/*  ===========================================================================
								 EJERCICIO 7: 
		Crear ahora un desencadenador asociado a las inserciones o
		modificaciones de la tabla Matricula, de manera que si no
		existe la Asignatura especificada, la insertamos con el 
		codigo que nos indican, nombre 'Desconocido' y numero de
		horas 0. Antes de realizar el ejercicio es necesario que se
		inhabilite (no borrandolo) el trigger del ejercicio anterior, 
		utilizando ALTER TABLE.
    =========================================================================== */
 
	ALTER TABLE matricula
	DISABLE TRIGGER trigger2
	GO 

	IF OBJECT_ID ('trigger3') IS NOT NULL
	DROP TRIGGER trigger3
	GO

	CREATE TRIGGER trigger3
	   ON  matricula
	   AFTER INSERT, UPDATE
	AS
		BEGIN
			DECLARE @contador smallint
			-- Ejercicio aqu�
			SELECT @contador=COUNT(asignatura.id_asignatura)
			FROM asignatura JOIN inserted
			ON asignatura.id_asignatura = inserted.id_asignatura

			IF (@contador != 0)
				PRINT 'introduciendo las asignaturas'
			ELSE 
				BEGIN
					DECLARE @var smallint
					SELECT @var=id_asignatura FROM inserted

					PRINT 'no existe la asignatura que desea insertar'
					INSERT INTO asignatura 
					VALUES (@var, 'Desconocido', 0)

					/* tambien nos sirve lo siguiente:
					
					INSERT INTO asignatura
					SELECT id_asignatura, 'Desconocido', 0
					FROM inserted

					*/
				END
		END
	