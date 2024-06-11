
/*  =======================
	   DATABASE CREATION
    ======================= */
USE master

IF EXISTS (
  SELECT name 
    FROM sys.databases 
   WHERE name = 'Escuela'
)
  DROP DATABASE Escuela
GO

CREATE DATABASE Escuela
ON PRIMARY
	(NAME = Escuela,
	  FILENAME = 'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Data\Escuela.mdf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%)
LOG ON
	( NAME = Escuela_log,
	  FILENAME = 'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Data\Escuela_log.ldf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%)
GO

/*  ====================
	   TABLE CREATION
    ==================== */

USE escuela
GO

CREATE TABLE alumno
(
	num_matricula		smallint		NOT NULL
		CONSTRAINT PK_alumno PRIMARY KEY,
	nombre				varchar(50)		NOT NULL,
	direccion			varchar(50)		NULL,
	telefono			char(9)			NOT NULL,
	nombre_padre		varchar(50)		NULL,
	nombre_madre		varchar(50)		NULL,
)

CREATE TABLE asignatura
(
	id_asignatura		smallint		NOT NULL
		CONSTRAINT PK_asignatura PRIMARY KEY,
	nombre				varchar(15)		NOT NULL,
	num_horas			smallint		NOT NULL,
)

CREATE TABLE matricula
(
	num_matricula		smallint		NOT NULL
		CONSTRAINT FK_matricula_alumno
		FOREIGN KEY references alumno,
	id_asignatura		smallint		NOT NULL
		CONSTRAINT FK_matricula_asignatura
		FOREIGN KEY references asignatura,
	nota				smallint		NULL,

	CONSTRAINT PK_matricula
	PRIMARY KEY (num_matricula, id_asignatura),
)

/*  =================
	   DATA INSERT
    ================= */

	-- alumnos
	INSERT INTO alumno
	VALUES (004, 'Samira', 'C/Runaterra', 673445871, 'Intari', NULL)

	INSERT INTO alumno
	VALUES (001, 'Samson', 'C/Basement', 673445871, 'Mother', 'Dad')

	INSERT INTO alumno
	VALUES (002, 'Zote', 'C/Dirtmouth', 634526256, NULL, NULL)

	INSERT INTO alumno
	VALUES (003, 'Hornet', 'C/Deepnest', 675567732, 'Harra', NULL)

	-- asignaturas
	INSERT INTO asignatura
	VALUES (1, 'Matematicas', '260')

	INSERT INTO asignatura
	VALUES (2, 'Literatura', '300')

	INSERT INTO asignatura
	VALUES (3, 'Arte', '150')

	--matriculas
	INSERT INTO matricula
	VALUES (001, 1, 7)
	INSERT INTO matricula
	VALUES (001, 3, null)
	INSERT INTO matricula
	VALUES (001, 3, 5)
	INSERT INTO matricula
	VALUES (002, 4, 5)
	INSERT INTO matricula
	VALUES (001, 2, 5)

	INSERT INTO matricula
	VALUES (002, 1, 5)
	INSERT INTO matricula
	VALUES (002, 2, 8)

	INSERT INTO matricula
	VALUES (003, 2, 6)
	INSERT INTO matricula
	VALUES (003, 3, 10)

/*  =================
	   DATA SELECT
    ================= */

	SELECT * FROM alumno
	SELECT * FROM asignatura
	SELECT * FROM matricula

/*  =================
	   DATA DELETE
    ================= */

	DELETE FROM matricula
	DELETE FROM asignatura
	DELETE FROM alumno 
	