
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
	
/*  ==========================================================================
								  EJERCICIO 2:
		Cursor para seleccionar nombre del alumno, nombre asignatura y 
		nota ordenado secuencialmente por nombre alumno + nombre asignatura. 
		Recorrerlo secuencialmente del �ltimo registro al primero.
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

/*  ==========================================================================
								  EJERCICIO 3:
		Cursor para seleccionar nombre asignatura y nota media ordenado 
		por nombre asignatura. Recorrerlo secuencialmente del primer 
		registro al �ltimo.
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

/*  ===========================================================================
								EJERCICIO 5:
		Crear un desencadenador de manera que al insertar o modificar los 
		datos de un alumno inserte en la tabla ControlAlumno el n�mero de 
		matr�cula del alumno insertado o modificado, la fecha de modificaci�n 
		y el usuario que hizo la modificaci�n.
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

/*  ===========================================================================
								 EJERCICIO 6: 
		Eliminar la relaci�n entre las tablas Asignatura y Matr�cula. 
		Crear un  desencadenador asociado a las inserciones o modificaciones
		de la tabla Matricula, de manera que si no existe la Asignatura
		especificada, no nos permite realizar la acci�n (Rollback transaction) 
		y nos lo indica con un mensaje.
    =========================================================================== */

	ALTER TABLE matricula 
	DROP CONSTRAINT FK_matricula_asignatura
	 

	-- creacion del trigger para la insercion y actualizacion de la tabla
	-- matricula, para que no pueda a�adir asignaturas inexistentes
	IF OBJECT_ID ('trigger2') IS NOT NULL
	   DROP TRIGGER trigger2
	GO

	CREATE TRIGGER trigger2
	   ON  matricula
	   AFTER INSERT, UPDATE
	AS
		BEGIN
			DECLARE @contador smallint
			-- Ejercicio aqu�
			SELECT @contador=COUNT(asignatura.id_asignatura)
			FROM asignatura JOIN inserted
			ON asignatura.id_asignatura = inserted.id_asignatura

			IF (@contador != 0)
				PRINT 'introduciendo las asignaturas'
			ELSE 
				BEGIN
					PRINT 'no existe la asignatura que desea insertar'
					ROLLBACK 
				END
		END

/* =========================================================================================
	   							AMPLIACION DEL EJERCICIO 6:
		creacion del trigger para la actualizacion y eliminacion en la tabla asignatura,
		para que no se puedan borrar o editar asignaturas que ya existan en otras tablas.
	========================================================================================*/

	IF OBJECT_ID ('trigger3') IS NOT NULL
	   DROP TRIGGER trigger3
	GO

	CREATE TRIGGER trigger3
	   ON  asignatura
	   AFTER DELETE, UPDATE
	AS
		BEGIN
			DECLARE @contador smallint
			-- Ejercicio aqu�
			SELECT @contador=COUNT(matricula.id_asignatura)
			FROM matricula JOIN deleted
			ON matricula.id_asignatura = deleted.id_asignatura

			IF (@contador != 0)
				BEGIN
				PRINT 'la asignatura ya se esta impartiendo, no se puede borrar'
				ROLLBACK
				END
			ELSE 
				BEGIN
					PRINT 'borrando asignaturas'
				END
		END
/*  ===========================================================================
								 EJERCICIO 7: 
		Crear ahora un desencadenador asociado a las inserciones o
		modificaciones de la tabla Matricula, de manera que si no
		existe la Asignatura especificada, la insertamos con el 
		c�digo que nos indican, nombre 'Desconocido' y n�mero de
		horas 0. Antes de realizar el ejercicio es necesario que se
		inhabilite (no borr�ndolo) el trigger del ejercicio anterior, 
		utilizando ALTER TABLE.
    =========================================================================== */
 
	ALTER TABLE matricula
	DISABLE TRIGGER trigger2
	GO 

	IF OBJECT_ID ('trigger3') IS NOT NULL
	DROP TRIGGER trigger3
	GO

	CREATE TRIGGER trigger3
	   ON  matricula
	   AFTER INSERT, UPDATE
	AS
		BEGIN
			DECLARE @contador smallint
			-- Ejercicio aqu�
			SELECT @contador=COUNT(asignatura.id_asignatura)
			FROM asignatura JOIN inserted
			ON asignatura.id_asignatura = inserted.id_asignatura

			IF (@contador != 0)
				PRINT 'introduciendo las asignaturas'
			ELSE 
				BEGIN
					DECLARE @var smallint
					SELECT @var=id_asignatura FROM inserted

					PRINT 'no existe la asignatura que desea insertar'
					INSERT INTO asignatura 
					VALUES (@var, 'Desconocido', 0)

					/* tambien nos sirve lo siguiente:
					
					INSERT INTO asignatura
					SELECT id_asignatura, 'Desconocido', 0
					FROM inserted

					*/
				END
		END
	
/*  ===========================================================================
								 EJERCICIO 8: 
		Crear un procedimiento almacenado que nos indique el n�mero 
		de asignaturas de las que est� matriculado un alumno. El
		procedimiento tendr� como par�metro de entrada eln�mero de 
		matr�cula del alumno.Si se indica un n�mero de matr�cula el 
		procedimiento imprime por pantalla el n�mero de asignaturas
		para ese alumno. Si no se indica ning�n n�mero de matr�cula, 
		el procedimiento imprime el n�mero de asignaturas en que est� 
		matriculado cada alumno, ayud�ndose de un cursor.
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

/*  ===========================================================================
								 EJERCICIO 9: 
		Crear un procedimiento almacenado que nos indique el numero de 
		matriculas realizadas. El procedimiento tendra como parametro 
		de entrada el identificador de una asignatura. Si se indica el 
		identificador de la asignatura, el procedimiento devuelve 
		mediante la instruccion RETURN el numero de alumnos matriculados
		de esa asignatura. Si no se indica ning�n identificador de 
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
	 

/*  ===========================================================================
								 EJERCICIO 12: 
		Crear una funci�n escalar que indic�ndole el nombre de un alumno 
		nos devuelva su n�mero de matr�cula.
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

/*  ===========================================================================
								 EJERCICIO 13: 
		Crear una funci�n de tipo tabla en l�nea que indic�ndole el nombre
		de un alumno nos devuelve un listado con el nombre de las asignaturas 
		de las que est� matriculado y la nota que ha obtenido en cada una.
    =========================================================================== */

	GO 
	CREATE FUNCTION datos_alumno (@nombre varchar(50)) 
	RETURNS table
		AS
			RETURN (SELECT asignatura.nombre, matricula.nota
			FROM asignatura,matricula, alumno
			WHERE asignatura.id_asignatura = matricula.id_asignatura AND
			alumno.num_matricula = matricula.num_matricula
			AND alumno.nombre = @nombre) 

			/* RETURN (SELECT asignatura.nombre, matricula.nota
			FROM asignatura JOIN matricula on asignatura.id_asignatura = matricula.id_asignatura
			JOIN alumno alumno.num_matricula = matricula.num_matricula
			WHERE  alumno.nombre = @nombre)*/
	GO

	SELECT * FROM datos_alumno ('cyno')

	DROP FUNCTION datos_alumno

/*  ===========================================================================
								 EJERCICIO 14: 
		Crear una funci�n de tipo tabla multisentencia que nos devuelva 
		para cada alumno, su nombre y el n�mero de asignaturas en las 
		que est� matriculado.
    =========================================================================== */

	GO 
	create function func_prueba()
	returns @probando table
		(nombre varchar(50), num_asig smallint)
	as
	begin
		insert into @probando
		select alumno.nombre, count(*)
		from alumno, matricula
		where matricula.num_matricula=alumno.num_matricula
		group by alumno.nombre
	return
	end
	GO

	SELECT * FROM func_prueba()
