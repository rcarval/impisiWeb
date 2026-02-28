-- ============================================================
-- Catálogo de rodamientos - Estructura de tabla
-- ============================================================
-- MySQL/MariaDB: ejecutar el bloque "MySQL" a continuación.
-- PostgreSQL: ejecutar el bloque "PostgreSQL" al final del archivo.
-- ============================================================

-- ---------- MySQL / MariaDB ----------
USE cim107841_IMPISI;

CREATE TABLE catalogo_rodamientos (
    id                      INT UNSIGNED         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    codigo                  VARCHAR(20)         NOT NULL COMMENT 'Código del rodamiento (ej: 6205, 6205-2RS)',
    diametro_interior_mm    SMALLINT UNSIGNED   NOT NULL COMMENT 'Diámetro interior en mm',
    diametro_exterior_mm    SMALLINT UNSIGNED   NOT NULL COMMENT 'Diámetro exterior en mm',
    espesor_mm              SMALLINT UNSIGNED   NOT NULL COMMENT 'Espesor / ancho en mm',
    descripcion             VARCHAR(255)        NULL     COMMENT 'Descripción o tipo (ej: Rígido de bolas)',
    activo                  TINYINT(1)          NOT NULL DEFAULT 1 COMMENT '1=visible en catálogo, 0=oculto',
    creado_en               DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en          DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_codigo (codigo),
    KEY idx_dimensiones (diametro_interior_mm, diametro_exterior_mm, espesor_mm),
    KEY idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Catálogo de rodamientos para búsqueda por código o dimensiones';


-- ============================================================
-- Ejemplo de datos (MySQL)
-- ============================================================
-- INSERT INTO catalogo_rodamientos (codigo, diametro_interior_mm, diametro_exterior_mm, espesor_mm, descripcion) VALUES
-- ('6200', 10, 30, 9,  'Rígido de bolas'),
-- ('6201', 12, 32, 10, 'Rígido de bolas'),
-- ('6202', 15, 35, 11, 'Rígido de bolas'),
-- ('6203', 17, 40, 12, 'Rígido de bolas'),
-- ('6204', 20, 47, 14, 'Rígido de bolas'),
-- ('6205', 25, 52, 15, 'Rígido de bolas'),
-- ('6206', 30, 62, 16, 'Rígido de bolas'),
-- ('6305', 25, 62, 17, 'Rígido de bolas serie 63');


-- ============================================================
-- ---------- PostgreSQL (alternativa) ----------
-- ============================================================
/*
CREATE TABLE catalogo_rodamientos (
    id                      SERIAL PRIMARY KEY,
    codigo                  VARCHAR(20) NOT NULL,
    diametro_interior_mm    SMALLINT NOT NULL CHECK (diametro_interior_mm >= 0),
    diametro_exterior_mm    SMALLINT NOT NULL CHECK (diametro_exterior_mm >= 0),
    espesor_mm              SMALLINT NOT NULL CHECK (espesor_mm >= 0),
    descripcion             VARCHAR(255) NULL,
    activo                  SMALLINT NOT NULL DEFAULT 1 CHECK (activo IN (0, 1)),
    creado_en               TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_codigo UNIQUE (codigo)
);

CREATE INDEX idx_dimensiones ON catalogo_rodamientos (diametro_interior_mm, diametro_exterior_mm, espesor_mm);
CREATE INDEX idx_activo ON catalogo_rodamientos (activo);

CREATE OR REPLACE FUNCTION actualizar_actualizado_en()
RETURNS TRIGGER AS $$
BEGIN
    NEW.actualizado_en = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_catalogo_rodamientos_actualizado
    BEFORE UPDATE ON catalogo_rodamientos
    FOR EACH ROW EXECUTE PROCEDURE actualizar_actualizado_en();
*/
