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
-- Name: set_au_status(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_au_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE public."order" SET current_status = 'AU'
    WHERE order_id in 
        (
            SELECT order_id
            FROM  public.orderline
            GROUP BY order_id
            HAVING SUM(qty - qty_committed) = 0
        );
    

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_au_status() OWNER TO postgres;

--
-- Name: stamptostring(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stamptostring(timestamp without time zone) RETURNS character varying
    LANGUAGE sql
    AS $_$SELECT COALESCE(CAST($1 AS VARCHAR))$_$;


ALTER FUNCTION public.stamptostring(timestamp without time zone) OWNER TO postgres;

--
-- Name: unique_serial_warehouse_detail(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unique_serial_warehouse_detail() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.product_id IN (
        SELECT p.product_id FROM public.product p WHERE p.is_serial = true
    ) THEN
        IF EXISTS (
            SELECT 1 FROM public."warehouse_detail"
            WHERE product_id = NEW.product_id
            AND serial = NEW.serial
            AND (warehouse_detail_id IS DISTINCT FROM NEW.warehouse_detail_id OR warehouse_detail_id IS NULL)
        ) THEN
            RAISE EXCEPTION 'Proceso cancelado, ya existe otro warehouse_detail con el mismo producto y serial';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.unique_serial_warehouse_detail() OWNER TO postgres;

--
-- Name: unique_serial_withdrawalline(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unique_serial_withdrawalline() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.product_id IN (
        SELECT p.product_id FROM public.product p WHERE p.is_serial = true
    ) THEN
        IF EXISTS (
            SELECT 1 FROM public."withdrawalline"
            WHERE product_id = NEW.product_id
            AND serial = NEW.serial
            AND (withdrawalline_id IS DISTINCT FROM NEW.withdrawalline_id OR withdrawalline_id IS NULL)
        ) THEN
            RAISE EXCEPTION 'Proceso cancelado, ya existe otro withdrawalline con el mismo producto y serial';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.unique_serial_withdrawalline() OWNER TO postgres;

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
-- Name: update_bpartner_name(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_bpartner_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public."order"
    SET bpartner_name = NEW.name
    WHERE "order".bpartner_id = NEW.bpartner_id;
    
    UPDATE public."warehouse_detail"
    SET bpartner_name = NEW.name
    WHERE "warehouse_detail".bpartner_id = NEW.bpartner_id;
    
    UPDATE public."inspection"
    SET bpartner_name = NEW.name
    WHERE "inspection".bpartner_id = NEW.bpartner_id;


    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_bpartner_name() OWNER TO postgres;

--
-- Name: update_category_name(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_category_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public."product"
    SET category_name = NEW.name
    WHERE "product".category_id = NEW.category_id;
    

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_category_name() OWNER TO postgres;

--
-- Name: update_current_status(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_current_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE public."inout"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "inout".inout_id = NEW.origen_id;

    UPDATE public."order"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "order".order_id = NEW.origen_id;

    UPDATE public."bpartner"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "bpartner".bpartner_id = NEW.origen_id;

    UPDATE public."product"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "product".product_id = NEW.origen_id;

    UPDATE public."category"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "category".category_id = NEW.origen_id;

    UPDATE public."warehouse"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "warehouse".warehouse_id = NEW.origen_id;

    UPDATE public."rol"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "rol".rol_id = NEW.origen_id;

    UPDATE public."user"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "user".user_id = NEW.origen_id;

    UPDATE public."org"
    SET current_status =  (SELECT history_type_id FROM public.history WHERE history_id = NEW.history_id)
    WHERE "org".org_id = NEW.origen_id;


    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_current_status() OWNER TO postgres;

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
-- Name: update_org_name(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_org_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public."inout"
    SET org_name = NEW.name
    WHERE "inout".org_id = NEW.org_id;

    UPDATE public."order"
    SET org_name = NEW.name
    WHERE "order".org_id = NEW.org_id;

    UPDATE public."warehouse"
    SET org_name = NEW.name
    WHERE "warehouse".org_id = NEW.org_id;

    UPDATE public."warehouse_detail"
    SET org_name = NEW.name
    WHERE "warehouse_detail".org_id = NEW.org_id;

    UPDATE public."movement"
    SET origin_org_name = NEW.name
    WHERE "movement".origin_org_id = NEW.org_id;
    
    UPDATE public."movement"
    SET destination_org_name = NEW.name
    WHERE "movement".destination_org_id = NEW.org_id;
    

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_org_name() OWNER TO postgres;

--
-- Name: update_product_name(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_product_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public."warehouse_detail"
    SET product_name = NEW.name
    WHERE "warehouse_detail".product_id = NEW.product_id;

    UPDATE public."inoutline"
    SET product_name = NEW.name
    WHERE "inoutline".product_id = NEW.product_id;

    UPDATE public."movementline"
    SET product_name = NEW.name
    WHERE "movementline".product_id = NEW.product_id;

    UPDATE public."orderline"
    SET product_name = NEW.name
    WHERE "orderline".product_id = NEW.product_id;


    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_product_name() OWNER TO postgres;

--
-- Name: update_qty_committed(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_qty_committed() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    inoutlinesQty RECORD;
BEGIN

    FOR inoutlinesQty IN 

        SELECT COALESCE(SUM(il.qty), 0) as qty , ol.orderline_id
        FROM public.inoutline il
        INNER JOIN public.orderline ol ON ol.orderline_id = il.orderline_id
        WHERE ol.order_id = NEW.order_id
        GROUP BY ol.orderline_id

    LOOP
    
        UPDATE public."orderline"
        SET qty_committed =  qty - ABS(qty - inoutlinesQty.qty)
        WHERE public."orderline".orderline_id = inoutlinesQty.orderline_id;
    

    END LOOP;
    

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_qty_committed() OWNER TO postgres;

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

--
-- Name: update_user_name(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_user_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public."history"
    SET user_name = NEW.username
    WHERE "history".event_by = NEW.user_id;
    

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_user_name() OWNER TO postgres;

--
-- Name: update_warehouse_name(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_warehouse_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public."inout"
    SET warehouse_name = NEW.name
    WHERE "inout".warehouse_id = NEW.warehouse_id;

    UPDATE public."warehouse_detail"
    SET warehouse_name = NEW.name
    WHERE "warehouse_detail".warehouse_id = NEW.warehouse_id;

    UPDATE public."movement"
    SET out_warehouse_name = NEW.name
    WHERE "movement".out_warehouse_id = NEW.warehouse_id;

    UPDATE public."movement"
    SET in_warehouse_name = NEW.name
    WHERE "movement".in_warehouse_id = NEW.warehouse_id;
    

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_warehouse_name() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action (
    action_id character varying(36) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.action OWNER TO postgres;

--
-- Name: bpartner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpartner (
    bpartner_id character varying(36) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    is_customer boolean DEFAULT true NOT NULL,
    is_operator boolean DEFAULT false NOT NULL,
    is_vendor boolean DEFAULT false NOT NULL,
    name character varying(60) NOT NULL,
    name2 character varying(60),
    value character varying(40) DEFAULT NULL::character varying NOT NULL,
    current_status character varying(60) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.bpartner OWNER TO postgres;

--
-- Name: bpartner_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpartner_info (
    bpartner_id character varying(36) NOT NULL,
    info_id character varying(36) NOT NULL
);


ALTER TABLE public.bpartner_info OWNER TO postgres;

--
-- Name: bpartner_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpartner_location (
    bpartner_id character varying(36) NOT NULL,
    location_id character varying(36) NOT NULL
);


ALTER TABLE public.bpartner_location OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    category_id character varying(36) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    name character varying(60),
    current_status character varying(60) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_event (
    can boolean DEFAULT false NOT NULL,
    category_id character varying(36) NOT NULL,
    event_id character varying(36) NOT NULL
);


ALTER TABLE public.category_event OWNER TO postgres;

--
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    description character varying(255) DEFAULT NULL::character varying,
    event_id character varying(36) NOT NULL,
    name character varying(60) NOT NULL
);


ALTER TABLE public.event OWNER TO postgres;

--
-- Name: history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.history (
    description text DEFAULT ''::character varying NOT NULL,
    event_by character varying(36) NOT NULL,
    event_date timestamp without time zone DEFAULT now() NOT NULL,
    history_id character varying(36) NOT NULL,
    history_type_id character varying(36) NOT NULL,
    origen_id character varying(100) NOT NULL,
    origen_table character varying(36) NOT NULL,
    user_name character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.history OWNER TO postgres;

--
-- Name: history_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.history_type (
    description character varying(250) DEFAULT NULL::character varying,
    history_type_id character varying(36) NOT NULL,
    is_status boolean DEFAULT false NOT NULL,
    name character varying(60) NOT NULL
);


ALTER TABLE public.history_type OWNER TO postgres;

--
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    image text DEFAULT ''::text NOT NULL,
    image_id character varying(36) NOT NULL
);


ALTER TABLE public.image OWNER TO postgres;

--
-- Name: info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.info (
    info_id character varying(36) NOT NULL,
    info_type_id character varying(36) NOT NULL,
    value character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.info OWNER TO postgres;

--
-- Name: info_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.info_type (
    description character varying(255) DEFAULT NULL::character varying,
    info_type_id character varying(36) NOT NULL,
    name character varying(60) NOT NULL
);


ALTER TABLE public.info_type OWNER TO postgres;

--
-- Name: inout; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."inout" (
    bpartner_id character varying(36) NOT NULL,
    correlative character varying(255) NOT NULL,
    current_status character varying(60) DEFAULT ''::character varying NOT NULL,
    description character varying(255) DEFAULT NULL::character varying NOT NULL,
    documentno character varying(60) DEFAULT ''::character varying NOT NULL,
    inout_id character varying(36) NOT NULL,
    is_out boolean DEFAULT false NOT NULL,
    n_invoice character varying(60) DEFAULT ''::character varying NOT NULL,
    order_id character varying(36) NOT NULL,
    org_id character varying(36) DEFAULT NULL::character varying NOT NULL,
    org_name character varying(255) DEFAULT ''::character varying NOT NULL,
    warehouse_id character varying(36) NOT NULL,
    warehouse_name character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public."inout" OWNER TO postgres;

--
-- Name: inoutline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inoutline (
    inout_id character varying(36) NOT NULL,
    inoutline_id character varying(36) NOT NULL,
    orderline_id character varying(36) NOT NULL,
    product_id character varying(36) NOT NULL,
    product_name character varying(255) DEFAULT ''::character varying NOT NULL,
    qty numeric DEFAULT 1 NOT NULL,
    serial character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.inoutline OWNER TO postgres;

--
-- Name: inspection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inspection (
    bpartner_id character varying(36) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying NOT NULL,
    inspection_date timestamp without time zone DEFAULT now() NOT NULL,
    inspection_id character varying(36) NOT NULL,
    warehouse_detail_id character varying(36) NOT NULL,
    bpartner_name character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.inspection OWNER TO postgres;

--
-- Name: location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location (
    address1 character varying(255) DEFAULT ''::character varying NOT NULL,
    address2 character varying(255) NOT NULL,
    city character varying(60) NOT NULL,
    country character varying(60) NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    is_fiscal_address boolean DEFAULT false NOT NULL,
    is_main boolean DEFAULT false NOT NULL,
    is_office boolean DEFAULT false NOT NULL,
    is_residence boolean DEFAULT false NOT NULL,
    is_shipping_address boolean DEFAULT false NOT NULL,
    is_withdrawal_address boolean DEFAULT false NOT NULL,
    location_id character varying(36) NOT NULL,
    region character varying(60) NOT NULL
);


ALTER TABLE public.location OWNER TO postgres;

--
-- Name: movement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movement (
    current_status character varying(10) DEFAULT NULL::character varying NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    destination_org_id character varying(36) NOT NULL,
    destination_org_name character varying(255) DEFAULT ''::character varying NOT NULL,
    in_inout_id character varying(36) NOT NULL,
    in_warehouse_id character varying(36) NOT NULL,
    in_warehouse_name character varying(255) DEFAULT ''::character varying NOT NULL,
    movement_id character varying(36) NOT NULL,
    origin_org_id character varying(36) NOT NULL,
    origin_org_name character varying(255) DEFAULT ''::character varying NOT NULL,
    out_inout_id character varying(36) NOT NULL,
    out_warehouse_id character varying(36) NOT NULL,
    out_warehouse_name character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.movement OWNER TO postgres;

--
-- Name: movementline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movementline (
    movement_id character varying(36) NOT NULL,
    movementline_id character varying(36) NOT NULL,
    product_id character varying(36) NOT NULL,
    product_name character varying(255) DEFAULT ''::character varying NOT NULL,
    qty numeric DEFAULT 1 NOT NULL
);


ALTER TABLE public.movementline OWNER TO postgres;

--
-- Name: movementline_warehouse_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movementline_warehouse_detail (
    movementline_id character varying(36) NOT NULL,
    warehouse_detail_id character varying(36) NOT NULL
);


ALTER TABLE public.movementline_warehouse_detail OWNER TO postgres;

--
-- Name: oatpp_schema_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oatpp_schema_version (
    version bigint
);


ALTER TABLE public.oatpp_schema_version OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    bpartner_id character varying(36) NOT NULL,
    bpartner_name character varying(255) DEFAULT ''::character varying NOT NULL,
    current_status character varying(36) DEFAULT ''::character varying NOT NULL,
    description character varying(255) NOT NULL,
    documentno character varying(60) DEFAULT ''::character varying NOT NULL,
    is_out boolean DEFAULT true NOT NULL,
    order_id character varying(36) NOT NULL,
    org_id character varying(36) NOT NULL,
    org_name character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: orderline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderline (
    order_id character varying(36) NOT NULL,
    orderline_id character varying(36) NOT NULL,
    product_id character varying(36) NOT NULL,
    product_name character varying(255) DEFAULT ''::character varying NOT NULL,
    qty numeric DEFAULT 1 NOT NULL,
    qty_committed numeric DEFAULT 0 NOT NULL
);


ALTER TABLE public.orderline OWNER TO postgres;

--
-- Name: org; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org (
    description character varying(255) DEFAULT NULL::character varying,
    name character varying(60) NOT NULL,
    org_id character varying(36) DEFAULT NULL::character varying NOT NULL,
    social_name character varying(60),
    value character varying(40) DEFAULT NULL::character varying NOT NULL,
    current_status character varying(60) DEFAULT ''::character varying NOT NULL,
    vencimiento timestamp without time zone,
    parent_org_id character varying(36)
);


ALTER TABLE public.org OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    brand character varying(36),
    category_id character varying(36) NOT NULL,
    category_name character varying(60) DEFAULT ''::character varying NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    image_id character varying(36),
    is_serial boolean DEFAULT false NOT NULL,
    model character varying(36),
    name character varying(60) NOT NULL,
    product_id character varying(36) NOT NULL,
    current_status character varying(60) DEFAULT ''::character varying NOT NULL,
    value character varying(60) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_event (
    can boolean DEFAULT false NOT NULL,
    event_id character varying(36) NOT NULL,
    product_id character varying(36) NOT NULL
);


ALTER TABLE public.product_event OWNER TO postgres;

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
    value character varying(50) DEFAULT NULL::character varying NOT NULL,
    name character varying(255) NOT NULL,
    name2 character varying(255),
    description character varying(255) DEFAULT NULL::character varying,
    location character varying(255) DEFAULT NULL::character varying,
    tipo_contribuyente character varying(255),
    tipo_persona character varying(255),
    prueba_column character varying(256)
);


ALTER TABLE public.prueba OWNER TO postgres;

--
-- Name: reference_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reference_image (
    image_id character varying(36) NOT NULL,
    table_id character varying(36) NOT NULL
);


ALTER TABLE public.reference_image OWNER TO postgres;

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
    documentno character varying(60) DEFAULT NULL::character varying,
    nro_documento_fiscal character varying(60) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
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
    bpartner_name character varying(50) DEFAULT NULL::character varying,
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
    description character varying(255) DEFAULT NULL::character varying,
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
    isactive character(1) DEFAULT NULL::bpchar,
    created timestamp without time zone,
    createdby character varying(36),
    updated timestamp without time zone,
    updatedby character varying(36),
    alicuota numeric DEFAULT 0,
    description character varying(120) DEFAULT NULL::character varying NOT NULL,
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
-- Name: revision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revision (
    description character varying(255) DEFAULT NULL::character varying NOT NULL,
    event_id character varying(36) NOT NULL,
    last timestamp without time zone DEFAULT now() NOT NULL,
    next timestamp without time zone DEFAULT now() NOT NULL,
    period numeric DEFAULT 1 NOT NULL,
    revision_id character varying(36) NOT NULL,
    warehouse_detail_id character varying(36) NOT NULL
);


ALTER TABLE public.revision OWNER TO postgres;

--
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol (
    icon character varying(30) NOT NULL,
    name character varying(60),
    priority integer DEFAULT 5 NOT NULL,
    rol_id character varying(36) NOT NULL,
    current_status character varying(60) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.rol OWNER TO postgres;

--
-- Name: rol_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol_action (
    action_id character varying(36) NOT NULL,
    can boolean DEFAULT true NOT NULL,
    rol_id character varying(36) NOT NULL
);


ALTER TABLE public.rol_action OWNER TO postgres;

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
    description character varying(255) DEFAULT NULL::character varying,
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
    bpartner_id character varying(36) NOT NULL,
    image_id character varying(36),
    org_id character varying(36) NOT NULL,
    password character varying(40) NOT NULL,
    rol_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    username character varying(60) NOT NULL,
    current_status character varying(60) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_action (
    action_id character varying(36) NOT NULL,
    can boolean DEFAULT true NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_action OWNER TO postgres;

--
-- Name: warehouse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warehouse (
    description character varying(255) DEFAULT NULL::character varying,
    is_out boolean DEFAULT false NOT NULL,
    location_id character varying(36) NOT NULL,
    name character varying(60) NOT NULL,
    org_id character varying(36) DEFAULT NULL::character varying NOT NULL,
    org_name character varying(255) DEFAULT ''::character varying NOT NULL,
    warehouse_id character varying(36) NOT NULL,
    current_status character varying(60) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.warehouse OWNER TO postgres;

--
-- Name: warehouse_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warehouse_detail (
    bpartner_id character varying(36),
    bpartner_name character varying(255) DEFAULT ''::character varying NOT NULL,
    is_out boolean DEFAULT false NOT NULL,
    org_id character varying(36) DEFAULT ''::character varying NOT NULL,
    org_name character varying(36) DEFAULT ''::character varying NOT NULL,
    product_id character varying(36) NOT NULL,
    product_name character varying(255) DEFAULT ''::character varying NOT NULL,
    serial character varying(255) DEFAULT ''::character varying NOT NULL,
    warehouse_detail_id character varying(36) NOT NULL,
    warehouse_id character varying(36) NOT NULL,
    warehouse_name character varying(36) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.warehouse_detail OWNER TO postgres;

--
-- Name: warehouse_detail_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warehouse_detail_info (
    org_id character varying(36) DEFAULT ''::character varying NOT NULL,
    org_name character varying(255) DEFAULT ''::character varying NOT NULL,
    value character varying(255) DEFAULT NULL::character varying NOT NULL,
    warehouse_detail_id character varying(36) NOT NULL,
    warehouse_detail_info_id character varying(36) NOT NULL
);


ALTER TABLE public.warehouse_detail_info OWNER TO postgres;

--
-- Name: withdrawal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.withdrawal (
    withdrawal_id character varying(36) NOT NULL,
    order_id character varying(36) NOT NULL,
    bpartner_id character varying(36) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying NOT NULL,
    is_out boolean DEFAULT false NOT NULL,
    org_id character varying(36) DEFAULT NULL::character varying NOT NULL,
    org_name character varying(255) DEFAULT ''::character varying NOT NULL,
    documentno character varying(60) DEFAULT ''::character varying NOT NULL,
    warehouse_id character varying(36) NOT NULL,
    warehouse_name character varying(255) DEFAULT ''::character varying NOT NULL,
    current_status character varying(60) DEFAULT ''::character varying NOT NULL,
    bpartner_name character varying(60) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.withdrawal OWNER TO postgres;

--
-- Name: withdrawalline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.withdrawalline (
    withdrawalline_id character varying(36) NOT NULL,
    withdrawal_id character varying(36) NOT NULL,
    orderline_id character varying(36) NOT NULL,
    product_name character varying(255) DEFAULT ''::character varying NOT NULL,
    qty numeric DEFAULT 1 NOT NULL,
    product_id character varying(36) NOT NULL,
    serial character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.withdrawalline OWNER TO postgres;

--
-- Name: action action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_pkey PRIMARY KEY (action_id);


--
-- Name: bpartner_info bpartner_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpartner_info
    ADD CONSTRAINT bpartner_info_pkey PRIMARY KEY (info_id);


--
-- Name: bpartner_location bpartner_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpartner_location
    ADD CONSTRAINT bpartner_location_pkey PRIMARY KEY (bpartner_id, location_id);


--
-- Name: bpartner bpartner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpartner
    ADD CONSTRAINT bpartner_pkey PRIMARY KEY (bpartner_id);


--
-- Name: category_event category_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_event
    ADD CONSTRAINT category_event_pkey PRIMARY KEY (category_id, event_id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (event_id);


--
-- Name: history history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (history_id);


--
-- Name: history_type history_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history_type
    ADD CONSTRAINT history_type_pkey PRIMARY KEY (history_type_id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (image_id);


--
-- Name: info info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.info
    ADD CONSTRAINT info_pkey PRIMARY KEY (info_id);


--
-- Name: info_type info_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.info_type
    ADD CONSTRAINT info_type_pkey PRIMARY KEY (info_type_id);


--
-- Name: inout inout_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."inout"
    ADD CONSTRAINT inout_pkey PRIMARY KEY (inout_id);


--
-- Name: inoutline inoutline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inoutline
    ADD CONSTRAINT inoutline_pkey PRIMARY KEY (inoutline_id);


--
-- Name: inspection inspection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspection
    ADD CONSTRAINT inspection_pkey PRIMARY KEY (inspection_id);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);


--
-- Name: movement movement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movement
    ADD CONSTRAINT movement_pkey PRIMARY KEY (movement_id);


--
-- Name: movementline movementline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movementline
    ADD CONSTRAINT movementline_pkey PRIMARY KEY (movementline_id);


--
-- Name: movementline_warehouse_detail movementline_warehouse_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movementline_warehouse_detail
    ADD CONSTRAINT movementline_warehouse_detail_pkey PRIMARY KEY (movementline_id, warehouse_detail_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);


--
-- Name: orderline orderline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderline
    ADD CONSTRAINT orderline_pkey PRIMARY KEY (orderline_id);


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
-- Name: product_event product_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_event
    ADD CONSTRAINT product_event_pkey PRIMARY KEY (event_id, product_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: prueba prueba_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prueba
    ADD CONSTRAINT prueba_pkey PRIMARY KEY (prueba_id);


--
-- Name: reference_image reference_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reference_image
    ADD CONSTRAINT reference_image_pkey PRIMARY KEY (image_id, table_id);


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
-- Name: revision revision_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT revision_pkey PRIMARY KEY (revision_id);


--
-- Name: rol_action rol_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_action
    ADD CONSTRAINT rol_action_pkey PRIMARY KEY (action_id, rol_id);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (rol_id);


--
-- Name: sequence sequence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT sequence_pkey PRIMARY KEY (sequence_id);


--
-- Name: bpartner unique_bpartner_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpartner
    ADD CONSTRAINT unique_bpartner_name UNIQUE (name);


--
-- Name: category unique_category_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT unique_category_name UNIQUE (name);


--
-- Name: org unique_org_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT unique_org_name UNIQUE (name);


--
-- Name: product unique_product_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT unique_product_name UNIQUE (name);


--
-- Name: user unique_user_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT unique_user_name UNIQUE (username);


--
-- Name: warehouse unique_warehouse_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT unique_warehouse_name UNIQUE (name);


--
-- Name: user_action user_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_action
    ADD CONSTRAINT user_action_pkey PRIMARY KEY (action_id, user_id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- Name: warehouse_detail_info warehouse_detail_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouse_detail_info
    ADD CONSTRAINT warehouse_detail_info_pkey PRIMARY KEY (warehouse_detail_info_id);


--
-- Name: warehouse_detail warehouse_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouse_detail
    ADD CONSTRAINT warehouse_detail_pkey PRIMARY KEY (warehouse_detail_id);


--
-- Name: warehouse warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT warehouse_pkey PRIMARY KEY (warehouse_id);


--
-- Name: withdrawal withdrawal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_pkey PRIMARY KEY (withdrawal_id);


--
-- Name: withdrawalline withdrawalline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawalline
    ADD CONSTRAINT withdrawalline_pkey PRIMARY KEY (withdrawalline_id);


--
-- Name: retencion redondear_valoresnum_retencion_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER redondear_valoresnum_retencion_trigger AFTER INSERT ON public.retencion FOR EACH ROW EXECUTE FUNCTION public.redondear_valoresnum_retencion();


--
-- Name: retencionline redondear_valoresnum_retencionline_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER redondear_valoresnum_retencionline_trigger AFTER INSERT ON public.retencionline FOR EACH ROW EXECUTE FUNCTION public.redondear_valoresnum_retencionline();


--
-- Name: orderline set_au_status_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_au_status_trigger AFTER INSERT OR DELETE OR UPDATE ON public.orderline FOR EACH STATEMENT EXECUTE FUNCTION public.set_au_status();


--
-- Name: warehouse_detail unique_serial_warehouse_detail_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER unique_serial_warehouse_detail_trigger BEFORE INSERT OR UPDATE ON public.warehouse_detail FOR EACH ROW EXECUTE FUNCTION public.unique_serial_warehouse_detail();


--
-- Name: withdrawalline unique_serial_withdrawalline_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER unique_serial_withdrawalline_trigger BEFORE INSERT OR UPDATE ON public.withdrawalline FOR EACH ROW EXECUTE FUNCTION public.unique_serial_withdrawalline();


--
-- Name: retencionline update_alicuota_retencion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_alicuota_retencion AFTER INSERT ON public.retencionline FOR EACH ROW EXECUTE FUNCTION public.update_alicuota_retencion();


--
-- Name: bpartner update_bpartner_name_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_bpartner_name_trigger AFTER INSERT OR UPDATE ON public.bpartner FOR EACH ROW EXECUTE FUNCTION public.update_bpartner_name();


--
-- Name: category update_category_name_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_category_name_trigger AFTER INSERT OR UPDATE ON public.category FOR EACH ROW EXECUTE FUNCTION public.update_category_name();


--
-- Name: history update_current_status_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_current_status_trigger AFTER INSERT OR UPDATE ON public.history FOR EACH ROW EXECUTE FUNCTION public.update_current_status();


--
-- Name: bpartner update_name_retencion_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_name_retencion_trigger AFTER UPDATE ON public.bpartner FOR EACH ROW EXECUTE FUNCTION public.update_name_retencion();


--
-- Name: org update_org_name_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_org_name_trigger AFTER INSERT OR UPDATE ON public.org FOR EACH ROW EXECUTE FUNCTION public.update_org_name();


--
-- Name: product update_product_name_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_product_name_trigger AFTER INSERT OR UPDATE ON public.product FOR EACH ROW EXECUTE FUNCTION public.update_product_name();


--
-- Name: inout update_qty_committed_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_qty_committed_trigger AFTER INSERT OR UPDATE ON public."inout" FOR EACH ROW WHEN (((new.current_status)::text = 'AP'::text)) EXECUTE FUNCTION public.update_qty_committed();


--
-- Name: user update_user_name_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user_name_trigger AFTER INSERT OR UPDATE ON public."user" FOR EACH ROW EXECUTE FUNCTION public.update_user_name();


--
-- Name: warehouse update_warehouse_name_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_warehouse_name_trigger AFTER INSERT OR UPDATE ON public.warehouse FOR EACH ROW EXECUTE FUNCTION public.update_warehouse_name();


--
-- Name: retencionline retencion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retencionline
    ADD CONSTRAINT retencion_fkey FOREIGN KEY (retencion_id) REFERENCES public.retencion(retencion_id) NOT VALID;


--
-- PostgreSQL database dump complete
--

