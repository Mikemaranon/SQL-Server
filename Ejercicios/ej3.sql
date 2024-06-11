
/*  ==========================================================================
								  EJERCICIO 3:
		Cursor para seleccionar nombre asignatura y nota media ordenado 
		por nombre asignatura. Recorrerlo secuencialmente del primer 
		registro al ultimo.
    ========================================================================== */

	DECLARE cursorAsignatura CURSOR FOR
		SELECT nombre, ROUND(AVG(nota), 2) as Nota_media
			FROM asignatura, matricula
			WHERE asignatura.id_asignatura = matricula.id_asignatura
			GROUP BY nombre
    OPEN cursorAsignatura

	DECLARE @nombre_asignatura char(11)
	DECLARE @media smallint

	-- realizamos el primer fetsh
	FETCH NEXT FROM cursorAsignatura
	INTO @nombre_asignatura, @media
	
	IF @@FETCH_STATUS != 0
		PRINT 'no hay registros de matricula'
	ELSE
	BEGIN
		PRINT 'esta es la lista de asignaturas y sus medias'
		PRINT '---------------------------------------------'
		PRINT 'Asignatura        Nota Media'
	END

	-- chequear @@FETCH_STATUS para ver si hay mas filas a recuperar
	WHILE @@FETCH_STATUS = 0
	BEGIN
			PRINT '------------------------------------'
			PRINT @nombre_asignatura + '       ' + 
			ISNULL(convert(varchar(10), @media), 'sin notas')
			FETCH NEXT FROM cursorAsignatura
			INTO @nombre_asignatura, @media
	END

	CLOSE cursorAsignatura
	DEALLOCATE cursorAsignatura
	GO
