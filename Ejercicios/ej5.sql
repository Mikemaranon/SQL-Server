
/*  ===========================================================================
								EJERCICIO 5:
		Crear un desencadenador de manera que al insertar o modificar los 
		datos de un alumno inserte en la tabla ControlAlumno el numero de 
		matricula del alumno insertado o modificado, la fecha de modificacion 
		y el usuario que hizo la modificacion.
    =========================================================================== */

	CREATE TABLE controlAlumno 
	(
		num_matricula	smallint		NOT NULL,
		fecha			date			NOT NULL,
		usuario			varchar(50)		NOT NULL,
	)
	
	IF OBJECT_ID ('trigger1') IS NOT NULL
	   DROP TRIGGER trigger1
	GO

	CREATE TRIGGER trigger1
	   ON  matricula
	   AFTER INSERT, UPDATE
	AS
		BEGIN
			INSERT INTO controlAlumno
			SELECT num_matricula, getdate(), suser_sname()
			FROM inserted
		END

	SELECT * FROM controlAlumno
