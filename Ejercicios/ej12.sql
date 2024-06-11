
/*  ===========================================================================
								 EJERCICIO 12: 
		Crear una funcion escalar que indicandole el nombre de un alumno 
		nos devuelva su numero de matricula.
    =========================================================================== */

	GO
	CREATE FUNCTION nombre_num_mat (@nombre varchar(50)) 
	RETURNS int
		BEGIN 
			DECLARE @num_mat int
				SELECT @num_mat=num_matricula FROM alumno
				WHERE nombre=@nombre
		RETURN @num_mat
	END
	GO

	DECLARE @var int
	EXECUTE @var=nombre_num_mat @nombre='Bennet'
	PRINT ISNULL(CONVERT(varchar(50), @var), 'el alumno no existe')

	DROP FUNCTION nombre_num_mat

	--si quisieramos devolver todos los resultados
	--con el nombre que le damos

	GO
	CREATE FUNCTION nombre_num_mat_2 (@nombre varchar(50)) 
	RETURNS table
		AS
			RETURN (SELECT num_matricula FROM alumno
			WHERE nombre=@nombre)
	GO

	SELECT * FROM nombre_num_mat_2 ('cyno')

	DROP FUNCTION nombre_num_mat
