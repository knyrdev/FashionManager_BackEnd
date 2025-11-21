-- Tabla entities
CREATE TABLE entities (
    id BIGSERIAL PRIMARY KEY, -- Usamos BIGSERIAL para auto-incremento en la PK
    type CHAR(1), -- Asumiendo que 'type' es un solo caracter, ajustamos a CHAR(1)
    document_type VARCHAR(25), -- Ajusta el tamaño según sea necesario
    document_number VARCHAR(50), -- Asumiendo que el número de documento debe ser único
    nick_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

---

-- Tabla physical_persons
CREATE TABLE physical_persons (
    id **BIGSERIAL** PRIMARY KEY,
    entity_id **BIGINT** UNIQUE **NOT NULL**, -- UNIQUE para relación 1:1, NOT NULL para obligatoriedad
    name1 VARCHAR(100) **NOT NULL**,
    name2 VARCHAR(100),
    last_name1 VARCHAR(100) **NOT NULL**,
    last_name2 VARCHAR(100),
    birth_date DATE **NOT NULL**,
    CONSTRAINT fk_physical_persons_entity FOREIGN KEY (entity_id) REFERENCES entities(id)
);

---

-- Tabla suppliers
CREATE TABLE suppliers (
    id **BIGSERIAL** PRIMARY KEY,
    entity_id **BIGINT** UNIQUE **NOT NULL**,
    last_purchase TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_suppliers_entity FOREIGN KEY (entity_id) REFERENCES entities(id)
);

---

-- Tabla personnel
CREATE TABLE personnel (
    id **BIGSERIAL** PRIMARY KEY,
    entity_id **BIGINT** UNIQUE **NOT NULL**,
    position VARCHAR(100),
    status BOOLEAN **DEFAULT TRUE**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_personnel_entity FOREIGN KEY (entity_id) REFERENCES entities(id)
);

---

-- Tabla roles
CREATE TABLE roles (
    id **BIGSERIAL** PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE **NOT NULL**
);

---

-- Tabla users
CREATE TABLE users (
    id **BIGSERIAL** PRIMARY KEY,
    personal_id **BIGINT** **NOT NULL**,
    role_id **BIGINT** **NOT NULL**,
    username VARCHAR(50) UNIQUE **NOT NULL**,
    password VARCHAR(255) **NOT NULL**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_users_personnel FOREIGN KEY (personal_id) REFERENCES personnel(id),
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

---

-- Tabla audit_logs
CREATE TABLE audit_logs (
    id **BIGSERIAL** PRIMARY KEY,
    user_id **BIGINT** **NOT NULL**,
    table_name VARCHAR(50) **NOT NULL**,
    record_id VARCHAR(50) **NOT NULL**,
    action_type VARCHAR(20) **NOT NULL**,
    old_data JSONB,
    new_data JSONB,
    logged_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES users(id)
);

---

-- Tabla clients
CREATE TABLE clients (
    id **BIGSERIAL** PRIMARY KEY,
    entity_id **BIGINT** UNIQUE **NOT NULL**,
    balance DECIMAL(10, 4) **DEFAULT 0.0000**,
    tastes_vector JSONB,
    last_purchase TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_clients_entity FOREIGN KEY (entity_id) REFERENCES entities(id)
);

---

-- Tabla purchases
CREATE TABLE purchases (
    id **VARCHAR(50)** PRIMARY KEY,
    fiscal_control VARCHAR(100),
    supplier_id **BIGINT** **NOT NULL**,
    user_id **BIGINT** **NOT NULL**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    CONSTRAINT fk_purchases_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    CONSTRAINT fk_purchases_user FOREIGN KEY (user_id) REFERENCES users(id)
);

---

-- Tabla discounts
CREATE TABLE discounts (
    id **BIGSERIAL** PRIMARY KEY,
    name VARCHAR(100) **NOT NULL**,
    percentage DECIMAL(5, 2) **NOT NULL**,
    start_date TIMESTAMP WITHOUT TIME ZONE **NOT NULL**,
    end_date TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN **DEFAULT TRUE**,
    applie_to VARCHAR(50)
);

---
CREATE TYPE type_sale AS ENUM ('cashSale', 'reserved','credit', )
-- Tabla sales
CREATE TABLE sales (
    id **VARCHAR(50)** PRIMARY KEY,
    fiscal_control VARCHAR(100),
    client_id **BIGINT** **NOT NULL**,
    user_id **BIGINT** **NOT NULL**,
    type VARCHAR(50), -- Podría ser un ENUM
    discount_id **BIGINT**,
    discount_percentage DECIMAL(5, 2) **DEFAULT 0.00**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**, -- Cambiamos BIGINT a TIMESTAMP para la fecha de creación
    CONSTRAINT fk_sales_client FOREIGN KEY (client_id) REFERENCES clients(id),
    CONSTRAINT fk_sales_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_sales_discount FOREIGN KEY (discount_id) REFERENCES discounts(id)
);

---

-- Tabla credits
CREATE TABLE credits (
    id **VARCHAR(50)** PRIMARY KEY,
    sale_id **VARCHAR(50)** UNIQUE **NOT NULL**, -- Asumo 1:1 con sale
    due_amount DECIMAL(10, 4) **NOT NULL**,
    interes_rate INTEGER **DEFAULT 0**,
    due_date TIMESTAMP WITHOUT TIME ZONE **NOT NULL**,
    status VARCHAR(20), -- Podría ser un ENUM
    CONSTRAINT fk_credits_sale FOREIGN KEY (sale_id) REFERENCES sales(id)
);

---

-- Tabla at_asides
CREATE TABLE at_asides (
    id **VARCHAR(50)** PRIMARY KEY,
    user_id **BIGINT** **NOT NULL**,
    sale_id **VARCHAR(50)** UNIQUE, -- Asumo que un apartado puede estar vinculado a una venta, posiblemente 1:1 o NULL
    client_id **BIGINT** **NOT NULL**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    status VARCHAR(20), -- Podría ser un ENUM
    CONSTRAINT fk_at_asides_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_at_asides_sale FOREIGN KEY (sale_id) REFERENCES sales(id),
    CONSTRAINT fk_at_asides_client FOREIGN KEY (client_id) REFERENCES clients(id)
);

---

-- Tabla stores
CREATE TABLE stores (
    id **SERIAL** PRIMARY KEY, -- Usamos SERIAL ya que el modelo usa INTEGER para el ID
    store VARCHAR(100) UNIQUE **NOT NULL**,
    address TEXT
);

---

-- Tabla garments
CREATE TABLE garments (
    id **VARCHAR(50)** PRIMARY KEY,
    garment VARCHAR(100) UNIQUE **NOT NULL**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

---

-- Tabla brands
CREATE TABLE brands (
    id **VARCHAR(50)** PRIMARY KEY,
    brand VARCHAR(100) UNIQUE **NOT NULL**,
    gender VARCHAR(20),
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

---

-- Tabla type_sizes
CREATE TABLE type_sizes (
    id **BIGSERIAL** PRIMARY KEY, -- Agregamos PK para consistencia
    category VARCHAR(50) UNIQUE **NOT NULL**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

---

-- Tabla sizes
CREATE TABLE sizes (
    id **BIGSERIAL** PRIMARY KEY,
    type_size_id **BIGINT** **NOT NULL**,
    size VARCHAR(20) **NOT NULL**,
    CONSTRAINT fk_sizes_type_size FOREIGN KEY (type_size_id) REFERENCES type_sizes(id)
);

---

-- Tabla products
CREATE TABLE products (
    id **VARCHAR(50)** PRIMARY KEY,
    garment_id **VARCHAR(50)** **NOT NULL**,
    brand_id **VARCHAR(50)** **NOT NULL**,
    type_size_id **BIGINT** **NOT NULL**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_products_garment FOREIGN KEY (garment_id) REFERENCES garments(id),
    CONSTRAINT fk_products_brand FOREIGN KEY (brand_id) REFERENCES brands(id),
    CONSTRAINT fk_products_type_size FOREIGN KEY (type_size_id) REFERENCES type_sizes(id)
);

---

-- Tabla models
CREATE TABLE models (
    id **VARCHAR(50)** PRIMARY KEY,
    product_id **VARCHAR(50)** **NOT NULL**,
    model VARCHAR(100) UNIQUE **NOT NULL**,
    created_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_models_product FOREIGN KEY (product_id) REFERENCES products(id)
);

---

-- Tabla variants
CREATE TABLE variants (
    id **VARCHAR(50)** PRIMARY KEY,
    model_id **VARCHAR(50)** **NOT NULL**,
    feature VARCHAR(100),
    url_image VARCHAR(255),
    price DECIMAL(10, 2) **NOT NULL**,
    CONSTRAINT fk_variants_model FOREIGN KEY (model_id) REFERENCES models(id)
);

---

-- Tabla stocks
CREATE TABLE stocks (
    id **VARCHAR(50)** PRIMARY KEY,
    size_id **BIGINT** **NOT NULL**,
    variant_id **VARCHAR(50)** **NOT NULL**,
    store_id **INTEGER** **NOT NULL**,
    amount INTEGER **DEFAULT 0**,
    CONSTRAINT fk_stocks_size FOREIGN KEY (size_id) REFERENCES sizes(id),
    CONSTRAINT fk_stocks_variant FOREIGN KEY (variant_id) REFERENCES variants(id),
    CONSTRAINT fk_stocks_store FOREIGN KEY (store_id) REFERENCES stores(id)
);

---

-- Tabla purchase_details
CREATE TABLE purchase_details (
    stock_id **VARCHAR(50)** **NOT NULL**, -- Arreglado vatchar a VARCHAR
    purchase_id **VARCHAR(50)** **NOT NULL**,
    price DECIMAL(10, 4) **NOT NULL**,
    amount INTEGER **NOT NULL**,
    PRIMARY KEY (stock_id, purchase_id),
    CONSTRAINT fk_purchase_details_stock FOREIGN KEY (stock_id) REFERENCES stocks(id),
    CONSTRAINT fk_purchase_details_purchase FOREIGN KEY (purchase_id) REFERENCES purchases(id)
);

---

-- Tabla sale_details
CREATE TABLE sale_details (
    stock_id **VARCHAR(50)** **NOT NULL**,
    sale_id **VARCHAR(50)** **NOT NULL**,
    amount INTEGER **NOT NULL**,
    price DECIMAL(10, 2) **NOT NULL**,
    PRIMARY KEY (stock_id, sale_id),
    CONSTRAINT fk_sale_details_stock FOREIGN KEY (stock_id) REFERENCES stocks(id),
    CONSTRAINT fk_sale_details_sale FOREIGN KEY (sale_id) REFERENCES sales(id)
);

---

-- Tabla at_asides_details
CREATE TABLE at_asides_details (
    at_aside_id **VARCHAR(50)** **NOT NULL**,
    stock_id **VARCHAR(50)** **NOT NULL**,
    amount INTEGER **NOT NULL**,
    price DECIMAL(10, 2) **NOT NULL**,
    PRIMARY KEY (at_aside_id, stock_id),
    CONSTRAINT fk_at_asides_details_at_aside FOREIGN KEY (at_aside_id) REFERENCES at_asides(id),
    CONSTRAINT fk_at_asides_details_stock FOREIGN KEY (stock_id) REFERENCES stocks(id)
);

---

-- Tabla coins
CREATE TABLE coins (
    id **BIGSERIAL** PRIMARY KEY,
    coin VARCHAR(50) UNIQUE **NOT NULL**,
    symbol CHAR(5) UNIQUE **NOT NULL**,
    is_reference_currency BOOLEAN **DEFAULT FALSE**
);

---

-- Tabla payment_methods
CREATE TABLE payment_methods (
    id **BIGSERIAL** PRIMARY KEY,
    coin_id **BIGINT** **NOT NULL**,
    method VARCHAR(50) UNIQUE **NOT NULL**,
    is_electronic BOOLEAN **DEFAULT FALSE**,
    CONSTRAINT fk_payment_methods_coin FOREIGN KEY (coin_id) REFERENCES coins(id)
);

---

-- Tabla purchase_payments
CREATE TABLE purchase_payments (
    id **VARCHAR(50)** **NOT NULL**, -- Removido PK compuesta, usando sólo 'id'
    purchase_id **VARCHAR(50)** **NOT NULL**,
    payment_method_id **BIGINT** **NOT NULL**,
    amount DECIMAL(10, 4) **NOT NULL**,
    exchange_rate DECIMAL(10, 4) **NOT NULL**,
    reference VARCHAR(100),
    paid_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    PRIMARY KEY (id),
    CONSTRAINT fk_purchase_payments_purchase FOREIGN KEY (purchase_id) REFERENCES purchases(id),
    CONSTRAINT fk_purchase_payments_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

---

-- Tabla sale_payments
CREATE TABLE sale_payments (
    id **VARCHAR(50)** PRIMARY KEY,
    sale_id **VARCHAR(50)** **NOT NULL**,
    payment_method_id **BIGINT** **NOT NULL**, -- Corregido 'pyment_method_id' a 'payment_method_id'
    amount DECIMAL(10, 4) **NOT NULL**,
    exchange_rate DECIMAL(10, 4) **NOT NULL**,
    reference VARCHAR(100),
    paid_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    CONSTRAINT fk_sale_payments_sale FOREIGN KEY (sale_id) REFERENCES sales(id),
    CONSTRAINT fk_sale_payments_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

---

-- Tabla at_aside_payments
CREATE TABLE at_aside_payments (
    id **VARCHAR(50)** PRIMARY KEY,
    at_aside_id **VARCHAR(50)** **NOT NULL**,
    payment_method_id **BIGINT** **NOT NULL**,
    amount DECIMAL(10, 4) **NOT NULL**,
    exchange_rate DECIMAL(10, 4) **NOT NULL**,
    reference VARCHAR(100),
    paid_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    CONSTRAINT fk_at_aside_payments_at_aside FOREIGN KEY (at_aside_id) REFERENCES at_asides(id),
    CONSTRAINT fk_at_aside_payments_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

---

-- Tabla credit_payments
CREATE TABLE credit_payments (
    id **VARCHAR(50)** PRIMARY KEY,
    credit_id **VARCHAR(50)** **NOT NULL**,
    payment_method_id **BIGINT** **NOT NULL**,
    amount DECIMAL(10, 4) **NOT NULL**,
    exchange_rate DECIMAL(10, 4) **NOT NULL**,
    reference VARCHAR(100),
    paid_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    CONSTRAINT fk_credit_payments_credit FOREIGN KEY (credit_id) REFERENCES credits(id),
    CONSTRAINT fk_credit_payments_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

---

-- Tabla tags
CREATE TABLE tags (
    id **BIGSERIAL** PRIMARY KEY,
    tag VARCHAR(50) UNIQUE **NOT NULL**
);

---

-- Tabla hashtag (muchos a muchos entre variants y tags)
CREATE TABLE hashtag (
    variant_id **VARCHAR(50)** **NOT NULL**,
    tag_id **BIGINT** **NOT NULL**,
    PRIMARY KEY (variant_id, tag_id),
    CONSTRAINT fk_hashtag_variant FOREIGN KEY (variant_id) REFERENCES variants(id),
    CONSTRAINT fk_hashtag_tag FOREIGN KEY (tag_id) REFERENCES tags(id)
);

---

-- Tabla transaction_types
CREATE TABLE transaction_types (
    id **BIGSERIAL** PRIMARY KEY,
    type_name VARCHAR(50) UNIQUE **NOT NULL**,
    is_income BOOLEAN **NOT NULL**
);

---

-- Tabla financial_transactions
CREATE TABLE financial_transactions (
    id **BIGSERIAL** PRIMARY KEY,
    type_id **BIGINT** **NOT NULL**,
    user_id **BIGINT** **NOT NULL**,
    method_id **BIGINT** **NOT NULL**,
    amount DECIMAL(10, 4) **NOT NULL**,
    description VARCHAR(255),
    reference VARCHAR(100),
    date_at TIMESTAMP WITHOUT TIME ZONE **DEFAULT NOW()**,
    CONSTRAINT fk_financial_transactions_type FOREIGN KEY (type_id) REFERENCES transaction_types(id),
    CONSTRAINT fk_financial_transactions_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_financial_transactions_method FOREIGN KEY (method_id) REFERENCES payment_methods(id)
);

---

-- Tabla discount_target (muchos a muchos/asociación)
CREATE TABLE discount_target (
    discount_id **BIGINT** **NOT NULL**,
    target_type VARCHAR(50) **NOT NULL**, -- ej. 'product', 'brand', 'garment'
    target_id VARCHAR(50) **NOT NULL**,
    PRIMARY KEY (discount_id, target_type, target_id),
    CONSTRAINT fk_discount_target_discount FOREIGN KEY (discount_id) REFERENCES discounts(id)
);