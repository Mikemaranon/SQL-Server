
/*  ===========================================================================
								 EJERCICIO 8: 
		Crear un procedimiento almacenado que nos indique el numero 
		de asignaturas de las que este matriculado un alumno. El
		procedimiento tendra como parametro de entrada el numero de 
		matricula del alumno.Si se indica un numero de matricula el 
		procedimiento imprime por pantalla el numero de asignaturas
		para ese alumno. Si no se indica ningun numero de matricula, 
		el procedimiento imprime el numero de asignaturas en que esta 
		matriculado cada alumno, ayudandose de un cursor.
    =========================================================================== */

	GO
	CREATE PROCEDURE Numero_matriculas
		@nummat int = NULL
	AS
	BEGIN
		IF @nummat IS NOT NULL
			--Totalizar toda la tabla
			SELECT @nummat as matricula_alumno, 
			COUNT(DISTINCT id_asignatura) as asignaturas
			FROM matricula
			WHERE num_matricula = @nummat

		ELSE --Pero si se ha facilitado
			BEGIN
			DECLARE cursorAsignatura CURSOR FOR
			SELECT num_matricula, 
				COUNT(DISTINCT id_asignatura) as asignaturas
				FROM matricula 
				GROUP BY num_matricula
			OPEN cursorAsignatura

			DECLARE @num_mat varchar(11)
			DECLARE @count_asig smallint

			-- realizamos el primer fetsh
			FETCH NEXT FROM cursorAsignatura
			INTO @num_mat, @count_asig
	
			IF @@FETCH_STATUS != 0
				PRINT 'no hay registros de matricula'
			ELSE
			BEGIN
				PRINT 'esta es la lista de alumnos y sus asignaturas'
				PRINT '---------------------------------------------'
				PRINT 'Alumno           Asignaturas'
			END

			-- chequear @@FETCH_STATUS para ver si hay mas filas a recuperar
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT '------------------------------------'
				PRINT @num_mat + '                ' + 
				ISNULL(convert(varchar(10), @count_asig), 'sin asignaturas')
				FETCH NEXT FROM cursorAsignatura
				INTO @num_mat, @count_asig
			END

			CLOSE cursorAsignatura
			DEALLOCATE cursorAsignatura
		END
	END
	GO

	EXECUTE Numero_matriculas @nummat=002

	DROP PROCEDURE Numero_matriculas
