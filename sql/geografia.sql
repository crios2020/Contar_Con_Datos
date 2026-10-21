DROP DATABASE IF EXISTS estadisticas_eph;
CREATE DATABASE IF NOT EXISTS estadisticas_eph
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE estadisticas_eph;

-- =====================================================
-- 1. TABLA DE REGIONES EPH
-- =====================================================

CREATE TABLE regiones_eph (
    codigo_region SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE = InnoDB;

INSERT INTO regiones_eph (codigo_region, nombre) VALUES
(1,  'Gran Buenos Aires'),
(40, 'Noroeste (NOA)'),
(41, 'Noreste (NEA)'),
(42, 'Cuyo'),
(43, 'Pampeana'),
(44, 'Patagonia');


-- =====================================================
-- 2. TABLA DE AGLOMERADOS EPH
-- =====================================================

CREATE TABLE aglomerados_eph (
    codigo_aglomerado CHAR(2) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo_region SMALLINT UNSIGNED NOT NULL,

    CONSTRAINT fk_aglomerado_region
        FOREIGN KEY (codigo_region)
        REFERENCES regiones_eph (codigo_region)
) ENGINE = InnoDB;



INSERT INTO aglomerados_eph
    (codigo_aglomerado, nombre, codigo_region)
VALUES
    ('02', 'Gran La Plata', 43),
    ('03', 'Bahía Blanca-Cerri', 43),
    ('04', 'Gran Rosario', 43),
    ('05', 'Gran Santa Fe', 43),
    ('06', 'Gran Paraná', 43),
    ('07', 'Posadas', 41),
    ('08', 'Gran Resistencia', 41),
    ('09', 'Comodoro Rivadavia-Rada Tilly', 44),
    ('10', 'Gran Mendoza', 42),
    ('12', 'Corrientes', 41),
    ('13', 'Gran Córdoba', 43),
    ('14', 'Concordia', 43),
    ('15', 'Formosa', 41),
    ('17', 'Neuquén-Plottier', 44),
    ('18', 'Santiago del Estero-La Banda', 40),
    ('19', 'Jujuy-Palpalá', 40),
    ('20', 'Río Gallegos', 44),
    ('22', 'Gran Catamarca', 40),
    ('23', 'Gran Salta', 40),
    ('25', 'La Rioja', 40),
    ('26', 'Gran San Luis', 42),
    ('27', 'Gran San Juan', 42),
    ('29', 'Gran Tucumán-Tafí Viejo', 40),
    ('30', 'Santa Rosa-Toay', 43),
    ('31', 'Ushuaia-Río Grande', 44),
    ('32', 'Ciudad Autónoma de Buenos Aires', 1),
    ('33', 'Partidos del Gran Buenos Aires', 1),
    ('34', 'Mar del Plata', 43),
    ('36', 'Río Cuarto', 43),
    ('38', 'San Nicolás-Villa Constitución', 43),
    ('91', 'Rawson-Trelew', 44),
    ('93', 'Viedma-Carmen de Patagones', 44);

/*
SELECT COUNT(*) AS total_codigos
FROM aglomerados_eph;

select * from aglomerados_eph;
*/

-- =====================================================
-- 3. TABLA DE PROVINCIAS Y CABA
-- =====================================================

CREATE TABLE provincias (
    id_provincia SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE,
    es_caba BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE = InnoDB;

INSERT INTO provincias (nombre, es_caba) VALUES
('Buenos Aires', FALSE),
('Catamarca', FALSE),
('Chaco', FALSE),
('Chubut', FALSE),
('Córdoba', FALSE),
('Corrientes', FALSE),
('Entre Ríos', FALSE),
('Formosa', FALSE),
('Jujuy', FALSE),
('La Pampa', FALSE),
('La Rioja', FALSE),
('Mendoza', FALSE),
('Misiones', FALSE),
('Neuquén', FALSE),
('Río Negro', FALSE),
('Salta', FALSE),
('San Juan', FALSE),
('San Luis', FALSE),
('Santa Cruz', FALSE),
('Santa Fe', FALSE),
('Santiago del Estero', FALSE),
('Tierra del Fuego', FALSE),
('Tucumán', FALSE),
('Ciudad Autónoma de Buenos Aires', TRUE);

/*select count(*) from provincias;*/
-- =====================================================
-- 4. TABLA PUENTE: AGLOMERADOS Y PROVINCIAS
-- =====================================================

CREATE TABLE aglomerados_provincias (
    codigo_aglomerado CHAR(2) NOT NULL,
    id_provincia SMALLINT UNSIGNED NOT NULL,

    PRIMARY KEY (codigo_aglomerado, id_provincia),

    CONSTRAINT fk_ap_aglomerado
        FOREIGN KEY (codigo_aglomerado)
        REFERENCES aglomerados_eph (codigo_aglomerado),

    CONSTRAINT fk_ap_provincia
        FOREIGN KEY (id_provincia)
        REFERENCES provincias (id_provincia)
) ENGINE = InnoDB;


-- =====================================================
-- RELACIONES ENTRE AGLOMERADOS Y PROVINCIAS
-- =====================================================

INSERT INTO aglomerados_provincias
    (codigo_aglomerado, id_provincia)
SELECT '02', id_provincia
FROM provincias WHERE nombre = 'Buenos Aires'

UNION ALL
SELECT '03', id_provincia
FROM provincias WHERE nombre = 'Buenos Aires'

UNION ALL
SELECT '04', id_provincia
FROM provincias WHERE nombre = 'Santa Fe'

UNION ALL
SELECT '05', id_provincia
FROM provincias WHERE nombre = 'Santa Fe'

UNION ALL
SELECT '06', id_provincia
FROM provincias WHERE nombre = 'Entre Ríos'

UNION ALL
SELECT '07', id_provincia
FROM provincias WHERE nombre = 'Misiones'

UNION ALL
SELECT '08', id_provincia
FROM provincias WHERE nombre = 'Chaco'

UNION ALL
SELECT '09', id_provincia
FROM provincias WHERE nombre = 'Chubut'

UNION ALL
SELECT '10', id_provincia
FROM provincias WHERE nombre = 'Mendoza'

UNION ALL
SELECT '12', id_provincia
FROM provincias WHERE nombre = 'Corrientes'

UNION ALL
SELECT '13', id_provincia
FROM provincias WHERE nombre = 'Córdoba'

UNION ALL
SELECT '14', id_provincia
FROM provincias WHERE nombre = 'Entre Ríos'

UNION ALL
SELECT '15', id_provincia
FROM provincias WHERE nombre = 'Formosa'

UNION ALL
SELECT '17', id_provincia
FROM provincias WHERE nombre = 'Neuquén'

UNION ALL
SELECT '18', id_provincia
FROM provincias WHERE nombre = 'Santiago del Estero'

UNION ALL
SELECT '19', id_provincia
FROM provincias WHERE nombre = 'Jujuy'

UNION ALL
SELECT '20', id_provincia
FROM provincias WHERE nombre = 'Santa Cruz'

UNION ALL
SELECT '22', id_provincia
FROM provincias WHERE nombre = 'Catamarca'

UNION ALL
SELECT '23', id_provincia
FROM provincias WHERE nombre = 'Salta'

UNION ALL
SELECT '25', id_provincia
FROM provincias WHERE nombre = 'La Rioja'

UNION ALL
SELECT '26', id_provincia
FROM provincias WHERE nombre = 'San Luis'

UNION ALL
SELECT '27', id_provincia
FROM provincias WHERE nombre = 'San Juan'

UNION ALL
SELECT '29', id_provincia
FROM provincias WHERE nombre = 'Tucumán'

UNION ALL
SELECT '30', id_provincia
FROM provincias WHERE nombre = 'La Pampa'

UNION ALL
SELECT '31', id_provincia
FROM provincias WHERE nombre = 'Tierra del Fuego'

UNION ALL
SELECT '32', id_provincia
FROM provincias
WHERE nombre = 'Ciudad Autónoma de Buenos Aires'

UNION ALL
SELECT '33', id_provincia
FROM provincias WHERE nombre = 'Buenos Aires'

UNION ALL
SELECT '34', id_provincia
FROM provincias WHERE nombre = 'Buenos Aires'

UNION ALL
SELECT '36', id_provincia
FROM provincias WHERE nombre = 'Córdoba'

UNION ALL
SELECT '38', id_provincia
FROM provincias WHERE nombre = 'Buenos Aires'

UNION ALL
SELECT '38', id_provincia
FROM provincias WHERE nombre = 'Santa Fe'

UNION ALL
SELECT '91', id_provincia
FROM provincias WHERE nombre = 'Chubut'

UNION ALL
SELECT '93', id_provincia
FROM provincias WHERE nombre = 'Río Negro'

UNION ALL
SELECT '93', id_provincia
FROM provincias WHERE nombre = 'Buenos Aires';


USE estadisticas_eph;

show tables;
select * from aglomerados_eph;
select * from aglomerados_provincias;

SELECT
    r.codigo_region,
    r.nombre AS region,
    a.codigo_aglomerado,
    a.nombre AS aglomerado,
    p.id_provincia,
    p.nombre AS provincia,
    p.es_caba
FROM regiones_eph AS r
INNER JOIN aglomerados_eph AS a
    ON r.codigo_region = a.codigo_region
INNER JOIN aglomerados_provincias AS ap
    ON a.codigo_aglomerado = ap.codigo_aglomerado
INNER JOIN provincias AS p
    ON ap.id_provincia = p.id_provincia
ORDER BY
    r.codigo_region,
    a.codigo_aglomerado,
    p.nombre;