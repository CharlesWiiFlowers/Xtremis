-- Esquema MySQL 8 para la plataforma SPHEREx + WISE + Gaia
CREATE DATABASE IF NOT EXISTS astro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE astro;

-- Catálogo de APIs externas (se carga desde catalog/api_catalog.json con python/app/seed.py)
CREATE TABLE IF NOT EXISTS api_services (
  slug          VARCHAR(64)  PRIMARY KEY,
  mission       VARCHAR(16)  NOT NULL,
  provider      VARCHAR(64)  NOT NULL,
  protocol      VARCHAR(32)  NOT NULL,
  category      VARCHAR(32)  NOT NULL,
  upstream_url  TEXT         NOT NULL,
  internal_route VARCHAR(128) NULL,
  description   TEXT         NULL,
  verified      TINYINT(1)   NOT NULL DEFAULT 0,
  source_doc    VARCHAR(255) NULL,
  INDEX idx_mission (mission),
  INDEX idx_category (category)
) ENGINE=InnoDB;

-- Gaia DR3: estrellas con posición 3D calculada
CREATE TABLE IF NOT EXISTS gaia_stars (
  source_id        BIGINT UNSIGNED PRIMARY KEY,
  ra               DOUBLE NOT NULL,
  `dec`            DOUBLE NOT NULL,
  parallax         DOUBLE NULL,
  parallax_error   DOUBLE NULL,
  pmra             DOUBLE NULL,
  pmdec            DOUBLE NULL,
  phot_g_mean_mag  DOUBLE NULL,
  bp_rp            DOUBLE NULL,
  phot_bp_mean_mag DOUBLE NULL,
  phot_rp_mean_mag DOUBLE NULL,
  radial_velocity  DOUBLE NULL,
  teff             DOUBLE NULL,
  logg             DOUBLE NULL,
  metallicity      DOUBLE NULL,
  ruwe             DOUBLE NULL,
  astrometric_excess_noise DOUBLE NULL,
  distance_pc      DOUBLE NULL,
  x_pc             DOUBLE NULL,
  y_pc             DOUBLE NULL,
  z_pc             DOUBLE NULL,
  provider         VARCHAR(16) NOT NULL DEFAULT 'esa',
  fetched_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_pos (ra, `dec`)
) ENGINE=InnoDB;

-- WISE / NEOWISE: catálogo de fuentes (AllWISE por defecto)
CREATE TABLE IF NOT EXISTS wise_sources (
  designation  VARCHAR(32) PRIMARY KEY,
  catalog      VARCHAR(48) NOT NULL DEFAULT 'allwise_p3as_psd',
  ra           DOUBLE NOT NULL,
  `dec`        DOUBLE NOT NULL,
  w1mpro       DOUBLE NULL,
  w2mpro       DOUBLE NULL,
  w3mpro       DOUBLE NULL,
  w4mpro       DOUBLE NULL,
  pmra         DOUBLE NULL,
  pmdec        DOUBLE NULL,
  fetched_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_pos (ra, `dec`)
) ENGINE=InnoDB;

-- SPHEREx: imágenes espectrales que cubren una posición consultada
CREATE TABLE IF NOT EXISTS spherex_images (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  uri_hash     CHAR(40)     NOT NULL UNIQUE,
  uri          VARCHAR(768) NOT NULL,
  query_ra     DOUBLE       NOT NULL,
  query_dec    DOUBLE       NOT NULL,
  bandpass     VARCHAR(16)  NULL,
  t_obs_mjd    DOUBLE       NULL,
  fetched_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_query (query_ra, query_dec),
  INDEX idx_band (bandpass)
) ENGINE=InnoDB;

-- Bandas SPHEREx (valores publicados en el tutorial de IRSA)
CREATE TABLE IF NOT EXISTS spherex_bands (
  bandpass   VARCHAR(16) PRIMARY KEY,
  lambda_min DOUBLE NOT NULL,
  lambda_max DOUBLE NOT NULL,
  resolving_power INT NOT NULL
) ENGINE=InnoDB;
INSERT IGNORE INTO spherex_bands VALUES
 ('SPHEREx-D1', 0.75, 1.09,  39),
 ('SPHEREx-D2', 1.10, 1.62,  41),
 ('SPHEREx-D3', 1.63, 2.41,  41),
 ('SPHEREx-D4', 2.42, 3.82,  35),
 ('SPHEREx-D5', 3.83, 4.41, 112),
 ('SPHEREx-D6', 4.42, 5.00, 128);

-- Cuerpos de referencia para la proyección orbital 2D (elementos aproximados J2000)
CREATE TABLE IF NOT EXISTS orbital_bodies (
  name      VARCHAR(48) PRIMARY KEY,
  a_au      DOUBLE NOT NULL,
  e         DOUBLE NOT NULL,
  i_deg     DOUBLE NOT NULL,
  node_deg  DOUBLE NOT NULL,
  peri_deg  DOUBLE NOT NULL,
  color     VARCHAR(9) NOT NULL DEFAULT '#9ad',
  source    VARCHAR(64) NOT NULL DEFAULT 'approx J2000'
) ENGINE=InnoDB;
INSERT IGNORE INTO orbital_bodies (name,a_au,e,i_deg,node_deg,peri_deg,color) VALUES
 ('Mercury', 0.387, 0.2056, 7.00,  48.33,  29.12, '#b5b5b5'),
 ('Venus',   0.723, 0.0068, 3.39,  76.68,  54.88, '#e6c36a'),
 ('Earth',   1.000, 0.0167, 0.00,   0.00, 102.94, '#4f9dff'),
 ('Mars',    1.524, 0.0934, 1.85,  49.56, 286.50, '#e0643c'),
 ('Jupiter', 5.203, 0.0484, 1.30, 100.46, 273.87, '#d9a066'),
 ('Saturn',  9.537, 0.0539, 2.49, 113.66, 339.39, '#e3cf9a');

CREATE TABLE IF NOT EXISTS ingest_log (
  id         BIGINT AUTO_INCREMENT PRIMARY KEY,
  mission    VARCHAR(16) NOT NULL,
  ra         DOUBLE NOT NULL,
  `dec`      DOUBLE NOT NULL,
  radius_deg DOUBLE NOT NULL,
  rows_upserted INT NOT NULL,
  provider   VARCHAR(16) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
