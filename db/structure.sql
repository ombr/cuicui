--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying(255),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE images (
    id integer NOT NULL,
    page_id integer,
    cloudinary character varying(255),
    "position" integer,
    legend text,
    "full" boolean DEFAULT false,
    content text DEFAULT ''::text,
    content_css text DEFAULT 'bottom: 22.02204265611258%;top: auto;right: 13.927145245170877%;left: auto;'::text,
    title character varying(255),
    image_css text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    original text,
    image text,
    snapshot text,
    exifs json,
    geometries json,
    focusx double precision,
    focusy double precision
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE images_id_seq OWNED BY images.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    name character varying(255),
    description text,
    site_id integer,
    "position" integer,
    description_html text DEFAULT ''::text,
    theme character varying(255) DEFAULT 'light'::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255)
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    title character varying(255) DEFAULT NULL::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description character varying(255),
    css text,
    metas text,
    language character varying(255) DEFAULT 'en'::character varying,
    twitter_id character varying(255),
    facebook_id character varying(255),
    facebook_app_id character varying(255),
    google_plus_id character varying(255),
    google_analytics_id character varying(255),
    user_id integer,
    slug character varying(255),
    domain character varying(255),
    favicon character varying(255),
    font_header character varying(255),
    font_body character varying(255)
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY images ALTER COLUMN id SET DEFAULT nextval('images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_sites_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_sites_on_slug ON sites USING btree (slug);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131215084016');

INSERT INTO schema_migrations (version) VALUES ('20131215113246');

INSERT INTO schema_migrations (version) VALUES ('20131215120642');

INSERT INTO schema_migrations (version) VALUES ('20131215143742');

INSERT INTO schema_migrations (version) VALUES ('20131215153255');

INSERT INTO schema_migrations (version) VALUES ('20131218200254');

INSERT INTO schema_migrations (version) VALUES ('20131218211056');

INSERT INTO schema_migrations (version) VALUES ('20131218211109');

INSERT INTO schema_migrations (version) VALUES ('20131220170909');

INSERT INTO schema_migrations (version) VALUES ('20131228185518');

INSERT INTO schema_migrations (version) VALUES ('20140125164812');

INSERT INTO schema_migrations (version) VALUES ('20140130124752');

INSERT INTO schema_migrations (version) VALUES ('20140206183239');

INSERT INTO schema_migrations (version) VALUES ('20140206183735');

INSERT INTO schema_migrations (version) VALUES ('20140212125425');

INSERT INTO schema_migrations (version) VALUES ('20140226121844');

INSERT INTO schema_migrations (version) VALUES ('20140303122831');

INSERT INTO schema_migrations (version) VALUES ('20140304121051');

INSERT INTO schema_migrations (version) VALUES ('20140307182947');

INSERT INTO schema_migrations (version) VALUES ('20140307223734');

INSERT INTO schema_migrations (version) VALUES ('20140307230948');

INSERT INTO schema_migrations (version) VALUES ('20140308000151');

INSERT INTO schema_migrations (version) VALUES ('20140420150458');

INSERT INTO schema_migrations (version) VALUES ('20140421090153');

INSERT INTO schema_migrations (version) VALUES ('20140421091326');

INSERT INTO schema_migrations (version) VALUES ('20140421092407');

INSERT INTO schema_migrations (version) VALUES ('20140427155851');

INSERT INTO schema_migrations (version) VALUES ('20140503093524');

INSERT INTO schema_migrations (version) VALUES ('20140505113049');

INSERT INTO schema_migrations (version) VALUES ('20140712084320');

INSERT INTO schema_migrations (version) VALUES ('20140712115400');

INSERT INTO schema_migrations (version) VALUES ('20140712120406');

INSERT INTO schema_migrations (version) VALUES ('20140714113530');

INSERT INTO schema_migrations (version) VALUES ('20140714131951');

INSERT INTO schema_migrations (version) VALUES ('20140714140959');

INSERT INTO schema_migrations (version) VALUES ('20140714141223');

INSERT INTO schema_migrations (version) VALUES ('20140714143222');

INSERT INTO schema_migrations (version) VALUES ('20140715191601');

INSERT INTO schema_migrations (version) VALUES ('20140728184611');

INSERT INTO schema_migrations (version) VALUES ('20140802105102');

INSERT INTO schema_migrations (version) VALUES ('20140812114044');

INSERT INTO schema_migrations (version) VALUES ('20140909185755');

INSERT INTO schema_migrations (version) VALUES ('20141021081149');

INSERT INTO schema_migrations (version) VALUES ('20141022143740');

INSERT INTO schema_migrations (version) VALUES ('20141028151422');

INSERT INTO schema_migrations (version) VALUES ('20141029084637');
