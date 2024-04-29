--Actividad 10

DROP TABLE DatosPersonales CASCADE CONSTRAINTS;
DROP TABLE Telefono CASCADE CONSTRAINTS;
DROP TABLE Correo CASCADE CONSTRAINTS;
DROP TABLE Director CASCADE CONSTRAINTS;
DROP TABLE Comercial CASCADE CONSTRAINTS;
DROP TABLE Oficina CASCADE CONSTRAINTS;
DROP TABLE Vendedor CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Venta CASCADE CONSTRAINTS;
DROP TABLE Tecnico CASCADE CONSTRAINTS;
DROP TABLE TelefonoTecnico CASCADE CONSTRAINTS;
DROP TABLE CorreoTecnico CASCADE CONSTRAINTS;
DROP TABLE Tematica CASCADE CONSTRAINTS;
DROP TABLE Libro CASCADE CONSTRAINTS;
DROP TABLE Autor CASCADE CONSTRAINTS;    
DROP TABLE AutorLibro CASCADE CONSTRAINTS; 
DROP TABLE LineaVenta CASCADE CONSTRAINTS; 
DROP TABLE Edita CASCADE CONSTRAINTS; 

CREATE TABLE DatosPersonales(
    dni NUMBER(8),
    Nombre VARCHAR2(30) NOT NULL,
    prApellido VARCHAR2(30) NOT NULL,
    sgApellido VARCHAR2(30),
    Domicilio VARCHAR2(60) NOT NULL,
    Tipo VARCHAR2(2) NOT NULL,
    CONSTRAINT pk_a10_datospersonales PRIMARY KEY(dni),
    CONSTRAINT ck_a10_tipo CHECK (UPPER(tipo) IN ('DI','CO','VE','CL')));

CREATE TABLE Telefono(
    NumTno NUMBER(9) CHECK(LENGTH (NumTno)=9),
    dni NUMBER(8),
    CONSTRAINT pk_a10_telefono PRIMARY KEY(NumTno),
    CONSTRAINT fk_a10_tele_dp FOREIGN KEY(dni) REFERENCES DatosPersonales(dni));

CREATE TABLE Correo(
    correo VARCHAR2(320),
    dni NUMBER(8),
    CONSTRAINT pk_a10_correo PRIMARY KEY(correo),
    CONSTRAINT fk_a10_correo_dp FOREIGN KEY(dni) REFERENCES DatosPersonales(dni));

CREATE TABLE Director(
    dni NUMBER(8),
    CONSTRAINT pk_a10_director PRIMARY KEY(dni),
    CONSTRAINT fk_a10_dir_dp FOREIGN KEY(dni) REFERENCES DatosPersonales(dni));
    
CREATE TABLE Comercial(
    dni NUMBER(8),
    comision NUMBER(3,1) NOT NULL,
    CONSTRAINT pk_a10_comercial PRIMARY KEY(dni),
    CONSTRAINT fk_a10_com_dp FOREIGN KEY(dni) REFERENCES DatosPersonales(dni));

CREATE TABLE Oficina(
    CodOficina NUMBER(3),
    Direccion VARCHAR2(60) NOT NULL,
    Telefono NUMBER(9) NOT NULL,
    dniDirector NUMBER(8), 
    dniComercial NUMBER(8),
    CONSTRAINT pk_a10_oficina PRIMARY KEY(CodOficina),
    CONSTRAINT fk_a10_of_director FOREIGN KEY(dniDirector) REFERENCES Director(dni),
    CONSTRAINT fk_a10_of_comercial FOREIGN KEY(dniComercial) REFERENCES Comercial(dni),
    CONSTRAINT ck_a10_oficina CHECK(LENGTH(Telefono)=9));

CREATE TABLE Vendedor(
    dni NUMBER(8),
    Turno CHAR(1) NOT NULL,
    CodOficina NUMBER(3) NOT NULL,
    CONSTRAINT pk_a10_vendedor PRIMARY KEY(dni),
    CONSTRAINT fk_a10_vend_dp FOREIGN KEY(dni) REFERENCES DatosPersonales(dni),
    CONSTRAINT fk_a10_vend_oficina FOREIGN KEY(CodOficina) REFERENCES Oficina(CodOficina),
    CONSTRAINT ck_a10_vend CHECK(Turno IN ('M','T','X')));

CREATE TABLE Cliente(
    dni NUMBER(8),
    numTarjeta NUMBER(20),
    CONSTRAINT pk_a10_cl PRIMARY KEY(dni),
    CONSTRAINT fk_a10_cldp FOREIGN KEY(dni) REFERENCES DatosPersonales(dni),
    CONSTRAINT ck_a10_cl CHECK(LENGTH(numTarjeta)=20));

CREATE TABLE Venta(
    CodVenta NUMBER(6),
    Fecha DATE NOT NULL,
    numLineaVenta NUMBER(2),
    tipo CHAR(1) NOT NULL,
    dniVen NUMBER(8) NOT NULL,
    dniCl NUMBER(8) NOT NULL,
    CONSTRAINT pk_a10_venta PRIMARY KEY(CodVenta),
    CONSTRAINT fk_a10_ventaVend FOREIGN KEY(dniVen) REFERENCES Vendedor(dni),
    CONSTRAINT fk_a10_ventaCl FOREIGN KEY(dniCl) REFERENCES Cliente(dni),
    CONSTRAINT ck_a10_ventatipo CHECK(Tipo IN ('I','W')),
    CONSTRAINT ck_a10_numlineaventa CHECK(numLineaVenta>=1),
    CONSTRAINT ck_a10_dni CHECK(dniVen!=dniCl));

CREATE TABLE Tematica(
    Tematica VARCHAR2(64),
    CONSTRAINT pk_a10_tem PRIMARY KEY(tematica));


CREATE TABLE Libro(
    ISBN NUMBER(13),
    Descripcion VARCHAR2(255) NOT NULL,
    NumPag NUMBER(4),
    Precio NUMBER(5,2) NOT NULL,
    Tematica VARCHAR2(64) NOT NULL,
    CONSTRAINT pk_a10_libro PRIMARY KEY(ISBN),
    CONSTRAINT fk_a10_librotem FOREIGN KEY(tematica) REFERENCES Tematica(tematica),
    CONSTRAINT ck_a10_libro CHECK(LENGTH(ISBN)=13 AND numPag>10 AND Precio>0));

CREATE TABLE Autor(
    CodAutor NUMBER(3),
    Autor VARCHAR2(128) UNIQUE,
    CONSTRAINT pk_a10_autor PRIMARY KEY(CodAutor));

CREATE TABLE AutorLibro(    
    CodAuto NUMBER(3),
    ISBN NUMBER(13),
    CONSTRAINT pk_a10_autoria PRIMARY KEY(CodAuto, ISBN),
    CONSTRAINT fk_a10_autoriaautor FOREIGN KEY(CodAuto) REFERENCES Autor(CodAutor),
    CONSTRAINT fk_a10_autoriaisbn FOREIGN KEY(ISBN) REFERENCES Libro(ISBN));

CREATE TABLE LineaVenta(
    CodVenta NUMBER(6),
    ISBN NUMBER(13),
    Cantidad NUMBER(4),
    CONSTRAINT pk_a10_lineaventa PRIMARY KEY(CodVenta, ISBN),
    CONSTRAINT fk_a10_lineaventaventa FOREIGN KEY(CodVenta) REFERENCES Venta(CodVenta),
    CONSTRAINT fk_a10_lineaventalibro FOREIGN KEY(isbn) REFERENCES Libro(isbn),
    CONSTRAINT ck_a10_lineaventa CHECK(cantidad>0));

    
INSERT INTO DatosPersonales VALUES(10203040, 'Miguel', 'González', 'Marín', 'Calle Gran Vía','CO');
INSERT INTO DatosPersonales VALUES(10203030, 'Marina', 'González', 'Marín', 'Calle Gran Vía','CO');
INSERT INTO DatosPersonales VALUES(10203041, 'Luis', 'García', 'Gómez', 'Calle Plaza Mayor', 'DI');
INSERT INTO DatosPersonales VALUES(11203041, 'Luisa', 'Román', 'Gómez', 'Calle Plaza Mayor', 'DI');
INSERT INTO DatosPersonales VALUES(10203042, 'Antonio', 'Sánchez', 'Ramon', 'Avenida de la Constitución', 'VE');
INSERT INTO DatosPersonales VALUES(10203043, 'Teresa', 'Romero', 'Martín', 'Avenida Juan de Austria', 'CL');
INSERT INTO DatosPersonales VALUES(10203044, 'María', 'Amor', 'Díaz', 'Avenida de la Montaña', 'CL');
INSERT INTO DatosPersonales VALUES(10203045, 'Lucía', 'Moreno', 'Díaz', 'Calle Preciados', 'CL');
INSERT INTO DatosPersonales VALUES(10203046, 'Lucía', 'Calle', 'Romero', 'Calle Betanzso', 'CL');
select * from DatosPersonales;

INSERT INTO Telefono VALUES(603200563, 10203040);
INSERT INTO Telefono VALUES(705123456, 10203041);
INSERT INTO Telefono VALUES(605845102, 10203041);
select * from telefono;

INSERT INTO Correo VALUES('m.gon.mar@gmail.com', 10203040);
INSERT INTO Correo VALUES('luisgargo@gmail.com', 10203041);
INSERT INTO Correo VALUES('luisgarcia@gamil.com', 10203041);
select * from correo;

INSERT INTO Director VALUES(10203041);
INSERT INTO Director VALUES(11203041);
select * from Director;

INSERT INTO Comercial VALUES(10203040, 12.1);
INSERT INTO Comercial VALUES(10203030, 10);
select * from Comercial;


INSERT INTO Oficina VALUES(23, 'Feria de Sevilla', 123456789, 10203041, 10203040);
INSERT INTO Oficina VALUES(34, 'Sanat feria', 234567891, 10203041, 10203040);
INSERT INTO Oficina VALUES(43, 'De ferias', 123789456, 10203041, 10203040);
INSERT INTO Oficina VALUES(48, 'Príncipe Pío', 456789123, 10203041, 10203040);
INSERT INTO Oficina VALUES(54, 'Guzmán el Bueno', 321654987, 10203041, 10203040);
INSERT INTO Oficina VALUES(67, 'Avenida de América', 987654321, 11203041, 10203040);
INSERT INTO Oficina VALUES(69, 'Goya', 147258369, 11203041, 10203040);
INSERT INTO Oficina VALUES(10, 'Plaza Castilla', 741852963, 11203041, 10203030);
INSERT INTO Oficina VALUES(5, 'Hortaleza', 753159789, 11203041, 10203030);
select * from oficina;

INSERT INTO Vendedor VALUES(10203042,'M', 23);
select * from Vendedor;

INSERT INTO Cliente VALUES(10203043, 44934993012911031000);
INSERT INTO Cliente VALUES(10203044, 33934993012911031000);
INSERT INTO Cliente VALUES(10203045, 22934993012911031000);
INSERT INTO Cliente VALUES(10203046, 11934993012911031000);
select * from cliente;

INSERT INTO Venta VALUES(1432, '10/2/2023', 1, 'I', 10203042, 10203043);
INSERT INTO Venta VALUES(23, '15/3/2023', 2, 'W', 10203042, 10203044);
INSERT INTO Venta VALUES(789, '18/3/2023', 3, 'W', 10203042, 10203045);
INSERT INTO Venta VALUES(300, '19/3/2023', 4, 'W', 10203042, 10203045);
SELECT * FROM VENTA;

INSERT INTO Tematica VALUES('Historia');
INSERT INTO Tematica VALUES('Infantil');
INSERT INTO Tematica VALUES('Fantasía');
INSERT INTO Tematica VALUES('Científico');
select * from Tematica;

INSERT INTO Libro VALUES(9788408043645, 'La sombra del viento', 200, 20.50, 'Historia');
INSERT INTO Libro VALUES(9788434856813, 'El pollo pepe', 11, 10.50, 'Infantil');
INSERT INTO Libro VALUES(9788430578054, 'Versos fritos', 11, 10.50, 'Infantil');
INSERT INTO Libro VALUES(9788467539677, 'El valle de los lobos', 200, 10.50, 'Fantasía');
INSERT INTO Libro VALUES(9788417547967, 'La astucia de los insectos', 300, 10.50, 'Científico');
select * from Libro;

INSERT INTO Autor VALUES(1, 'Carlos Ruíz Zafón');
INSERT INTO Autor VALUES(2, 'Laura Gallego');
INSERT INTO Autor VALUES(3, 'Nick Denchfield');
INSERT INTO Autor VALUES(4, 'Gloria Fuertes'); 
INSERT INTO Autor VALUES(5, 'JAIRO ROBLA SUÁREZ');
select * from Autor;

INSERT INTO AutorLibro VALUES(1, 9788408043645);
INSERT INTO AutorLibro VALUES(3, 9788434856813);
INSERT INTO AutorLibro VALUES(2, 9788467539677);
INSERT INTO AutorLibro VALUES(4, 9788430578054);
INSERT INTO AutorLibro VALUES(5, 9788417547967);
select * from AutorLibro;


INSERT INTO LineaVenta VALUES(1432, 9788408043645, 2);
INSERT INTO LineaVenta VALUES(1432, 9788467539677, 2);
INSERT INTO LineaVenta VALUES(23, 9788417547967, 1);
INSERT INTO LineaVenta VALUES(789, 9788430578054, 1);
INSERT INTO LineaVenta VALUES(300, 9788434856813, 1);
select * from lineaVenta;

--a) Mostrar la descripción de los
--libros que se vendieron con el código de venta 1432 con una cantidad entre 1 y 3 (incluidos 1 y 3).
select descripcion
from libro lb, lineaVenta lv
where lb.ISBN=lv.ISBN and lv.codVenta=1432 and lv.Cantidad>1 and lv.Cantidad<3;

--b) Mostrar los códigos de venta donde se han vendido libros del autor ‘Carlos Ruíz Zafón’.
select lv.CodVenta
from Venta v, lineaVenta lv, libro lb,autor at,autorlibro al
where lv.codventa=v.codventa and lb.isbn=lv.isbn and al.isbn=lb.isbn
and al.codauto=at.codautor and at.autor='Carlos Ruíz Zafón';

--c) Mostrar el código de las ventas efectuadas por el vendedor ‘Antonio Sánchez Ramon’.

select codventa
from venta v, vendedor vd, datospersonales dt
where v.dniVen=vd.dni and vd.dni=dt.dni and dt.nombre='Antonio' and prapellido='Sánchez' and sgapellido='Ramon';

--D)Mostrar los códigos de venta en los que se han vendido libros de temática Científico.

select lv.codventa
from  libro lb, lineaventa lv
where lv.isbn=lb.isbn and lb.tematica='Científico';


--e) Mostrar el nombre y apellidos de los directores que dirigen oficinas cuya dirección tiene el texto Feria.

select nombre, prapellido,sgapellido
from datospersonales dpe, director d, oficina ofi
where dpe.dni=d.dni and d.dni=ofi.dnidirector  and upper(ofi.direccion) like '%feria%';


--f) Mostrar el nombre y apellidos de los comerciales que trabajan para las oficinas 23, 34, 43, 48, 54, 67 y 69.

select nombre, prapellido,sgapellido
from comercial co, oficina ofi, datospersonales dpe
where co.dni=dpe.dni and co.dni=ofi.dnicomercial and ofi.codoficina in( 23,34,43,48,54,67,69);

--g) Mostrar el autor de los libros comprados por los clientes cuyo primer apellido empieza por A, C, M o S.

select au.*
from autor au,autorlibro auli, lineaventa lv, venta v, cliente cli, datospersonales dpe
where au.codautor = auli.codauto and auli.isbn=lv.isbn and lv.codventa=v.codventa and v.dnicl = cli.dni 
       and cli.dni=dpe.dni and  lower(dpe.prapellido) like 'a%' 
       or lower(dpe.prapellido) like 'c%'
        or  lower(dpe.prapellido) like 'm%'
        or  lower(dpe.prapellido) like 's%';

--Esta es otr forma de hacerlo
select au.autor
from autor au,autorlibro auli, lineaventa lv, venta v, cliente cli, datospersonales dpe
where au.codautor = auli.codauto and auli.isbn=lv.isbn and lv.codventa=v.codventa and v.dnicl = cli.dni 
       and cli.dni=dpe.dni and  
        UPPER(SUBSTR(dpe.prapellido,1,1)) in ('A','C','M','S');
        
select prapellido
from datospersonales
where UPPER(SUBSTR(datospersonales.prapellido,1,1)) in ('A','C','M','S');
