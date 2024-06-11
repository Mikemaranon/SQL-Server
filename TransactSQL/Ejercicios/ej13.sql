
/*  ===========================================================================
								 EJERCICIO 13: 
		Crear una funcion de tipo tabla en linea que indicandole el nombre
		de un alumno nos devuelve un listado con el nombre de las asignaturas 
		de las que esta matriculado y la nota que ha obtenido en cada una.
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
