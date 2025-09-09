--README UTILS START ***

CREATE OR REPLACE EXTENSION pgcrypto; 
-- ó
CREATE EXTENSION IF NOT EXISTS pgcrypto;

SELECT * FROM pg_extension WHERE extname = 'pgcrypto';

--README UTILS END ***



--CREATE LICENCE TABLE START
-- Table: public.licencia
-- DROP TABLE IF EXISTS public.licencia;
CREATE TABLE IF NOT EXISTS public.licencia
(
    licencia_id text COLLATE pg_catalog."default" NOT NULL,
    licencia bytea,
    CONSTRAINT licencia_pkey PRIMARY KEY (licencia_id)
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public.licencia
    OWNER to postgres;
--CREATE LICENCE TABLE END



--CREATE TIMER LICENCE START
-- Table: public.licence_timer

-- DROP TABLE IF EXISTS public.licence_timer;

CREATE TABLE IF NOT EXISTS public.licence_timer
(
    time_record bytea,
    num_time bytea,
    id integer NOT NULL DEFAULT nextval('licence_timer_id_seq'::regclass),
    CONSTRAINT primary_key PRIMARY KEY (id)
        INCLUDE(id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.licence_timer
    OWNER to postgres;

--CREATE TIMER LICENCE END


--TEST
UPDATE usuarios SET contraseña = pgp_sym_encrypt('tu_contraseña', 'clave_de_encriptacion');
SELECT pgp_sym_decrypt(contraseña, 'clave_de_encriptacion') AS contraseña_descifrada FROM usuarios;
--TEST

