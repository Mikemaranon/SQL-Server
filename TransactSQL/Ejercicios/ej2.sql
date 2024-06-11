
/*  ==========================================================================
								  EJERCICIO 2:
		Cursor para seleccionar nombre del alumno, nombre asignatura y 
		nota ordenado secuencialmente por nombre alumno + nombre asignatura. 
		Recorrerlo secuencialmente del ultimo registro al primero.
    ========================================================================== */

	DECLARE cursorAlumnos2 CURSOR FOR
		SELECT alumno.nombre, asignatura.nombre, nota
		 FROM alumno, asignatura, matricula
			WHERE alumno.num_matricula = matricula.num_matricula
			AND matricula.id_asignatura = asignatura.id_asignatura
			ORDER BY alumno.nombre, asignatura.nombre 
    OPEN cursorAlumnos2
	                                                   
	DECLARE @nombre_alumno char(8)
	DECLARE @nombre_asignatura char(8)
	DECLARE @nota smallint

	-- realizamos el primer fetsh
	FETCH NEXT FROM cursorAlumnos2
	INTO @nombre_alumno, @nombre_asignatura, @nota

	IF @@FETCH_STATUS != 0
		PRINT 'no hay registros de matricula'
	ELSE
	BEGIN
		PRINT 'esta es la lista de alumnos y sus notas'
		PRINT '----------------------------------------'
		PRINT 'Alumno       Asignatura       Nota'
	END
	
	-- chequear @@FETCH_STATUS para ver si hay mas filas a recuperar
	WHILE @@FETCH_STATUS = 0
	BEGIN
			--PRINT @num_matricula + ' ' + @nombre
			PRINT '------------------------------------'
			PRINT @nombre_alumno + '      ' + 
			@nombre_asignatura + '       ' + 
			ISNULL(convert(varchar(10),@nota), 'sin nota')
			FETCH NEXT FROM cursorAlumnos2
			INTO @nombre_alumno, @nombre_asignatura, @nota
	END

	CLOSE cursorAlumnos2
	DEALLOCATE cursorAlumnos2
	GO
