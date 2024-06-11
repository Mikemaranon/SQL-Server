
/*  ===========================================================================
							  EJERCICIO 4: (pagina 10 apuntes)
		Modificar el ejercicio anterior de manera que los datos recuperados 
		por el cursor se almacenen en una variable detipo table.
    =========================================================================== */

	DECLARE @Tabla TABLE
		(asignatura varchar(15), nota_media float)


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
			INSERT INTO @Tabla VALUES (@nombre_asignatura, @media)
			FETCH NEXT FROM cursorAsignatura
			INTO @nombre_asignatura, @media
	END
	
	SELECT * FROM @Tabla

	CLOSE cursorAsignatura
	DEALLOCATE cursorAsignatura
	GO
