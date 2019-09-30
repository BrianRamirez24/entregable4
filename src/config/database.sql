-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 30, 2019 at 11:49 AM
-- Server version: 5.7.26
-- PHP Version: 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_erpentregable`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `spCrearCategoria`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spCrearCategoria` (IN `_nombrecategoria` VARCHAR(50), IN `_descripcion` TEXT, OUT `_message` VARCHAR(50))  BEGIN
	IF NOT EXISTS(select nombrecategoria 
              		from categoria 
             		where LOWER(nombrecategoria) =LOWER(_nombrecategoria) LIMIT 1) THEN
		
                INSERT INTO categoria(nombrecategoria,
                                      descripcion) 
                                      VALUES(_nombrecategoria,
                                             _descripcion);
                set _message = 'categoria creada exitosamente';
                                             
    ELSE
     set _message = 'la categoria ya ha sido creada';
   END IF;
END$$

DROP PROCEDURE IF EXISTS `spCrearGenero`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spCrearGenero` (IN `_genero` VARCHAR(50))  begin
     insert into genero(genero) 
     			 values(LOWER(_genero));
    end$$

DROP PROCEDURE IF EXISTS `spCrearProducto`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spCrearProducto` (IN `_codreferencia` VARCHAR(50), IN `_nombre` VARCHAR(50), IN `_marca` VARCHAR(50), IN `_descripcion` TEXT, IN `_categoria` VARCHAR(50), IN `_stock` INT(11), IN `_preciocompra` DECIMAL(6,2), OUT `_message` VARCHAR(50))  BEGIN	

 IF EXISTS(select codreferencia 
           from producto 
           where codreferencia = _codreferencia 
           limit 1) THEN
	set _message = ('el producto ya existe');
    
 ELSE
 
 	
 	INSERT INTO producto (codreferencia,
                          nombre, 
                          marca,
                          descripcion,
                          idcategoria,
                          stock,
                          preciocompra)
                           values(_codreferencia,
                                  _nombre, 
                                  _marca,
                                  _descripcion,
                                  (select idcategoria 
                                   from categoria 
                                   where nombrecategoria = _categoria),
                                  _stock,
                                  _preciocompra);
                          
                          set _message = ('producto creado exitosamente');
                          
 END IF;
END$$

DROP PROCEDURE IF EXISTS `spCrearRoll`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spCrearRoll` (IN `_roll` VARCHAR(50))  begin
     insert into roll(roll) 
     			 values(LOWER(_roll));
    end$$

DROP PROCEDURE IF EXISTS `spCrearTdoc`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spCrearTdoc` (IN `_tipodocumento` VARCHAR(50))  begin
     insert into tipodocumento(tipodocumento) 
     			 values(LOWER(_tipodocumento));
    end$$

DROP PROCEDURE IF EXISTS `spCrearUsuarios`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spCrearUsuarios` (IN `_tdoc` VARCHAR(50), IN `_numdocumento` VARCHAR(50), IN `_nombres` VARCHAR(50), IN `_apellidos` VARCHAR(50), IN `_genero` VARCHAR(50), IN `_direccion` VARCHAR(50), IN `_roll` VARCHAR(50), IN `_telefono` VARCHAR(50), IN `_nocelular` VARCHAR(50), IN `_fechanacimiento` DATE, IN `_email` VARCHAR(50), IN `_pass` VARCHAR(50), IN `_nomDept` VARCHAR(50), IN `_nomMunicipio` VARCHAR(50))  BEGIN
  INSERT INTO usuario( idnodoc, 
					  numdocumento, 
					  nombres,
					  apellidos, 
					  idgenero, 
					  direccion, 
					  idroll, 
					  telefono,
					  nocelular,
					  fechanacimiento, 
					  fechaActivo, 
					  email, 
					  pass, 
					  userimage,
					  idDepartamentos, 
					  idMunicipios) 
                      VALUES (
					 
					  (select idnodoc 
                       from tipodocumento
                       where tipodocumento = _tdoc), 
					  _numdocumento, 
					  _nombres,
					  _apellidos, 
					  (select idgenero 
                       from genero 
                       where genero = _genero), 
					  _direccion, 
					  (select idroll 
                       from roll 
                       where roll = _roll), 
					  _telefono,
					  _nocelular,
					  _fechanacimiento, 
					  _fechaActivo, 
					  _email, 
					  md5(_pass), 
					  _userimage,
					  (select idDepartamento from departamentos where nomDept = _nomDept), 
					  (select idMunicipios from municipios where nombreMunicipio = _nomMunicipio)
					  );
                      
END$$

DROP PROCEDURE IF EXISTS `spFilterproducts`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spFilterproducts` (IN `_dato` VARCHAR(50))  BEGIN

	
SELECT p.idproducto,
	   c.nombrecategoria 'CATEGORIA',
	   p.codreferencia 'ID',
	   p.nombre,
	   p.marca, 
	   p.descripcion,
	   p.stock, 
	   p.preciocompra 
	   FROM producto p inner join 
	   categoria c on p.idcategoria = c.idcategoria
       where (p.nombre like '%_dato%' OR
             p.marca  like '%_dato%' OR
             p.codreferencia  like '%_dato%');
	
END$$

DROP PROCEDURE IF EXISTS `spListarCategoria`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spListarCategoria` ()  BEGIN
	select nombrecategoria 
    from categoria;
END$$

DROP PROCEDURE IF EXISTS `spListarDepto`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spListarDepto` ()  BEGIN
	select LOWER(nombreDepto)
    from departamentos;
END$$

DROP PROCEDURE IF EXISTS `spListarMun`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spListarMun` (IN `_nombreDepto` VARCHAR(50))  begin 

	select lower(nombreMunicipio)
    from municipios 
    where idDepartamentos = (select idDepartamentos 
    						from departamentos
                            where nombreDepto = _nombreDepto) 
                            order by nombreMunicipio asc;


end$$

DROP PROCEDURE IF EXISTS `spListproducts`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spListproducts` ()  BEGIN

	
SELECT p.idproducto,
	   c.nombrecategoria 'CATEGORIA',
	   p.codreferencia 'ID',
	   p.nombre,
	   p.marca, 
	   p.descripcion,
	   p.stock, 
	   p.preciocompra 
	   FROM producto p inner join 
	   categoria c on p.idcategoria = c.idcategoria;
	
END$$

DROP PROCEDURE IF EXISTS `spRegistrarDepartamento`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spRegistrarDepartamento` (IN `_coddepto` VARCHAR(2), IN `_nombreDepto` VARCHAR(120))  begin
       insert into departamentos(coddepto,
	                         nombreDepto) 
                          values(_coddepto, 
				 _nombreDepto);
end$$

DROP PROCEDURE IF EXISTS `spRegistrarDetalleVenta`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spRegistrarDetalleVenta` (IN `_codreferencia` VARCHAR(50), IN `_IdVenta` INT, IN `_Cantidad` INT, OUT `_Mensaje` VARCHAR(100))  Begin 
	IF ((SELECT stock 
         from producto 
         where codreferencia = _codreferencia limit 1) < _Cantidad) THEN
    SET _Mensaje =('no hay stock suficiente para agregar el producto a la venta');
    ELSE
    
    		insert into DetalleVenta (idproducto,
                                      iddetalleventa,
                                      cantidad,
                                      subtotal)
            						values((select idproducto 
                                           from producto 
                                           where codreferencia = _codreferencia 
                                           limit 1),
		                           _IdVenta,
								   _Cantidad,
								   (select preciocompra 
                                           from producto 
                                           where codreferencia = _codreferencia 
                                           limit 1) * _Cantidad * 0.16);
                                   
                                   SET _Mensaje = 'producto agregado satisfactoriamente';
	END IF;
				
		
End$$

DROP PROCEDURE IF EXISTS `spRegistrarMunicipios`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spRegistrarMunicipios` (IN `_codmun` VARCHAR(3), IN `_nombreMunicipio` VARCHAR(120), IN `_idDepartamentos` INT)  begin
       insert into municipios(codmun,
	                          nombreMunicipio, 
                              idDepartamentos) 
					   values(_codmun,
					          _nombreMunicipio, 
					          _idDepartamentos);
end$$

DROP PROCEDURE IF EXISTS `spRegistrarVenta`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spRegistrarVenta` (IN `_email` VARCHAR(200), IN `_codigoFactura` VARCHAR(200), IN `_fechaVenta` DATE, IN `_iddetalleventa` INT(11), IN `_Total` VARCHAR(200), OUT `_Mensaje` VARCHAR(100))  BEGIN
	INSERT INTO encabezadoventa (idusuario,
                                 iddetalleventa, 
                                 codigoFactura,
                                 fechaVenta, 
                                 Total)
                                 VALUES(
                                        (Select idusuario from usuario where email = _email) ,
                                         _iddetalleventa,
                                         _codigoFactura,            
                                        _fechaVenta,
                                        _Total);
		set _Mensaje = 'La Venta se ha Generado Correctamente.';
	END$$

DROP PROCEDURE IF EXISTS `spUpdateProducto`$$
CREATE DEFINER=`IsraelRitchie`@`localhost` PROCEDURE `spUpdateProducto` (IN `_idproducto` INT(11), IN `_codreferencia` VARCHAR(50), IN `_nombre` VARCHAR(50), IN `_marca` VARCHAR(50), IN `_descripcion` TEXT, IN `_categoria` VARCHAR(50), IN `_stock` INT(11), IN `_preciocompra` DECIMAL(6,2), OUT `_message` VARCHAR(50))  BEGIN	


 UPDATE `producto` set `codreferencia` =_codreferencia ,
                     `nombre` = _nombre, 
                     `marca` = _marca,
                     `descripcion` = _descripcion,
                     `idcategoria` = (select idcategoria 
                                    from categoria 
                                    where nombrecategoria = _categoria),
                     `stock` = _stock,
                     `preciocompra` = _preciocompra
                      where idproducto = _idproducto;             
                          
           set _message = ('producto actualizado exitosamente');
                          

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
CREATE TABLE IF NOT EXISTS `categoria` (
  `idcategoria` int(11) NOT NULL AUTO_INCREMENT,
  `nombrecategoria` varchar(50) NOT NULL,
  `descripcion` text,
  PRIMARY KEY (`idcategoria`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `categoria`
--

INSERT INTO `categoria` (`idcategoria`, `nombrecategoria`, `descripcion`) VALUES
(1, 'comestibles', 'categoria destinada a alimentos de comida como mecato y bonbones y otros.');

-- --------------------------------------------------------

--
-- Table structure for table `departamentos`
--

DROP TABLE IF EXISTS `departamentos`;
CREATE TABLE IF NOT EXISTS `departamentos` (
  `idDepartamentos` int(11) NOT NULL AUTO_INCREMENT,
  `coddepto` varchar(2) NOT NULL,
  `nombreDepto` varchar(120) NOT NULL,
  PRIMARY KEY (`idDepartamentos`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `departamentos`
--

INSERT INTO `departamentos` (`idDepartamentos`, `coddepto`, `nombreDepto`) VALUES
(1, '91', 'AMAZONAS'),
(2, '05', 'ANTIOQUIA'),
(3, '81', 'ARAUCA'),
(4, '08', 'ATLANTICO'),
(5, '11', 'BOGOTA D.C.'),
(6, '13', 'BOLIVAR'),
(7, '15', 'BOYACA'),
(8, '17', 'CALDAS'),
(9, '18', 'CAQUETA'),
(10, '85', 'CASANARE'),
(11, '19', 'CAUCA'),
(12, '20', 'CESAR'),
(13, '27', 'CHOCO'),
(14, '23', 'CORDOBA'),
(15, '25', 'CUNDINAMARCA'),
(16, '94', 'GUAINÍA'),
(17, '95', 'GUAVIARE'),
(18, '41', 'HUILA'),
(19, '44', 'GUAJIRA'),
(20, '47', 'MAGDALENA'),
(21, '50', 'META'),
(22, '52', 'NARIÑO'),
(23, '54', 'NORTE DE SANTANDER'),
(24, '86', 'PUTUMAYO'),
(25, '63', 'QUINDIO'),
(26, '66', 'RISARALDA'),
(27, '88', 'SAN ANDRES Y PROVIDENCIA'),
(28, '68', 'SANTANDER'),
(29, '70', 'SUCRE'),
(30, '73', 'TOLIMA'),
(31, '76', 'VALLE DEL CAUCA'),
(32, '97', 'VAUPES'),
(33, '99', 'VICHADA');

-- --------------------------------------------------------

--
-- Table structure for table `detalleventa`
--

DROP TABLE IF EXISTS `detalleventa`;
CREATE TABLE IF NOT EXISTS `detalleventa` (
  `iddetalleventa` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `iva` decimal(6,2) NOT NULL,
  `subtotal` decimal(6,2) NOT NULL,
  PRIMARY KEY (`iddetalleventa`),
  KEY `idproducto` (`idproducto`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `encabezadoventa`
--

DROP TABLE IF EXISTS `encabezadoventa`;
CREATE TABLE IF NOT EXISTS `encabezadoventa` (
  `idEncabezadoVenta` int(11) NOT NULL AUTO_INCREMENT,
  `codigoFactura` varchar(10) NOT NULL,
  `FechaVenta` date NOT NULL,
  `idusuario` int(11) NOT NULL,
  `iddetalleventa` int(11) NOT NULL,
  `Total` decimal(6,2) NOT NULL,
  PRIMARY KEY (`idEncabezadoVenta`),
  KEY `idusuario` (`idusuario`),
  KEY `iddetalleventa` (`iddetalleventa`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `genero`
--

DROP TABLE IF EXISTS `genero`;
CREATE TABLE IF NOT EXISTS `genero` (
  `idgenero` int(11) NOT NULL AUTO_INCREMENT,
  `genero` varchar(50) NOT NULL,
  PRIMARY KEY (`idgenero`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `genero`
--

INSERT INTO `genero` (`idgenero`, `genero`) VALUES
(1, 'masculino'),
(2, 'femenino');

-- --------------------------------------------------------

--
-- Table structure for table `municipios`
--

DROP TABLE IF EXISTS `municipios`;
CREATE TABLE IF NOT EXISTS `municipios` (
  `idMunicipios` int(11) NOT NULL AUTO_INCREMENT,
  `idDepartamentos` int(11) NOT NULL,
  `codmun` varchar(3) NOT NULL,
  `nombreMunicipio` varchar(120) NOT NULL,
  PRIMARY KEY (`idMunicipios`),
  KEY `idDepartamentos` (`idDepartamentos`)
) ENGINE=MyISAM AUTO_INCREMENT=1126 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `municipios`
--

INSERT INTO `municipios` (`idMunicipios`, `idDepartamentos`, `codmun`, `nombreMunicipio`) VALUES
(1, 2, '001', 'MEDELLIN'),
(2, 2, '002', 'ABEJORRAL'),
(3, 2, '004', 'ABRIAQUI'),
(4, 2, '021', 'ALEJANDRIA'),
(5, 2, '030', 'AMAGA'),
(6, 2, '031', 'AMALFI'),
(7, 2, '034', 'ANDES'),
(8, 2, '036', 'ANGELOPOLIS'),
(9, 2, '038', 'ANGOSTURA'),
(10, 2, '040', 'ANORI'),
(11, 2, '042', 'ANTIOQUIA'),
(12, 2, '044', 'ANZA'),
(13, 2, '045', 'APARTADO'),
(14, 2, '051', 'ARBOLETES'),
(15, 2, '055', 'ARGELIA'),
(16, 2, '059', 'ARMENIA'),
(17, 2, '079', 'BARBOSA'),
(18, 2, '086', 'BELMIRA'),
(19, 2, '088', 'BELLO'),
(20, 2, '091', 'BETANIA'),
(21, 2, '093', 'BETULIA'),
(22, 2, '101', 'BOLIVAR'),
(23, 2, '107', 'BRICEÑO'),
(24, 2, '113', 'BURITICA'),
(25, 2, '120', 'CACERES'),
(26, 2, '125', 'CAICEDO'),
(27, 2, '129', 'CALDAS'),
(28, 2, '134', 'CAMPAMENTO'),
(29, 2, '138', 'CAÑASGORDAS'),
(30, 2, '142', 'CARACOLI'),
(31, 2, '145', 'CARAMANTA'),
(32, 2, '147', 'CAREPA'),
(33, 2, '148', 'CARMEN DE VIBORAL'),
(34, 2, '150', 'CAROLINA'),
(35, 2, '154', 'CAUCASIA'),
(36, 2, '172', 'CHIGORODO'),
(37, 2, '190', 'CISNEROS'),
(38, 2, '197', 'COCORNA'),
(39, 2, '206', 'CONCEPCION'),
(40, 2, '209', 'CONCORDIA'),
(41, 2, '212', 'COPACABANA'),
(42, 2, '234', 'DABEIBA'),
(43, 2, '237', 'DON MATIAS'),
(44, 2, '240', 'EBEJICO'),
(45, 2, '250', 'EL BAGRE'),
(46, 2, '264', 'ENTRERRIOS'),
(47, 2, '266', 'ENVIGADO'),
(48, 2, '282', 'FREDONIA'),
(49, 2, '284', 'FRONTINO'),
(50, 2, '306', 'GIRALDO'),
(51, 2, '308', 'GIRARDOTA'),
(52, 2, '310', 'GOMEZ PLATA'),
(53, 2, '313', 'GRANADA'),
(54, 2, '315', 'GUADALUPE'),
(55, 2, '318', 'GUARNE'),
(56, 2, '321', 'GUATAPE'),
(57, 2, '347', 'HELICONIA'),
(58, 2, '353', 'HISPANIA'),
(59, 2, '360', 'ITAGUI'),
(60, 2, '361', 'ITUANGO'),
(61, 2, '364', 'JARDIN'),
(62, 2, '368', 'JERICO'),
(63, 2, '376', 'LA CEJA'),
(64, 2, '380', 'LA ESTRELLA'),
(65, 2, '390', 'LA PINTADA'),
(66, 2, '400', 'LA UNION'),
(67, 2, '411', 'LIBORINA'),
(68, 2, '425', 'MACEO'),
(69, 2, '440', 'MARINILLA'),
(70, 2, '467', 'MONTEBELLO'),
(71, 2, '475', 'MURINDO'),
(72, 2, '480', 'MUTATA'),
(73, 2, '483', 'NARIÑO'),
(74, 2, '490', 'NECOCLI'),
(75, 2, '495', 'NECHI'),
(76, 2, '501', 'OLAYA'),
(77, 2, '541', 'PEÑOL'),
(78, 2, '543', 'PEQUE'),
(79, 2, '576', 'PUEBLORRICO'),
(80, 2, '579', 'PUERTO BERRIO'),
(81, 2, '585', 'PUERTO NARE(LA MAGDALENA)'),
(82, 2, '591', 'PUERTO TRIUNFO'),
(83, 2, '604', 'REMEDIOS'),
(84, 2, '607', 'RETIRO'),
(85, 2, '615', 'RIONEGRO'),
(86, 2, '628', 'SABANALARGA'),
(87, 2, '631', 'SABANETA'),
(88, 2, '642', 'SALGAR'),
(89, 2, '647', 'SAN ANDRES'),
(90, 2, '649', 'SAN CARLOS'),
(91, 2, '652', 'SAN FRANCISCO'),
(92, 2, '656', 'SAN JERONIMO'),
(93, 2, '658', 'SAN JOSE DE LA MONTAÑA'),
(94, 2, '659', 'SAN JUAN DE URABA'),
(95, 2, '660', 'SAN LUIS'),
(96, 2, '664', 'SAN PEDRO'),
(97, 2, '665', 'SAN PEDRO DE URABA'),
(98, 2, '667', 'SAN RAFAEL'),
(99, 2, '670', 'SAN ROQUE'),
(100, 2, '674', 'SAN VICENTE'),
(101, 2, '679', 'SANTA BARBARA'),
(102, 2, '686', 'SANTA ROSA DE OSOS'),
(103, 2, '690', 'SANTO DOMINGO'),
(104, 2, '697', 'SANTUARIO'),
(105, 2, '736', 'SEGOVIA'),
(106, 2, '756', 'SONSON'),
(107, 2, '761', 'SOPETRAN'),
(108, 2, '789', 'TAMESIS'),
(109, 2, '790', 'TARAZA'),
(110, 2, '792', 'TARSO'),
(111, 2, '809', 'TITIRIBI'),
(112, 2, '819', 'TOLEDO'),
(113, 2, '837', 'TURBO'),
(114, 2, '842', 'URAMITA'),
(115, 2, '847', 'URRAO'),
(116, 2, '854', 'VALDIVIA'),
(117, 2, '856', 'VALPARAISO'),
(118, 2, '858', 'VEGACHI'),
(119, 2, '861', 'VENECIA'),
(120, 2, '873', 'VIGIA DEL FUERTE'),
(121, 2, '885', 'YALI'),
(122, 2, '887', 'YARUMAL'),
(123, 2, '890', 'YOLOMBO'),
(124, 2, '893', 'YONDO'),
(125, 2, '895', 'ZARAGOZA'),
(126, 4, '001', 'BARRANQUILLA'),
(127, 4, '078', 'BARANOA'),
(128, 4, '137', 'CAMPO DE LA CRUZ'),
(129, 4, '141', 'CANDELARIA'),
(130, 4, '296', 'GALAPA'),
(131, 4, '372', 'JUAN DE ACOSTA'),
(132, 4, '421', 'LURUACO'),
(133, 4, '433', 'MALAMBO'),
(134, 4, '436', 'MANATI'),
(135, 4, '520', 'PALMAR DE VARELA'),
(136, 4, '549', 'PIOJO'),
(137, 4, '558', 'POLO NUEVO'),
(138, 4, '560', 'PONEDERA'),
(139, 4, '573', 'PUERTO COLOMBIA'),
(140, 4, '606', 'REPELON'),
(141, 4, '634', 'SABANAGRANDE'),
(142, 4, '638', 'SABANALARGA'),
(143, 4, '675', 'SANTA LUCIA'),
(144, 4, '685', 'SANTO TOMAS'),
(145, 4, '758', 'SOLEDAD'),
(146, 4, '770', 'SUAN'),
(147, 4, '832', 'TUBARA'),
(148, 4, '849', 'USIACURI'),
(149, 5, '001', 'USAQUEN'),
(150, 5, '002', 'CHAPINERO'),
(151, 5, '003', 'SANTA FE DE BOGOTA'),
(152, 5, '004', 'SAN CRISTOBAL'),
(153, 5, '005', 'USME'),
(154, 5, '006', 'TUNJUELITO'),
(155, 5, '007', 'BOSA'),
(156, 5, '008', 'KENNEDY'),
(157, 5, '009', 'FONTIBON'),
(158, 5, '010', 'ENGATIVA'),
(159, 5, '011', 'SUBA'),
(160, 5, '012', 'BARRIOS UNIDOS'),
(161, 5, '013', 'TEUSAQUILLO'),
(162, 5, '014', 'MARTIRES'),
(163, 5, '015', 'ANTONIO NARIÑO'),
(164, 5, '016', 'PUENTE ARANDA'),
(165, 5, '017', 'CANDELARIA'),
(166, 5, '018', 'RAFAEL URIBE'),
(167, 5, '019', 'CIUDAD BOLIVAR'),
(168, 5, '020', 'SUMAPAZ'),
(169, 6, '001', 'CARTAGENA'),
(170, 6, '006', 'ACHI'),
(171, 6, '030', 'ALTOS DEL ROSARIO'),
(172, 6, '042', 'ARENAL'),
(173, 6, '052', 'ARJONA'),
(174, 6, '062', 'ARROYOHONDO'),
(175, 6, '074', 'BARRANCO DE LOBA'),
(176, 6, '140', 'CALAMAR'),
(177, 6, '160', 'CANTAGALLO'),
(178, 6, '188', 'CICUCO'),
(179, 6, '212', 'CORDOBA'),
(180, 6, '222', 'CLEMENCIA'),
(181, 6, '244', 'EL CARMEN DE BOLIVAR'),
(182, 6, '248', 'EL GUAMO'),
(183, 6, '268', 'EL PEÑON'),
(184, 6, '300', 'HATILLO DE LOBA'),
(185, 6, '430', 'MAGANGUE'),
(186, 6, '433', 'MAHATES'),
(187, 6, '440', 'MARGARITA'),
(188, 6, '442', 'MARIA LA BAJA'),
(189, 6, '458', 'MONTECRISTO'),
(190, 6, '468', 'MOMPOS'),
(191, 6, '473', 'MORALES'),
(192, 6, '549', 'PINILLOS'),
(193, 6, '580', 'REGIDOR'),
(194, 6, '600', 'RIO VIEJO'),
(195, 6, '620', 'SAN CRISTOBAL'),
(196, 6, '647', 'SAN ESTANISLAO'),
(197, 6, '650', 'SAN FERNANDO'),
(198, 6, '654', 'SAN JACINTO'),
(199, 6, '655', 'SAN JACINTO DEL CAUCA'),
(200, 6, '657', 'SAN JUAN NEPOMUCENO'),
(201, 6, '667', 'SAN MARTIN DE LOBA'),
(202, 6, '670', 'SAN PABLO'),
(203, 6, '673', 'SANTA CATALINA'),
(204, 6, '683', 'SANTA ROSA'),
(205, 6, '688', 'SANTA ROSA DEL SUR'),
(206, 6, '744', 'SIMITI'),
(207, 6, '760', 'SOPLAVIENTO'),
(208, 6, '780', 'TALAIGUA NUEVO'),
(209, 6, '810', 'TIQUISIO (PUERTO RICO)'),
(210, 6, '836', 'TURBACO'),
(211, 6, '838', 'TURBANA'),
(212, 6, '873', 'VILLANUEVA'),
(213, 6, '894', 'ZAMBRANO'),
(214, 7, '001', 'TUNJA'),
(215, 7, '022', 'ALMEIDA'),
(216, 7, '047', 'AQUITANIA'),
(217, 7, '051', 'ARCABUCO'),
(218, 7, '087', 'BELEN'),
(219, 7, '090', 'BERBEO'),
(220, 7, '092', 'BETEITIVA'),
(221, 7, '097', 'BOAVITA'),
(222, 7, '104', 'BOYACA'),
(223, 7, '106', 'BRICEÑO'),
(224, 7, '109', 'BUENAVISTA'),
(225, 7, '114', 'BUSBANZA'),
(226, 7, '131', 'CALDAS'),
(227, 7, '135', 'CAMPOHERMOSO'),
(228, 7, '162', 'CERINZA'),
(229, 7, '172', 'CHINAVITA'),
(230, 7, '176', 'CHIQUINQUIRA'),
(231, 7, '180', 'CHISCAS'),
(232, 7, '183', 'CHITA'),
(233, 7, '185', 'CHITARAQUE'),
(234, 7, '187', 'CHIVATA'),
(235, 7, '189', 'CIENEGA'),
(236, 7, '204', 'COMBITA'),
(237, 7, '212', 'COPER'),
(238, 7, '215', 'CORRALES'),
(239, 7, '218', 'COVARACHIA'),
(240, 7, '223', 'CUBARA'),
(241, 7, '224', 'CUCAITA'),
(242, 7, '226', 'CUITIVA'),
(243, 7, '232', 'CHIQUIZA'),
(244, 7, '236', 'CHIVOR'),
(245, 7, '238', 'DUITAMA'),
(246, 7, '244', 'EL COCUY'),
(247, 7, '248', 'EL ESPINO'),
(248, 7, '272', 'FIRAVITOBA'),
(249, 7, '276', 'FLORESTA'),
(250, 7, '293', 'GACHANTIVA'),
(251, 7, '296', 'GAMEZA'),
(252, 7, '299', 'GARAGOA'),
(253, 7, '317', 'GUACAMAYAS'),
(254, 7, '322', 'GUATEQUE'),
(255, 7, '325', 'GUAYATA'),
(256, 7, '332', 'GUICAN'),
(257, 7, '362', 'IZA'),
(258, 7, '367', 'JENESANO'),
(259, 7, '368', 'JERICO'),
(260, 7, '377', 'LABRANZAGRANDE'),
(261, 7, '380', 'LA CAPILLA'),
(262, 7, '401', 'LA VICTORIA'),
(263, 7, '403', 'LA UVITA'),
(264, 7, '407', 'VILLA DE LEIVA'),
(265, 7, '425', 'MACANAL'),
(266, 7, '442', 'MARIPI'),
(267, 7, '455', 'MIRAFLORES'),
(268, 7, '464', 'MONGUA'),
(269, 7, '466', 'MONGUI'),
(270, 7, '469', 'MONIQUIRA'),
(271, 7, '476', 'MOTAVITA'),
(272, 7, '480', 'MUZO'),
(273, 7, '491', 'NOBSA'),
(274, 7, '494', 'NUEVO COLON'),
(275, 7, '500', 'OICATA'),
(276, 7, '507', 'OTANCHE'),
(277, 7, '511', 'PACHAVITA'),
(278, 7, '514', 'PAEZ'),
(279, 7, '516', 'PAIPA'),
(280, 7, '518', 'PAJARITO'),
(281, 7, '522', 'PANQUEBA'),
(282, 7, '531', 'PAUNA'),
(283, 7, '533', 'PAYA'),
(284, 7, '537', 'PAZ DEL RIO'),
(285, 7, '542', 'PESCA'),
(286, 7, '550', 'PISBA'),
(287, 7, '572', 'PUERTO'),
(288, 7, '580', 'QUIPAMA'),
(289, 7, '599', 'RAMIRIQUI'),
(290, 7, '600', 'RAQUIRA'),
(291, 7, '621', 'RONDON'),
(292, 7, '632', 'SABOYA'),
(293, 7, '638', 'SACHICA'),
(294, 7, '646', 'SAMACA'),
(295, 7, '660', 'SAN EDUARDO'),
(296, 7, '664', 'SAN JOSE DE PARE'),
(297, 7, '667', 'SAN LUIS DE GACENO'),
(298, 7, '673', 'SAN MATEO'),
(299, 7, '676', 'SAN MIGUEL DE SEMA'),
(300, 7, '681', 'SAN PABLO DE BORBUR'),
(301, 7, '686', 'SANTANA'),
(302, 7, '690', 'SANTA MARIA'),
(303, 7, '693', 'SANTA ROSA DE VITERBO'),
(304, 7, '693', 'SANTA SOFIA'),
(305, 7, '720', 'SATIVANORTE'),
(306, 7, '723', 'SATIVASUR'),
(307, 7, '740', 'SIACHOQUE'),
(308, 7, '753', 'SOATA'),
(309, 7, '755', 'SOCOTA'),
(310, 7, '757', 'SOCHA'),
(311, 7, '759', 'SOGAMOSO'),
(312, 7, '761', 'SOMONDOCO'),
(313, 7, '762', 'SORA'),
(314, 7, '763', 'SOTAQUIRA'),
(315, 7, '764', 'SORACA'),
(316, 7, '774', 'SUSACON'),
(317, 7, '776', 'SUTAMARCHAN'),
(318, 7, '778', 'SUTATENZA'),
(319, 7, '790', 'TASCO'),
(320, 7, '798', 'TENZA'),
(321, 7, '804', 'TIBANA'),
(322, 7, '806', 'TIBASOSA'),
(323, 7, '808', 'TINJACA'),
(324, 7, '810', 'TIPACOQUE'),
(325, 7, '814', 'TOCA'),
(326, 7, '816', 'TOGUI'),
(327, 7, '820', 'TOPAGA'),
(328, 7, '822', 'TOTA'),
(329, 7, '832', 'TUNUNGUA'),
(330, 7, '835', 'TURMEQUE'),
(331, 7, '837', 'TUTA'),
(332, 7, '839', 'TUTASA'),
(333, 7, '842', 'UMBITA'),
(334, 7, '861', 'VENTAQUEMADA'),
(335, 7, '879', 'VIRACACHA'),
(336, 7, '897', 'ZETAQUIRA'),
(337, 8, '001', 'MANIZALES'),
(338, 8, '013', 'AGUADAS'),
(339, 8, '042', 'ANSERMA'),
(340, 8, '050', 'ARANZAZU'),
(341, 8, '088', 'BELALCAZAR'),
(342, 8, '174', 'CHINCHINA'),
(343, 8, '272', 'FILADELFIA'),
(344, 8, '380', 'LA DORADA'),
(345, 8, '388', 'LA MERCED'),
(346, 8, '433', 'MANZANARES'),
(347, 8, '442', 'MARMATO'),
(348, 8, '444', 'MARQUETALIA'),
(349, 8, '446', 'MARULANDA'),
(350, 8, '486', 'NEIRA'),
(351, 8, '495', 'NORCASIA'),
(352, 8, '513', 'PACORA'),
(353, 8, '524', 'PALESTINA'),
(354, 8, '541', 'PENSILVANIA'),
(355, 8, '614', 'RIOSUCIO'),
(356, 8, '616', 'RISARALDA'),
(357, 8, '653', 'SALAMINA'),
(358, 8, '662', 'SAMANA'),
(359, 8, '665', 'SAN JOSE'),
(360, 8, '777', 'SUPIA'),
(361, 8, '867', 'VICTORIA'),
(362, 8, '873', 'VILLAMARIA'),
(363, 8, '877', 'VITERBO'),
(364, 9, '001', 'FLORENCIA'),
(365, 9, '029', 'ALBANIA'),
(366, 9, '094', 'BELEN DE LOS ANDAQUIES'),
(367, 9, '150', 'CARTAGENA DEL CHAIRA'),
(368, 9, '205', 'CURILLO'),
(369, 9, '247', 'EL DONCELLO'),
(370, 9, '256', 'EL PAUJIL'),
(371, 9, '410', 'LA MONTAÑITA'),
(372, 9, '460', 'MILAN'),
(373, 9, '479', 'MORELIA'),
(374, 9, '592', 'PUERTO RICO'),
(375, 9, '610', 'SAN JOSE DE FRAGUA'),
(376, 9, '753', 'SAN VICENTE DEL CAGUAN'),
(377, 9, '756', 'SOLANO'),
(378, 9, '785', 'SOLITA'),
(379, 9, '860', 'VALPARAISO'),
(380, 11, '001', 'POPAYAN'),
(381, 11, '022', 'ALMAGUER'),
(382, 11, '050', 'ARGELIA'),
(383, 11, '075', 'BALBOA'),
(384, 11, '100', 'BOLIVAR'),
(385, 11, '110', 'BUENOS AIRES'),
(386, 11, '130', 'CAJIBIO'),
(387, 11, '137', 'CALDONO'),
(388, 11, '142', 'CALOTO'),
(389, 11, '212', 'CORINTO'),
(390, 11, '256', 'EL TAMBO'),
(391, 11, '290', 'FLORENCIA'),
(392, 11, '318', 'GUAPI'),
(393, 11, '355', 'INZA'),
(394, 11, '364', 'JAMBALO'),
(395, 11, '392', 'LA SIERRA'),
(396, 11, '397', 'LA VEGA'),
(397, 11, '418', 'LOPEZ (MICAY)'),
(398, 11, '450', 'MERCADERES'),
(399, 11, '455', 'MIRANDA'),
(400, 11, '473', 'MORALES'),
(401, 11, '513', 'PADILLA'),
(402, 11, '517', 'PAEZ (BELALCAZAR)'),
(403, 11, '532', 'PATIA (EL BORDO)'),
(404, 11, '533', 'PIAMONTE'),
(405, 11, '548', 'PIENDAMO'),
(406, 11, '573', 'PUERTO TEJADA'),
(407, 11, '585', 'PURACE (COCONUCO)'),
(408, 11, '622', 'ROSAS'),
(409, 11, '693', 'SAN SEBASTIAN'),
(410, 11, '698', 'SANTANDER DE QUILICHAO'),
(411, 11, '701', 'SANTA ROSA'),
(412, 11, '743', 'SILVIA'),
(413, 11, '760', 'SOTARA (PAISPAMBA)'),
(414, 11, '780', 'SUAREZ'),
(415, 11, '807', 'TIMBIO'),
(416, 11, '809', 'TIMBIQUI'),
(417, 11, '821', 'TORIBIO'),
(418, 11, '824', 'TOTORO'),
(419, 11, '845', 'VILLARICA'),
(420, 12, '001', 'VALLEDUPAR'),
(421, 12, '011', 'AGUACHICA'),
(422, 12, '013', 'AGUSTIN CODAZZI'),
(423, 12, '032', 'ASTREA'),
(424, 12, '045', 'BECERRIL'),
(425, 12, '060', 'BOSCONIA'),
(426, 12, '175', 'CHIMICHAGUA'),
(427, 12, '178', 'CHIRIGUANA'),
(428, 12, '228', 'CURUMANI'),
(429, 12, '238', 'EL COPEY'),
(430, 12, '250', 'EL PASO'),
(431, 12, '295', 'GAMARRA'),
(432, 12, '310', 'GONZALEZ'),
(433, 12, '383', 'LA GLORIA'),
(434, 12, '400', 'LA JAGUA IBIRICO'),
(435, 12, '443', 'MANAURE'),
(436, 12, '517', 'PAILITAS'),
(437, 12, '550', 'PELAYA'),
(438, 12, '570', 'PUEBLO BELLO'),
(439, 12, '614', 'RIO DE ORO'),
(440, 12, '621', 'LA PAZ (ROBLES)'),
(441, 12, '710', 'SAN ALBERTO'),
(442, 12, '750', 'SAN DIEGO'),
(443, 12, '770', 'SAN MARTIN'),
(444, 12, '787', 'TAMALAMEQUE'),
(445, 14, '001', 'MONTERIA'),
(446, 14, '068', 'AYAPEL'),
(447, 14, '079', 'BUENAVISTA'),
(448, 14, '090', 'CANALETE'),
(449, 14, '162', 'CERETE'),
(450, 14, '168', 'CHIMA'),
(451, 14, '182', 'CHINU'),
(452, 14, '189', 'CIENAGA DE ORO'),
(453, 14, '300', 'COTORRA'),
(454, 14, '350', 'LA APARTADA'),
(455, 14, '417', 'LORICA'),
(456, 14, '419', 'LOS CORDOBAS'),
(457, 14, '464', 'MOMIL'),
(458, 14, '466', 'MONTELIBANO'),
(459, 14, '500', 'MOÑITOS'),
(460, 14, '555', 'PLANETA RICA'),
(461, 14, '570', 'PUEBLO NUEVO'),
(462, 14, '574', 'PUERTO ESCONDIDO'),
(463, 14, '580', 'PUERTO LIBERTADOR'),
(464, 14, '586', 'PURISIMA'),
(465, 14, '660', 'SAHAGUN'),
(466, 14, '670', 'SAN ANDRES SOTAVENTO'),
(467, 14, '672', 'SAN ANTERO'),
(468, 14, '675', 'SAN BERNARDO DEL VIENTO'),
(469, 14, '678', 'SAN CARLOS'),
(470, 14, '686', 'SAN PELAYO'),
(471, 14, '807', 'TIERRALTA'),
(472, 14, '855', 'VALENCIA'),
(473, 15, '001', 'AGUA DE DIOS'),
(474, 15, '019', 'ALBAN'),
(475, 15, '035', 'ANAPOIMA'),
(476, 15, '040', 'ANOLAIMA'),
(477, 15, '053', 'ARBELAEZ'),
(478, 15, '086', 'BELTRAN'),
(479, 15, '095', 'BITUIMA'),
(480, 15, '099', 'BOJACA'),
(481, 15, '120', 'CABRERA'),
(482, 15, '123', 'CACHIPAY'),
(483, 15, '126', 'CAJICA'),
(484, 15, '148', 'CAPARRAPI'),
(485, 15, '151', 'CAQUEZA'),
(486, 15, '154', 'CARMEN DE CARUPA'),
(487, 15, '168', 'CHAGUANI'),
(488, 15, '175', 'CHIA'),
(489, 15, '178', 'CHIPAQUE'),
(490, 15, '181', 'CHOACHI'),
(491, 15, '183', 'CHOCONTA'),
(492, 15, '200', 'COGUA'),
(493, 15, '214', 'COTA'),
(494, 15, '224', 'CUCUNUBA'),
(495, 15, '245', 'EL COLEGIO'),
(496, 15, '258', 'EL PEÑON'),
(497, 15, '260', 'EL ROSAL'),
(498, 15, '269', 'FACATATIVA'),
(499, 15, '279', 'FOMEQUE'),
(500, 15, '281', 'FOSCA'),
(501, 15, '286', 'FUNZA'),
(502, 15, '288', 'FUQUENE'),
(503, 15, '290', 'FUSAGASUGA'),
(504, 15, '293', 'GACHALA'),
(505, 15, '295', 'GACHANCIPA'),
(506, 15, '297', 'GACHETA'),
(507, 15, '299', 'GAMA'),
(508, 15, '307', 'GIRARDOT'),
(509, 15, '312', 'GRANADA'),
(510, 15, '317', 'GUACHETA'),
(511, 15, '320', 'GUADUAS'),
(512, 15, '322', 'GUASCA'),
(513, 15, '324', 'GUATAQUI'),
(514, 15, '326', 'GUATAVITA'),
(515, 15, '328', 'GUAYABAL DE SIQUIMA'),
(516, 15, '335', 'GUAYABETAL'),
(517, 15, '339', 'GUTIERREZ'),
(518, 15, '368', 'JERUSALEN'),
(519, 15, '372', 'JUNIN'),
(520, 15, '377', 'LA CALERA'),
(521, 15, '386', 'LA MESA'),
(522, 15, '394', 'LA PALMA'),
(523, 15, '398', 'LA PEÑA'),
(524, 15, '402', 'LA VEGA'),
(525, 15, '407', 'LENGUAZAQUE'),
(526, 15, '426', 'MACHETA'),
(527, 15, '430', 'MADRID'),
(528, 15, '436', 'MANTA'),
(529, 15, '438', 'MEDINA'),
(530, 15, '473', 'MOSQUERA'),
(531, 15, '483', 'NARIÑO'),
(532, 15, '486', 'NEMOCON'),
(533, 15, '488', 'NILO'),
(534, 15, '489', 'NIMAIMA'),
(535, 15, '491', 'NOCAIMA'),
(536, 15, '506', 'VENECIA (OSPINA PEREZ)'),
(537, 15, '513', 'PACHO'),
(538, 15, '518', 'PAIME'),
(539, 15, '524', 'PANDI'),
(540, 15, '530', 'PARATEBUENO'),
(541, 15, '535', 'PASCA'),
(542, 15, '572', 'PUERTO SALGAR'),
(543, 15, '580', 'PULI'),
(544, 15, '592', 'QUEBRADANEGRA'),
(545, 15, '594', 'QUETAME'),
(546, 15, '596', 'QUIPILE'),
(547, 15, '599', 'APULO (RAFAEL REYES)'),
(548, 15, '612', 'RICAURTE'),
(549, 15, '645', 'SAN ANTONIO DEL TEQUENDAMA'),
(550, 15, '649', 'SAN BERNARDO'),
(551, 15, '653', 'SAN CAYETANO'),
(552, 15, '658', 'SAN FRANCISCO'),
(553, 15, '662', 'SAN JUAN DE RIOSECO'),
(554, 15, '718', 'SASAIMA'),
(555, 15, '736', 'SESQUILE'),
(556, 15, '740', 'SIBATE'),
(557, 15, '743', 'SILVANIA'),
(558, 15, '745', 'SIMIJACA'),
(559, 15, '754', 'SOACHA'),
(560, 15, '758', 'SOPO'),
(561, 15, '769', 'SUBACHOQUE'),
(562, 15, '772', 'SUESCA'),
(563, 15, '777', 'SUPATA'),
(564, 15, '779', 'SUSA'),
(565, 15, '781', 'SUTATAUSA'),
(566, 15, '785', 'TABIO'),
(567, 15, '793', 'TAUSA'),
(568, 15, '797', 'TENA'),
(569, 15, '799', 'TENJO'),
(570, 15, '805', 'TIBACUY'),
(571, 15, '807', 'TIBIRITA'),
(572, 15, '815', 'TOCAIMA'),
(573, 15, '817', 'TOCANCIPA'),
(574, 15, '823', 'TOPAIPI'),
(575, 15, '839', 'UBALA'),
(576, 15, '841', 'UBAQUE'),
(577, 15, '843', 'UBATE'),
(578, 15, '845', 'UNE'),
(579, 15, '851', 'UTICA'),
(580, 15, '862', 'VERGARA'),
(581, 15, '867', 'VIANI'),
(582, 15, '871', 'VILLAGOMEZ'),
(583, 15, '873', 'VILLAPINZON'),
(584, 15, '875', 'VILLETA'),
(585, 15, '878', 'VIOTA'),
(586, 15, '885', 'YACOPI'),
(587, 15, '898', 'ZIPACON'),
(588, 15, '899', 'ZIPAQUIRA'),
(589, 13, '001', 'QUIBDO'),
(590, 13, '006', 'ACANDI'),
(591, 13, '025', 'ALTO BAUDO (PIE DE PATO)'),
(592, 13, '050', 'ATRATO'),
(593, 13, '073', 'BAGADO'),
(594, 13, '075', 'BAHIA SOLANO (MUTIS)'),
(595, 13, '077', 'BAJO BAUDO (PIZARRO)'),
(596, 13, '099', 'BOJAYA (BELLAVISTA)'),
(597, 13, '135', 'CANTON DE SAN PABLO(MANAGRU)'),
(598, 13, '205', 'CONDOTO'),
(599, 13, '245', 'EL CARMEN DE ATRATO'),
(600, 13, '250', 'LITORAL DEL BAJO SAN JUAN'),
(601, 13, '361', 'ISTMINA'),
(602, 13, '372', 'JURADO'),
(603, 13, '413', 'LLORO'),
(604, 13, '425', 'MEDIO ATRATO'),
(605, 13, '430', 'MEDIO BAUDO'),
(606, 13, '491', 'NOVITA'),
(607, 13, '495', 'NUQUI'),
(608, 13, '600', 'RIOQUITO'),
(609, 13, '615', 'RIOSUCIO'),
(610, 13, '660', 'SAN JOSE DEL PALMAR'),
(611, 13, '745', 'SIPI'),
(612, 13, '787', 'TADO'),
(613, 13, '800', 'UNGUIA'),
(614, 13, '810', 'UNION PANAMERICANA'),
(615, 18, '001', 'NEIVA'),
(616, 18, '006', 'ACEVEDO'),
(617, 18, '013', 'AGRADO'),
(618, 18, '016', 'AIPE'),
(619, 18, '020', 'ALGECIRAS'),
(620, 18, '026', 'ALTAMIRA'),
(621, 18, '078', 'BARAYA'),
(622, 18, '132', 'CAMPOALEGRE'),
(623, 18, '206', 'COLOMBIA'),
(624, 18, '244', 'ELIAS'),
(625, 18, '298', 'GARZON'),
(626, 18, '306', 'GIGANTE'),
(627, 18, '319', 'GUADALUPE'),
(628, 18, '349', 'HOBO'),
(629, 18, '357', 'IQUIRA'),
(630, 18, '359', 'SAN JOSE DE ISNOS'),
(631, 18, '378', 'LA ARGENTINA'),
(632, 18, '396', 'LA PLATA'),
(633, 18, '483', 'NATAGA'),
(634, 18, '503', 'OPORAPA'),
(635, 18, '518', 'PAICOL'),
(636, 18, '524', 'PALERMO'),
(637, 18, '530', 'PALESTINA'),
(638, 18, '548', 'PITAL'),
(639, 18, '551', 'PITALITO'),
(640, 18, '615', 'RIVERA'),
(641, 18, '660', 'SALADOBLANCO'),
(642, 18, '668', 'SAN AGUSTIN'),
(643, 18, '676', 'SANTA MARIA'),
(644, 18, '770', 'SUAZA'),
(645, 18, '791', 'TARQUI'),
(646, 18, '797', 'TESALIA'),
(647, 18, '799', 'TELLO'),
(648, 18, '801', 'TERUEL'),
(649, 18, '807', 'TIMANA'),
(650, 18, '872', 'VILLAVIEJA'),
(651, 18, '885', 'YAGUARA'),
(652, 19, '001', 'RIOHACHA'),
(653, 19, '078', 'BARRANCAS'),
(654, 19, '090', 'DIBULLA'),
(655, 19, '098', 'DISTRACCION'),
(656, 19, '110', 'EL MOLINO'),
(657, 19, '279', 'FONSECA'),
(658, 19, '378', 'HATONUEVO'),
(659, 19, '420', 'LA JAGUA DEL PILAR'),
(660, 19, '430', 'MAICAO'),
(661, 19, '560', 'MANAURE'),
(662, 19, '650', 'SAN JUAN DEL CESAR'),
(663, 19, '847', 'URIBIA'),
(664, 19, '855', 'URUMITA'),
(665, 19, '874', 'VILLANUEVA'),
(666, 20, '001', 'SANTA MARTA'),
(667, 20, '030', 'ALGARROBO'),
(668, 20, '053', 'ARACATACA'),
(669, 20, '058', 'ARIGUANI (EL DIFICIL)'),
(670, 20, '161', 'CERRO SAN ANTONIO'),
(671, 20, '170', 'CHIVOLO'),
(672, 20, '189', 'CIENAGA'),
(673, 20, '205', 'CONCORDIA'),
(674, 20, '245', 'EL BANCO'),
(675, 20, '258', 'EL PIÑON'),
(676, 20, '268', 'EL RETEN'),
(677, 20, '288', 'FUNDACION'),
(678, 20, '318', 'GUAMAL'),
(679, 20, '541', 'PEDRAZA'),
(680, 20, '545', 'PIJIÑO DEL CARMEN(PIJIÑO)'),
(681, 20, '551', 'PIVIJAY'),
(682, 20, '555', 'PLATO'),
(683, 20, '570', 'PUEBLOVIEJO'),
(684, 20, '605', 'REMOLINO'),
(685, 20, '660', 'SABANAS DE SAN ANGEL'),
(686, 20, '675', 'SALAMINA'),
(687, 20, '692', 'SAN SEBASTIAN DE BUENAVISTA'),
(688, 20, '703', 'SAN ZENON'),
(689, 20, '707', 'SANTA ANA'),
(690, 20, '745', 'SITIONUEVO'),
(691, 20, '798', 'TENERIFE'),
(692, 21, '001', 'VILLAVICENCIO'),
(693, 21, '006', 'ACACIAS'),
(694, 21, '110', 'BARRANCA DE UPIA'),
(695, 21, '124', 'CABUYARO'),
(696, 21, '150', 'CASTILLA LA NUEVA'),
(697, 21, '223', 'SAN LUIS DE CUBARRAL'),
(698, 21, '226', 'CUMARAL'),
(699, 21, '245', 'EL CALVARIO'),
(700, 21, '251', 'EL CASTILLO'),
(701, 21, '270', 'EL DORADO'),
(702, 21, '287', 'FUENTE DE ORO'),
(703, 21, '313', 'GRANADA'),
(704, 21, '318', 'GUAMAL'),
(705, 21, '325', 'MAPIRIPAN'),
(706, 21, '330', 'MESETAS'),
(707, 21, '350', 'LA MACARENA'),
(708, 21, '370', 'LA URIBE'),
(709, 21, '400', 'LEJANIAS'),
(710, 21, '450', 'PUERTO CONCORDIA'),
(711, 21, '568', 'PUERTO GAITAN'),
(712, 21, '573', 'PUERTO LOPEZ'),
(713, 21, '577', 'PUERTO LLERAS'),
(714, 21, '590', 'PUERTO RICO'),
(715, 21, '606', 'RESTREPO'),
(716, 21, '680', 'SAN CARLOS DE GUAROA'),
(717, 21, '683', 'SAN JUAN DE ARAMA'),
(718, 21, '686', 'SAN JUANITO'),
(719, 21, '689', 'SAN MARTIN'),
(720, 21, '711', 'VISTAHERMOSA'),
(721, 22, '001', 'PASTO'),
(722, 22, '019', 'ALBAN (SAN JOSE)'),
(723, 22, '022', 'ALDANA'),
(724, 22, '036', 'ANCUYA'),
(725, 22, '051', 'ARBOLEDA (BERRUECOS)'),
(726, 22, '079', 'BARBACOAS'),
(727, 22, '083', 'BELEN'),
(728, 22, '110', 'BUESACO'),
(729, 22, '203', 'COLON (GENOVA)'),
(730, 22, '207', 'CONSACA'),
(731, 22, '210', 'CONTADERO'),
(732, 22, '215', 'CORDOBA'),
(733, 22, '224', 'CUASPUD (CARLOSAMA)'),
(734, 22, '227', 'CUMBAL'),
(735, 22, '233', 'CUMBITARA'),
(736, 22, '240', 'CHACHAGUI'),
(737, 22, '250', 'EL CHARCO'),
(738, 22, '254', 'EL PEÑOL'),
(739, 22, '256', 'EL ROSARIO'),
(740, 22, '258', 'EL TABLON'),
(741, 22, '260', 'EL TAMBO'),
(742, 22, '287', 'FUNES'),
(743, 22, '317', 'GUACHUCAL'),
(744, 22, '320', 'GUAITARILLA'),
(745, 22, '323', 'GUALMATAN'),
(746, 22, '352', 'ILES'),
(747, 22, '354', 'IMUES'),
(748, 22, '356', 'IPIALES'),
(749, 22, '378', 'LA CRUZ'),
(750, 22, '381', 'LA FLORIDA'),
(751, 22, '385', 'LA LLANADA'),
(752, 22, '390', 'LA TOLA'),
(753, 22, '399', 'LA UNION'),
(754, 22, '405', 'LEIVA'),
(755, 22, '411', 'LINARES'),
(756, 22, '418', 'LOS ANDES (SOTOMAYOR)'),
(757, 22, '427', 'MAGUI (PAYAN)'),
(758, 22, '435', 'MALLAMA (PIEDRANCHA)'),
(759, 22, '473', 'MOSQUERA'),
(760, 22, '490', 'OLAYA HERRERA (BOCAS DE SATINGA)'),
(761, 22, '506', 'OSPINA'),
(762, 22, '520', 'FRANCISCO PIZARRO(SALAHONDA)'),
(763, 22, '540', 'POLICARPA'),
(764, 22, '560', 'POTOSI'),
(765, 22, '565', 'PROVIDENCIA'),
(766, 22, '573', 'PUERRES'),
(767, 22, '585', 'PUPIALES'),
(768, 22, '612', 'RICAURTE'),
(769, 22, '621', 'ROBERTO PAYAN (SAN JOSE)'),
(770, 22, '678', 'SAMANIEGO'),
(771, 22, '683', 'SANDONA'),
(772, 22, '685', 'SAN BERNARDO'),
(773, 22, '687', 'SAN LORENZO'),
(774, 22, '693', 'SAN PABLO'),
(775, 22, '694', 'SAN PEDRO DE CARTAGO'),
(776, 22, '696', 'SANTA BARBARA(ISCUANDE)'),
(777, 22, '699', 'SANTA CRUZ (GUACHAVES)'),
(778, 22, '720', 'SAPUYES'),
(779, 22, '786', 'TAMINANGO'),
(780, 22, '788', 'TANGUA'),
(781, 22, '835', 'TUMACO'),
(782, 22, '838', 'TUQUERRES'),
(783, 22, '885', 'YACUANQUER'),
(784, 23, '001', 'CUCUTA'),
(785, 23, '003', 'ABREGO'),
(786, 23, '051', 'ARBOLEDAS'),
(787, 23, '099', 'BOCHALEMA'),
(788, 23, '109', 'BUCARASICA'),
(789, 23, '125', 'CACOTA'),
(790, 23, '128', 'CACHIRA'),
(791, 23, '172', 'CHINACOTA'),
(792, 23, '174', 'CHITAGA'),
(793, 23, '206', 'CONVENCION'),
(794, 23, '223', 'CUCUTILLA'),
(795, 23, '239', 'DURANIA'),
(796, 23, '245', 'EL CARMEN'),
(797, 23, '250', 'EL TARRA'),
(798, 23, '261', 'EL ZULIA'),
(799, 23, '313', 'GRAMALOTE'),
(800, 23, '344', 'HACARI'),
(801, 23, '347', 'HERRAN'),
(802, 23, '377', 'LABATECA'),
(803, 23, '385', 'LA ESPERANZA'),
(804, 23, '398', 'LA PLAYA'),
(805, 23, '405', 'LOS PATIOS'),
(806, 23, '418', 'LOURDES'),
(807, 23, '480', 'MUTISCUA'),
(808, 23, '498', 'OCAÑA'),
(809, 23, '518', 'PAMPLONA'),
(810, 23, '520', 'PAMPLONITA'),
(811, 23, '553', 'PUERTO SANTANDER'),
(812, 23, '599', 'RAGONVALIA'),
(813, 23, '660', 'SALAZAR'),
(814, 23, '670', 'SAN CALIXTO'),
(815, 23, '673', 'SAN CAYETANO'),
(816, 23, '680', 'SANTIAGO'),
(817, 23, '720', 'SARDINATA'),
(818, 23, '743', 'SILOS'),
(819, 23, '800', 'TEORAMA'),
(820, 23, '810', 'TIBU'),
(821, 23, '820', 'TOLEDO'),
(822, 23, '871', 'VILLACARO'),
(823, 23, '874', 'VILLA DEL ROSARIO'),
(824, 25, '001', 'ARMENIA'),
(825, 25, '110', 'BUENAVISTA'),
(826, 25, '130', 'CALARCA'),
(827, 25, '190', 'CIRCASIA'),
(828, 25, '212', 'CORDOBA'),
(829, 25, '272', 'FILANDIA'),
(830, 25, '302', 'GENOVA'),
(831, 25, '401', 'LA TEBAIDA'),
(832, 25, '470', 'MONTENEGRO'),
(833, 25, '548', 'PIJAO'),
(834, 25, '594', 'QUIMBAYA'),
(835, 25, '690', 'SALENTO'),
(836, 26, '001', 'PEREIRA'),
(837, 26, '045', 'APIA'),
(838, 26, '075', 'BALBOA'),
(839, 26, '088', 'BELEN DE UMBRIA'),
(840, 26, '170', 'DOS QUEBRADAS'),
(841, 26, '318', 'GUATICA'),
(842, 26, '383', 'LA CELIA'),
(843, 26, '400', 'LA VIRGINIA'),
(844, 26, '440', 'MARSELLA'),
(845, 26, '446', 'MISTRATO'),
(846, 26, '572', 'PUEBLO RICO'),
(847, 26, '594', 'QUINCHIA'),
(848, 26, '682', 'SANTA ROSA DE CABAL'),
(849, 26, '687', 'SANTUARIO'),
(850, 28, '001', 'BUCARAMANGA'),
(851, 28, '013', 'AGUADA'),
(852, 28, '020', 'ALBANIA'),
(853, 28, '051', 'ARATOCA'),
(854, 28, '077', 'BARBOSA'),
(855, 28, '079', 'BARICHARA'),
(856, 28, '081', 'BARRANCABERMEJA'),
(857, 28, '092', 'BETULIA'),
(858, 28, '101', 'BOLIVAR'),
(859, 28, '121', 'CABRERA'),
(860, 28, '132', 'CALIFORNIA'),
(861, 28, '147', 'CAPITANEJO'),
(862, 28, '152', 'CARCASI'),
(863, 28, '160', 'CEPITA'),
(864, 28, '162', 'CERRITO'),
(865, 28, '167', 'CHARALA'),
(866, 28, '169', 'CHARTA'),
(867, 28, '176', 'CHIMA'),
(868, 28, '179', 'CHIPATA'),
(869, 28, '190', 'CIMITARRA'),
(870, 28, '207', 'CONCEPCION'),
(871, 28, '209', 'CONFINES'),
(872, 28, '211', 'CONTRATACION'),
(873, 28, '217', 'COROMORO'),
(874, 28, '229', 'CURITI'),
(875, 28, '235', 'EL CARMEN DE CHUCURY'),
(876, 28, '245', 'EL GUACAMAYO'),
(877, 28, '250', 'EL PEÑON'),
(878, 28, '255', 'EL PLAYON'),
(879, 28, '264', 'ENCINO'),
(880, 28, '266', 'ENCISO'),
(881, 28, '271', 'FLORIAN'),
(882, 28, '276', 'FLORIDABLANCA'),
(883, 28, '296', 'GALAN'),
(884, 28, '298', 'GAMBITA'),
(885, 28, '307', 'GIRON'),
(886, 28, '318', 'GUACA'),
(887, 28, '320', 'GUADALUPE'),
(888, 28, '322', 'GUAPOTA'),
(889, 28, '324', 'GUAVATA'),
(890, 28, '327', 'GUEPSA'),
(891, 28, '344', 'HATO'),
(892, 28, '368', 'JESUS MARIA'),
(893, 28, '370', 'JORDAN'),
(894, 28, '377', 'LA BELLEZA'),
(895, 28, '385', 'LANDAZURI'),
(896, 28, '397', 'LA PAZ'),
(897, 28, '406', 'LEBRIJA'),
(898, 28, '418', 'LOS SANTOS'),
(899, 28, '425', 'MACARAVITA'),
(900, 28, '432', 'MALAGA'),
(901, 28, '444', 'MATANZA'),
(902, 28, '464', 'MOGOTES'),
(903, 28, '468', 'MOLAGAVITA'),
(904, 28, '498', 'OCAMONTE'),
(905, 28, '500', 'OIBA'),
(906, 28, '502', 'ONZAGA'),
(907, 28, '522', 'PALMAR'),
(908, 28, '524', 'PALMAS DEL SOCORRO'),
(909, 28, '533', 'PARAMO'),
(910, 28, '547', 'PIEDECUESTA'),
(911, 28, '549', 'PINCHOTE'),
(912, 28, '572', 'PUENTE NACIONAL'),
(913, 28, '573', 'PUERTO PARRA'),
(914, 28, '575', 'PUERTO WILCHES'),
(915, 28, '615', 'RIONEGRO'),
(916, 28, '655', 'SABANA DE TORRES'),
(917, 28, '669', 'SAN ANDRES'),
(918, 28, '673', 'SAN BENITO'),
(919, 28, '679', 'SAN GIL'),
(920, 28, '682', 'SAN JOAQUIN'),
(921, 28, '684', 'SAN JOSE DE MIRANDA'),
(922, 28, '686', 'SAN MIGUEL'),
(923, 28, '689', 'SAN VICENTE DE CHUCURI'),
(924, 28, '705', 'SANTA BARBARA'),
(925, 28, '720', 'SANTA HELENA DEL OPON'),
(926, 28, '745', 'SIMACOTA'),
(927, 28, '755', 'SOCORRO'),
(928, 28, '770', 'SUAITA'),
(929, 28, '773', 'SUCRE'),
(930, 28, '780', 'SURATA'),
(931, 28, '820', 'TONA'),
(932, 28, '855', 'VALLE SAN JOSE'),
(933, 28, '861', 'VELEZ'),
(934, 28, '867', 'VETAS'),
(935, 28, '872', 'VILLANUEVA'),
(936, 28, '895', 'ZAPATOCA'),
(937, 29, '001', 'SINCELEJO'),
(938, 29, '110', 'BUENAVISTA'),
(939, 29, '124', 'CAIMITO'),
(940, 29, '204', 'COLOSO (RICAURTE)'),
(941, 29, '215', 'COROZAL'),
(942, 29, '230', 'CHALAN'),
(943, 29, '235', 'GALERAS (NUEVA GRANADA)'),
(944, 29, '235', 'GUARANDA'),
(945, 29, '400', 'LA UNION'),
(946, 29, '418', 'LOS PALMITOS'),
(947, 29, '429', 'MAJAGUAL'),
(948, 29, '473', 'MORROA'),
(949, 29, '508', 'OVEJAS'),
(950, 29, '523', 'PALMITO'),
(951, 29, '670', 'SAMPUES'),
(952, 29, '678', 'SAN BENITO ABAD'),
(953, 29, '702', 'SAN JUAN DE BETULIA'),
(954, 29, '708', 'SAN MARCOS'),
(955, 29, '713', 'SAN ONOFRE'),
(956, 29, '717', 'SAN PEDRO'),
(957, 29, '742', 'SINCE'),
(958, 29, '741', 'SUCRE'),
(959, 29, '820', 'TOLU'),
(960, 29, '823', 'TOLUVIEJO'),
(961, 30, '001', 'IBAGUE'),
(962, 30, '024', 'ALPUJARRA'),
(963, 30, '026', 'ALVARADO'),
(964, 30, '030', 'AMBALEMA'),
(965, 30, '043', 'ANZOATEGUI'),
(966, 30, '055', 'ARMERO (GUAYABAL)'),
(967, 30, '067', 'ATACO'),
(968, 30, '124', 'CAJAMARCA'),
(969, 30, '148', 'CARMEN APICALA'),
(970, 30, '152', 'CASABIANCA'),
(971, 30, '168', 'CHAPARRAL'),
(972, 30, '200', 'COELLO'),
(973, 30, '217', 'COYAIMA'),
(974, 30, '226', 'CUNDAY'),
(975, 30, '236', 'DOLORES'),
(976, 30, '268', 'ESPINAL'),
(977, 30, '270', 'FALAN'),
(978, 30, '275', 'FLANDES'),
(979, 30, '283', 'FRESNO'),
(980, 30, '319', 'GUAMO'),
(981, 30, '347', 'HERVEO'),
(982, 30, '349', 'HONDA'),
(983, 30, '352', 'ICONONZO'),
(984, 30, '408', 'LERIDA'),
(985, 30, '411', 'LIBANO'),
(986, 30, '443', 'MARIQUITA'),
(987, 30, '449', 'MELGAR'),
(988, 30, '461', 'MURILLO'),
(989, 30, '483', 'NATAGAIMA'),
(990, 30, '504', 'ORTEGA'),
(991, 30, '520', 'PALOCABILDO'),
(992, 30, '547', 'PIEDRAS'),
(993, 30, '555', 'PLANADAS'),
(994, 30, '563', 'PRADO'),
(995, 30, '585', 'PURIFICACION'),
(996, 30, '616', 'RIOBLANCO'),
(997, 30, '622', 'RONCESVALLES'),
(998, 30, '624', 'ROVIRA'),
(999, 30, '671', 'SALDAÑA'),
(1000, 30, '675', 'SAN ANTONIO'),
(1001, 30, '678', 'SAN LUIS'),
(1002, 30, '686', 'SANTA ISABEL'),
(1003, 30, '770', 'SUAREZ'),
(1004, 30, '854', 'VALLE DE SAN JUAN'),
(1005, 30, '861', 'VENADILLO'),
(1006, 30, '870', 'VILLAHERMOSA'),
(1007, 30, '873', 'VILLARRICA'),
(1008, 31, '001', 'CALI (SANTIAGO DE CALI)'),
(1009, 31, '020', 'ALCALA'),
(1010, 31, '036', 'ANDALUCIA'),
(1011, 31, '041', 'ANSERMANUEVO'),
(1012, 31, '054', 'ARGELIA'),
(1013, 31, '100', 'BOLIVAR'),
(1014, 31, '109', 'BUENAVENTURA'),
(1015, 31, '111', 'BUGA'),
(1016, 31, '113', 'BUGALAGRANDE'),
(1017, 31, '122', 'CAICEDONIA'),
(1018, 31, '126', 'CALIMA (DARIEN)'),
(1019, 31, '130', 'CANDELARIA'),
(1020, 31, '147', 'CARTAGO'),
(1021, 31, '233', 'DAGUA'),
(1022, 31, '243', 'EL AGUILA'),
(1023, 31, '246', 'EL CAIRO'),
(1024, 31, '248', 'EL CERRITO'),
(1025, 31, '250', 'EL DOVIO'),
(1026, 31, '275', 'FLORIDA'),
(1027, 31, '306', 'GINEBRA'),
(1028, 31, '318', 'GUACARI'),
(1029, 31, '364', 'JAMUNDI'),
(1030, 31, '377', 'LA CUMBRE'),
(1031, 31, '400', 'LA UNION'),
(1032, 31, '403', 'LA VICTORIA'),
(1033, 31, '497', 'OBANDO'),
(1034, 31, '520', 'PALMIRA'),
(1035, 31, '563', 'PRADERA'),
(1036, 31, '606', 'RESTREPO'),
(1037, 31, '616', 'RIOFRIO'),
(1038, 31, '622', 'ROLDANILLO'),
(1039, 31, '670', 'SAN PEDRO'),
(1040, 31, '736', 'SEVILLA'),
(1041, 31, '823', 'TORO'),
(1042, 31, '828', 'TRUJILLO'),
(1043, 31, '834', 'TULUA'),
(1044, 31, '845', 'ULLOA'),
(1045, 31, '863', 'VERSALLES'),
(1046, 31, '869', 'VIJES'),
(1047, 31, '890', 'YOTOCO'),
(1048, 31, '892', 'YUMBO'),
(1049, 31, '895', 'ZARZAL'),
(1050, 3, '001', 'ARAUCA'),
(1051, 3, '065', 'ARAUQUITA'),
(1052, 3, '220', 'CRAVO NORTE'),
(1053, 3, '300', 'FORTUL'),
(1054, 3, '591', 'PUERTO RONDON'),
(1055, 3, '736', 'SARAVENA'),
(1056, 3, '794', 'TAME'),
(1057, 10, '001', 'YOPAL'),
(1058, 10, '010', 'AGUAZUL'),
(1059, 10, '015', 'CHAMEZA'),
(1060, 10, '125', 'HATO COROZAL'),
(1061, 10, '136', 'LA SALINA'),
(1062, 10, '139', 'MANI'),
(1063, 10, '162', 'MONTERREY'),
(1064, 10, '225', 'NUNCHIA'),
(1065, 10, '230', 'OROCUE'),
(1066, 10, '250', 'PAZ DE ARIPORO'),
(1067, 10, '263', 'PORE'),
(1068, 10, '279', 'RECETOR'),
(1069, 10, '300', 'SABANALARGA'),
(1070, 10, '315', 'SACAMA'),
(1071, 10, '325', 'SAN LUIS DE PALENQUE'),
(1072, 10, '400', 'TAMARA'),
(1073, 10, '410', 'TAURAMENA'),
(1074, 10, '430', 'TRINIDAD'),
(1075, 10, '440', 'VILLANUEVA'),
(1076, 24, '001', 'MOCOA'),
(1077, 24, '219', 'COLON'),
(1078, 24, '320', 'ORITO'),
(1079, 24, '568', 'PUERTO ASIS'),
(1080, 24, '569', 'PUERTO CAICEDO'),
(1081, 24, '571', 'PUERTO GUZMAN'),
(1082, 24, '573', 'PUERTO LEGUIZAMO'),
(1083, 24, '749', 'SIBUNDOY'),
(1084, 24, '755', 'SAN FRANCISCO'),
(1085, 24, '757', 'SAN MIGUEL(LA DORADA)'),
(1086, 24, '760', 'SANTIAGO'),
(1087, 24, '865', 'LA HORMIGA(VALLE DEL GUAMUEZ)'),
(1088, 24, '885', 'VILLAGARZON'),
(1089, 27, '001', 'SAN ANDRES'),
(1090, 27, '564', 'PROVIDENCIA'),
(1091, 1, '001', 'LETICIA'),
(1092, 1, '263', 'EL ENCANTO'),
(1093, 1, '405', 'LA CHORRERA'),
(1094, 1, '407', 'LA PEDRERA'),
(1095, 1, '430', 'LA VICTORIA'),
(1096, 1, '460', 'MIRITI-PARANA'),
(1097, 1, '530', 'PUERTO ALEGRIA'),
(1098, 1, '536', 'PUERTO ARICA'),
(1099, 1, '540', 'PUERTO NARIÑO'),
(1100, 1, '669', 'PUERTO SANTANDER'),
(1101, 1, '798', 'TARAPACA'),
(1102, 16, '001', 'PUERTO INIRIDA'),
(1103, 16, '343', 'BARRANCO MINAS'),
(1104, 16, '883', 'SAN FELIPE'),
(1105, 16, '884', 'PUERTO COLOMBIA'),
(1106, 16, '885', 'LA GUADALUPE'),
(1107, 16, '886', 'CACAHUAL'),
(1108, 16, '887', 'PANA PANA (CAMPO ALEGRE)'),
(1109, 16, '888', 'MORICHAL (MORICHAL NUEVO)'),
(1110, 17, '001', 'SAN JOSE DEL GUAVIARE'),
(1111, 17, '015', 'CALAMAR'),
(1112, 17, '025', 'EL RETORNO'),
(1113, 17, '200', 'MIRAFLORES'),
(1114, 32, '001', 'MITU'),
(1115, 32, '161', 'CARURU'),
(1116, 32, '511', 'PACOA'),
(1117, 32, '666', 'TARAIRA'),
(1118, 32, '777', 'PAPUNAUA (MORICHAL)'),
(1119, 32, '889', 'YAVARATE'),
(1120, 33, '001', 'PUERTO CARREÑO'),
(1121, 33, '524', 'LA PRIMAVERA'),
(1122, 33, '572', 'SANTA RITA'),
(1123, 33, '666', 'SANTA ROSALIA'),
(1124, 33, '760', 'SAN JOSE DE OCUNE'),
(1125, 33, '773', 'CUMARIBO');

-- --------------------------------------------------------

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
CREATE TABLE IF NOT EXISTS `producto` (
  `idproducto` int(11) NOT NULL AUTO_INCREMENT,
  `idcategoria` int(11) NOT NULL,
  `codreferencia` varchar(20) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `marca` varchar(80) DEFAULT 'N/A',
  `descripcion` text,
  `imagen` text,
  `stock` int(11) NOT NULL,
  `preciocompra` decimal(6,2) NOT NULL,
  PRIMARY KEY (`idproducto`),
  KEY `idcategoria` (`idcategoria`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `roll`
--

DROP TABLE IF EXISTS `roll`;
CREATE TABLE IF NOT EXISTS `roll` (
  `idroll` int(11) NOT NULL AUTO_INCREMENT,
  `roll` varchar(50) NOT NULL,
  PRIMARY KEY (`idroll`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `roll`
--

INSERT INTO `roll` (`idroll`, `roll`) VALUES
(1, 'administrador'),
(2, 'cliente');

-- --------------------------------------------------------

--
-- Table structure for table `tipodocumento`
--

DROP TABLE IF EXISTS `tipodocumento`;
CREATE TABLE IF NOT EXISTS `tipodocumento` (
  `idnodoc` int(11) NOT NULL AUTO_INCREMENT,
  `tipodocumento` varchar(50) NOT NULL,
  PRIMARY KEY (`idnodoc`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tipodocumento`
--

INSERT INTO `tipodocumento` (`idnodoc`, `tipodocumento`) VALUES
(1, 'cedula de ciudadania'),
(2, 'targeta de identidad'),
(3, 'cedula de extrangeria');

-- --------------------------------------------------------

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `idusuario` int(11) NOT NULL AUTO_INCREMENT,
  `idnodoc` int(11) NOT NULL,
  `numdocumento` varchar(20) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) NOT NULL,
  `idgenero` int(11) NOT NULL,
  `direccion` varchar(200) NOT NULL,
  `idroll` int(11) DEFAULT NULL,
  `telefono` varchar(15) NOT NULL,
  `nocelular` varchar(15) DEFAULT 'ninguno',
  `fechanacimiento` date NOT NULL,
  `fechaActivo` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `email` varchar(200) NOT NULL,
  `pass` varchar(60) NOT NULL,
  `userimage` text NOT NULL,
  `idDepartamentos` int(11) NOT NULL,
  `idMunicipios` int(11) NOT NULL,
  PRIMARY KEY (`idusuario`),
  KEY `idnodoc` (`idnodoc`),
  KEY `idgenero` (`idgenero`),
  KEY `idroll` (`idroll`),
  KEY `idDepartamentos` (`idDepartamentos`),
  KEY `idMunicipios` (`idMunicipios`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
