--
-- PostgreSQL database dump
--

\restrict pHgIDFFvg3ShZUq8ZIjRMwSFSE7C6nYvZeoHWjJxyNwFpUcSI5TWH2LlK8mWuvQ

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: at_aside_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.at_aside_payments (
    id character varying(50) NOT NULL,
    at_aside_id character varying(50) NOT NULL,
    payment_method_id bigint NOT NULL,
    amount numeric(10,4) NOT NULL,
    exchange_rate numeric(10,4) NOT NULL,
    reference character varying(100),
    paid_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.at_aside_payments OWNER TO postgres;

--
-- Name: at_asides; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.at_asides (
    id character varying(50) NOT NULL,
    user_id bigint NOT NULL,
    sale_id character varying(50),
    client_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) NOT NULL
);


ALTER TABLE public.at_asides OWNER TO postgres;

--
-- Name: at_asides_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.at_asides_details (
    at_aside_id character varying(50) NOT NULL,
    stock_id character varying(50) NOT NULL,
    amount integer NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.at_asides_details OWNER TO postgres;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    user_id bigint,
    table_name character varying(50) NOT NULL,
    record_id character varying(50) NOT NULL,
    action_type character varying(10) NOT NULL,
    old_data jsonb,
    new_data jsonb,
    logged_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brands (
    id character varying(50) NOT NULL,
    brand character varying(100) NOT NULL,
    gender character(1),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.brands OWNER TO postgres;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    id bigint NOT NULL,
    entity_id bigint NOT NULL,
    balance numeric(10,4) DEFAULT 0.0000,
    tastes_vector jsonb,
    last_purchase timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO postgres;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: coins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coins (
    id bigint NOT NULL,
    coin character varying(50) NOT NULL,
    symbol character(3) NOT NULL,
    is_reference_currency boolean DEFAULT false NOT NULL
);


ALTER TABLE public.coins OWNER TO postgres;

--
-- Name: coins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.coins_id_seq OWNER TO postgres;

--
-- Name: coins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coins_id_seq OWNED BY public.coins.id;


--
-- Name: credit_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_payments (
    id character varying(50) NOT NULL,
    credit_id character varying(50) NOT NULL,
    payment_method_id bigint NOT NULL,
    amount numeric(10,4) NOT NULL,
    exchange_rate numeric(10,4) NOT NULL,
    reference character varying(100),
    paid_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.credit_payments OWNER TO postgres;

--
-- Name: credits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credits (
    id character varying(50) NOT NULL,
    sale_id character varying(50) NOT NULL,
    due_amount numeric(10,4) NOT NULL,
    interes_rate integer DEFAULT 0,
    due_date timestamp with time zone NOT NULL,
    status character varying(20) NOT NULL
);


ALTER TABLE public.credits OWNER TO postgres;

--
-- Name: discount_target; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discount_target (
    discount_id bigint NOT NULL,
    target_type character varying(50) NOT NULL,
    target_id character varying(50) NOT NULL
);


ALTER TABLE public.discount_target OWNER TO postgres;

--
-- Name: discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    percentage numeric(5,2) NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    applie_to character varying(50)
);


ALTER TABLE public.discounts OWNER TO postgres;

--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.discounts_id_seq OWNER TO postgres;

--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discounts_id_seq OWNED BY public.discounts.id;


--
-- Name: entities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entities (
    id bigint NOT NULL,
    type character(1) NOT NULL,
    document_type character varying(20),
    document_number character varying(50),
    nick_name character varying(100),
    phone character varying(20),
    email character varying(100),
    address text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    update_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.entities OWNER TO postgres;

--
-- Name: entities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.entities_id_seq OWNER TO postgres;

--
-- Name: entities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entities_id_seq OWNED BY public.entities.id;


--
-- Name: financial_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.financial_transactions (
    id bigint NOT NULL,
    type_id bigint NOT NULL,
    user_id bigint NOT NULL,
    method_id bigint,
    amount numeric(10,4) NOT NULL,
    description text,
    reference character varying(100),
    date_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.financial_transactions OWNER TO postgres;

--
-- Name: financial_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.financial_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.financial_transactions_id_seq OWNER TO postgres;

--
-- Name: financial_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.financial_transactions_id_seq OWNED BY public.financial_transactions.id;


--
-- Name: garments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.garments (
    id character varying(50) NOT NULL,
    garment character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    update_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.garments OWNER TO postgres;

--
-- Name: hashtag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hashtag (
    variant_id character varying(50) NOT NULL,
    tag_id bigint NOT NULL
);


ALTER TABLE public.hashtag OWNER TO postgres;

--
-- Name: models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models (
    id character varying(50) NOT NULL,
    product_id character varying(50) NOT NULL,
    model character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.models OWNER TO postgres;

--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_methods (
    id bigint NOT NULL,
    coin_id bigint NOT NULL,
    method character varying(50) NOT NULL,
    is_electronic boolean DEFAULT false NOT NULL
);


ALTER TABLE public.payment_methods OWNER TO postgres;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_methods_id_seq OWNER TO postgres;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_methods_id_seq OWNED BY public.payment_methods.id;


--
-- Name: personnel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personnel (
    id bigint NOT NULL,
    entity_id bigint NOT NULL,
    burden character varying(100),
    status boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.personnel OWNER TO postgres;

--
-- Name: personnel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personnel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personnel_id_seq OWNER TO postgres;

--
-- Name: personnel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personnel_id_seq OWNED BY public.personnel.id;


--
-- Name: physical_persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.physical_persons (
    id bigint NOT NULL,
    entity_id bigint NOT NULL,
    name1 character varying(50) NOT NULL,
    name2 character varying(50),
    last_name1 character varying(50) NOT NULL,
    last_name2 character varying(50),
    birth_date date
);


ALTER TABLE public.physical_persons OWNER TO postgres;

--
-- Name: physical_persons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.physical_persons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.physical_persons_id_seq OWNER TO postgres;

--
-- Name: physical_persons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.physical_persons_id_seq OWNED BY public.physical_persons.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id character varying(50) NOT NULL,
    garment_id character varying(50) NOT NULL,
    brand_id character varying(50) NOT NULL,
    type_size_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: purchase_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_details (
    stock_id character varying(50) NOT NULL,
    purchase_id character varying(50) NOT NULL,
    price numeric(10,4) NOT NULL,
    amount integer NOT NULL
);


ALTER TABLE public.purchase_details OWNER TO postgres;

--
-- Name: purchase_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_payments (
    id character varying(50) NOT NULL,
    purchase_id character varying(50) NOT NULL,
    payment_method_id bigint NOT NULL,
    amount numeric(10,4) NOT NULL,
    exchange_rate numeric(10,4) NOT NULL,
    reference character varying(100),
    paid_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.purchase_payments OWNER TO postgres;

--
-- Name: purchases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchases (
    id character varying(50) NOT NULL,
    fiscal_control character varying(100),
    supplier_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.purchases OWNER TO postgres;

--
-- Name: returns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.returns (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    sale_detail_id character varying(50) NOT NULL,
    amount integer NOT NULL,
    reason character varying(255),
    payment_method_id bigint,
    status boolean DEFAULT false NOT NULL,
    return_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    craeted_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.returns OWNER TO postgres;

--
-- Name: returns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.returns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.returns_id_seq OWNER TO postgres;

--
-- Name: returns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.returns_id_seq OWNED BY public.returns.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    role_name character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: sale_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sale_details (
    id character varying(50) NOT NULL,
    stock_id character varying(50) NOT NULL,
    sale_id character varying(50) NOT NULL,
    amount integer NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.sale_details OWNER TO postgres;

--
-- Name: sale_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sale_payments (
    id character varying(50) NOT NULL,
    sale_id character varying(50) NOT NULL,
    pyment_method_id bigint NOT NULL,
    amount numeric(10,4) NOT NULL,
    exchange_rate numeric(10,4) NOT NULL,
    reference character varying(100),
    paid_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sale_payments OWNER TO postgres;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id character varying(50) NOT NULL,
    fiscal_control character varying(100),
    client_id bigint NOT NULL,
    user_id bigint NOT NULL,
    type character varying(50),
    discount_id bigint,
    discount_percentage numeric(5,2),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: sizes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sizes (
    id bigint NOT NULL,
    type_size_id bigint NOT NULL,
    size character varying(20) NOT NULL
);


ALTER TABLE public.sizes OWNER TO postgres;

--
-- Name: sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sizes_id_seq OWNER TO postgres;

--
-- Name: sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sizes_id_seq OWNED BY public.sizes.id;


--
-- Name: stocks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stocks (
    id character varying(50) NOT NULL,
    size_id bigint NOT NULL,
    variant_id character varying(50) NOT NULL,
    store_id integer NOT NULL,
    amount integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.stocks OWNER TO postgres;

--
-- Name: stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stores (
    id integer NOT NULL,
    store character varying(100) NOT NULL,
    address text
);


ALTER TABLE public.stores OWNER TO postgres;

--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stores_id_seq OWNER TO postgres;

--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id bigint NOT NULL,
    entity_id bigint NOT NULL,
    last_purchase timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_id_seq OWNER TO postgres;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    tag character varying(50) NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: transaction_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_types (
    id bigint NOT NULL,
    type_name character varying(50) NOT NULL,
    is_income boolean DEFAULT false NOT NULL
);


ALTER TABLE public.transaction_types OWNER TO postgres;

--
-- Name: transaction_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_types_id_seq OWNER TO postgres;

--
-- Name: transaction_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_types_id_seq OWNED BY public.transaction_types.id;


--
-- Name: type_sizes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_sizes (
    id bigint NOT NULL,
    category character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.type_sizes OWNER TO postgres;

--
-- Name: type_sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_sizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_sizes_id_seq OWNER TO postgres;

--
-- Name: type_sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_sizes_id_seq OWNED BY public.type_sizes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    personal_id bigint NOT NULL,
    role_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: variants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variants (
    id character varying(50) NOT NULL,
    model_id character varying(50) NOT NULL,
    feature character varying(100),
    url_image character varying(255),
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.variants OWNER TO postgres;

--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: coins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coins ALTER COLUMN id SET DEFAULT nextval('public.coins_id_seq'::regclass);


--
-- Name: discounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts ALTER COLUMN id SET DEFAULT nextval('public.discounts_id_seq'::regclass);


--
-- Name: entities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities ALTER COLUMN id SET DEFAULT nextval('public.entities_id_seq'::regclass);


--
-- Name: financial_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_transactions ALTER COLUMN id SET DEFAULT nextval('public.financial_transactions_id_seq'::regclass);


--
-- Name: payment_methods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods ALTER COLUMN id SET DEFAULT nextval('public.payment_methods_id_seq'::regclass);


--
-- Name: personnel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personnel ALTER COLUMN id SET DEFAULT nextval('public.personnel_id_seq'::regclass);


--
-- Name: physical_persons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.physical_persons ALTER COLUMN id SET DEFAULT nextval('public.physical_persons_id_seq'::regclass);


--
-- Name: returns id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returns ALTER COLUMN id SET DEFAULT nextval('public.returns_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: sizes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sizes ALTER COLUMN id SET DEFAULT nextval('public.sizes_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: transaction_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_types ALTER COLUMN id SET DEFAULT nextval('public.transaction_types_id_seq'::regclass);


--
-- Name: type_sizes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_sizes ALTER COLUMN id SET DEFAULT nextval('public.type_sizes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: at_aside_payments at_aside_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_aside_payments
    ADD CONSTRAINT at_aside_payments_pkey PRIMARY KEY (id);


--
-- Name: at_asides_details at_asides_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_asides_details
    ADD CONSTRAINT at_asides_details_pkey PRIMARY KEY (at_aside_id, stock_id);


--
-- Name: at_asides at_asides_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_asides
    ADD CONSTRAINT at_asides_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: brands brands_brand_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_brand_key UNIQUE (brand);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: clients clients_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_entity_id_key UNIQUE (entity_id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: coins coins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT coins_pkey PRIMARY KEY (id);


--
-- Name: credit_payments credit_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_payments
    ADD CONSTRAINT credit_payments_pkey PRIMARY KEY (id);


--
-- Name: credits credits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_pkey PRIMARY KEY (id);


--
-- Name: credits credits_sale_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_sale_id_key UNIQUE (sale_id);


--
-- Name: discount_target discount_target_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_target
    ADD CONSTRAINT discount_target_pkey PRIMARY KEY (discount_id, target_type, target_id);


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: entities entities_document_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_document_number_key UNIQUE (document_number);


--
-- Name: entities entities_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_email_key UNIQUE (email);


--
-- Name: entities entities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: financial_transactions financial_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_transactions
    ADD CONSTRAINT financial_transactions_pkey PRIMARY KEY (id);


--
-- Name: garments garments_garment_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.garments
    ADD CONSTRAINT garments_garment_key UNIQUE (garment);


--
-- Name: garments garments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.garments
    ADD CONSTRAINT garments_pkey PRIMARY KEY (id);


--
-- Name: hashtag hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hashtag
    ADD CONSTRAINT hashtag_pkey PRIMARY KEY (variant_id, tag_id);


--
-- Name: models models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: personnel personnel_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personnel
    ADD CONSTRAINT personnel_entity_id_key UNIQUE (entity_id);


--
-- Name: personnel personnel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personnel
    ADD CONSTRAINT personnel_pkey PRIMARY KEY (id);


--
-- Name: physical_persons physical_persons_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.physical_persons
    ADD CONSTRAINT physical_persons_entity_id_key UNIQUE (entity_id);


--
-- Name: physical_persons physical_persons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.physical_persons
    ADD CONSTRAINT physical_persons_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchase_details purchase_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT purchase_details_pkey PRIMARY KEY (stock_id, purchase_id);


--
-- Name: purchase_payments purchase_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_payments
    ADD CONSTRAINT purchase_payments_pkey PRIMARY KEY (id, purchase_id, payment_method_id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: returns returns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returns
    ADD CONSTRAINT returns_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: sale_details sale_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_details
    ADD CONSTRAINT sale_details_pkey PRIMARY KEY (id);


--
-- Name: sale_payments sale_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_payments
    ADD CONSTRAINT sale_payments_pkey PRIMARY KEY (id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: sizes sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sizes
    ADD CONSTRAINT sizes_pkey PRIMARY KEY (id);


--
-- Name: stocks stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_entity_id_key UNIQUE (entity_id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tags tags_tag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_tag_key UNIQUE (tag);


--
-- Name: transaction_types transaction_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_types
    ADD CONSTRAINT transaction_types_pkey PRIMARY KEY (id);


--
-- Name: transaction_types transaction_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_types
    ADD CONSTRAINT transaction_types_type_name_key UNIQUE (type_name);


--
-- Name: type_sizes type_sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_sizes
    ADD CONSTRAINT type_sizes_pkey PRIMARY KEY (id);


--
-- Name: users users_personal_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_personal_id_key UNIQUE (personal_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: variants variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variants
    ADD CONSTRAINT variants_pkey PRIMARY KEY (id);


--
-- Name: at_aside_payments fk_at_aside_payments_at_aside_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_aside_payments
    ADD CONSTRAINT fk_at_aside_payments_at_aside_id FOREIGN KEY (at_aside_id) REFERENCES public.at_asides(id);


--
-- Name: at_aside_payments fk_at_aside_payments_payment_method_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_aside_payments
    ADD CONSTRAINT fk_at_aside_payments_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: at_asides fk_at_asides_client_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_asides
    ADD CONSTRAINT fk_at_asides_client_id FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: at_asides_details fk_at_asides_details_at_aside_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_asides_details
    ADD CONSTRAINT fk_at_asides_details_at_aside_id FOREIGN KEY (at_aside_id) REFERENCES public.at_asides(id);


--
-- Name: at_asides_details fk_at_asides_details_stock_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_asides_details
    ADD CONSTRAINT fk_at_asides_details_stock_id FOREIGN KEY (stock_id) REFERENCES public.stocks(id);


--
-- Name: at_asides fk_at_asides_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_asides
    ADD CONSTRAINT fk_at_asides_sale_id FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: at_asides fk_at_asides_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.at_asides
    ADD CONSTRAINT fk_at_asides_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: audit_logs fk_audit_logs_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT fk_audit_logs_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: clients fk_clients_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT fk_clients_entity_id FOREIGN KEY (entity_id) REFERENCES public.entities(id);


--
-- Name: credit_payments fk_credit_payments_credit_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_payments
    ADD CONSTRAINT fk_credit_payments_credit_id FOREIGN KEY (credit_id) REFERENCES public.credits(id);


--
-- Name: credit_payments fk_credit_payments_payment_method_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_payments
    ADD CONSTRAINT fk_credit_payments_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: credits fk_credits_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT fk_credits_sale_id FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: discount_target fk_discount_target_discount_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_target
    ADD CONSTRAINT fk_discount_target_discount_id FOREIGN KEY (discount_id) REFERENCES public.discounts(id);


--
-- Name: financial_transactions fk_financial_transactions_method_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_transactions
    ADD CONSTRAINT fk_financial_transactions_method_id FOREIGN KEY (method_id) REFERENCES public.payment_methods(id);


--
-- Name: financial_transactions fk_financial_transactions_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_transactions
    ADD CONSTRAINT fk_financial_transactions_type_id FOREIGN KEY (type_id) REFERENCES public.transaction_types(id);


--
-- Name: financial_transactions fk_financial_transactions_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_transactions
    ADD CONSTRAINT fk_financial_transactions_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: hashtag fk_hashtag_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hashtag
    ADD CONSTRAINT fk_hashtag_tag_id FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: hashtag fk_hashtag_variant_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hashtag
    ADD CONSTRAINT fk_hashtag_variant_id FOREIGN KEY (variant_id) REFERENCES public.variants(id);


--
-- Name: models fk_models_product_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT fk_models_product_id FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: payment_methods fk_payment_methods_coin_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT fk_payment_methods_coin_id FOREIGN KEY (coin_id) REFERENCES public.coins(id);


--
-- Name: personnel fk_personnel_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personnel
    ADD CONSTRAINT fk_personnel_entity_id FOREIGN KEY (entity_id) REFERENCES public.entities(id);


--
-- Name: physical_persons fk_physical_persons_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.physical_persons
    ADD CONSTRAINT fk_physical_persons_entity_id FOREIGN KEY (entity_id) REFERENCES public.entities(id);


--
-- Name: products fk_products_brand_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_brand_id FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- Name: products fk_products_garment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_garment_id FOREIGN KEY (garment_id) REFERENCES public.garments(id);


--
-- Name: products fk_products_type_size_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_type_size_id FOREIGN KEY (type_size_id) REFERENCES public.type_sizes(id);


--
-- Name: purchase_details fk_purchase_details_purchase_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT fk_purchase_details_purchase_id FOREIGN KEY (purchase_id) REFERENCES public.purchases(id);


--
-- Name: purchase_details fk_purchase_details_stock_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT fk_purchase_details_stock_id FOREIGN KEY (stock_id) REFERENCES public.stocks(id);


--
-- Name: purchase_payments fk_purchase_payments_payment_method_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_payments
    ADD CONSTRAINT fk_purchase_payments_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: purchase_payments fk_purchase_payments_purchase_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_payments
    ADD CONSTRAINT fk_purchase_payments_purchase_id FOREIGN KEY (purchase_id) REFERENCES public.purchases(id);


--
-- Name: purchases fk_purchases_supplier_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT fk_purchases_supplier_id FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: purchases fk_purchases_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT fk_purchases_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: returns fk_returns_payment_method_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returns
    ADD CONSTRAINT fk_returns_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: returns fk_returns_sale_detail_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returns
    ADD CONSTRAINT fk_returns_sale_detail_id FOREIGN KEY (sale_detail_id) REFERENCES public.sale_details(id);


--
-- Name: returns fk_returns_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returns
    ADD CONSTRAINT fk_returns_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: sale_details fk_sale_details_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_details
    ADD CONSTRAINT fk_sale_details_sale_id FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: sale_details fk_sale_details_stock_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_details
    ADD CONSTRAINT fk_sale_details_stock_id FOREIGN KEY (stock_id) REFERENCES public.stocks(id);


--
-- Name: sale_payments fk_sale_payments_payment_method_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_payments
    ADD CONSTRAINT fk_sale_payments_payment_method_id FOREIGN KEY (pyment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: sale_payments fk_sale_payments_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_payments
    ADD CONSTRAINT fk_sale_payments_sale_id FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: sales fk_sales_client_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT fk_sales_client_id FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: sales fk_sales_discount_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT fk_sales_discount_id FOREIGN KEY (discount_id) REFERENCES public.discounts(id);


--
-- Name: sales fk_sales_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT fk_sales_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: sizes fk_sizes_type_size_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sizes
    ADD CONSTRAINT fk_sizes_type_size_id FOREIGN KEY (type_size_id) REFERENCES public.type_sizes(id);


--
-- Name: stocks fk_stocks_size_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT fk_stocks_size_id FOREIGN KEY (size_id) REFERENCES public.sizes(id);


--
-- Name: stocks fk_stocks_store_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT fk_stocks_store_id FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: stocks fk_stocks_variant_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT fk_stocks_variant_id FOREIGN KEY (variant_id) REFERENCES public.variants(id);


--
-- Name: suppliers fk_suppliers_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT fk_suppliers_entity_id FOREIGN KEY (entity_id) REFERENCES public.entities(id);


--
-- Name: users fk_users_personal_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_personal_id FOREIGN KEY (personal_id) REFERENCES public.personnel(id);


--
-- Name: users fk_users_role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_role_id FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: variants fk_variants_model_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variants
    ADD CONSTRAINT fk_variants_model_id FOREIGN KEY (model_id) REFERENCES public.models(id);


--
-- PostgreSQL database dump complete
--

\unrestrict pHgIDFFvg3ShZUq8ZIjRMwSFSE7C6nYvZeoHWjJxyNwFpUcSI5TWH2LlK8mWuvQ

