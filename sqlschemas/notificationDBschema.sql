--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.25
-- Dumped by pg_dump version 9.5.25

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: announcements; Type: SCHEMA; Schema: -; Owner: indoc_vre
--

CREATE SCHEMA announcements;


ALTER SCHEMA announcements OWNER TO indoc_vre;

--
-- Name: notifications; Type: SCHEMA; Schema: -; Owner: indoc_vre
--

CREATE SCHEMA notifications;


ALTER SCHEMA notifications OWNER TO indoc_vre;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: announcement; Type: TABLE; Schema: announcements; Owner: indoc_vre
--

CREATE TABLE announcements.announcement (
    id integer NOT NULL,
    project_code character varying,
    content character varying,
    version character varying,
    publisher character varying,
    date timestamp without time zone
);


ALTER TABLE announcements.announcement OWNER TO indoc_vre;

--
-- Name: announcement_id_seq; Type: SEQUENCE; Schema: announcements; Owner: indoc_vre
--

CREATE SEQUENCE announcements.announcement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE announcements.announcement_id_seq OWNER TO indoc_vre;

--
-- Name: announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: announcements; Owner: indoc_vre
--

ALTER SEQUENCE announcements.announcement_id_seq OWNED BY announcements.announcement.id;


--
-- Name: system_maintenance; Type: TABLE; Schema: notifications; Owner: indoc_vre
--

CREATE TABLE notifications.system_maintenance (
    id integer NOT NULL,
    type character varying,
    message character varying,
    maintenance_date timestamp without time zone,
    duration integer,
    duration_unit character varying,
    created_date timestamp without time zone
);


ALTER TABLE notifications.system_maintenance OWNER TO indoc_vre;

--
-- Name: system_maintenance_id_seq; Type: SEQUENCE; Schema: notifications; Owner: indoc_vre
--

CREATE SEQUENCE notifications.system_maintenance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notifications.system_maintenance_id_seq OWNER TO indoc_vre;

--
-- Name: system_maintenance_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: indoc_vre
--

ALTER SEQUENCE notifications.system_maintenance_id_seq OWNED BY notifications.system_maintenance.id;


--
-- Name: unsubscribed_notifications; Type: TABLE; Schema: notifications; Owner: indoc_vre
--

CREATE TABLE notifications.unsubscribed_notifications (
    id integer NOT NULL,
    username character varying NOT NULL,
    notification_id integer NOT NULL
);


ALTER TABLE notifications.unsubscribed_notifications OWNER TO indoc_vre;

--
-- Name: unsubscribed_notifications_id_seq; Type: SEQUENCE; Schema: notifications; Owner: indoc_vre
--

CREATE SEQUENCE notifications.unsubscribed_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notifications.unsubscribed_notifications_id_seq OWNER TO indoc_vre;

--
-- Name: unsubscribed_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: notifications; Owner: indoc_vre
--

ALTER SEQUENCE notifications.unsubscribed_notifications_id_seq OWNED BY notifications.unsubscribed_notifications.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: indoc_vre
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO indoc_vre;

--
-- Name: id; Type: DEFAULT; Schema: announcements; Owner: indoc_vre
--

ALTER TABLE ONLY announcements.announcement ALTER COLUMN id SET DEFAULT nextval('announcements.announcement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: notifications; Owner: indoc_vre
--

ALTER TABLE ONLY notifications.system_maintenance ALTER COLUMN id SET DEFAULT nextval('notifications.system_maintenance_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: notifications; Owner: indoc_vre
--

ALTER TABLE ONLY notifications.unsubscribed_notifications ALTER COLUMN id SET DEFAULT nextval('notifications.unsubscribed_notifications_id_seq'::regclass);


--
-- Name: announcement_pkey; Type: CONSTRAINT; Schema: announcements; Owner: indoc_vre
--

ALTER TABLE ONLY announcements.announcement
    ADD CONSTRAINT announcement_pkey PRIMARY KEY (id);


--
-- Name: project_code_version; Type: CONSTRAINT; Schema: announcements; Owner: indoc_vre
--

ALTER TABLE ONLY announcements.announcement
    ADD CONSTRAINT project_code_version UNIQUE (project_code, version);


--
-- Name: system_maintenance_pkey; Type: CONSTRAINT; Schema: notifications; Owner: indoc_vre
--

ALTER TABLE ONLY notifications.system_maintenance
    ADD CONSTRAINT system_maintenance_pkey PRIMARY KEY (id);


--
-- Name: unsubscribed_notifications_pkey; Type: CONSTRAINT; Schema: notifications; Owner: indoc_vre
--

ALTER TABLE ONLY notifications.unsubscribed_notifications
    ADD CONSTRAINT unsubscribed_notifications_pkey PRIMARY KEY (id);


--
-- Name: alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: indoc_vre
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: indoc_vre
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM indoc_vre;
GRANT ALL ON SCHEMA public TO indoc_vre;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
