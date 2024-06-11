
/*
	EJERCICIO 1: MIGUEL MARA�ON QUERO
*/

/*  ===================================
	   Creacion de la base de datos
    =================================== */
USE master

IF EXISTS (
  SELECT name 
    FROM sys.databases 
   WHERE name = 'empresa'
)
  DROP DATABASE empresa
GO

CREATE DATABASE empresa
ON PRIMARY
	(NAME = empresa,
	  FILENAME = 'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Data\empresa.mdf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%)
LOG ON
	( NAME = empresa_log,
	  FILENAME = 'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Data\empresa_log.ldf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%)
GO

/*  ========================
	   Creacion de tablas
    ======================== */

USE empresa
GO

CREATE TABLE proveedor
(
	CIF					varchar(10)		NOT NULL
		CONSTRAINT PK_proveedor PRIMARY KEY,
	nombre				varchar(25)		NOT NULL,
	email				varchar(50)		NOT NULL,
)

CREATE TABLE producto
(
	referencia			smallint		NOT NULL
		CONSTRAINT PK_producto PRIMARY KEY,
	denominacion		varchar(50)		NOT NULL,
	stock				smallint		NOT NULL,
	proveedor			varchar(10)		NOT NULL
		CONSTRAINT FK_matricula_alumno
		FOREIGN KEY references proveedor,
	precio				real			NOT NULL,
)
 
/* =====================================
	   Tabla de referencias cruzadas
   =====================================

   ---------------------------------------------------------------------
						 producto		    | 	      proveedor
   ---------------------------------------------------------------------
					| S     U     I     D   |   S     U     I     D
   ---------------------------------------------------------------------
   Gestor			| X	    X	  X	    X   |   X     X     X     X
   ---------------------------------------------------------------------
   Administrativo   | X	    1		 	    |   2                 
   ---------------------------------------------------------------------
   Trabajador       | 3	   		 	        |   4          
   ---------------------------------------------------------------------

   1. solo puede ver el contenido de STOCK y PRECIO
   2. puede ver todo (CIF, NOMBRE) menos EMAIL, crear rol
   3. puede ver todo (REFERENCIA, DENOMINACION, STOCK, PRECIO) 
	  menos PROVEEDOR
   4. puede ver NOMBRE

   Para realizar estos permisos vamos a otorgar lo siguiente
   - Gestor: entrar en roles db_datareader y db_datawriter
   - Administrativo: acceso al rol, el cual tendra permisos SELECT
	 en la tabla PRODUCTO y SELECT en las variables CIF y NOMBRE de 
	 la tabla PROVEEDOR
	 Tambi�n podr� manipular los datos STOCK y PRECIO de la tabla
	 PRODUCTOS
   - Trabajador: tendr� acceso a una vista, la cual imprimir� lo
	 siguiente haciendo una consulta mixta entre ambas tablas 
	 relacionando el CIF del proveedor:
		1. producto.referencia
		2. producto.denominacion
		3. producto.stock
		4. producto.precio
		5. proveedor.nombre

   =====================================
	   creaci�n de inicios de sesi�n
   =====================================*/

   	GO
	USE master
	CREATE LOGIN Administrador WITH PASSWORD='P@ssw0rd'
	CREATE LOGIN Operador WITH PASSWORD='P@ssw0rd'

	GO
	USE master
	CREATE LOGIN Gestor WITH PASSWORD='P@ssw0rd'
	CREATE LOGIN Administrativo WITH PASSWORD='P@ssw0rd'
	CREATE LOGIN Trabajador WITH PASSWORD='P@ssw0rd'

/* =============================
	   creaci�n de usuarios
   =============================*/

    GO
	USE empresa
	CREATE USER Administrador FOR LOGIN Administrador
	ALTER ROLE [db_ddladmin] ADD MEMBER [Administrador]

    GO
	USE empresa
	CREATE USER Operador FOR LOGIN Operador
	ALTER ROLE [db_backupoperator] ADD MEMBER [Operador]

	GO
	USE empresa
	CREATE USER Gestor FOR LOGIN Gestor
	CREATE USER Administrativo FOR LOGIN Administrativo
	CREATE USER Trabajador FOR LOGIN Trabajador

/* ==========================
	   creaci�n de roles
   ==========================*/
   
	GO
	USE empresa
	CREATE ROLE RolAdmin
	GRANT SELECT ON producto TO RolAdmin
	GRANT SELECT ON proveedor (CIF, nombre) TO RolAdmin
	GRANT UPDATE ON producto (stock, precio) TO RolAdmin

/* =============================
	   asignacion de permisos
   =============================*/

    -- a�adimos gestor a db_datareader y db_datawriter
	-- para garantizarle acceso a los 4 permisos requeridos
	GO
	USE empresa
	ALTER ROLE [db_datareader] ADD MEMBER [Gestor]
	ALTER ROLE [db_datawriter] ADD MEMBER [Gestor]

	-- Administrativo ha sido gestionado con un rol
	-- a�adimos al personal administrativo al rol
	ALTER ROLE RolAdmin ADD MEMBER Administrativo

	-- Trabajador solo tiene acceso a la tabla producto 
	-- quitando el proveedor y al nombre del proveedor
	-- de la tabla proveedor
	-- vamos a crear una vista para ello

	GO
	CREATE VIEW vistaProveedor
	AS
		SELECT producto.referencia, producto.denominacion, producto.stock,
		producto.precio, proveedor.nombre 
		FROM producto, proveedor WHERE
		proveedor.CIF = producto.proveedor
	GO

	-- ahora le otorgamos permisos a trabajador para que
	-- pueda visualizar esta vista

	GRANT SELECT ON vistaProveedor TO Trabajador
