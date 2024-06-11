
/*  ===========================================================================
								 EJERCICIO 14: 
		Crear una funcion de tipo tabla multisentencia que nos devuelva 
		para cada alumno, su nombre y el numero de asignaturas en las 
		que esta matriculado.
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
