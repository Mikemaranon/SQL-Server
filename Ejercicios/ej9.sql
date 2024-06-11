
/*  ===========================================================================
								 EJERCICIO 9: 
		Crear un procedimiento almacenado que nos indique el numero de 
		matriculas realizadas. El procedimiento tendra como parametro 
		de entrada el identificador de una asignatura. Si se indica el 
		identificador de la asignatura, el procedimiento devuelve 
		mediante la instruccion RETURN el numero de alumnos matriculados
		de esa asignatura. Si no se indica ningun identificador de 
		asignatura, el procedimiento devuelve mediante la instruccion 
		RETURN el numero total de matriculas en todas las asignaturas.
    =========================================================================== */

	GO
	CREATE PROCEDURE numero_alumnos
		@id_asig int = NULL
	AS
	BEGIN
		IF @id_asig IS NOT NULL
		BEGIN
			RETURN (SELECT COUNT(num_matricula) as Num_matricula
			FROM matricula
			WHERE @id_asig = id_asignatura)
		END

		ELSE
		BEGIN
			RETURN (SELECT COUNT(num_matricula) as Num_matricula
			FROM matricula)
		END
	END
	GO

	DECLARE @num_mat int
	EXECUTE @num_mat=numero_alumnos @id_asig=2
	PRINT @num_mat
	
	DROP PROCEDURE numero_alumnos
