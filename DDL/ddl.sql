use AlmacenScript

/*  ========================================================
		1. Eliminar el campo email de la tabla PROVEEDOR.
	======================================================== */

	ALTER TABLE proveedor DROP COLUMN email

/*  =================================================================
		2. añadir columna movil la tabla PROVEEDOR con restriccion.
	================================================================= */

	ALTER TABLE proveedor ADD movil CHAR(9)
	ALTER TABLE proveedor ADD CONSTRAINT CK_proveedor_movil CHECK
		(movil like '[67][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

	/*  ALTER TABLE proveedor ADD movil CHAR(9)
		CONSTRAINT CK_proveedor_movil CHECK
		(movil like '[67][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') */


/*  ======================================================
		3. modificar restriccion de la columna telefono.
	====================================================== */

	ALTER TABLE proveedor
	DROP CONSTRAINT CK_proveedor_telefono

	ALTER TABLE proveedor WITH NOCHECK
	ADD CONSTRAINT CK_proveedor_telefono CHECK
		(telefono like '[9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

	/* AMPLIACION: intentar mover los telefonos que no cumplen con
	la restriccion a la columna movil y dejarlos en null. */
	
	BEGIN TRAN
		UPDATE proveedor
		SET movil = telefono
		WHERE telefono like '[67]%'
		GO
		ALTER TABLE proveedor
		ALTER COLUMN telefono char(9) NULL
		GO
		UPDATE proveedor
		SET telefono = NULL
		WHERE telefono like '[67]%'
		GO
	ROLLBACK

		SELECT * FROM proveedor
/*  ==============================================================================
		4. modificar restriccion de la columna descripcion de la tabla articulo.
	============================================================================== */

	ALTER TABLE articulo
	DROP CONSTRAINT CK_articulo_descripcion

	ALTER TABLE articulo 
	ADD CONSTRAINT CK_articulo_descripcion CHECK
		(LEN(descripcion) = 100)
	
/*  =================================================================================
		5. Modificar el tipo del campo numReferenciade la tabla ARTICULO a smallint. 
	================================================================================= */

	BEGIN TRANSACTION

		ALTER TABLE ARTICULO_PEDIDO
		DROP CONSTRAINT FK_AP_ARTICULO

		ALTER TABLE ARTICULO
		DROP CONSTRAINT PK_ARTICULO

		ALTER TABLE ARTICULO ALTER COLUMN 
		numReferencia SMALLINT NOT NULL

		ALTER TABLE ARTICULO_PEDIDO ALTER COLUMN 
		numReferencia SMALLINT NOT NULL

		ALTER TABLE ARTICULO 
		ADD CONSTRAINT PK_ARTICULO PRIMARY KEY(numReferencia)

		ALTER TABLE ARTICULO_PEDIDO
		ADD CONSTRAINT FK_AP_ARTICULO
		FOREIGN KEY(numReferencia) REFERENCES ARTICULO(numReferencia)

	ROLLBACK

/*  =======================================================================================
		6. Añadir el campo sexo a la tabla cliente sin admitir nulos. solo admitira H o M
	======================================================================================= */

	ALTER TABLE cliente ADD sexo char(1) NOT NULL default 'X'
	ALTER TABLE cliente WITH NOCHECK ADD CONSTRAINT CK_cliente_sexo
		CHECK (sexo LIKE '[HM]')

	
/*  ======================================================================================
		7. Modificarla tabla ARTICULO desactivando la restricción que comprueba que la 
		longitud del campo descripcion. Introducir algún registro con longitud de 
		descripción inferior a 5 caracteres. Volver a activar la restricción check sobre 
		descripcion.
	====================================================================================== */

	ALTER TABLE articulo DROP CONSTRAINT CK_articulo_descripcion

	INSERT INTO articulo VALUES (10, 'hola', 500, 7, 12345)

	ALTER TABLE articulo WITH NOCHECK -- para que no de error, de lo contrario diria que
									  -- no podria aceptar los valores que no coincidan que ya existen
		ADD CONSTRAINT CK_articulo_descripcion CHECK
		(LEN(descripcion) = 100)
	