/*  ====================================================================
							  EJERCICIO 1:
		Cursor para seleccionar alumnos que no tienen informados 
		los campos Nombre_Padre ni Nombre_Madre. Recorrerlo 
		secuencialmente del primer registro al ultimo.
    ==================================================================== */

	--declaras un cursor
    DECLARE cursorAlumnos CURSOR FOR
	--seleccionas los elementos que el cursos coge
		SELECT num_matricula, nombre FROM alumno
			WHERE nombre_padre IS NULL
			OR nombre_madre IS NULL
			ORDER BY nombre, num_matricula ASC
	--abrimos el cursor
    OPEN cursorAlumnos

	--declaramos variables para almacenar la informacion
	DECLARE @num_matricula smallint
	DECLARE @nombre varchar(50)

	-- realizamos el primer fetsh
	FETCH NEXT FROM cursorAlumnos
	INTO @num_matricula, @nombre

	IF @@FETCH_STATUS != 0
		PRINT 'no hay alumnos con estas condiciones'
	ELSE
	BEGIN
		PRINT 'los alumnos que no tienen informados el nombre de algunos de sus padres son'
		PRINT '------------------------'
		PRINT 'Num_matricula - Nombre'
	END

	-- chequear @@FETCH_STATUS para ver si hay mas filas a recuperar
	WHILE @@FETCH_STATUS = 0
	BEGIN
			--PRINT @num_matricula + ' ' + @nombre
			PRINT '------------------------'
			PRINT convert(varchar(5), @num_matricula) + 
			'               ' + @nombre
			FETCH NEXT FROM cursorAlumnos
			INTO @num_matricula, @nombre
	END
	PRINT '------------------------'

	CLOSE cursorAlumnos
	DEALLOCATE cursorAlumnos
	GO

	DELETE FROM matricula
	DELETE FROM asignatura
	DELETE FROM alumno 
	
