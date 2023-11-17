--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.23
-- Dumped by pg_dump version 9.5.23

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
-- Name: indoc_vre; Type: SCHEMA; Schema: -; Owner: indoc_vre
--

CREATE SCHEMA indoc_vre;


ALTER SCHEMA indoc_vre OWNER TO indoc_vre;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: typeenum; Type: TYPE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TYPE indoc_vre.typeenum AS ENUM (
    'text',
    'multiple_choice'
);


ALTER TYPE indoc_vre.typeenum OWNER TO indoc_vre;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: announcement; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.announcement (
    id integer NOT NULL,
    project_code character varying,
    content character varying,
    version character varying,
    publisher character varying,
    date timestamp without time zone
);


ALTER TABLE indoc_vre.announcement OWNER TO indoc_vre;

--
-- Name: announcement_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.announcement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.announcement_id_seq OWNER TO indoc_vre;

--
-- Name: announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.announcement_id_seq OWNED BY indoc_vre.announcement.id;


--
-- Name: approval_entity; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.approval_entity (
    id uuid NOT NULL,
    request_id uuid,
    entity_geid character varying,
    entity_type character varying,
    review_status character varying,
    reviewed_by character varying,
    reviewed_at character varying,
    parent_geid character varying,
    copy_status character varying,
    name character varying,
    uploaded_by character varying,
    dcm_id character varying,
    uploaded_at timestamp without time zone,
    file_size bigint
);


ALTER TABLE indoc_vre.approval_entity OWNER TO indoc_vre;

--
-- Name: approval_request; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.approval_request (
    id uuid NOT NULL,
    status character varying,
    submitted_by character varying,
    submitted_at timestamp without time zone,
    destination_geid character varying,
    source_geid character varying,
    note character varying,
    project_geid character varying,
    destination_path character varying,
    source_path character varying,
    review_notes character varying,
    completed_by character varying,
    completed_at timestamp without time zone
);


ALTER TABLE indoc_vre.approval_request OWNER TO indoc_vre;

--
-- Name: archive_preview; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.archive_preview (
    id integer NOT NULL,
    file_geid character varying,
    archive_preview character varying
);


ALTER TABLE indoc_vre.archive_preview OWNER TO indoc_vre;

--
-- Name: archive_preview_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.archive_preview_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.archive_preview_id_seq OWNER TO indoc_vre;

--
-- Name: archive_preview_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.archive_preview_id_seq OWNED BY indoc_vre.archive_preview.id;


--
-- Name: bids_results; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.bids_results (
    id integer NOT NULL,
    dataset_geid character varying(50) NOT NULL,
    created_time timestamp without time zone NOT NULL,
    updated_time timestamp without time zone NOT NULL,
    validate_output json
);


ALTER TABLE indoc_vre.bids_results OWNER TO indoc_vre;

--
-- Name: bids_results_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.bids_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.bids_results_id_seq OWNER TO indoc_vre;

--
-- Name: bids_results_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.bids_results_id_seq OWNED BY indoc_vre.bids_results.id;


--
-- Name: casbin_rule; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.casbin_rule (
    id integer NOT NULL,
    ptype character varying(255),
    v0 character varying(255),
    v1 character varying(255),
    v2 character varying(255),
    v3 character varying(255),
    v4 character varying(255),
    v5 character varying(255)
);


ALTER TABLE indoc_vre.casbin_rule OWNER TO indoc_vre;

--
-- Name: casbin_rule_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.casbin_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.casbin_rule_id_seq OWNER TO indoc_vre;

--
-- Name: casbin_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.casbin_rule_id_seq OWNED BY indoc_vre.casbin_rule.id;


--
-- Name: data_attribute; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.data_attribute (
    id integer NOT NULL,
    manifest_id integer,
    name character varying,
    type indoc_vre.typeenum NOT NULL,
    value character varying,
    project_code character varying,
    optional boolean
);


ALTER TABLE indoc_vre.data_attribute OWNER TO indoc_vre;

--
-- Name: data_attribute_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.data_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.data_attribute_id_seq OWNER TO indoc_vre;

--
-- Name: data_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.data_attribute_id_seq OWNED BY indoc_vre.data_attribute.id;


--
-- Name: data_manifest; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.data_manifest (
    id integer NOT NULL,
    name character varying,
    project_code character varying
);


ALTER TABLE indoc_vre.data_manifest OWNER TO indoc_vre;

--
-- Name: data_manifest_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.data_manifest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.data_manifest_id_seq OWNER TO indoc_vre;

--
-- Name: data_manifest_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.data_manifest_id_seq OWNED BY indoc_vre.data_manifest.id;


--
-- Name: dataset_schema; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.dataset_schema (
    geid character varying NOT NULL,
    name character varying,
    dataset_geid character varying,
    tpl_geid character varying,
    standard character varying,
    system_defined boolean,
    is_draft boolean,
    content jsonb,
    create_timestamp timestamp without time zone,
    update_timestamp timestamp without time zone,
    creator character varying
);


ALTER TABLE indoc_vre.dataset_schema OWNER TO indoc_vre;

--
-- Name: dataset_schema_template; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.dataset_schema_template (
    geid character varying NOT NULL,
    name character varying,
    dataset_geid character varying,
    standard character varying,
    system_defined boolean,
    is_draft boolean,
    content jsonb,
    create_timestamp timestamp without time zone,
    update_timestamp timestamp without time zone,
    creator character varying
);


ALTER TABLE indoc_vre.dataset_schema_template OWNER TO indoc_vre;

--
-- Name: dataset_version; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.dataset_version (
    id integer NOT NULL,
    dataset_code character varying,
    dataset_geid character varying,
    version character varying,
    created_by character varying,
    created_at timestamp without time zone,
    location character varying,
    notes character varying
);


ALTER TABLE indoc_vre.dataset_version OWNER TO indoc_vre;

--
-- Name: dataset_version_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.dataset_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.dataset_version_id_seq OWNER TO indoc_vre;

--
-- Name: dataset_version_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.dataset_version_id_seq OWNED BY indoc_vre.dataset_version.id;


--
-- Name: resource_request; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.resource_request (
    id integer NOT NULL,
    user_geid character varying,
    username character varying,
    email character varying,
    project_geid character varying,
    project_name character varying,
    request_date timestamp without time zone,
    request_for character varying,
    active boolean,
    complete_date timestamp without time zone
);


ALTER TABLE indoc_vre.resource_request OWNER TO indoc_vre;

--
-- Name: resource_request_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.resource_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.resource_request_id_seq OWNER TO indoc_vre;

--
-- Name: resource_request_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.resource_request_id_seq OWNED BY indoc_vre.resource_request.id;


--
-- Name: system_metrics; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.system_metrics (
    id integer NOT NULL,
    active_user integer,
    project integer,
    storage integer,
    vm integer,
    cores integer,
    ram integer,
    date timestamp with time zone
);


ALTER TABLE indoc_vre.system_metrics OWNER TO indoc_vre;

--
-- Name: system_metrics_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.system_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.system_metrics_id_seq OWNER TO indoc_vre;

--
-- Name: system_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.system_metrics_id_seq OWNED BY indoc_vre.system_metrics.id;


--
-- Name: user_invitation; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.user_invitation (
    invitation_code text,
    invitation_detail text,
    expiry_timestamp timestamp without time zone NOT NULL,
    create_timestamp timestamp without time zone NOT NULL,
    invited_by text,
    email text,
    role text,
    project text,
    id integer NOT NULL,
    status text
);


ALTER TABLE indoc_vre.user_invitation OWNER TO indoc_vre;

--
-- Name: user_invitation_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.user_invitation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.user_invitation_id_seq OWNER TO indoc_vre;

--
-- Name: user_invitation_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.user_invitation_id_seq OWNED BY indoc_vre.user_invitation.id;


--
-- Name: user_key; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.user_key (
    id integer NOT NULL,
    user_geid character varying,
    public_key character varying,
    key_name character varying,
    is_sandboxed boolean,
    created_at timestamp without time zone
);


ALTER TABLE indoc_vre.user_key OWNER TO indoc_vre;

--
-- Name: user_key_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.user_key_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.user_key_id_seq OWNER TO indoc_vre;

--
-- Name: user_key_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.user_key_id_seq OWNED BY indoc_vre.user_key.id;


--
-- Name: user_password_reset; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.user_password_reset (
    reset_token text,
    email text,
    expiry_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE indoc_vre.user_password_reset OWNER TO indoc_vre;

--
-- Name: workbench_resource; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE indoc_vre.workbench_resource (
    id integer NOT NULL,
    geid character varying,
    project_code character varying,
    workbench_resource character varying,
    deployed boolean,
    deployed_date timestamp without time zone,
    deployed_by character varying
);


ALTER TABLE indoc_vre.workbench_resource OWNER TO indoc_vre;

--
-- Name: workbench_resource_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE indoc_vre.workbench_resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.workbench_resource_id_seq OWNER TO indoc_vre;

--
-- Name: workbench_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.workbench_resource_id_seq OWNED BY indoc_vre.workbench_resource.id;


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.announcement ALTER COLUMN id SET DEFAULT nextval('indoc_vre.announcement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.archive_preview ALTER COLUMN id SET DEFAULT nextval('indoc_vre.archive_preview_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.bids_results ALTER COLUMN id SET DEFAULT nextval('indoc_vre.bids_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.casbin_rule ALTER COLUMN id SET DEFAULT nextval('indoc_vre.casbin_rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_attribute ALTER COLUMN id SET DEFAULT nextval('indoc_vre.data_attribute_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_manifest ALTER COLUMN id SET DEFAULT nextval('indoc_vre.data_manifest_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_version ALTER COLUMN id SET DEFAULT nextval('indoc_vre.dataset_version_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.resource_request ALTER COLUMN id SET DEFAULT nextval('indoc_vre.resource_request_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.system_metrics ALTER COLUMN id SET DEFAULT nextval('indoc_vre.system_metrics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_invitation ALTER COLUMN id SET DEFAULT nextval('indoc_vre.user_invitation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_key ALTER COLUMN id SET DEFAULT nextval('indoc_vre.user_key_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.workbench_resource ALTER COLUMN id SET DEFAULT nextval('indoc_vre.workbench_resource_id_seq'::regclass);


--
-- Name: announcement_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.announcement
    ADD CONSTRAINT announcement_pkey PRIMARY KEY (id);


--
-- Name: approval_entity_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.approval_entity
    ADD CONSTRAINT approval_entity_pkey PRIMARY KEY (id);


--
-- Name: approval_request_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.approval_request
    ADD CONSTRAINT approval_request_pkey PRIMARY KEY (id);


--
-- Name: archive_preview_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.archive_preview
    ADD CONSTRAINT archive_preview_pkey PRIMARY KEY (id);


--
-- Name: bids_results_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.bids_results
    ADD CONSTRAINT bids_results_pkey PRIMARY KEY (id);


--
-- Name: casbin_rule_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.casbin_rule
    ADD CONSTRAINT casbin_rule_pkey PRIMARY KEY (id);


--
-- Name: data_attribute_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_attribute
    ADD CONSTRAINT data_attribute_pkey PRIMARY KEY (id);


--
-- Name: data_manifest_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_manifest
    ADD CONSTRAINT data_manifest_pkey PRIMARY KEY (id);


--
-- Name: dataset_schema_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_schema
    ADD CONSTRAINT dataset_schema_pkey PRIMARY KEY (geid);


--
-- Name: dataset_schema_template_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_schema_template
    ADD CONSTRAINT dataset_schema_template_pkey PRIMARY KEY (geid);


--
-- Name: dataset_version_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_version
    ADD CONSTRAINT dataset_version_pkey PRIMARY KEY (id);


--
-- Name: project_code_version; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.announcement
    ADD CONSTRAINT project_code_version UNIQUE (project_code, version);


--
-- Name: resource_request_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.resource_request
    ADD CONSTRAINT resource_request_pkey PRIMARY KEY (id);


--
-- Name: system_metrics_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.system_metrics
    ADD CONSTRAINT system_metrics_pkey PRIMARY KEY (id);


--
-- Name: unique_key; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_key
    ADD CONSTRAINT unique_key UNIQUE (key_name, user_geid, is_sandboxed);


--
-- Name: user_invitation_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_invitation
    ADD CONSTRAINT user_invitation_pkey PRIMARY KEY (id);


--
-- Name: user_key_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_key
    ADD CONSTRAINT user_key_pkey PRIMARY KEY (id);


--
-- Name: workbench_resource_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.workbench_resource
    ADD CONSTRAINT workbench_resource_pkey PRIMARY KEY (id);


--
-- Name: approval_entity_request_id_fkey; Type: FK CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.approval_entity
    ADD CONSTRAINT approval_entity_request_id_fkey FOREIGN KEY (request_id) REFERENCES indoc_vre.approval_request(id);


--
-- Name: data_attribute_manifest_id_fkey; Type: FK CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_attribute
    ADD CONSTRAINT data_attribute_manifest_id_fkey FOREIGN KEY (manifest_id) REFERENCES indoc_vre.data_manifest(id);


--
-- Name: dataset_schema_tpl_geid_fkey; Type: FK CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_schema
    ADD CONSTRAINT dataset_schema_tpl_geid_fkey FOREIGN KEY (tpl_geid) REFERENCES indoc_vre.dataset_schema_template(geid);


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

