-- ============================================================================
-- TEST-SKRIPT FOR OBLIG 1
-- ============================================================================
SELECT *
FROM sykkel;
order by sykkel_id;

SELECT etternavn, fornavn, mobilnummer
FROM kunde
ORDER BY etternavn ASC;

SELECT *
FROM sykkel
WHERE hente_tidspunkt > '2026-01-01';

SELECT COUNT(*) AS antall_kunder
FROM kunde;

SELECT 
    k.kunde_id,
    k.fornavn,
    k.etternavn,
    COUNT(u.utleie_id) AS antall_utleier
FROM kunde k
LEFT JOIN utleie u ON k.kunde_id = u.kunde_id
GROUP BY k.kunde_id, k.fornavn, k.etternavn
ORDER BY k.etternavn;

SELECT k.*
FROM kunde k
LEFT JOIN utleie u ON k.kunde_id = u.kunde_id
WHERE u.utleie_id IS NULL;

SELECT *
FROM kunde
WHERE kunde_id NOT IN (
    SELECT kunde_id
    FROM utleie
);

SELECT s.*
FROM sykkel s
LEFT JOIN utleie u ON s.sykkel_id = u.sykkel_id
WHERE u.utleie_id IS NULL;

SELECT 
    s.sykkel_id,
    k.fornavn,
    k.etternavn,
    u.utlevert_tidspunkt
FROM utleie u
JOIN sykkel s ON s.sykkel_id = u.sykkel_id
JOIN kunde k ON k.kunde_id = u.kunde_id
WHERE u.inlevert_tidspunkt IS NULL
  AND u.utlevert_tidspunkt < NOW() - INTERVAL '1 day';
-- Kjør med: docker-compose exec postgres psql -h -U admin -d data1500_db -f test-scripts/queries.sql

-- En test med en SQL-spørring mot metadata i PostgreSQL (kan slettes fra din script)
select nspname as schema_name from pg_catalog.pg_namespace;
