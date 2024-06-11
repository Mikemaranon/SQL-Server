
/*  ===========================================================================
								 EJERCICIO 11: 
		Crear un procedimiento almacenado para insertar un nuevo registro 
		en la tabla matr�cula, que tenga como datos de entrada el nombre 
		del alumno, el nombre de la asignatura y la nota obtenida. El 
		procedimiento contendr� las comprobaciones oportunas de modo que los 
		posibles errores de inserci�n sean controlados por el procedimiento.
    =========================================================================== */

	GO
	CREATE PROCEDURE ej11 
		@nombre_alum varchar(50) = NULL,
		@nombre_asig varchar(50) = NULL,
		@nota int = NULL
	AS
	BEGIN
		IF (@nombre_alum IS NOT NULL AND 
		   @nombre_asig IS NOT NULL)
			BEGIN
				declare @cont int
				declare @cont2 int
				declare @num_mat int
				declare @id_asig int

				SELECT @cont=COUNT(num_matricula), @num_mat=num_matricula FROM alumno
				WHERE @nombre_alum = nombre
				GROUP BY num_matricula

				SELECT @cont2=COUNT(id_asignatura), @id_asig=id_asignatura FROM asignatura
				WHERE @nombre_asig = nombre
				GROUP BY id_asignatura

				IF (@cont != 0 and @cont2 != 0)
					BEGIN
					PRINT 'nombre disponible'
					INSERT INTO matricula 
					VALUES (@num_mat, @id_asig, @nota)
					END
				ELSE
					PRINT 'no existe el alumno o la asignatura'
			END
		ELSE
			PRINT 'El nombre del alumno o la asignatura seleccionada no existe'
	END
	GO

	EXECUTE ej11 @nombre_alum='nilou', @nombre_asig='arte', @nota=10
	EXECUTE ej11 @nombre_alum='nilou', @nombre_asig='matematicas'
	--aqu� va a dar error porque no existe la asignatura fisica, no se a�adira
	--a la tabla matricula
	EXECUTE ej11 @nombre_alum='nilou', @nombre_asig='fisica'

	DELETE FROM matricula WHERE num_matricula=005

	--he hecho este select para poder ver con mas claridad en funcion de los nombres 
	--y no en funcion de las claves
	SELECT alumno.nombre as nom_alum, asignatura.nombre as nom_asig, nota 
	FROM matricula, asignatura, alumno
	WHERE matricula.id_asignatura = asignatura.id_asignatura AND 
	matricula.num_matricula = alumno.num_matricula
	 
