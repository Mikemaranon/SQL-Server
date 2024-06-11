/* ejercicio 1 */
USE Biblioteca

/* Ejercicio 2 */
	SELECT * FROM lector_adulto 
	WHERE (edad=25)
-----------------------------------------------
	SELECT *
	FROM lector_adulto
	WHERE edad > 25 AND nombre != 'Lector4'

	SELECT nombre, edad
	FROM lector_adulto
-----------------------------------------------
	SELECT *  
	FROM lector_infantil WHERE NOT edad=5 
	union
	SELECT *
	FROM lector_adulto WHERE NOT edad=5
-----------------------------------------------
	SELECT *
	FROM lector_adulto
	WHERE edad > 30 AND num_lector NOT IN (
		SELECT num_lector
		FROM investigador
	)
-----------------------------------------------
	SELECT *
	FROM investigador, libro
	
	SELECT *
	FROM lector_adulto
	WHERE num_lector IN (
		SELECT num_lector
		FROM investigador
	)
----------------------------------------------
/* los demas ejemplos son combinaciones asi que los he 
desarrollado en el ejercicio 23 */

/* Ejercicio 3 */
	SELECT * 
	INTO #tabla_temporal 
	FROM lector_adulto
	WHERE (edad>30) AND (edad<50)
--  WHERE edad BETWEEN 30 AND 50

	SELECT * FROM #tabla_temporal

/* ejercicio 4 */
	SELECT *
	FROM lector_adulto
	WHERE num_lector IN (SELECT num_lector
	FROM investigador)

/* ejercicio 5 */
	SELECT nombre, 2*edad AS doble_edad
	FROM lector_infantil

/* ejercicio 6 */
	SELECT *  
	FROM lector_infantil WHERE NOT edad=5 
	union
	SELECT *
	FROM lector_adulto WHERE NOT edad=5
	
	SELECT *
	FROM lector_adulto
	union ALL --para ver registros duplicados
	SELECT * 
	FROM investigador

	SELECT *
	FROM investigador
	Intersect
	/* WHERE num_lector IN (SELECT num_lector
	FROM lector_adulto) */
	SELECT *
	FROM lector_adulto

	SELECT *
	FROM lector_adulto
	WHERE edad > 30
	/* AND num_lector NOT IN (SELECT num_lector
	FROM investigador) */
	EXCEPT
	SELECT *
	FROM investigador

/* ejercicio 7 */
	SELECT SUBSTRING(nombre, 3, 2) as caracteres
	FROM lector_infantil 

	-- para coger desde la izquierda
	SELECT LEFT(LTRIM(nombre), 2) as caracteres
	FROM lector_infantil 
	-- para coger desde la derecha
	SELECT RIGHT(RTRIM(nombre), 2) as caracteres
	FROM lector_infantil 

/* ejercicio 8 */
	SELECT LOWER (nombre)
	FROM investigador

/* ejercicio 9 */
	SELECT 'el nombre del lector es' + UPPER (nombre)
	FROM lector_adulto

/* ejercicio 10 */
	SELECT num_lector, cod_libro, DATEDIFF(DAY, fec_prestamo, GETDATE()) AS dias_en_prestamo
	FROM prestamo

	-- cuando ha pasado de un mes a otro te saldra que ha pasado un mes a pesar de
	-- que hayan pasado menos de 30 d�as
	SELECT num_lector, cod_libro, DATEDIFF(MM, fec_prestamo, GETDATE()) as meses_en_prestamo
	, DATEDIFF(DAY, fec_prestamo, GETDATE()) AS dias_en_prestamo
	FROM prestamo

/* ejercicio 11 */
	SELECT *
	FROM prestamo
	WHERE DATEDIFF(MM, fec_prestamo, GETDATE()) > 1

	SELECT *
	FROM prestamo
	WHERE DATEDIFF(DAY, fec_prestamo, GETDATE()) > 30

/* ejercicio 12 */
	SELECT nombre, DATENAME(DD, fec_nac) + ' de ' +
	DATENAME(MONTH, fec_nac) + ' de ' + DATENAME(YEAR, fec_nac) 
	AS fecha_nacimiento
	FROM autor

	SELECT cod_autor, nombre, CONVERT(CHAR, fec_nac, 106) as fecha_nacimiento
	FROM autor
/* ejercicio 13 */ 
	SELECT id_prestamo, fec_prestamo, DATENAME(DD, fec_prestamo) as dia_mes,
	DATENAME(DW, fec_prestamo) as dia_semana, DATEPART(DW, fec_prestamo) as dia_semana
	FROM prestamo

/* ejercicio 14 */
	SELECT nombre, DATENAME(MONTH, fec_nac) AS mes
	FROM autor

/* ejercicio 15 */
	SELECT ('el nombre del lector es ' + nombre) as nombre, 
	('su edad es ' + CONVERT(char(10), edad)) as edad
	FROM lector_adulto

/* ejercicio 16 */
	SELECT COUNT(*) "total de lectores"
	FROM lector_infantil

/* ejercicio 17 */
	SELECT count(*) as num_lectores, edad
	FROM lector_infantil
	GROUP BY edad

/* ejercicio 18 */
	SELECT COUNT(DISTINCT edad)"cantidad de edades"
	FROM lector_infantil

/* ejercicio 19.a */
	SELECT AVG(DISTINCT CONVERT(float, edad))"media de edades distintas"
	FROM lector_infantil

/* ejercicio 19.b */
	SELECT AVG(ALL CONVERT(float, edad))"media de edades totales"
	FROM lector_infantil

/* ejercicio 20 */
	SELECT *
	FROM lector_adulto
	WHERE edad in (SELECT MAX(edad)
	FROM lector_adulto)

/* ejercicio 21 */
	SELECT edad
	FROM lector_infantil
	WHERE edad IN (SELECT edad
	FROM lector_infantil
	WHERE edad < 6) 
	GROUP BY edad

	SELECT COUNT(*) as num_lector, edad
	FROM lector_infantil
	WHERE edad<6
	GROUP BY edad

/* ejercicio 22 */
	SELECT COUNT(edad)
	FROM lector_infantil
	WHERE edad IN (SELECT MIN(edad) 
	FROM lector_infantil)

/* ejercicio 23 */
------------------------- a
	SELECT *
	FROM libro INNER JOIN autor
------------------------- b
	SELECT *
	FROM lector_adulto
	WHERE num_lector in (SELECT num_lector
	FROM prestamo)
------------------------- c
	SELECT *
	FROM lector_adulto INNER JOIN prestamo
------------------------- d
	SELECT *
	FROM prestamo INNER JOIN libro
	