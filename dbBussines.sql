-- Tipos enumerados
CREATE TYPE entity_document_type AS ENUM ('V', 'J', 'G', 'E', 'P');
CREATE TYPE payment_method_type AS ENUM ('CASH', 'CARD', 'DIGITAL');
CREATE TYPE sale_type AS ENUM ('SPOT_CASH', 'CREDIT', 'LAYAWAY', 'CREDIT_NOTE', 'DEBIT_NOTE');
CREATE TYPE credit_status AS ENUM ('ACTIVE', 'DEFEATED', 'PAID', 'PUNISHED', 'BAD_DEBT');
CREATE TYPE at_aside_status AS ENUM ('ACTIVE', 'DEFEATED', 'COMPLETED', 'CANCELED');
CREATE TYPE defective_stock_status AS ENUM ('PENDING', 'APROVED', 'REJECTED', 'REPLACED');
CREATE TYPE gift_card_type AS ENUM ('PERCENTAGE', 'FIXED');
CREATE TYPE discount_type AS ENUM ('PERCENTAGE', 'FIXED');
CREATE TYPE discount_target_type AS ENUM ('STOCK', 'VARIANT', 'BRAND', 'GARMENT', 'CLIENT_GROUP');
CREATE TYPE automation_campaign_type AS ENUM ('BILLING', 'STOCK_WATCH', 'MARKETING');
CREATE TYPE automation_campaign_trigger AS ENUM ('EXPIRED_BALANCE', 'PRODUCTO_IN_STOCK', 'SPECIFIC_DATE');

-- 1. Tablas Maestras de Identificación y Personas
CREATE TABLE entities (
    id BIGSERIAL PRIMARY KEY,
    document_type entity_document_type NOT NULL, -- Tipo ENUM
    document_number VARCHAR(50) NOT NULL UNIQUE,
    nick_name VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(255),
    address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE physical_persons (
    id BIGSERIAL PRIMARY KEY,
    entity_id BIGINT NOT NULL UNIQUE,
    name1 VARCHAR(100) NOT NULL,
    name2 VARCHAR(100),
    last_name1 VARCHAR(100) NOT NULL,
    last_name2 VARCHAR(100),
    birth_date DATE,
    FOREIGN KEY (entity_id) REFERENCES entities (id)
);

-- 2. Tablas de Usuarios, Personal y Sesiones
CREATE TABLE stores (
    id BIGSERIAL PRIMARY KEY,
    store VARCHAR(255) NOT NULL,
    address TEXT
);

CREATE TABLE personnel (
    id BIGSERIAL PRIMARY KEY,
    physical_person_id BIGINT NOT NULL UNIQUE,
    store_id BIGINT,
    job_title VARCHAR(100),
    status BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (physical_person_id) REFERENCES physical_persons (id),
    FOREIGN KEY (store_id) REFERENCES stores (id)
);

CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    personnel_id BIGINT NOT NULL UNIQUE,
    role_id BIGINT NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (personnel_id) REFERENCES personnel (id),
    FOREIGN KEY (role_id) REFERENCES roles (id)
);

CREATE TABLE sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    device VARCHAR(255),
    refresh_token VARCHAR(255) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    expired_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    table_name VARCHAR(100) NOT NULL,
    record_id VARCHAR(50) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    old_data JSONB,
    new_data JSONB,
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- 3. Tablas de Proveedores y Clientes
CREATE TABLE suppliers (
    id BIGSERIAL PRIMARY KEY,
    entity_id BIGINT NOT NULL UNIQUE,
    last_purchase TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (entity_id) REFERENCES entities (id)
);

CREATE TABLE clients (
    id BIGSERIAL PRIMARY KEY,
    physical_person_id BIGINT NOT NULL UNIQUE,
    balance DECIMAL(10, 4) NOT NULL DEFAULT 0.0000, -- dinero
    tastes_vector JSONB,
    lifetime_value DECIMAL(10, 4) NOT NULL DEFAULT 0.0000, -- dinero
    last_purchase TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (physical_person_id) REFERENCES physical_persons (id)
);

-- 4. Tablas de Productos e Inventario
CREATE TABLE garments (
    id VARCHAR(50) PRIMARY KEY, -- ID de negocio/transacción
    garment VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE brands (
    id VARCHAR(50) PRIMARY KEY, -- ID de negocio/transacción
    brand VARCHAR(100) NOT NULL,
    gender VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE type_sizes (
    id BIGSERIAL PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE sizes (
    id BIGSERIAL PRIMARY KEY,
    type_size_id BIGINT NOT NULL,
    size VARCHAR(50) NOT NULL,
    FOREIGN KEY (type_size_id) REFERENCES type_sizes (id)
);

CREATE TABLE products (
    id VARCHAR(50) PRIMARY KEY, -- ID de negocio/transacción
    garment_id VARCHAR(50) NOT NULL,
    brand_id VARCHAR(50) NOT NULL,
    type_size_id BIGINT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (garment_id) REFERENCES garments (id),
    FOREIGN KEY (brand_id) REFERENCES brands (id),
    FOREIGN KEY (type_size_id) REFERENCES type_sizes (id)
);

CREATE TABLE models (
    id VARCHAR(50) PRIMARY KEY, -- ID de negocio/transacción
    product_id VARCHAR(50) NOT NULL,
    model VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (product_id) REFERENCES products (id)
);

CREATE TABLE variants (
    id VARCHAR(50) PRIMARY KEY, -- ID de negocio/transacción
    model_id VARCHAR(50) NOT NULL,
    feature VARCHAR(255),
    url_image VARCHAR(255),
    price DECIMAL(10, 4) NOT NULL, -- dinero
    FOREIGN KEY (model_id) REFERENCES models (id)
);

CREATE TABLE stocks (
    id VARCHAR(50) PRIMARY KEY, -- ID de negocio/transacción
    size_id BIGINT NOT NULL,
    variant_id VARCHAR(50) NOT NULL,
    store_id BIGINT NOT NULL,
    amount INTEGER NOT NULL DEFAULT 0,
    reserved_amount INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (size_id) REFERENCES sizes (id),
    FOREIGN KEY (variant_id) REFERENCES variants (id),
    FOREIGN KEY (store_id) REFERENCES stores (id),
    UNIQUE (size_id, variant_id, store_id)
);

CREATE TABLE defective_stocks (
    id BIGSERIAL PRIMARY KEY,
    stock_id VARCHAR(50) NOT NULL,
    amount INTEGER NOT NULL,
    reason TEXT,
    user_id BIGINT NOT NULL,
    status defective_stock_status NOT NULL, -- Tipo ENUM
    registered_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (stock_id) REFERENCES stocks (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- 5. Tablas de Compras
CREATE TABLE purchases (
    id BIGSERIAL PRIMARY KEY,
    supplier_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE purchase_details (
    id VARCHAR(50) PRIMARY KEY, -- ID de negocio/transacción
    stock_id VARCHAR(50) NOT NULL,
    purchase_id BIGINT NOT NULL,
    price DECIMAL(10, 4) NOT NULL, -- dinero/costo de compra
    amount INTEGER NOT NULL,
    FOREIGN KEY (stock_id) REFERENCES stocks (id),
    FOREIGN KEY (purchase_id) REFERENCES purchases (id)
);

-- 6. Tablas de Ventas
CREATE TABLE sales (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT,
    user_id BIGINT NOT NULL,
    store_id BIGINT NOT NULL,
    type sale_type NOT NULL, -- Tipo ENUM
    document_ref_id BIGINT, -- Para notas de crédito/débito
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (store_id) REFERENCES stores (id),
    FOREIGN KEY (document_ref_id) REFERENCES sales (id) -- Autoreferencia para documentos de referencia
);

CREATE TABLE sale_details (
    id VARCHAR(50) PRIMARY KEY, -- ID de negocio/transacción
    sale_id BIGINT NOT NULL,
    stock_id VARCHAR(50) NOT NULL,
    amount INTEGER NOT NULL,
    price DECIMAL(10, 4) NOT NULL, -- Precio de venta por unidad
    FOREIGN KEY (sale_id) REFERENCES sales (id),
    FOREIGN KEY (stock_id) REFERENCES stocks (id)
);

-- 7. Tablas de Devoluciones
CREATE TABLE returns (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    sale_detail_id VARCHAR(50) NOT NULL,
    reason TEXT,
    status BOOLEAN NOT NULL DEFAULT FALSE, -- Indicador de si la devolución fue procesada
    return_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (sale_detail_id) REFERENCES sale_details (id)
);

-- 8. Tablas de Cajas (Carts)
CREATE TABLE sale_carts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    client_id BIGINT,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (client_id) REFERENCES clients (id)
);

CREATE TABLE sale_cart_details (
    id BIGSERIAL PRIMARY KEY,
    cart_id BIGINT NOT NULL,
    stock_id VARCHAR(50) NOT NULL,
    amount INTEGER NOT NULL,
    price DECIMAL(10, 4) NOT NULL, -- Precio por unidad
    FOREIGN KEY (cart_id) REFERENCES sale_carts (id),
    FOREIGN KEY (stock_id) REFERENCES stocks (id)
);

-- 9. Tablas de Créditos y Apartados
CREATE TABLE credits (
    id BIGSERIAL PRIMARY KEY,
    sale_id BIGINT NOT NULL UNIQUE,
    due_amount DECIMAL(10, 4) NOT NULL, -- dinero
    interes_rate DECIMAL(5, 2) NOT NULL, -- porcentaje (usando la convención)
    credit_duration INTERVAL, -- El tipo DURATION en el modelo se mapea a INTERVAL en Postgres
    status credit_status NOT NULL, -- Tipo ENUM
    FOREIGN KEY (sale_id) REFERENCES sales (id)
);

CREATE TABLE at_asides (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    sale_id BIGINT, -- Se asume que al completar, se genera una venta
    client_id BIGINT NOT NULL,
    status at_aside_status NOT NULL, -- Tipo ENUM
    at_aside_duration INTERVAL, -- El tipo DURATION se mapea a INTERVAL
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (sale_id) REFERENCES sales (id),
    FOREIGN KEY (client_id) REFERENCES clients (id)
);

CREATE TABLE at_aside_details (
    id BIGSERIAL PRIMARY KEY,
    at_aside_id BIGINT NOT NULL,
    stock_id VARCHAR(50) NOT NULL,
    amount INTEGER NOT NULL,
    price DECIMAL(10, 4) NOT NULL, -- dinero
    FOREIGN KEY (at_aside_id) REFERENCES at_asides (id),
    FOREIGN KEY (stock_id) REFERENCES stocks (id)
);

-- 10. Tablas de Monedas y Pagos
CREATE TABLE coins (
    id BIGSERIAL PRIMARY KEY,
    coin VARCHAR(50) NOT NULL,
    code CHAR(3) NOT NULL UNIQUE,
    exchange_rate DECIMAL(10, 4) NOT NULL,
    is_reference_currency BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE payment_methods (
    id BIGSERIAL PRIMARY KEY,
    coin_id BIGINT NOT NULL,
    method VARCHAR(100) NOT NULL,
    type payment_method_type NOT NULL, -- Tipo ENUM
    is_electronic BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (coin_id) REFERENCES coins (id)
);

CREATE TABLE purchase_payments (
    id BIGSERIAL PRIMARY KEY,
    purchase_id BIGINT NOT NULL,
    payment_method_id BIGINT NOT NULL,
    amount DECIMAL(10, 4) NOT NULL, -- dinero
    exchange_rate DECIMAL(10, 4) NOT NULL,
    reference VARCHAR(255),
    paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (purchase_id) REFERENCES purchases (id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
);

CREATE TABLE sale_payments (
    id BIGSERIAL PRIMARY KEY,
    sale_id BIGINT NOT NULL,
    payment_method_id BIGINT NOT NULL,
    amount DECIMAL(10, 4) NOT NULL, -- dinero
    exchange_rate DECIMAL(10, 4) NOT NULL,
    reference VARCHAR(255),
    paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sale_id) REFERENCES sales (id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
);

CREATE TABLE at_aside_payments (
    id BIGSERIAL PRIMARY KEY,
    at_aside_id BIGINT NOT NULL,
    payment_method_id BIGINT NOT NULL,
    amount DECIMAL(10, 4) NOT NULL, -- dinero
    exchange_rate DECIMAL(10, 4) NOT NULL,
    reference VARCHAR(255),
    paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (at_aside_id) REFERENCES at_asides (id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
);

CREATE TABLE credit_payments (
    id BIGSERIAL PRIMARY KEY,
    credit_id BIGINT NOT NULL,
    payment_method_id BIGINT NOT NULL,
    amount DECIMAL(10, 4) NOT NULL, -- dinero
    exchange_rate DECIMAL(10, 4) NOT NULL,
    reference VARCHAR(255),
    paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (credit_id) REFERENCES credits (id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
);

-- 11. Tablas de Tarjetas de Regalo
CREATE TABLE gift_cards (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL, -- Quién la registra o crea
    code VARCHAR(50) NOT NULL UNIQUE,
    is_purchasable BOOLEAN NOT NULL DEFAULT FALSE,
    client_id BIGINT,
    type gift_card_type NOT NULL, -- Tipo ENUM
    initial_amount DECIMAL(10, 4) NOT NULL, -- dinero
    current_balance DECIMAL(10, 4) NOT NULL, -- dinero
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (client_id) REFERENCES clients (id)
);

CREATE TABLE gift_card_usages (
    id BIGSERIAL PRIMARY KEY,
    sale_payment_id BIGINT NOT NULL,
    gift_card_id BIGINT NOT NULL,
    amount_used INTEGER NOT NULL, -- Ojo: En el modelo se usa INTEGER, si es dinero debería ser DECIMAL(10, 4)
    FOREIGN KEY (sale_payment_id) REFERENCES sale_payments (id),
    FOREIGN KEY (gift_card_id) REFERENCES gift_cards (id)
);

-- 12. Tablas de Descuentos
CREATE TABLE discounts (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE,
    name VARCHAR(100) NOT NULL,
    type discount_type NOT NULL, -- Tipo ENUM
    value DECIMAL(5, 2) NOT NULL, -- porcentaje
    is_loyalty BOOLEAN NOT NULL DEFAULT FALSE,
    is_payment_method_required BOOLEAN NOT NULL DEFAULT FALSE,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    max_uses_global INTEGER
);

CREATE TABLE discount_targets (
    discount_id BIGINT,
    target_type discount_target_type, -- Tipo ENUM
    target_id VARCHAR(50), -- ID de la tabla objetivo
    PRIMARY KEY (discount_id, target_type, target_id), -- Clave Primaria Compuesta
    FOREIGN KEY (discount_id) REFERENCES discounts (id)
);

CREATE TABLE discount_payment_methods (
    discount_id BIGINT,
    payment_method_id BIGINT,
    PRIMARY KEY (discount_id, payment_method_id), -- Clave Primaria Compuesta
    FOREIGN KEY (discount_id) REFERENCES discounts (id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
);

CREATE TABLE sale_details_discounts (
    id BIGSERIAL PRIMARY KEY,
    sale_detail_id VARCHAR(50) NOT NULL,
    discount_id BIGINT NOT NULL,
    type discount_type NOT NULL,
    applied_value DECIMAL(5, 2) NOT NULL, -- O porcentaje o valor fijo aplicado (usando la convención de % para la tabla)
    amount_saved DECIMAL(10, 4) NOT NULL, -- dinero
    FOREIGN KEY (sale_detail_id) REFERENCES sale_details (id),
    FOREIGN KEY (discount_id) REFERENCES discounts (id)
);

-- 13. Tablas de Etiquetas (Tags)
CREATE TABLE tags (
    id BIGSERIAL PRIMARY KEY,
    tag VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE hashtags (
    tag_id BIGINT,
    variant_id VARCHAR(50),
    PRIMARY KEY (tag_id, variant_id), -- Clave Primaria Compuesta
    FOREIGN KEY (tag_id) REFERENCES tags (id),
    FOREIGN KEY (variant_id) REFERENCES variants (id)
);

-- 14. Tablas de Transacciones Financieras
CREATE TABLE transaction_types (
    id BIGSERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    is_income BOOLEAN NOT NULL
);

CREATE TABLE financial_transactions (
    id BIGSERIAL PRIMARY KEY,
    type_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    payment_method_id BIGINT,
    amount DECIMAL(10, 4) NOT NULL, -- dinero
    description TEXT,
    reference VARCHAR(255),
    date_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES transaction_types (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
);

-- 15. Tablas de Automatización y Vigilancia
CREATE TABLE automation_campaigns (
    id BIGSERIAL PRIMARY KEY,
    campaign_name VARCHAR(255) NOT NULL,
    campaign_type automation_campaign_type NOT NULL, -- Tipo ENUM
    trigger automation_campaign_trigger NOT NULL, -- Tipo ENUM
    template_code VARCHAR(50),
    template_message TEXT,
    status BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE campaign_execution_logs (
    id BIGSERIAL PRIMARY KEY,
    campaign_id BIGINT NOT NULL,
    client_id BIGINT,
    chanel_used VARCHAR(100),
    entity_type VARCHAR(100),
    entity_id VARCHAR(50),
    message_status VARCHAR(100),
    provider_reference VARCHAR(255),
    execution_details JSONB,
    execution_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES automation_campaigns (id),
    FOREIGN KEY (client_id) REFERENCES clients (id)
);

CREATE TABLE product_watches (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL,
    variant_id VARCHAR(50) NOT NULL,
    size_id BIGINT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    notified_at TIMESTAMP WITH TIME ZONE,
    is_resolved BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (client_id) REFERENCES clients (id),
    FOREIGN KEY (variant_id) REFERENCES variants (id),
    FOREIGN KEY (size_id) REFERENCES sizes (id)
);

INSERT INTO roles (role_name) VALUES
('Cajero'),
('Bodeguero'),
('RRHH'),
('Gerente'),
('Contador'),
('Administrador')

INSERT INTO coins (coin, code, exchange_rate, is_reference_currency) VALUES
('Dólar Estadounidense', 'USD', 1.0000, FALSE),
('Bolívar Soberano', 'BSS',321.8740, FALSE),
('Tether', 'UST', 1.0000, FALSE),
('Peso Colombiano', 'COP', 3800.0000, FALSE),
('Euro', 'EUR', 1.000, TRUE);