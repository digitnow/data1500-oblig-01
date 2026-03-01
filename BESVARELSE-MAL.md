# Besvarelse - Refleksjon og Analyse

**Student:** Kamal Alnaeb

**Studentnummer:** kaaln5036

**Dato:** 01.03.2026

---

## Del 1: Datamodellering

### Oppgave 1.1: Entiteter og attributter

**Identifiserte entiteter:**

Stasjon, Sykkel, Lås, Kunde, Utleie
**Attributter for hver entitet:**

#### 1.Stasjon: 
stasjon_id stabil primærnøkkel for å identifisere stasjonen.
navn  er lettere å lese av brukere.
adresse for å gjøre det lettere for brukere å lukalisere stasjonen.

#### 2. Sykkel
sykkel_id stabil primærnøkkel for å identifisere sykkel.
hente_tidspunkt for å registrere når brukeren har startet turen.
stasjon_id fremmednøkkel for å spore hvilken stasjon sykkelen befinner seg på.
laas_id  for å spore hvilken lås sykkelen står i.

#### 3.Lås
laas_id  stabil primærnøkkel for å identifisere lås.
laas_nummer enkel måte for å referere til låsene i en stasjon
stasjon_id for mange lås tilhører en stasjon

#### 4. Kunde
kunde_id stabil primærnøkkel for å identifisere kunde.
fornavn
etternavn
mobilnummer
epost


#### 5. Utleie
utleie_id stabil primærnøkkel for å identifisere utleie.
sykkel_id fremmednøkkel for å knytte utleien til en spesifikk sykkel
kunde_id fremmednøkkel for å knytte utleien til kunden,
utlevert_tidspunkt hjelper å beregne leie kostnat
inlevert_tidspunkt hjelper å beregne leie kostnat
leie_kostnad for å regne hvor mye må brukeren betale





---

### Oppgave 1.2: Datatyper og `CHECK`-constraints

**Valgte datatyper og begrunnelser:**
#### 1.Stasjon: 
stasjon_id bigserial
navn varchar(100)
adresse varchar(100)

#### 2. Sykkel
sykkel_id bigserial
hente_tidspunkt date
stasjon_id bigint (NULL)
laas_id bigint (NULL) når utleid

#### 3.Lås
laas_id bigserial
laas_nummer smallint
stasjon_id bigint

#### 4. Kunde
kunde_id bigserial
fornavn varchar(50)
etternavn varchar(50)
mobilnummer varchar(16)
epost varchar(100)

#### 5. Utleie
utleie_id bigserial
sykkel_id bigint
kunde_id bigint
utlevert_tidspunkt timestamptz
inlevert_tidspunkt timestamptz (NULL) for pågående utleie
leie_kostnad numeric(10,2) (NULL)



**`CHECK`-constraints:**

#### 1.Stasjon: 
stasjon_id 
navn 
adresse 

#### 2. Sykkel
sykkel_id 
hente_tidspunkt
stasjon_id 
laas_id 

#### 3.Lås 
laas_nummer CHECK (laas_nummer BETWEEN 1 AND 20)
stasjon_id 

#### 4. Kunde
mobilnummer CHECK (mobilnummer ~ '^\+?[0-9]{8,15}$')
epost CHECK (epost ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$')


#### 5. Utleie
inlevert_tidspunkt  CHECK (innlevert_tidspunkt IS NULL OR innlevert_tidspunkt >= utlevert_tidspunkt)
leie_kostnad CHECK (leie_kostnad IS NULL OR leie_kostnad >= 0)

**ER-diagram:**
---------
diagramen {

  
    STASJON {

        BIGSERIAL stasjon_id PK
        VARCHAR(100) navn
        VARCHAR(100) adresse

    }

    SYKKEL {
        BIGSERIAL sykkel_id PK
        DATE hente_tidspunkt
        BIGINT stasjon_id FK "NULL hvis ikke på stasjon"
        BIGINT laas_id FK "NULL hvis ikke utleid"
    }

    LAAS {
        BIGSERIAL laas_id PK
        SMALLINT laas_nummer
        BIGINT stasjon_id FK
    }

    KUNDE {
        BIGSERIAL kunde_id PK
        VARCHAR(50) fornavn
        VARCHAR(50) etternavn
        VARCHAR(16) mobilnummer 
        VARCHAR(100) epost
    }

    UTLEIE {
        BIGSERIAL utleie_id PK
        BIGINT sykkel_id FK
        BIGINT kunde_id FK
        TIMESTAMPTZ utlevert_tidspunkt
        TIMESTAMPTZ inlevert_tidspunkt "NULL = pågående"
        NUMERIC leie_kostnad "NULL"
    }

    STASJON ||--o{ LAAS : "har"
    STASJON ||--o{ SYKKEL : "har/oppbevarer"
    LAAS ||--o| SYKKEL : "kan være i bruk av"
    SYKKEL ||--o{ UTLEIE : "registrert i"
    KUNDE  ||--o{ UTLEIE : "gjør"




### Oppgave 1.3: Primærnøkler

**Valgte primærnøkler og begrunnelser:**

stasjon_id, sykkel_id, laas_id, kunde_id, utleie_id
**Naturlige vs. surrogatnøkler:**

[Skriv ditt svar her - diskuter om du har brukt naturlige eller surrogatnøkler og hvorfor]

**Oppdatert ER-diagram:**

[Legg inn mermaid-kode eller eventuelt en bildefil fra `mermaid.live` her]

---

### Oppgave 1.4: Forhold og fremmednøkler

**Identifiserte forhold og kardinalitet:**

[Skriv ditt svar her - list opp alle forholdene mellom entitetene og angi kardinalitet]

**Fremmednøkler:**

[Skriv ditt svar her - list opp alle fremmednøklene og forklar hvordan de implementerer forholdene]

**Oppdatert ER-diagram:**

[Legg inn mermaid-kode eller eventuelt en bildefil fra `mermaid.live` her]

---

### Oppgave 1.5: Normalisering

**Vurdering av 1. normalform (1NF):**

[Skriv ditt svar her - forklar om datamodellen din tilfredsstiller 1NF og hvorfor]

**Vurdering av 2. normalform (2NF):**

[Skriv ditt svar her - forklar om datamodellen din tilfredsstiller 2NF og hvorfor]

**Vurdering av 3. normalform (3NF):**

[Skriv ditt svar her - forklar om datamodellen din tilfredsstiller 3NF og hvorfor]

**Eventuelle justeringer:**

[Skriv ditt svar her - hvis modellen ikke var på 3NF, forklar hvilke justeringer du har gjort]

---

## Del 2: Database-implementering

### Oppgave 2.1: SQL-skript for database-initialisering

**Plassering av SQL-skript:**

[Bekreft at du har lagt SQL-skriptet i `init-scripts/01-init-database.sql`]

**Antall testdata:**

- Kunder: [antall]
- Sykler: [antall]
- Sykkelstasjoner: [antall]
- Låser: [antall]
- Utleier: [antall]

---

### Oppgave 2.2: Kjøre initialiseringsskriptet

**Dokumentasjon av vellykket kjøring:**

data1500-postgres  | /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/01-init-database.sql
data1500-postgres  | BEGIN
data1500-postgres  | CREATE TABLE
data1500-postgres  | CREATE TABLE
data1500-postgres  | CREATE TABLE
data1500-postgres  | CREATE TABLE
data1500-postgres  | CREATE TABLE
data1500-postgres  | CREATE INDEX
data1500-postgres  | INSERT 0 5
data1500-postgres  | INSERT 0 100
data1500-postgres  | INSERT 0 5
data1500-postgres  | INSERT 0 100
data1500-postgres  | INSERT 0 50
data1500-postgres  | UPDATE 50
data1500-postgres  | COMMIT


**Spørring mot systemkatalogen:**

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Resultat:**

```
 table_name
------------
 kunde
 laas
 stasjon
 sykkel
 utleie
(5 rows)```

---

## Del 3: Tilgangskontroll

### Oppgave 3.1: Roller og brukere

**SQL for å opprette rolle:**

```sql
CREATE ROLE kunde;
```

**SQL for å opprette bruker:**

```sql
CREATE USER kunde_1 WITH PASSWORD 'kunde_123';
GRANT kunde TO kunde_1;
```

**SQL for å tildele rettigheter:**

```sql
GRANT USAGE ON SCHEMA public TO kunde;
```

---

### Oppgave 3.2: Begrenset visning for kunder

**SQL for VIEW:**

```sql
GRANT SELECT ON stasjon TO kunde;
GRANT SELECT ON mine_utleier TO kunde;
REVOKE ALL ON utleie FROM kunde;
```

**Ulempe med VIEW vs. POLICIES:**

[Skriv ditt svar her - diskuter minst én ulempe med å bruke VIEW for autorisasjon sammenlignet med POLICIES]

---

## Del 4: Analyse og Refleksjon

### Oppgave 4.1: Lagringskapasitet

**Gitte tall for utleierate:**

- Høysesong (mai-september): 20000 utleier/måned
- Mellomsesong (mars, april, oktober, november): 5000 utleier/måned
- Lavsesong (desember-februar): 500 utleier/måned

**Totalt antall utleier per år:**

[Skriv din utregning her]

**Estimat for lagringskapasitet:**

[Skriv din utregning her - vis hvordan du har beregnet lagringskapasiteten for hver tabell]

**Totalt for første år:**

[Skriv ditt estimat her]

---

### Oppgave 4.2: Flat fil vs. relasjonsdatabase

**Analyse av CSV-filen (`data/utleier.csv`):**

**Problem 1: Redundans**

[Skriv ditt svar her - gi konkrete eksempler fra CSV-filen som viser redundans]

**Problem 2: Inkonsistens**

[Skriv ditt svar her - forklar hvordan redundans kan føre til inkonsistens med eksempler]

**Problem 3: Oppdateringsanomalier**

[Skriv ditt svar her - diskuter slette-, innsettings- og oppdateringsanomalier]

**Fordeler med en indeks:**

[Skriv ditt svar her - forklar hvorfor en indeks ville gjort spørringen mer effektiv]

**Case 1: Indeks passer i RAM**

[Skriv ditt svar her - forklar hvordan indeksen fungerer når den passer i minnet]

**Case 2: Indeks passer ikke i RAM**

[Skriv ditt svar her - forklar hvordan flettesortering kan brukes]

**Datastrukturer i DBMS:**

[Skriv ditt svar her - diskuter B+-tre og hash-indekser]

---

### Oppgave 4.3: Datastrukturer for logging

**Foreslått datastruktur:**

[Skriv ditt svar her - f.eks. heap-fil, LSM-tree, eller annen egnet datastruktur]

**Begrunnelse:**

**Skrive-operasjoner:**

[Skriv ditt svar her - forklar hvorfor datastrukturen er egnet for mange skrive-operasjoner]

**Lese-operasjoner:**

[Skriv ditt svar her - forklar hvordan datastrukturen håndterer sjeldne lese-operasjoner]

---

### Oppgave 4.4: Validering i flerlags-systemer

**Hvor bør validering gjøres:**

[Skriv ditt svar her - argumenter for validering i ett eller flere lag]

**Validering i nettleseren:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i applikasjonslaget:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i databasen:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Konklusjon:**

[Skriv ditt svar her - oppsummer hvor validering bør gjøres og hvorfor]

---

### Oppgave 4.5: Refleksjon over læringsutbytte

**Hva har du lært så langt i emnet:**

[Skriv din refleksjon her - diskuter sentrale konsepter du har lært]

**Hvordan har denne oppgaven bidratt til å oppnå læringsmålene:**

[Skriv din refleksjon her - koble oppgaven til læringsmålene i emnet]

Se oversikt over læringsmålene i en PDF-fil i Canvas https://oslomet.instructure.com/courses/33293/files/folder/Plan%20v%C3%A5ren%202026?preview=4370886

**Hva var mest utfordrende:**

[Skriv din refleksjon her - diskuter hvilke deler av oppgaven som var mest krevende]

**Hva har du lært om databasedesign:**

[Skriv din refleksjon her - reflekter over prosessen med å designe en database fra bunnen av]

---

## Del 5: SQL-spørringer og Automatisk Testing

**Plassering av SQL-spørringer:**

Jeg har lagt spørringer i `test-scripts/queries.sql`


**Eventuelle feil og rettelser:**

[Skriv ditt svar her - hvis noen tester feilet, forklar hva som var feil og hvordan du rettet det]

---

## Del 6: Bonusoppgaver (Valgfri)

### Oppgave 6.1: Trigger for lagerbeholdning

**SQL for trigger:**

```sql
[Skriv din SQL-kode for trigger her, hvis du har løst denne oppgaven]
```

**Forklaring:**

[Skriv ditt svar her - forklar hvordan triggeren fungerer]

**Testing:**

[Skriv ditt svar her - vis hvordan du har testet at triggeren fungerer som forventet]

---

### Oppgave 6.2: Presentasjon

**Lenke til presentasjon:**

[Legg inn lenke til video eller presentasjonsfiler her, hvis du har løst denne oppgaven]

**Hovedpunkter i presentasjonen:**

[Skriv ditt svar her - oppsummer de viktigste punktene du dekket i presentasjonen]

---

**Slutt på besvarelse**
