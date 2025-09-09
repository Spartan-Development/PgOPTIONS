--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: actualizar_retencion(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.actualizar_retencion()
    LANGUAGE plpgsql
    AS $$
DECLARE
    sum_baseamount NUMERIC := 0;
    sum_baseamountref NUMERIC := 0;
    sum_impamount NUMERIC := 0;
    sum_impamountref NUMERIC := 0;
    sum_taxamount NUMERIC := 0;
    sum_taxamountref NUMERIC := 0;
BEGIN
    -- Sumar los valores de baseamount, baseamountref, impamount e impamountref en la tabla retencionline
    SELECT sum(baseamount), sum(baseamountref), sum(impamount), sum(impamountref), sum(taxamount), sum(taxamountref)
    INTO sum_baseamount, sum_baseamountref, sum_impamount, sum_impamountref, sum_taxamount, sum_taxamountref
    FROM public.retencionline;

    -- Actualizar la tabla retencion con los valores de la sumaria
    UPDATE public.retencion SET
        baseamount = sum_baseamount,
        baseamountref = sum_baseamountref,
        impamount = sum_impamount,
        impamountref = sum_impamountref,
        taxamount = sum_taxamount,
        taxamountref = sum_taxamountref
    WHERE retencion_id = (SELECT max(retencion_id) FROM retencion);

    -- Sumar los valores de baseamount y impamount en la tabla retencion y actualizar las columnas totalamount y totalamountref con el resultado
    UPDATE public.retencion SET
        totalamount = baseamount + taxamount,
        totalamountref = baseamountref + taxamountref
    WHERE retencion_id = (SELECT max(retencion_id) FROM retencion);
END;
$$;


ALTER PROCEDURE public.actualizar_retencion() OWNER TO postgres;

--
-- Name: getorgchilds(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getorgchilds(org character varying) RETURNS TABLE(id character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    reg RECORD;
BEGIN
    FOR REG IN SELECT * FROM public."org" o WHERE o.parent_org_id = org LOOP
       id    := reg.org_id;
       RETURN NEXT;
    END LOOP;
END
$$;


ALTER FUNCTION public.getorgchilds(org character varying) OWNER TO postgres;

--
-- Name: getorgfamily(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getorgfamily(org character varying) RETURNS TABLE(id character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    padre RECORD;
    hijos RECORD;
    otros RECORD;
BEGIN
    -- Agregando el org padre a la lista
    FOR PADRE IN SELECT org_id from public."org" o where o.org_id = org LOOP
       id    := padre.org_id;
       RETURN NEXT;
    END LOOP;
    
    -- Agregando los org hijos a la lista
    FOR HIJOS IN SELECT getorgchilds(org) as org_id LOOP
       id    := hijos.org_id;
       RETURN NEXT;
    END LOOP;
    
    -- Agregando los hijos de los hijos a la lista
    FOR HIJOS IN SELECT getorgchilds(org) as org_id LOOP
        FOR OTROS IN SELECT DISTINCT getorgfamily(hijos.org_id) as org_id LOOP
            id    := otros.org_id;
            RETURN NEXT;
        END LOOP;
    END LOOP;
    
END
$$;


ALTER FUNCTION public.getorgfamily(org character varying) OWNER TO postgres;

--
-- Name: numerictofloat(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.numerictofloat(numeric) RETURNS real
    LANGUAGE sql
    AS $_$SELECT CAST($1 as real)$_$;


ALTER FUNCTION public.numerictofloat(numeric) OWNER TO postgres;

--
-- Name: redondear_lineaval(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.redondear_lineaval()
    LANGUAGE plpgsql
    AS $$
DECLARE
    registro RECORD;
BEGIN
    FOR registro IN SELECT * FROM public.retencionline LOOP
        UPDATE public.retencionline SET
		    baseaount = round(registro.baseamount::numeric, 2),
		    baseaountref = round(registro.baseamountref::numeric, 2),
            impamount = round(registro.impamount::numeric, 2),
            impamountref = round(registro.impamountref::numeric, 2)
        WHERE retencionline_id = registro.retencionline_id;
    END LOOP;
END;
$$;


ALTER PROCEDURE public.redondear_lineaval() OWNER TO postgres;

--
-- Name: redondear_valoresnum_retencion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.redondear_valoresnum_retencion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.baseamount := ROUND(NEW.baseamount::NUMERIC, 2);
    NEW.baseamountref := ROUND(NEW.baseamountref::NUMERIC, 2);
    NEW.impamount := ROUND(NEW.impamount::NUMERIC, 2);
    NEW.impamountref := ROUND(NEW.impamountref::NUMERIC, 2);
    NEW.totalamount := ROUND(NEW.totalamount::NUMERIC, 2);
    NEW.totalamountref := ROUND(NEW.totalamountref::NUMERIC, 2);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.redondear_valoresnum_retencion() OWNER TO postgres;

--
-- Name: redondear_valoresnum_retencionline(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.redondear_valoresnum_retencionline() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.baseamount := ROUND(NEW.baseamount::NUMERIC, 2);
    NEW.baseamountref := ROUND(NEW.baseamountref::NUMERIC, 2);
    NEW.impamount := ROUND(NEW.impamount::NUMERIC, 2);
    NEW.impamountref := ROUND(NEW.impamountref::NUMERIC, 2);
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.redondear_valoresnum_retencionline() OWNER TO postgres;

--
-- Name: stamptostring(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stamptostring(timestamp without time zone) RETURNS character varying
    LANGUAGE sql
    AS $_$SELECT COALESCE(CAST($1 AS VARCHAR))$_$;


ALTER FUNCTION public.stamptostring(timestamp without time zone) OWNER TO postgres;

--
-- Name: update_alicuota_retencion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_alicuota_retencion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public.retencion SET alicuota = NEW.alicuota WHERE retencion_id = NEW.retencion_id;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_alicuota_retencion() OWNER TO postgres;

--
-- Name: update_name_retencion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_name_retencion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
UPDATE
    public.retencion
SET
    bpartner_name = NEW.name
WHERE
    bpartner_id = NEW.bpartner_id;

RETURN NEW;

END;

$$;


ALTER FUNCTION public.update_name_retencion() OWNER TO postgres;

--
-- Name: update_retencion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_retencion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

--DECLARANDO VARIABLES
	DECLARE
    baseamountRet FLOAT;
    baseamountrefRet FLOAT;
    impamountRet FLOAT;
    impamountrefRet FLOAT;
    totalamountRet FLOAT;
    totalamountrefRet FLOAT;
	
	baseamountLine FLOAT;
    baseamountrefLine FLOAT;
    impamountLine FLOAT;
    impamountrefLine FLOAT;
BEGIN

	
    --A OBTENIENDO LOS VALORES DE RETENCION...
	SELECT 
    r.baseamount, r.baseamountref, r.impamount, r.impamountref,
	r.totalamount, r.totalamountref
	FROM public."retencion" r
	WHERE r.retencion_id = NEW.retencion_id
	INTO 
	baseamountRet, baseamountrefRet, impamountRet, impamountrefRet,
	totalamountRet, totalamountrefRet;
	
	--END A
	
	 --B OBTENIENDO LOS VALORES DE RETENCIONLINE...
	SELECT 
	SUM(rl.baseamount), SUM(rl.baseamountref), SUM(rl.impamount), 
	SUM(rl.impamountref)
	INTO 
	baseamountLine, baseamountrefLine, impamountLine, impamountrefLine
	FROM public.retencion rl 
	WHERE rl.retencion_id = NEW.retencion_id AND isactive = 'Y';
	--END B
	
	--OPERANDO VALORES..
	baseamountRet = baseamountLine;
    baseamountrefRet = baseamountrefLine;
    impamountRet = impamountLine;
    impamountrefRet = impamountrefLine;
    totalamountRet = baseamountRet + impamountRet;
    totalamountrefRet = baseamountrefRet + impamountrefRet;
	
	--ACTUALIZANDO LA RETENCIÓN
	UPDATE public.retencion
	SET
	baseamount = baseamountRet,
    baseamountref = baseamountrefRet,
    impamount = impamountRet,
    impamountref = impamountrefRet,
    totalamount = totalamountRet,
    totalamountref = totalamountrefRet
	WHERE retencion_id = NEW.retencion_id;
	
	RETURN NEW;
END
$$;


ALTER FUNCTION public.update_retencion() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bpartner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpartner (
    bpartner_id character varying(36) NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(36) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(36) NOT NULL,
    value character varying(40) NOT NULL,
    name character varying(60) NOT NULL,
    name2 character varying(60),
    description character varying(255),
    location character varying(255),
    tipo_contribuyente character varying(36),
    tipo_persona character varying(36)
);


ALTER TABLE public.bpartner OWNER TO postgres;

--
-- Name: oatpp_schema_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oatpp_schema_version (
    version bigint
);


ALTER TABLE public.oatpp_schema_version OWNER TO postgres;

--
-- Name: org; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org (
    org_id character varying(36) NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(36) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(36) NOT NULL,
    value character varying(40) NOT NULL,
    name character varying(60) NOT NULL,
    name2 character varying(60),
    description character varying(255),
    location character varying(255),
    licencia character varying(1000),
    vencimiento timestamp without time zone,
    parent_org_id character varying(36)
);


ALTER TABLE public.org OWNER TO postgres;

--
-- Name: prueba; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prueba (
    prueba_id character varying(12) NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(12) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(12) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    name2 character varying(255),
    description character varying(255),
    location character varying(255),
    tipo_contribuyente character varying(255),
    tipo_persona character varying(255),
    prueba_column character varying(256)
);


ALTER TABLE public.prueba OWNER TO postgres;

--
-- Name: retencion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retencion (
    retencion_id character varying(36) NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(36) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(36) NOT NULL,
    bpartner_id character varying(36) NOT NULL,
    documentno character varying(60),
    nro_documento_fiscal character varying(60) NOT NULL,
    description character varying(255),
    baseamount numeric DEFAULT 0 NOT NULL,
    baseamountref numeric DEFAULT 0 NOT NULL,
    impamount numeric DEFAULT 0 NOT NULL,
    impamountref numeric DEFAULT 0 NOT NULL,
    totalamount numeric DEFAULT 0 NOT NULL,
    totalamountref numeric DEFAULT 0 NOT NULL,
    ispaid character(1) DEFAULT 'N'::bpchar NOT NULL,
    ref_payment character varying(255),
    sequence_id character varying(36) NOT NULL,
    rate_conversion numeric NOT NULL,
    issotrx character(5),
    date_invoice timestamp without time zone,
    date_ret timestamp without time zone,
    isiva character(1),
    bpartner_name character varying(50),
    amount_payment character varying(255),
    isigtf character(1),
    igtfamount numeric,
    isinvoiceiva character(1),
    invoiceivaamount numeric,
    invoicesequence character varying(50),
    invoiceivaalicuota numeric,
    taxamount numeric,
    taxamountref numeric,
    alicuota numeric
);


ALTER TABLE public.retencion OWNER TO postgres;

--
-- Name: retencionline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retencionline (
    retencionline_id character varying(36) NOT NULL,
    retencion_id character varying(36) NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(36) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(36) NOT NULL,
    description character varying(255),
    alicuota numeric DEFAULT 0 NOT NULL,
    baseamount numeric DEFAULT 0 NOT NULL,
    baseamountref numeric DEFAULT 0 NOT NULL,
    impamount numeric DEFAULT 0 NOT NULL,
    impamountref numeric DEFAULT 0 NOT NULL,
    taxamount numeric DEFAULT 0 NOT NULL,
    taxamountref numeric DEFAULT 0 NOT NULL,
    tax numeric
);


ALTER TABLE public.retencionline OWNER TO postgres;

--
-- Name: retenciontype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retenciontype (
    retenciontype_id character varying(36) NOT NULL,
    isactive character(1),
    created timestamp without time zone,
    createdby character varying(36),
    updated timestamp without time zone,
    updatedby character varying(36),
    alicuota numeric DEFAULT 0,
    description character varying(120) NOT NULL,
    isiva character(1),
    tax numeric DEFAULT 100 NOT NULL,
    isallpaid character varying(1),
    issustraendo character varying(1),
    minmax character varying(2),
    auxamount numeric,
    tipo_persona character varying(36),
    used character(1) DEFAULT 'N'::bpchar
);


ALTER TABLE public.retenciontype OWNER TO postgres;

--
-- Name: sequence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sequence (
    sequence_id character varying(36) NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(36) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(36) NOT NULL,
    name character varying(60) NOT NULL,
    description character varying(255),
    incrementno numeric(10,0) NOT NULL,
    startno numeric(10,0) NOT NULL,
    currentnext numeric(10,0) NOT NULL,
    currentnextsys numeric(10,0) NOT NULL,
    prefix character varying(10),
    sufix character varying(10),
    issotrx character varying(2)
);


ALTER TABLE public.sequence OWNER TO postgres;

--
-- Name: sistema; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sistema (
    sistema_id character varying(255) NOT NULL,
    rif character varying(15) NOT NULL,
    razon_social character varying(255) NOT NULL,
    licencia character varying(2500) NOT NULL,
    direccion character varying(500) NOT NULL,
    telefono character varying(15),
    archivo character varying(2500)
);


ALTER TABLE public.sistema OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    user_id character varying(36) NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(36) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(36) NOT NULL,
    name character varying(60) NOT NULL,
    description character varying(255),
    password character varying(40),
    username character varying(60),
    lectura character(1) DEFAULT 'Y'::bpchar NOT NULL,
    escritura character(1) DEFAULT 'Y'::bpchar NOT NULL,
    administrador character(1) DEFAULT 'N'::bpchar NOT NULL,
    token character varying(36)
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: bpartner bpartner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpartner
    ADD CONSTRAINT bpartner_pkey PRIMARY KEY (bpartner_id);


--
-- Name: org org_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT org_pkey PRIMARY KEY (org_id);


--
-- Name: retenciontype pk_retenciontype_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retenciontype
    ADD CONSTRAINT pk_retenciontype_id PRIMARY KEY (retenciontype_id) INCLUDE (retenciontype_id);


--
-- Name: sistema pk_sistema_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistema
    ADD CONSTRAINT pk_sistema_id PRIMARY KEY (sistema_id) INCLUDE (sistema_id);


--
-- Name: prueba prueba_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prueba
    ADD CONSTRAINT prueba_pkey PRIMARY KEY (prueba_id);


--
-- Name: retencion retencion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retencion
    ADD CONSTRAINT retencion_pkey PRIMARY KEY (retencion_id);


--
-- Name: retencionline retencionline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retencionline
    ADD CONSTRAINT retencionline_pkey PRIMARY KEY (retencionline_id);


--
-- Name: sequence sequence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT sequence_pkey PRIMARY KEY (sequence_id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- Name: retencion redondear_valoresnum_retencion_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER redondear_valoresnum_retencion_trigger AFTER INSERT ON public.retencion FOR EACH ROW EXECUTE FUNCTION public.redondear_valoresnum_retencion();


--
-- Name: retencionline redondear_valoresnum_retencionline_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER redondear_valoresnum_retencionline_trigger AFTER INSERT ON public.retencionline FOR EACH ROW EXECUTE FUNCTION public.redondear_valoresnum_retencionline();


--
-- Name: retencionline update_alicuota_retencion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_alicuota_retencion AFTER INSERT ON public.retencionline FOR EACH ROW EXECUTE FUNCTION public.update_alicuota_retencion();


--
-- Name: bpartner update_name_retencion_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_name_retencion_trigger AFTER UPDATE ON public.bpartner FOR EACH ROW EXECUTE FUNCTION public.update_name_retencion();


--
-- Name: retencionline retencion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retencionline
    ADD CONSTRAINT retencion_fkey FOREIGN KEY (retencion_id) REFERENCES public.retencion(retencion_id) NOT VALID;


--
-- PostgreSQL database dump complete
--

