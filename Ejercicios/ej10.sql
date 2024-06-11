
/*  ===========================================================================
								 EJERCICIO 10: 
		modificar el ejercicio anterior de manera que los resultados se
		devuelvan en un parametro de salida
    =========================================================================== */

	GO
	CREATE PROCEDURE numero_alumnos_2
		@id_asig int = NULL,
		@salida int OUTPUT
	AS
	BEGIN
		IF @id_asig IS NOT NULL
		BEGIN
			SELECT @salida=COUNT(num_matricula)
			FROM matricula
			WHERE @id_asig = id_asignatura
		END

		ELSE
		BEGIN
			SELECT @salida=COUNT(num_matricula)
			FROM matricula
		END
	END
	GO

	DECLARE @num_mat int
	--EXECUTE numero_alumnos_2 @id_asig=2, @salida=@num_mat OUTPUT
	EXECUTE numero_alumnos_2 @salida=@num_mat OUTPUT
	PRINT @num_mat
	
	DROP PROCEDURE numero_alumnos_2
