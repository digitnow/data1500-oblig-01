-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================
BEGIN;
-- Opprett grunnleggende tabeller
create table stasjon (
    stasjon_id BIGSERIAL PRIMARY KEY,
    navn VARCHAR(100) NOT NULL UNIQUE,
    adresse VARCHAR(100) NOT NULL
);
create table laas (
    laas_id BIGSERIAL PRIMARY KEY,
    laas_nummer SMALLINT NOT NULL CHECK (laas_nummer > 0),
    stasjon_id BIGINT NOT NULL REFERENCES stasjon(stasjon_id) ON DELETE CASCADE,
    CONSTRAINT unike_laas_nummer_per_stasjon UNIQUE (laas_nummer, stasjon_id)
);
CREATE TABLE sykkel (
  sykkel_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  hente_tidspunkt TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  stasjon_id BIGINT NULL REFERENCES stasjon(stasjon_id),
  laas_id BIGINT NULL REFERENCES laas(laas_id),

  CONSTRAINT ck_sykkel_parkert_eller_utleid
    CHECK (
      (stasjon_id IS NULL AND laas_id IS NULL)
      OR
      (stasjon_id IS NOT NULL AND laas_id IS NOT NULL)
    ),

  CONSTRAINT uq_sykkel_laas UNIQUE (laas_id)
);
create table kunde (
    kunde_id BIGSERIAL PRIMARY KEY,
    fornavn VARCHAR(50) NOT NULL,
    etternavn VARCHAR(50) NOT NULL,
    mobilnummer VARCHAR(16) NOT NULL UNIQUE CHECK (mobilnummer ~ '^(\+47)?[0-9]{8}$'),
    epost VARCHAR(100) NOT NULL UNIQUE CHECK (epost ~ '^[^@]+@[^@]+\.[^@]+$')
);
CREATE TABLE utleie (
  utleie_id BIGSERIAL PRIMARY KEY,
  sykkel_id BIGINT NOT NULL REFERENCES sykkel(sykkel_id),
  kunde_id  BIGINT NOT NULL REFERENCES kunde(kunde_id),
  utlevert_tidspunkt TIMESTAMPTZ NOT NULL,
  inlevert_tidspunkt TIMESTAMPTZ NULL,
  leie_kostnad NUMERIC(10, 2) NULL CHECK (leie_kostnad IS NULL OR leie_kostnad >= 0),

  CONSTRAINT utleie_tidspunkt_sammenheng CHECK (
    (inlevert_tidspunkt IS NULL) OR
    (utlevert_tidspunkt < inlevert_tidspunkt)
  )
);
CREATE UNIQUE INDEX uq_utleie_en_aktiv_per_sykkel
ON utleie (sykkel_id)
WHERE inlevert_tidspunkt IS NULL;


-- Sett inn testdata

INSERT INTO stasjon (navn, adresse) VALUES
('Stasjon Sentrum', 'Sentrum 1'),
('Stasjon Øst',     'Østgata 10'),
('Stasjon Vest',    'Vestveien 5'),
('Stasjon Nord',    'Nordlia 3'),
('Stasjon Sør',     'Sørbakken 8');

INSERT INTO laas (laas_nummer, stasjon_id)
SELECT gs.laas_nummer, s.stasjon_id
FROM stasjon s
CROSS JOIN generate_series(1, 20) AS gs(laas_nummer);


INSERT INTO kunde (fornavn, etternavn, mobilnummer, epost) VALUES
  ('Ola', 'Nordmann', '91234567', 'ola.nordmann@example.com'),
  ('Kari', 'Hansen',  '92345678', 'kari.hansen@example.com'),
  ('Per', 'Jensen',   '93456789', 'per.jensen@example.com'),
  ('Anne','Larsen',   '94567890', 'anne.larsen@example.com'),
  ('Mohammed','Ali',  '95678901', 'mohammed.ali@example.com');

INSERT INTO sykkel (stasjon_id, laas_id)
SELECT l.stasjon_id, l.laas_id
FROM laas l
ORDER BY l.laas_id
LIMIT 100; 

INSERT INTO utleie (sykkel_id, kunde_id, utlevert_tidspunkt, inlevert_tidspunkt, leie_kostnad)
SELECT
  s.sykkel_id,
  k.kunde_id,
  now() - (random() * interval '30 days')            AS utlevert_tidspunkt,
  NULL::timestamptz                                   AS inlevert_tidspunkt,
  NULL::numeric                                       AS leie_kostnad
FROM sykkel s
CROSS JOIN LATERAL (
  SELECT kunde_id
  FROM kunde
  ORDER BY random()
  LIMIT 1
) k
WHERE s.stasjon_id IS NOT NULL
ORDER BY random()
LIMIT 50;
UPDATE sykkel
SET stasjon_id = NULL,
    laas_id = NULL
WHERE sykkel_id IN (
  SELECT sykkel_id
  FROM utleie
  WHERE inlevert_tidspunkt IS NULL
);

-- DBA setninger (rolle: kunde, bruker: kunde_1)

-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"

COMMIT;

