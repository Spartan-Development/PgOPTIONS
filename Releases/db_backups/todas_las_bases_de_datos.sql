--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:+1t1NxMHs6DLmZmPq7dXiw==$0x68XZyDbJn17skdY/g3gXT2KZlo2tHncENO1yF2eKI=:Sm+hPLWgPFJvqfTbZfhzLlOMMOTgXzPCTkKvqIwi7a4=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

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
-- PostgreSQL database dump complete
--

--
-- Database "minisellpos" dump
--

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
-- Name: minisellpos; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE minisellpos WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Latin America.1252';


ALTER DATABASE minisellpos OWNER TO postgres;

\connect minisellpos

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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id_category character varying(256) NOT NULL,
    name_category character varying(150),
    metter_category numeric(250,0)
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    id_cliente character varying(256) NOT NULL,
    dni_cliente character varying(50),
    nombre_cliente character varying(150),
    apellido_cliente character varying(150),
    telefono character varying(50),
    direccion character varying(256),
    email character varying(256)
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compra (
    id_compra character varying(256) NOT NULL,
    fecha_compra character varying(25),
    id_producto character varying(256),
    cantidad_producto numeric(256,0),
    precio_compra numeric(256,0),
    id_proveedor character varying(256)
);


ALTER TABLE public.compra OWNER TO postgres;

--
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresa (
    id_empresa character varying(256) NOT NULL,
    dni_empresa character varying(50),
    nombre_rs character varying(256),
    address character varying(256),
    telephone character varying(25),
    email character varying(256)
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- Name: inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario (
    id_inventario character varying(256) NOT NULL,
    fecha_inventario character varying(25),
    id_lista_producto character varying(256)
);


ALTER TABLE public.inventario OWNER TO postgres;

--
-- Name: lista_prod_venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lista_prod_venta (
    id_lista_pv character varying(256) NOT NULL,
    id_producto character varying(256),
    cantidad numeric(256,0),
    precio_total numeric(256,0),
    id_venta character varying(256)
);


ALTER TABLE public.lista_prod_venta OWNER TO postgres;

--
-- Name: lista_producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lista_producto (
    id_lista_producto character varying(256) NOT NULL,
    id_producto character varying(256),
    cantidad_producto numeric(256,0),
    precio_total numeric(256,0)
);


ALTER TABLE public.lista_producto OWNER TO postgres;

--
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    id_producto character varying(256) NOT NULL,
    serial_producto numeric(256,0),
    cat_producto character varying(256),
    desc_producto character varying(256),
    precio_producto numeric(256,0)
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- Name: proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedor (
    id_proveedor character varying(256) NOT NULL,
    dni_proveedor character varying(256),
    nombre_rs character varying(256),
    email character varying(256),
    telephone character varying(50),
    address character varying(256)
);


ALTER TABLE public.proveedor OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user character varying(256) NOT NULL,
    username character varying(50),
    email character varying(256),
    password character varying(256),
    type_user character varying(50),
    token character varying(256) DEFAULT 123456
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta (
    id_venta character varying(256) NOT NULL,
    factura numeric(256,0),
    id_empresa character varying(256),
    fecha_venta character varying(25),
    hora_venta character varying(25),
    id_cliente character varying(256),
    monto_total numeric(256,0),
    pago_cliente numeric(256,0),
    cambio_cliente numeric(256,0)
);


ALTER TABLE public.venta OWNER TO postgres;

--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id_category, name_category, metter_category) FROM stdin;
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (id_cliente, dni_cliente, nombre_cliente, apellido_cliente, telefono, direccion, email) FROM stdin;
9d35e68c-e449-47ad-86ed-ba1194b850e6	12121	Ana	White	04164301111	Una prueba sin dirección	testspartan@gmail.com
\.


--
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compra (id_compra, fecha_compra, id_producto, cantidad_producto, precio_compra, id_proveedor) FROM stdin;
\.


--
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresa (id_empresa, dni_empresa, nombre_rs, address, telephone, email) FROM stdin;
6e26eca7-1ce0-416c-bee1-6d2c80eccc22	j-33432	Spartan Test	Sin dirección	0412000000	spartantestadmin@gmail.com
6a6cea99-7b03-491b-84b2-533a3d31ce09	j-33432	Spartan Test two	Sin dirección	0412000000	spartantestadmin@gmail.com
\.


--
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario (id_inventario, fecha_inventario, id_lista_producto) FROM stdin;
\.


--
-- Data for Name: lista_prod_venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lista_prod_venta (id_lista_pv, id_producto, cantidad, precio_total, id_venta) FROM stdin;
\.


--
-- Data for Name: lista_producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lista_producto (id_lista_producto, id_producto, cantidad_producto, precio_total) FROM stdin;
\.


--
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (id_producto, serial_producto, cat_producto, desc_producto, precio_producto) FROM stdin;
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedor (id_proveedor, dni_proveedor, nombre_rs, email, telephone, address) FROM stdin;
5d791962-8d21-4154-840b-a97e6f836819	j-4324	SpartanTests	emailspartantest@gmail.com	014000000	Ninguna
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id_user, username, email, password, type_user, token) FROM stdin;
a77fcdae-c8bc-4b64-b47f-95ceab6eb30a	louis32	louis32_2023@gmail.com	5678	Employ	2222
887b6d75-967b-4935-9adf-184faa82e780	Andax	guteberg@gmail.com	12345	Admin	99d877b6-016e-11ee-a4ab-9765b5c77c8b
8048e23f-4667-423f-b9b4-a78841066772	Indax	enxample@org	1234	Admin	56159642-112e-11ee-a2be-4bb4fafe6303
7be55693-5509-4cf2-b9ee-4484d06aeab2	jorge64	joe642023@gmail.com	1234	Admin	a91eb7d2-11fc-11ee-ac85-af1f684d83de
\.


--
-- Data for Name: venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venta (id_venta, factura, id_empresa, fecha_venta, hora_venta, id_cliente, monto_total, pago_cliente, cambio_cliente) FROM stdin;
\.


--
-- Name: category pk_id_category; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT pk_id_category PRIMARY KEY (id_category) INCLUDE (id_category);


--
-- Name: cliente pk_id_cliente; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT pk_id_cliente PRIMARY KEY (id_cliente) INCLUDE (id_cliente);


--
-- Name: compra pk_id_compra; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT pk_id_compra PRIMARY KEY (id_compra) INCLUDE (id_compra);


--
-- Name: empresa pk_id_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT pk_id_empresa PRIMARY KEY (id_empresa) INCLUDE (id_empresa);


--
-- Name: inventario pk_id_inventario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT pk_id_inventario PRIMARY KEY (id_inventario) INCLUDE (id_inventario);


--
-- Name: lista_producto pk_id_lista_producto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_producto
    ADD CONSTRAINT pk_id_lista_producto PRIMARY KEY (id_lista_producto) INCLUDE (id_lista_producto);


--
-- Name: lista_prod_venta pk_id_lista_pv; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_prod_venta
    ADD CONSTRAINT pk_id_lista_pv PRIMARY KEY (id_lista_pv) INCLUDE (id_lista_pv);


--
-- Name: producto pk_id_producto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT pk_id_producto PRIMARY KEY (id_producto) INCLUDE (id_producto);


--
-- Name: proveedor pk_id_proveedor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT pk_id_proveedor PRIMARY KEY (id_proveedor) INCLUDE (id_proveedor);


--
-- Name: users pk_id_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_id_user PRIMARY KEY (id_user) INCLUDE (id_user);


--
-- Name: venta pk_id_venta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT pk_id_venta PRIMARY KEY (id_venta) INCLUDE (id_venta);


--
-- Name: venta fk_id_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_id_cliente FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente) NOT VALID;


--
-- Name: venta fk_id_empresa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_id_empresa FOREIGN KEY (id_empresa) REFERENCES public.empresa(id_empresa);


--
-- Name: inventario fk_id_lista_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT fk_id_lista_producto FOREIGN KEY (id_lista_producto) REFERENCES public.lista_producto(id_lista_producto);


--
-- Name: lista_producto fk_id_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_producto
    ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- Name: compra fk_id_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- Name: lista_prod_venta fk_id_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_prod_venta
    ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- Name: compra fk_id_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: lista_prod_venta fk_id_venta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_prod_venta
    ADD CONSTRAINT fk_id_venta FOREIGN KEY (id_venta) REFERENCES public.venta(id_venta) NOT VALID;


--
-- PostgreSQL database dump complete
--

--
-- Database "minisellpos_test3" dump
--

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
-- Name: minisellpos_test3; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE minisellpos_test3 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Latin America.1252';


ALTER DATABASE minisellpos_test3 OWNER TO postgres;

\connect minisellpos_test3

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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id_category character varying(256) NOT NULL,
    name_category character varying(150),
    metter_category numeric(250,0)
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    id_cliente character varying(256) NOT NULL,
    dni_cliente character varying(50),
    nombre_cliente character varying(150),
    apellido_cliente character varying(150),
    telefono character varying(50),
    direccion character varying(256),
    email character varying(256)
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compra (
    id_compra character varying(256) NOT NULL,
    fecha_compra character varying(25),
    id_producto character varying(256),
    cantidad_producto numeric(256,0),
    precio_compra numeric(256,0),
    id_proveedor character varying(256)
);


ALTER TABLE public.compra OWNER TO postgres;

--
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresa (
    id_empresa character varying(256) NOT NULL,
    dni_empresa character varying(50),
    nombre_rs character varying(256),
    address character varying(256),
    telephone character varying(25),
    email character varying(256)
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- Name: inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario (
    id_inventario character varying(256) NOT NULL,
    fecha_inventario character varying(25),
    id_lista_producto character varying(256)
);


ALTER TABLE public.inventario OWNER TO postgres;

--
-- Name: lista_prod_venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lista_prod_venta (
    id_lista_pv character varying(256) NOT NULL,
    id_producto character varying(256),
    cantidad numeric(256,0),
    precio_total numeric(256,0),
    id_venta character varying(256)
);


ALTER TABLE public.lista_prod_venta OWNER TO postgres;

--
-- Name: lista_producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lista_producto (
    id_lista_producto character varying(256) NOT NULL,
    id_producto character varying(256),
    cantidad_producto numeric(256,0),
    precio_total numeric(256,0)
);


ALTER TABLE public.lista_producto OWNER TO postgres;

--
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    id_producto character varying(256) NOT NULL,
    serial_producto numeric(256,0),
    cat_producto character varying(256),
    desc_producto character varying(256),
    precio_producto numeric(256,0)
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- Name: proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedor (
    id_proveedor character varying(256) NOT NULL,
    dni_proveedor character varying(256),
    nombre_rs character varying(256),
    email character varying(256),
    telephone character varying(50),
    address character varying(256)
);


ALTER TABLE public.proveedor OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user character varying(256) NOT NULL,
    username character varying(50),
    email character varying(256),
    password character varying(256),
    type_user character varying(50),
    token character varying(256) DEFAULT 123456
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta (
    id_venta character varying(256) NOT NULL,
    factura numeric(256,0),
    id_empresa character varying(256),
    fecha_venta character varying(25),
    hora_venta character varying(25),
    id_cliente character varying(256),
    monto_total numeric(256,0),
    pago_cliente numeric(256,0),
    cambio_cliente numeric(256,0)
);


ALTER TABLE public.venta OWNER TO postgres;

--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id_category, name_category, metter_category) FROM stdin;
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (id_cliente, dni_cliente, nombre_cliente, apellido_cliente, telefono, direccion, email) FROM stdin;
9d35e68c-e449-47ad-86ed-ba1194b850e6	12121	Ana	White	04164301111	Una prueba sin dirección	testspartan@gmail.com
\.


--
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compra (id_compra, fecha_compra, id_producto, cantidad_producto, precio_compra, id_proveedor) FROM stdin;
\.


--
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresa (id_empresa, dni_empresa, nombre_rs, address, telephone, email) FROM stdin;
6e26eca7-1ce0-416c-bee1-6d2c80eccc22	j-33432	Spartan Test	Sin dirección	0412000000	spartantestadmin@gmail.com
6a6cea99-7b03-491b-84b2-533a3d31ce09	j-33432	Spartan Test two	Sin dirección	0412000000	spartantestadmin@gmail.com
\.


--
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario (id_inventario, fecha_inventario, id_lista_producto) FROM stdin;
\.


--
-- Data for Name: lista_prod_venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lista_prod_venta (id_lista_pv, id_producto, cantidad, precio_total, id_venta) FROM stdin;
\.


--
-- Data for Name: lista_producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lista_producto (id_lista_producto, id_producto, cantidad_producto, precio_total) FROM stdin;
\.


--
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (id_producto, serial_producto, cat_producto, desc_producto, precio_producto) FROM stdin;
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedor (id_proveedor, dni_proveedor, nombre_rs, email, telephone, address) FROM stdin;
5d791962-8d21-4154-840b-a97e6f836819	j-4324	SpartanTests	emailspartantest@gmail.com	014000000	Ninguna
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id_user, username, email, password, type_user, token) FROM stdin;
a77fcdae-c8bc-4b64-b47f-95ceab6eb30a	louis32	louis32_2023@gmail.com	5678	Employ	2222
887b6d75-967b-4935-9adf-184faa82e780	Andax	guteberg@gmail.com	12345	Admin	99d877b6-016e-11ee-a4ab-9765b5c77c8b
8048e23f-4667-423f-b9b4-a78841066772	Indax	enxample@org	1234	Admin	56159642-112e-11ee-a2be-4bb4fafe6303
7be55693-5509-4cf2-b9ee-4484d06aeab2	jorge64	joe642023@gmail.com	1234	Admin	a91eb7d2-11fc-11ee-ac85-af1f684d83de
\.


--
-- Data for Name: venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venta (id_venta, factura, id_empresa, fecha_venta, hora_venta, id_cliente, monto_total, pago_cliente, cambio_cliente) FROM stdin;
\.


--
-- Name: category pk_id_category; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT pk_id_category PRIMARY KEY (id_category) INCLUDE (id_category);


--
-- Name: cliente pk_id_cliente; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT pk_id_cliente PRIMARY KEY (id_cliente) INCLUDE (id_cliente);


--
-- Name: compra pk_id_compra; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT pk_id_compra PRIMARY KEY (id_compra) INCLUDE (id_compra);


--
-- Name: empresa pk_id_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT pk_id_empresa PRIMARY KEY (id_empresa) INCLUDE (id_empresa);


--
-- Name: inventario pk_id_inventario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT pk_id_inventario PRIMARY KEY (id_inventario) INCLUDE (id_inventario);


--
-- Name: lista_producto pk_id_lista_producto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_producto
    ADD CONSTRAINT pk_id_lista_producto PRIMARY KEY (id_lista_producto) INCLUDE (id_lista_producto);


--
-- Name: lista_prod_venta pk_id_lista_pv; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_prod_venta
    ADD CONSTRAINT pk_id_lista_pv PRIMARY KEY (id_lista_pv) INCLUDE (id_lista_pv);


--
-- Name: producto pk_id_producto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT pk_id_producto PRIMARY KEY (id_producto) INCLUDE (id_producto);


--
-- Name: proveedor pk_id_proveedor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT pk_id_proveedor PRIMARY KEY (id_proveedor) INCLUDE (id_proveedor);


--
-- Name: users pk_id_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_id_user PRIMARY KEY (id_user) INCLUDE (id_user);


--
-- Name: venta pk_id_venta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT pk_id_venta PRIMARY KEY (id_venta) INCLUDE (id_venta);


--
-- Name: venta fk_id_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_id_cliente FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente) NOT VALID;


--
-- Name: venta fk_id_empresa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_id_empresa FOREIGN KEY (id_empresa) REFERENCES public.empresa(id_empresa);


--
-- Name: inventario fk_id_lista_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT fk_id_lista_producto FOREIGN KEY (id_lista_producto) REFERENCES public.lista_producto(id_lista_producto);


--
-- Name: lista_producto fk_id_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_producto
    ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- Name: compra fk_id_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- Name: lista_prod_venta fk_id_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_prod_venta
    ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- Name: compra fk_id_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: lista_prod_venta fk_id_venta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_prod_venta
    ADD CONSTRAINT fk_id_venta FOREIGN KEY (id_venta) REFERENCES public.venta(id_venta) NOT VALID;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

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
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- PostgreSQL database dump complete
--

--
-- Database "retencion_db" dump
--

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
-- Name: retencion_db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE retencion_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Latin America.1252';


ALTER DATABASE retencion_db OWNER TO postgres;

\connect retencion_db

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
-- Data for Name: bpartner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpartner (bpartner_id, isactive, created, createdby, updated, updatedby, value, name, name2, description, location, tipo_contribuyente, tipo_persona) FROM stdin;
00caef86-9772-4c66-8309-57d0aa92a678	Y	2023-08-08 14:32:04.387663	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-08 14:32:04.387663	bb1d3aa8-a196-4ec4-a05d-a68798e53489	J-12355123-1	tercero de prueba 4	qweqwe	qwe	qweqqweqw	FOR_ESP	NAT_RES
\.


--
-- Data for Name: oatpp_schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oatpp_schema_version (version) FROM stdin;
1
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org (org_id, isactive, created, createdby, updated, updatedby, value, name, name2, description, location, licencia, vencimiento, parent_org_id) FROM stdin;
1c0101a3-b4c2-4d24-9673-822c388d4faf	N	2023-08-04 16:00:57.721034	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-14 14:42:49.086885	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	26164403	DANIEL DAVID RODRIGUEZ MARIN 		\N	MARCANO	\N	\N	\N
\.


--
-- Data for Name: retencion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retencion (retencion_id, isactive, created, createdby, updated, updatedby, bpartner_id, documentno, nro_documento_fiscal, description, baseamount, baseamountref, impamount, impamountref, totalamount, totalamountref, ispaid, ref_payment, sequence_id, rate_conversion, issotrx, date_invoice, date_ret, isiva, bpartner_name, amount_payment, isigtf, igtfamount, isinvoiceiva, invoiceivaamount, invoicesequence, invoiceivaalicuota, taxamount, taxamountref, alicuota) FROM stdin;
5ba5c4da-9139-42fa-8106-ff69f307d0ed	Y	2023-08-14 14:13:25.596042	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-14 15:10:29.819032	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	00caef86-9772-4c66-8309-57d0aa92a678	2373	NDF-0001	descripciondescripcion	100	3.13	-19.5	-0.61	200	6.26	N		b72edb6f-9026-4980-9804-810b2bfe7e9f	32	N    	2023-08-01 02:13:00	2023-08-01 02:13:00	N	tercero de prueba 4	\N	N	0	N	0	NC-0001	0	200	6.25	\N
\.


--
-- Data for Name: retencionline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retencionline (retencionline_id, retencion_id, isactive, created, createdby, updated, updatedby, description, alicuota, baseamount, baseamountref, impamount, impamountref, taxamount, taxamountref, tax) FROM stdin;
1f9f39e6-243e-42f3-a0aa-523ce429e793	5ba5c4da-9139-42fa-8106-ff69f307d0ed	Y	2023-08-14 14:17:18.279477	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-14 15:10:29.613496	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	retencion recurrete isrl del tres porciento	3	100	3.13	-267	-8.34	100	3.13	100
\.


--
-- Data for Name: retenciontype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retenciontype (retenciontype_id, isactive, created, createdby, updated, updatedby, alicuota, description, isiva, tax, isallpaid, issustraendo, minmax, auxamount, tipo_persona, used) FROM stdin;
97f50c2e-4c33-4379-8486-ae31fb92cc8d	Y	2023-08-07 14:10:01.533497	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-07 14:10:01.533497	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	1	prueba	Y	1	N	N		0	NAT_RES	N
5c4cced7-b679-4a86-9358-f5cc5d410eb1	Y	2023-08-08 08:50:13.157907	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-08 08:50:13.157907	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	12	descripciondescripcion	Y	12	N	N		0	NAT_RES	N
cf02325b-27bb-4dab-98aa-42548cd4583f	Y	2023-08-07 15:00:07.496528	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-10 11:11:51.915612	bb1d3aa8-a196-4ec4-a05d-a68798e53489	10	retencion isrl	N	100	N	Y		0	NAT_RES	N
e894e6ed-16a5-4fe7-81da-981b8c49d4e0	Y	2023-08-09 11:40:33.252576	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-10 11:13:32.350486	bb1d3aa8-a196-4ec4-a05d-a68798e53489	3	retencion recurrete isrl del tres porciento	N	100	N	Y		0	NAT_RES	Y
49c01982-7efb-45a8-a9a4-9cce75d81939	Y	2023-08-07 14:11:05.614574	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-10 11:13:37.396638	bb1d3aa8-a196-4ec4-a05d-a68798e53489	12	prueba	N	100	N	Y		0	NAT_RES	N
\.


--
-- Data for Name: sequence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sequence (sequence_id, isactive, created, createdby, updated, updatedby, name, description, incrementno, startno, currentnext, currentnextsys, prefix, sufix, issotrx) FROM stdin;
03b7b602-55d8-4bb6-9a22-6e2ee838475f	Y	2023-08-08 08:46:15.932887	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-08 08:46:15.932887	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	secuencia comra	descripciondescripcion	2	1	3	2	5	3	N
607d8e54-33ed-446e-8b7e-901855137393	Y	2023-08-07 15:56:56.359371	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-07 15:56:56.359371	bb1d3aa8-a196-4ec4-a05d-a68798e53489	pruebasecuenca	pruebasecuencapruebasecuenca	1	1	5	5	1	1	Y
476b9e4e-3d5b-4eea-9fe1-364e12970192	Y	2023-08-07 16:01:39.106368	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-07 16:01:39.106368	bb1d3aa8-a196-4ec4-a05d-a68798e53489	pruebacompra	pruebacomprapruebacompra	32	1	129	5	1	232	N
b72edb6f-9026-4980-9804-810b2bfe7e9f	Y	2023-08-07 14:16:48.30295	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-07 14:16:48.30295	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	saecuencia de prueba	prueba de secuencia	4	1	41	11	2	3	Y
\.


--
-- Data for Name: sistema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sistema (sistema_id, rif, razon_social, licencia, direccion, telefono, archivo) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (user_id, isactive, created, createdby, updated, updatedby, name, description, password, username, lectura, escritura, administrador, token) FROM stdin;
dd702f21-8f64-4cfd-b02c-f2b0fb735c76	Y	2023-08-11 15:41:26.317822	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-11 15:41:26.317822	bb1d3aa8-a196-4ec4-a05d-a68798e53489	Adriana Rodriguez	qwe qwe qwe	1234*Sp	Ro1234	Y	N	N	
6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	Y	2023-08-04 14:14:56.924131	SISTEMA	2023-08-04 14:14:56.924131	SISTEMA	SPARTANTECHS	SPARTANTECHS	2209*Sp	SPARTANTECHS	Y	Y	Y	0cc02fe6-45c9-11ee-befb-9b16538dae27
bb1d3aa8-a196-4ec4-a05d-a68798e53489	Y	2023-08-07 09:30:13.749433	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-07 09:30:13.749433	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	ELIEZER	administrador	1234*Sp	ELIEZER23	Y	Y	Y	
\.


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

--
-- Database "retencion_db_OLD" dump
--

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
-- Name: retencion_db_OLD; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "retencion_db_OLD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Latin America.1252';


ALTER DATABASE "retencion_db_OLD" OWNER TO postgres;

\connect "retencion_db_OLD"

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
-- Name: trigger_update_name_retencion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_update_name_retencion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM public.update_name_retencion();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_update_name_retencion() OWNER TO postgres;

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
    AS $$
BEGIN
	UPDATE public.retencion SET bpartner_name = NEW.name WHERE bpartner_id = NEW.bpartner_id;
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
    vencimiento timestamp without time zone NOT NULL,
    parent_org_id character varying(36)
);


ALTER TABLE public.org OWNER TO postgres;

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
    tipo_persona character varying(36)
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
    licencia character varying(400) NOT NULL,
    direccion character varying(500) NOT NULL,
    telefono character varying(15)
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
-- Data for Name: bpartner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpartner (bpartner_id, isactive, created, createdby, updated, updatedby, value, name, name2, description, location, tipo_contribuyente, tipo_persona) FROM stdin;
ad7ee15c-3b5d-42db-a468-d9fa6595c5cd	Y	2023-07-07 09:48:42.664008	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-07 11:00:08.207637	0d8c1647-408b-411c-aed3-2f287b7e845b	J-12333456-1	Licoreria Aquelarre SA	Licoreria Aquelarre SA	TEST	try update 1000	FOR_ESP	JUR_DOM
563fa74d-7bc7-4ac5-a7b4-57576c1ad1b9	Y	2023-07-13 09:47:50.689352	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 09:47:50.689352	0d8c1647-408b-411c-aed3-2f287b7e845b	J-12312312-3	BODEGON JHGONNY	BODEGON JHONNY CN	SDSDSD	try update 1000	FOR_ESP	NAT_RES
ae1c15d8-9a0a-4746-bd9f-045b9355e1aa	Y	2023-07-13 09:46:53.513509	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 09:48:33.657386	0d8c1647-408b-411c-aed3-2f287b7e845b	J-12345678-9	Licoreria Aquelarre SA	Licoreria Aquelarre SA	licoredia donde venden licor	try update 1000	FOR_ESP	JUR_DOM
ec648524-c5f2-4ea6-bac4-e615c445fe75	Y	2023-07-13 15:28:25.132531	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-14 11:33:10.358893	0d8c1647-408b-411c-aed3-2f287b7e845b	J-12312312-1	mAMARREMAMARRE	MAMARRE SA	ASDASDAS	try update 1000	FOR_ESP	NAT_RES
f7a1e894-6b99-462f-83d2-4a35dace7b3c	Y	2023-07-19 09:04:21.859302	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:04:21.859302	0d8c1647-408b-411c-aed3-2f287b7e845b	J-12399982-1	CARLITOS SHOP	CARLITOS SHOP C.A	TIENDA DE ROPA Y CALZADO	try update 1000	ORD_ESP	NAT_RES
8ef57d2b-7bd6-4e99-8966-e5286c1be793	Y	2023-07-17 15:06:01.818709	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:04:35.658375	0d8c1647-408b-411c-aed3-2f287b7e845b	J-11111111-1	pruevbaSDSD	prueba	ssssssssssssss	try update 1000	ORD	JUR_DOM
b04a7c70-7a39-452f-859d-d590bd5b5e0a	Y	2023-07-07 10:55:37.441774	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-07 10:55:37.441774	0d8c1647-408b-411c-aed3-2f287b7e845b	J-12312312-1	Automotores S.A	Automotores SA	TEST	try update 1000	FOR_ESP	NAT_RES
\.


--
-- Data for Name: oatpp_schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oatpp_schema_version (version) FROM stdin;
1
1
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org (org_id, isactive, created, createdby, updated, updatedby, value, name, name2, description, location, licencia, vencimiento, parent_org_id) FROM stdin;
5da76ee5-1c7a-422a-a667-9779c6aa4467	Y	2023-05-05 15:32:26.933368	createdby	2023-07-13 15:12:15.274383	0d8c1647-408b-411c-aed3-2f287b7e845b	J-12300123-1	Spartan Techs C.A	Spartan Techs C.A	description	location activa	123123123	2021-02-13 00:00:00	\N
\.


--
-- Data for Name: retencion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retencion (retencion_id, isactive, created, createdby, updated, updatedby, bpartner_id, documentno, nro_documento_fiscal, description, baseamount, baseamountref, impamount, impamountref, totalamount, totalamountref, ispaid, ref_payment, sequence_id, rate_conversion, issotrx, date_invoice, date_ret, isiva, bpartner_name, amount_payment, isigtf, igtfamount, isinvoiceiva, invoiceivaamount, invoicesequence, invoiceivaalicuota, taxamount, taxamountref, alicuota) FROM stdin;
5a138bf9-36ed-4d85-92a9-b6317dd75f89	N	2023-07-10 10:50:24.178982	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-10 10:51:04.420446	0d8c1647-408b-411c-aed3-2f287b7e845b	ad7ee15c-3b5d-42db-a468-d9fa6595c5cd	RET-7-ISLR-C	NDF-0001	qwe	926.45	32.51	0	0	0	0	Y	REF-002	1047bc35-f993-4838-9c38-b78358d204fc	28.5	N    	2023-07-12 10:49:00	2023-07-13 10:49:00	N	Licoreria Aquelarre SA	10000	Y	27.79	Y	148.24	NC-0001	16	0	0	\N
935cfb63-872b-441b-8200-f65b024e3441	Y	2023-07-10 10:51:51.506158	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-10 10:52:45.903652	0d8c1647-408b-411c-aed3-2f287b7e845b	ad7ee15c-3b5d-42db-a468-d9fa6595c5cd	RET-8-ISLR-C	NDF-0001	qwe	926.45	32.51	18.53	0.65	1852.9	65.02	Y	REF-002	1047bc35-f993-4838-9c38-b78358d204fc	28.5	N    	2023-07-12 10:51:00	2023-07-13 10:51:00	N	Licoreria Aquelarre SA	10000	Y	27.79	Y	148.24	NC-0001	16	926.45	32.51	\N
6f565377-1883-4e86-b4ea-66c5976e43a3	Y	2023-07-10 09:13:21.836487	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-10 09:38:23.542516	0d8c1647-408b-411c-aed3-2f287b7e845b	ad7ee15c-3b5d-42db-a468-d9fa6595c5cd	RET-7-IVA-C	NDF-0001	qwe	926.45	32.27	111.17	3.87	1074.68	37.43	Y	REF-001	32302fa0-34b7-4715-9771-9b014d6c18a9	28.71	N    	2023-07-11 09:12:00	2023-07-11 09:12:00	Y	Licoreria Aquelarre SA	100000	Y	27.79	N	0	NC-0001	0	148.23	5.16	\N
64a15369-28fd-404e-82cd-ac9d23e9227e	Y	2023-07-19 09:54:19.094885	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:54:53.676367	0d8c1647-408b-411c-aed3-2f287b7e845b	563fa74d-7bc7-4ac5-a7b4-57576c1ad1b9	235712	NDF-0001212	DSFSDFSDF	343	0.08	0	0	0	0	Y	SDFSDFSD	d598fcd9-20a3-455f-b509-70bc7c61e79b	4345	N    	2023-07-01 09:53:00	2023-07-04 09:53:00	N	BODEGON JHGONNY	110	N	0	Y	1213	NC-000212	12	0	0	\N
f720e31e-ba6e-4d10-a3b5-4e2d06c15b95	Y	2023-07-14 13:38:32.361324	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:48:52.336451	0d8c1647-408b-411c-aed3-2f287b7e845b	ae1c15d8-9a0a-4746-bd9f-045b9355e1aa	231512	NDF-00043	dfgfdgdgddgdg	322	26.83	0	0	0	0	Y	11123	d598fcd9-20a3-455f-b509-70bc7c61e79b	12	N    	2023-07-01 01:38:00	2023-07-04 01:38:00	N	Licoreria Aquelarre SA	110	Y	56	N	0	NC-00012	0	0	0	\N
7f4477de-768e-4d46-9450-83ca45e77070	N	2023-07-14 13:31:22.994805	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-14 14:16:37.177481	0d8c1647-408b-411c-aed3-2f287b7e845b	ec648524-c5f2-4ea6-bac4-e615c445fe75	23112	NDF-00012	ghcngygcukjgcuk	12342	3.8	0	0	0	0	Y	123	d598fcd9-20a3-455f-b509-70bc7c61e79b	3245	N    	2023-07-01 01:30:00	2023-07-02 01:30:00	N	mAMARREMAMARRE	11	Y	234	N	0	NC-00012	0	0	0	\N
3a4a2c94-8c97-4a4b-aca6-f8b11add8786	Y	2023-07-19 09:53:35.563283	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:54:53.679984	0d8c1647-408b-411c-aed3-2f287b7e845b	ec648524-c5f2-4ea6-bac4-e615c445fe75	234312	NDF-0001212	BMJ B JM 	1212	1	0	0	0	0	Y	SDFSDFSD	d598fcd9-20a3-455f-b509-70bc7c61e79b	1212	N    	2023-07-01 09:53:00	2023-07-03 09:53:00	N	mAMARREMAMARRE	110	Y	12121	N	0	NC-0001212	0	0	0	\N
e462e2a1-e943-49ff-a8cf-233cf521be43	Y	2023-07-19 10:01:50.4157	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 10:02:47.823902	0d8c1647-408b-411c-aed3-2f287b7e845b	ec648524-c5f2-4ea6-bac4-e615c445fe75	RET-10-ISLR-C	NDF-000567	567	56757	75.08	0	0	0	0	Y	345	1047bc35-f993-4838-9c38-b78358d204fc	756	N    	2023-07-06 10:01:00	2023-07-05 10:01:00	Y	mAMARREMAMARRE	12	N	0	N	0	NC-000567	0	0	0	\N
0f8b049e-e669-4c22-99a7-8203250e47df	Y	2023-07-19 10:12:10.820471	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 10:12:23.684226	0d8c1647-408b-411c-aed3-2f287b7e845b	ec648524-c5f2-4ea6-bac4-e615c445fe75	238512	NDF-000123	asasdasdasd	123	1	420	420	543	421	Y	sdfsdf	d598fcd9-20a3-455f-b509-70bc7c61e79b	123	N    	2023-07-08 10:11:00	2023-07-07 10:11:00	N	mAMARREMAMARRE	123123	Y	123	N	0	NC-000123	0	420	420	0.21
2d961768-b34c-4b5d-a637-2909f72abb01	Y	2023-07-19 09:58:44.548716	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:59:30.101522	0d8c1647-408b-411c-aed3-2f287b7e845b	f7a1e894-6b99-462f-83d2-4a35dace7b3c	237112	NDF-000123	setgdfgdfgdfg	3434	27.92	0	0	0	0	Y	11221	d598fcd9-20a3-455f-b509-70bc7c61e79b	123	N    	2023-07-01 09:58:00	2023-07-07 09:58:00	N	CARLITOS SHOP	110	Y	123	N	0	NC-000123	0	0	0	\N
15f5b956-8f30-419c-846c-d09852428370	Y	2023-07-19 09:48:23.802454	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:48:52.33073	0d8c1647-408b-411c-aed3-2f287b7e845b	f7a1e894-6b99-462f-83d2-4a35dace7b3c	232912	NDF-0001234212	RETENCION DE ISRL PARA UNA COMPRA	100	3.33	0	0	0	0	Y	11123	d598fcd9-20a3-455f-b509-70bc7c61e79b	30	N    	2023-07-01 09:04:00	2023-07-31 09:04:00	N	CARLITOS SHOP	110	Y	12	Y	44	NC-00000987	12	0	0	\N
e37dfd53-e73b-416d-a3b1-f5e25e34bc3e	Y	2023-07-19 10:04:05.46536	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 10:04:24.362357	0d8c1647-408b-411c-aed3-2f287b7e845b	f7a1e894-6b99-462f-83d2-4a35dace7b3c	RET-11-ISLR-C	NDF-000567	fjfgjghjghjg	567576	1001.02	0	0	0	0	Y	yrty	1047bc35-f993-4838-9c38-b78358d204fc	567	N    	2023-07-01 10:03:00	2023-07-02 10:03:00	N	CARLITOS SHOP	768678	N	0	N	0	NC-000567	0	0	0	\N
c3685c76-909e-4b0b-bd2b-96d585749e73	N	2023-07-13 10:23:06.972552	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 10:25:32.877033	0d8c1647-408b-411c-aed3-2f287b7e845b	b04a7c70-7a39-452f-859d-d590bd5b5e0a	RET-8-IVA-C	NDF-00045	FHHFGHFHFH	120	4	0	0	0	0	Y	0009	32302fa0-34b7-4715-9771-9b014d6c18a9	30	N    	2023-07-01 10:22:00	2023-07-12 10:22:00	N	Automotores S.A	100	Y	12	Y	34	NC-00023	12	0	0	\N
9f83bc74-ee8b-4cb6-8fa2-f37e7cad0366	Y	2023-07-19 09:59:07.75176	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:59:30.098789	0d8c1647-408b-411c-aed3-2f287b7e845b	b04a7c70-7a39-452f-859d-d590bd5b5e0a	RET-9-ISLR-C	NDF-000123	sdfsfs	1231231	37310.03	0	0	0	0	Y	11221	1047bc35-f993-4838-9c38-b78358d204fc	33	N    	2023-07-01 09:58:00	2023-07-12 09:58:00	N	Automotores S.A	110	Y	123123	N	0	NC-000123	0	0	0	\N
9a99fe67-8f37-46f8-9b31-982c18893750	Y	2023-07-13 10:59:28.54512	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-19 09:52:37.078977	0d8c1647-408b-411c-aed3-2f287b7e845b	ae1c15d8-9a0a-4746-bd9f-045b9355e1aa	23012	NDF-00012	rfghfghfg	678	1.24	0	0	0	0	Y	123	d598fcd9-20a3-455f-b509-70bc7c61e79b	546	N    	2023-07-05 10:59:00	2023-07-06 10:59:00	N	Licoreria Aquelarre SA	110	Y	124	N	0	NC-0002343	0	0	0	\N
\.


--
-- Data for Name: retencionline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retencionline (retencionline_id, retencion_id, isactive, created, createdby, updated, updatedby, description, alicuota, baseamount, baseamountref, impamount, impamountref, taxamount, taxamountref, tax) FROM stdin;
4eaa9a26-b31a-4223-9705-3b4666cfb1ed	6f565377-1883-4e86-b4ea-66c5976e43a3	N	2023-07-10 09:37:50.38627	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-10 09:37:50.38627	0d8c1647-408b-411c-aed3-2f287b7e845b	IVA 16, 75	75	926.45	32.27	111.17	3.87	148.23	5.16	16
ae19a2bc-ae68-4722-b2c4-e53fdfe40338	935cfb63-872b-441b-8200-f65b024e3441	Y	2023-07-10 10:52:21.466933	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-10 10:52:21.466933	0d8c1647-408b-411c-aed3-2f287b7e845b	Honorarios profesionales 2	2	926.45	32.51	18.53	0.65	926.45	32.51	100
bc4a907a-23ee-404e-9d10-9bb7dfb57f25	7f4477de-768e-4d46-9450-83ca45e77070	Y	2023-07-14 13:39:35.793481	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-14 13:39:35.793481	0d8c1647-408b-411c-aed3-2f287b7e845b	Y COMO DICES	10	100	0.03	9.8	0	100	0.03	100
d75a8f03-2971-44f2-b05c-f3d6fd60ac0b	0f8b049e-e669-4c22-99a7-8203250e47df	Y	2023-08-24 08:58:24.77283	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-08-24 08:58:24.77283	0d8c1647-408b-411c-aed3-2f287b7e845b	Retención de impuestos	0.21	1000	1000	210	210	210	210	21
\.


--
-- Data for Name: retenciontype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retenciontype (retenciontype_id, isactive, created, createdby, updated, updatedby, alicuota, description, isiva, tax, isallpaid, issustraendo, minmax, auxamount, tipo_persona) FROM stdin;
3adf5098-0ebc-4a9f-9c11-0f0066bc9ea4	Y	2023-07-07 10:36:03.322064	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-07 10:36:03.322064	0d8c1647-408b-411c-aed3-2f287b7e845b	3	Honorarios profesionales 1	N	100	N	N		0	JUR_DOM
628d1d05-4835-4174-9c51-9ba4e0938d69	Y	2023-07-07 11:03:05.600809	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-07 11:03:05.600809	0d8c1647-408b-411c-aed3-2f287b7e845b	2	Honorarios profesionales 2	N	100	N	N		0	JUR_DOM
fea98333-ec82-4317-ae82-e4ced4c00f80	Y	2023-07-07 11:43:15.448086	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-07 11:43:15.448086	0d8c1647-408b-411c-aed3-2f287b7e845b	75	IVA 16, 75	Y	16	N	N		0	NAT_RES
ff2814ca-051b-46c5-be31-b26e15f98ab4	Y	2023-07-13 10:26:06.81149	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 10:26:29.977466	0d8c1647-408b-411c-aed3-2f287b7e845b	90	ARETENCION RECURRENTE CON IVA 12 Y UN PORCENTAJE DE RETENCION DEL 90	Y	12	N	N		0	NAT_RES
3625c737-8183-4668-8e35-d21495a44c55	Y	2023-07-13 10:27:05.599807	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 10:27:05.599807	0d8c1647-408b-411c-aed3-2f287b7e845b	10	Y COMO DICES	N	100	N	Y	<	50	NAT_RES
3ff1b7e3-733a-47c4-94b7-d446cef86f0e	Y	2023-07-13 11:20:12.927135	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-18 09:10:25.67373	0d8c1647-408b-411c-aed3-2f287b7e845b	23	dfgdfgdfgdf	Y	23	N	N		0	NAT_RES
\.


--
-- Data for Name: sequence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sequence (sequence_id, isactive, created, createdby, updated, updatedby, name, description, incrementno, startno, currentnext, currentnextsys, prefix, sufix, issotrx) FROM stdin;
a13c306d-3e18-4b5c-a384-b48a223dc5c8	Y	2023-06-27 16:37:40.815292	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-06-27 16:40:58.79991	0d8c1647-408b-411c-aed3-2f287b7e845b	Retenciones de ISRL, venta	Retenciones de ISRL, venta	1	0	0	1	RET-	-ISLR-V	Y
ca0d2dfa-596f-4f37-b505-2056cb466df6	Y	2023-07-13 15:24:54.591901	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-14 13:41:17.906305	0d8c1647-408b-411c-aed3-2f287b7e845b	DDFGDFGDFG	DFGDFGDFG	1	1	0	0	1	1	Y
deb7dab6-a931-4831-afe1-0ab487468960	Y	2023-07-14 14:09:44.799868	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-14 14:10:06.74398	0d8c1647-408b-411c-aed3-2f287b7e845b	sadasd	asdasdasdasd	3	1	0	0	1	2	Y
32302fa0-34b7-4715-9771-9b014d6c18a9	Y	2023-07-03 14:13:26.071008	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-14 14:10:56.581509	0d8c1647-408b-411c-aed3-2f287b7e845b	Retenciones de IVA, compra		1	0	0	10	RET-	-IVA-C	N
55aab338-48df-4948-bb9e-a408ec4b7571	Y	2023-06-27 16:34:29.505867	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-18 09:20:55.430333	0d8c1647-408b-411c-aed3-2f287b7e845b	Retenciones de IVA, venta	Retenciones de iva, venta	1	0	0	1	RET-	-IVA-V	Y
1047bc35-f993-4838-9c38-b78358d204fc	Y	2023-06-27 16:48:34.888346	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-06-27 16:49:27.105496	0d8c1647-408b-411c-aed3-2f287b7e845b	Retenciones de ISRL, compra		1	0	12	13	RET-	-ISLR-C	N
d598fcd9-20a3-455f-b509-70bc7c61e79b	Y	2023-07-13 10:27:37.373075	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 10:28:03.010907	0d8c1647-408b-411c-aed3-2f287b7e845b	RETENCION FINA	SECUENCIA DE PRUEBA	14	1	99	8	23	12	N
d59dd011-93ef-4ed6-979b-dabf6480d47a	Y	2023-07-13 15:16:00.381582	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 15:16:00.381582	0d8c1647-408b-411c-aed3-2f287b7e845b	SDFSDFSDF	DFSDFSDFSDF	112	4	0	0	2	3	Y
115982a8-dada-4a83-b35e-0330161bb553	Y	2023-07-13 15:21:42.590746	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 15:21:42.590746	0d8c1647-408b-411c-aed3-2f287b7e845b	GDFGDFG	SDFGSDFSDFSFD	2	2	0	0	1	2	Y
\.


--
-- Data for Name: sistema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sistema (sistema_id, rif, razon_social, licencia, direccion, telefono) FROM stdin;
0072fa98-9dfa-4e14-9587-ac0a511f235f	j-2222	Makro	543445	Porlamar, Calle el Colegio	04121111111
611fc864-c440-4541-9590-bc36b265a2ca	j-33333	Makro	643445	Porlamar, Calle el Colegio	04121111111
fb472cad-30f7-4c6b-a954-c9f1f19a9354	j-1111	Makro	343445	Porlamar, Calle el Colegio	0412000000
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (user_id, isactive, created, createdby, updated, updatedby, name, description, password, username, lectura, escritura, administrador, token) FROM stdin;
d2d5fdbd-ce33-4a89-b48c-69dbe3b73e9a	Y	2023-06-23 17:05:53.928788	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-06-23 17:05:53.928788	0d8c1647-408b-411c-aed3-2f287b7e845b	Pedro Alfonzo	pedro alfonso encargado de agregar datos	1234*A	pedroalfonzo	Y	Y	N	
6b8242fc-6c19-433f-b7ef-3a3c21c06e1d	Y	2023-07-14 13:41:02.250473	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-14 13:41:02.250473	0d8c1647-408b-411c-aed3-2f287b7e845b	JUAN GABRIEL	sadasdasdasd	Juanga123*	juanga	Y	Y	Y	
818fb5e9-3494-4a00-a6b4-bef8ea4b7e4c	Y	2023-07-13 10:28:39.386081	0d8c1647-408b-411c-aed3-2f287b7e845b	2023-07-13 10:28:48.909229	0d8c1647-408b-411c-aed3-2f287b7e845b	jOSE JIMENEZ	JOSEITO ADMINISTRADORS	1234*J	JOSEITO	Y	Y	Y	
0d8c1647-408b-411c-aed3-2f287b7e845a	Y	2023-05-05 15:43:06.375814	1111	2023-07-14 13:40:11.233775	0d8c1647-408b-411c-aed3-2f287b7e845b	Spartan	Enterprise tech...	1234*J	spartan	Y	Y	Y	84f67616-41e4-11ee-955c-f3464697f4c2
0d8c1647-408b-411c-aed3-2f287b7e8aqs	Y	2023-05-05 15:43:06.375814	2222	2023-06-09 14:44:34.556102	0d8c1647-408b-411c-aed3-2f287b7e90df	Support	Company	1234*W	support	Y	N	N	b26b9142-27d3-11ee-9689-575518255717
0d8c1647-408b-411c-aed3-2f287b7e845b	Y	2023-05-05 15:43:06.375814	createdby	2023-06-27 15:53:49.918207	0d8c1647-408b-411c-aed3-2f287b7e845b	udfdsdfsf	USUARIO DE PREUBA EXITOSA	1234*A	username	Y	Y	Y	
\.


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

--
-- Database "retencion_db_old2" dump
--

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
-- Name: retencion_db_old2; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE retencion_db_old2 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Latin America.1252';


ALTER DATABASE retencion_db_old2 OWNER TO postgres;

\connect retencion_db_old2

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
    prueba_id character varying(36) NOT NULL,
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
    taxamountref numeric
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
-- Data for Name: bpartner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpartner (bpartner_id, isactive, created, createdby, updated, updatedby, value, name, name2, description, location, tipo_contribuyente, tipo_persona) FROM stdin;
d550d1a9-23ed-439a-9a0a-3b5943582789	Y	2023-08-07 14:18:24.032719	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-07 14:18:24.032719	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	J-11111111-1	prueba terceor	prueba terceor	prueba terceorprueba terceor	prueba terceorprueba terceor	FOR_ESP	NAT_RES
14ff0b8b-4c51-4954-882f-97166159867e	Y	2023-08-08 14:04:15.847277	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-08 14:04:15.847277	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	J-12121212-1	Tercero prueba	Tercero prueba	Tercero pruebaTercero prueba	Tercero pruebaTercero prueba	FOR_ESP	NAT_RES
c8fbdb02-390d-4699-9db2-2cfc4954b660	N	2023-08-08 14:20:13.167142	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-08 14:20:13.167142	bb1d3aa8-a196-4ec4-a05d-a68798e53489	J-12333123-1	Tercero desde selector	tercero de prueba	qwe	qweqwe	FOR_ESP	NAT_RES
9938ab16-6770-4842-bc93-4442486e9610	Y	2023-08-08 14:22:53.210327	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-08 14:22:53.210327	bb1d3aa8-a196-4ec4-a05d-a68798e53489	J-12333213-1	Tercero desde Selector 2	qweqwe	qweqwe	qweqwe	FOR_ESP	NAT_RES
5cd530cb-dae2-4be1-8649-dfa2a92d31e9	Y	2023-08-08 14:28:42.361109	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-08 14:28:42.361109	bb1d3aa8-a196-4ec4-a05d-a68798e53489	J-12322123-1	Tercero de prueba 3	qwe qwe qwe	asdasdas	asdasd	FOR_ESP	NAT_RES
00caef86-9772-4c66-8309-57d0aa92a678	Y	2023-08-08 14:32:04.387663	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-08 14:32:04.387663	bb1d3aa8-a196-4ec4-a05d-a68798e53489	J-12355123-1	tercero de prueba 4	qweqwe	qwe	qweqqweqw	FOR_ESP	NAT_RES
\.


--
-- Data for Name: oatpp_schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oatpp_schema_version (version) FROM stdin;
1
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org (org_id, isactive, created, createdby, updated, updatedby, value, name, name2, description, location, licencia, vencimiento, parent_org_id) FROM stdin;
1c0101a3-b4c2-4d24-9673-822c388d4faf	N	2023-08-04 16:00:57.721034	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-14 14:42:49.086885	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	26164403	DANIEL DAVID RODRIGUEZ MARIN 		\N	MARCANO	\N	\N	\N
\.


--
-- Data for Name: prueba; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prueba (prueba_id, isactive, created, createdby, updated, updatedby, value, name, name2, description, location, tipo_contribuyente, tipo_persona) FROM stdin;
\.


--
-- Data for Name: retencion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retencion (retencion_id, isactive, created, createdby, updated, updatedby, bpartner_id, documentno, nro_documento_fiscal, description, baseamount, baseamountref, impamount, impamountref, totalamount, totalamountref, ispaid, ref_payment, sequence_id, rate_conversion, issotrx, date_invoice, date_ret, isiva, bpartner_name, amount_payment, isigtf, igtfamount, isinvoiceiva, invoiceivaamount, invoicesequence, invoiceivaalicuota, taxamount, taxamountref) FROM stdin;
5ba5c4da-9139-42fa-8106-ff69f307d0ed	Y	2023-08-14 14:13:25.596042	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-14 15:10:29.819032	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	00caef86-9772-4c66-8309-57d0aa92a678	2373	NDF-0001	descripciondescripcion	100	3.13	-19.5	-0.61	200	6.26	N		b72edb6f-9026-4980-9804-810b2bfe7e9f	32	N    	2023-08-01 02:13:00	2023-08-01 02:13:00	N	tercero de prueba 4	\N	N	0	N	0	NC-0001	0	200	6.25
\.


--
-- Data for Name: retencionline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retencionline (retencionline_id, retencion_id, isactive, created, createdby, updated, updatedby, description, alicuota, baseamount, baseamountref, impamount, impamountref, taxamount, taxamountref, tax) FROM stdin;
1f9f39e6-243e-42f3-a0aa-523ce429e793	5ba5c4da-9139-42fa-8106-ff69f307d0ed	Y	2023-08-14 14:17:18.279477	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-14 15:10:29.613496	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	retencion recurrete isrl del tres porciento	3	100	3.13	-267	-8.34	100	3.13	100
\.


--
-- Data for Name: retenciontype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retenciontype (retenciontype_id, isactive, created, createdby, updated, updatedby, alicuota, description, isiva, tax, isallpaid, issustraendo, minmax, auxamount, tipo_persona, used) FROM stdin;
97f50c2e-4c33-4379-8486-ae31fb92cc8d	Y	2023-08-07 14:10:01.533497	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-07 14:10:01.533497	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	1	prueba	Y	1	N	N		0	NAT_RES	N
5c4cced7-b679-4a86-9358-f5cc5d410eb1	Y	2023-08-08 08:50:13.157907	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-08 08:50:13.157907	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	12	descripciondescripcion	Y	12	N	N		0	NAT_RES	N
cf02325b-27bb-4dab-98aa-42548cd4583f	Y	2023-08-07 15:00:07.496528	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-10 11:11:51.915612	bb1d3aa8-a196-4ec4-a05d-a68798e53489	10	retencion isrl	N	100	N	Y		0	NAT_RES	N
e894e6ed-16a5-4fe7-81da-981b8c49d4e0	Y	2023-08-09 11:40:33.252576	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-10 11:13:32.350486	bb1d3aa8-a196-4ec4-a05d-a68798e53489	3	retencion recurrete isrl del tres porciento	N	100	N	Y		0	NAT_RES	Y
49c01982-7efb-45a8-a9a4-9cce75d81939	Y	2023-08-07 14:11:05.614574	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-10 11:13:37.396638	bb1d3aa8-a196-4ec4-a05d-a68798e53489	12	prueba	N	100	N	Y		0	NAT_RES	N
\.


--
-- Data for Name: sequence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sequence (sequence_id, isactive, created, createdby, updated, updatedby, name, description, incrementno, startno, currentnext, currentnextsys, prefix, sufix, issotrx) FROM stdin;
03b7b602-55d8-4bb6-9a22-6e2ee838475f	Y	2023-08-08 08:46:15.932887	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-08 08:46:15.932887	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	secuencia comra	descripciondescripcion	2	1	3	2	5	3	N
607d8e54-33ed-446e-8b7e-901855137393	Y	2023-08-07 15:56:56.359371	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-07 15:56:56.359371	bb1d3aa8-a196-4ec4-a05d-a68798e53489	pruebasecuenca	pruebasecuencapruebasecuenca	1	1	5	5	1	1	Y
476b9e4e-3d5b-4eea-9fe1-364e12970192	Y	2023-08-07 16:01:39.106368	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-07 16:01:39.106368	bb1d3aa8-a196-4ec4-a05d-a68798e53489	pruebacompra	pruebacomprapruebacompra	32	1	129	5	1	232	N
b72edb6f-9026-4980-9804-810b2bfe7e9f	Y	2023-08-07 14:16:48.30295	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-07 14:16:48.30295	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	saecuencia de prueba	prueba de secuencia	4	1	41	11	2	3	Y
\.


--
-- Data for Name: sistema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sistema (sistema_id, rif, razon_social, licencia, direccion, telefono, archivo) FROM stdin;
11af49c6-0e40-4967-8549-ad4f4e9ffa07	26164403	DANIEL DAVID RODRIGUEZ MARIN 	iVHllJJshJoIR8/NaM1dt7JrEGe1GU0Rdvzp3ibnJX4Wc0i4AEfjcmV2DwlD4UEPzJzYq9qD7phdnQYhT7kkG1Jd3pMjNj3GuuZ2tyCO6ZLegzMxA7B6+ocN+xs1DG3l,d47/Iv7WhEZQ0p/RUJXKeYxcd7Mzut/7dwbWwRuWUzg=,jROBOpZqtL+O+L9bneZP5RM5H5UxHH5iYe/OEgpL/NNaxvtTkhFr5V8w4alYx8gtojIFoSe3lp9Y9yu6+N8M3vcN9VmwEOzCkFkKFxSZTmzTBA//yMWSeVUXoa/LHVHq,+2YQB9QI9jqmHtxSzVKvS6TIjt+h9g+CHgh05swP67rNduU6KBVegCEdT5T+t2Y5,OtV/fWLfU1P5QMYnRK4vFAwLWCh60U4ZjFZw/MsqEJY/GqgZQvyrURn65L7HoYlbjvU3AFt/ckrjLLtfeBkrG4rD1qKmzNois//AAf9tBaWVVW3XEPoBtFLy/cuGsKqi,umUeJo57aeZAqmI4TZbT9cPlgEBLJ3AKCGuwLwQyA+g=,Y8aFKOJG6/s8j+oil0+TmpWGj5Aymx2Pg+ybCO+RqIj0rX1Sc4Z3JFddwHEIxJTic5w8Gf/jZMHm8KI8/rIrW9UF6e2HM4ItAtKdY2Mnxach3FoF60N6oO3jojxXAN4l,aDUy0SPZc4bLyA+QNn+lI0hhkXlmnSENOrBPvspDKjk=,CSiw+PvlChJZpDKRCd1tedNKiFl0/20J+dMsUcE2j7RYIJxb3hBTbGaVfCaUfZ0NnVFKg/gKULvnA6XEMIpRqlRyhYH4wg41p9voj3Cs+sFrM2oW4xJzZEergM5ITREd	JUAN GRIEGO	04123562644	ICwe156cp/mKvtOI5psUZGo21AzWAZw6HaSMZ+ONerWG2mVifFI/1ZFRcPLZ67pOaEOPlpYp2FID1Kwh1dYEpyftaeGA7hNPyUrAikcDhz18Qtt8F7DC1K1sznyIrA77cEg8gaQtyXe3DbaExBP/Uuh5YAs/1jb5HBDG6PjlDPAv/HjA7cjsvzWd9F9P1+Ymjyq0M0knbkG3qxMBSi8Q3sgRNsxOutqesAntE/j0cQt2Bqymx1HUn8rhbUIBwr/yl71q3DlcWNlJ1IMzed6ACGZRyEylyv7ukSJY8EcyHIG2zFVP6W4mvu3fLZQQ5akJWPN4DPLutaxhrYKo4HXQLc/penvXfbAzYl9bmohpoAAZacHM4KRKbKaXkT92ZV5rSMGip9oK4clKq/GT1CSl/q+WeHUh/rE/R0mbjjv9+W8KjjC9rslmCdjONp+B0Pq7Qn8l/X5FJL2zPyx4iSr6ThgxH211bsU2qsGZxlYn39F4aFuxcq1oO7NV7lCroNmHqvsXbCAQ/x42YtrIqwcEWGlPof/FgF+nqREbNt40d5fp6PA7/HP5gfBAxN40Fk/AwpxL+R7kYeobcF21ykW8vc5u6RUx5qyWteKSZsZOe2SbkjRcdWeafwTsuvn7YE7ypCSADe0kfhopBo3jwt3LlctzmedPrE0Qxw4pTm9kUtC1kaTQnBSQ/+5gwGES4GkVk3mLMiKZTtbE3TRwKR/PTA+cKVy+REBiNRSegdyNrmjuAEYynMH7p2ImU3PLqSsiY9bLCs+CTPDB2hyZsyq35mAcpnZEiH36beG5kvJPQLbiWbLuFJEuFBLq1IvkbtWJLnEtPkqR3U5K8s/UERTsAC9ws07p6mW7Zauh2r1QsSxBumUSKMsYsFyePRFQWgmYYgtSNu//GrAexIGZBJi30GWHV7HYM0NWMM2R1/2khZSR/lguC5fOY0CDBu6P7Yp3YiWkQ36LML4DpuTNzf2BrbMp/f0pGROW29xmNomSjcDzxvtxiylgC/1G1tLgJ6F7wqitimXOP3+yaaSe6flAJ4nsnXmBiM7Nv+eEe8HX1t9L+xVHi3NBkJ6aETKgz6ehtwkHRl3FoFYtjt6I9w4IgPPupkEU7jYX26bIN8Yv18sUDQ9gE/8MF8aUbYVXWIWI0+C+t4GlD+IYDL+TjcZ543F11qtzeeG6LM/xaRleP36m8hpfZMz0F9b9V7/ieXmy4crOX65Jyd+7IB1MDLoftwNtr0JubZrlYaltd4+J4906ZzcoysuOaP/fQTjWfX53per51jUplGgYIg3ewjp1UU4lp/3Acjm8tI9gdmMdsDs=
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (user_id, isactive, created, createdby, updated, updatedby, name, description, password, username, lectura, escritura, administrador, token) FROM stdin;
dd702f21-8f64-4cfd-b02c-f2b0fb735c76	Y	2023-08-11 15:41:26.317822	bb1d3aa8-a196-4ec4-a05d-a68798e53489	2023-08-11 15:41:26.317822	bb1d3aa8-a196-4ec4-a05d-a68798e53489	Adriana Rodriguez	qwe qwe qwe	1234*Sp	Ro1234	Y	N	N	
6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	Y	2023-08-04 14:14:56.924131	SISTEMA	2023-08-04 14:14:56.924131	SISTEMA	SPARTANTECHS	SPARTANTECHS	2209*Sp	SPARTANTECHS	Y	Y	Y	3b81f848-3c44-11ee-8ee7-346f246bb1b4
bb1d3aa8-a196-4ec4-a05d-a68798e53489	Y	2023-08-07 09:30:13.749433	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	2023-08-07 09:30:13.749433	6a4074d2-5f0b-4e85-b168-56ebc87b8ec0	ELIEZER	administrador	1234*Sp	ELIEZER23	Y	Y	Y	d3757fd2-3c60-11ee-9655-346f246bb1b4
\.


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

--
-- PostgreSQL database cluster dump complete
--

