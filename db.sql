-- Tabla entities
CREATE TABLE entities (
  id BIGSERIAL PRIMARY KEY,
  type CHAR(1) NOT NULL, -- 'C' para Cliente, 'S' para Suplidor, 'P' para Personal
  document_type VARCHAR(20),
  document_number VARCHAR(50) UNIQUE,
  nick_name VARCHAR(100),
  phone VARCHAR(20),
  email VARCHAR(100) UNIQUE,
  address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  update_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla physical_persons
CREATE TABLE physical_persons (
  id BIGSERIAL PRIMARY KEY,
  entity_id BIGINT UNIQUE NOT NULL,
  name1 VARCHAR(50) NOT NULL,
  name2 VARCHAR(50),
  last_name1 VARCHAR(50) NOT NULL,
  last_name2 VARCHAR(50),
  birth_date DATE,
  CONSTRAINT fk_physical_persons_entity_id FOREIGN KEY (entity_id) REFERENCES entities(id)
);

-- Tabla personnel
CREATE TABLE personnel (
  id BIGSERIAL PRIMARY KEY,
  entity_id BIGINT UNIQUE NOT NULL,
  burden VARCHAR(100), -- Cargo/Puesto
  status BOOLEAN DEFAULT TRUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_personnel_entity_id FOREIGN KEY (entity_id) REFERENCES entities(id)
);

-- Tabla roles
CREATE TABLE roles (
  id BIGSERIAL PRIMARY KEY,
  role_name VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla users
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  personal_id BIGINT UNIQUE NOT NULL,
  role_id BIGINT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_personal_id FOREIGN KEY (personal_id) REFERENCES personnel(id),
  CONSTRAINT fk_users_role_id FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- Tabla audit_logs
CREATE TABLE audit_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT,
  table_name VARCHAR(50) NOT NULL,
  record_id VARCHAR(50) NOT NULL,
  action_type VARCHAR(10) NOT NULL,
  old_data JSONB,
  new_data JSONB,
  logged_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_audit_logs_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tabla suppliers
CREATE TABLE suppliers (
  id BIGSERIAL PRIMARY KEY,
  entity_id BIGINT UNIQUE NOT NULL, -- Se ajustó a BIGINT para coincidir con entities.id
  last_purchase TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_suppliers_entity_id FOREIGN KEY (entity_id) REFERENCES entities(id)
);

-- Tabla purchases
CREATE TABLE purchases (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  fiscal_control VARCHAR(100),
  supplier_id BIGINT NOT NULL, -- Se ajustó a BIGINT para ser consistente con suppliers.id
  user_id BIGINT NOT NULL, -- Se ajustó a BIGINT para ser consistente con users.id
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_purchases_supplier_id FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
  CONSTRAINT fk_purchases_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tabla clients
CREATE TABLE clients (
  id BIGSERIAL PRIMARY KEY,
  entity_id BIGINT UNIQUE NOT NULL,
  balance DECIMAL(10, 4) DEFAULT 0.0000,
  tastes_vector JSONB,
  last_purchase TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_clients_entity_id FOREIGN KEY (entity_id) REFERENCES entities(id)
);

-- Tabla sales
CREATE TABLE sales (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  fiscal_control VARCHAR(100),
  client_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  type VARCHAR(50), -- Ej. 'REGULAR', 'LAYAWAY'
  discount_id BIGINT,
  discount_percentage DECIMAL(5, 2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Se ajustó a TIMESTAMP
  CONSTRAINT fk_sales_client_id FOREIGN KEY (client_id) REFERENCES clients(id),
  CONSTRAINT fk_sales_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_sales_discount_id FOREIGN KEY (discount_id) REFERENCES discounts(id)
);

-- Tabla credits
CREATE TABLE credits (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  sale_id VARCHAR(50) UNIQUE NOT NULL,
  due_amount DECIMAL(10, 4) NOT NULL,
  interes_rate INTEGER DEFAULT 0,
  due_date TIMESTAMP WITH TIME ZONE NOT NULL,
  status VARCHAR(20) NOT NULL, -- Ej. 'PENDING', 'PAID', 'OVERDUE'
  CONSTRAINT fk_credits_sale_id FOREIGN KEY (sale_id) REFERENCES sales(id)
);

-- Tabla at_asides (Apartados/Layaways)
CREATE TABLE at_asides (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  user_id BIGINT NOT NULL,
  sale_id VARCHAR(50), -- Puede estar NULL hasta que se complete la venta
  client_id BIGINT NOT NULL,
  status VARCHAR(20) NOT NULL, -- Ej. 'PENDING', 'COMPLETE', 'CANCELLED'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_at_asides_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_at_asides_sale_id FOREIGN KEY (sale_id) REFERENCES sales(id),
  CONSTRAINT fk_at_asides_client_id FOREIGN KEY (client_id) REFERENCES clients(id)
);

-- Tabla stores
CREATE TABLE stores (
  id SERIAL PRIMARY KEY, -- Se ajustó a SERIAL para INTEGER PK
  store VARCHAR(100) NOT NULL,
  address TEXT
);

-- Tabla garments
CREATE TABLE garments (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial, Ej. SKU prefijo
  garment VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  update_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla brands
CREATE TABLE brands (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  brand VARCHAR(100) UNIQUE NOT NULL,
  gender CHAR(1), -- 'M', 'F', 'U'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla type_sizes
CREATE TABLE type_sizes (
  id BIGSERIAL PRIMARY KEY,
  category VARCHAR(50) NOT NULL, -- Se corrigió 'varhcar' a 'VARCHAR'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla sizes
CREATE TABLE sizes (
  id BIGSERIAL PRIMARY KEY,
  type_size_id BIGINT NOT NULL,
  size VARCHAR(20) NOT NULL,
  CONSTRAINT fk_sizes_type_size_id FOREIGN KEY (type_size_id) REFERENCES type_sizes(id)
);

-- Tabla products
CREATE TABLE products (
  id VARCHAR(50) PRIMARY KEY, -- SKU base
  garment_id VARCHAR(50) NOT NULL,
  brand_id VARCHAR(50) NOT NULL,
  type_size_id BIGINT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_garment_id FOREIGN KEY (garment_id) REFERENCES garments(id),
  CONSTRAINT fk_products_brand_id FOREIGN KEY (brand_id) REFERENCES brands(id),
  CONSTRAINT fk_products_type_size_id FOREIGN KEY (type_size_id) REFERENCES type_sizes(id)
);

-- Tabla models
CREATE TABLE models (
  id VARCHAR(50) PRIMARY KEY, -- SKU del modelo
  product_id VARCHAR(50) NOT NULL,
  model VARCHAR(100) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_models_product_id FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Tabla variants
CREATE TABLE variants (
  id VARCHAR(50) PRIMARY KEY, -- SKU de la variante (ej. con color/material)
  model_id VARCHAR(50) NOT NULL,
  feature VARCHAR(100), -- Ej. Color, Material
  url_image VARCHAR(255),
  price DECIMAL(10, 2) NOT NULL,
  CONSTRAINT fk_variants_model_id FOREIGN KEY (model_id) REFERENCES models(id)
);

-- Tabla stocks
CREATE TABLE stocks (
  id VARCHAR(50) PRIMARY KEY, -- SKU de Stock (Variante + Talla + Tienda)
  size_id BIGINT NOT NULL,
  variant_id VARCHAR(50) NOT NULL,
  store_id INTEGER NOT NULL, -- Se ajustó a INTEGER para stores.id
  amount INTEGER NOT NULL DEFAULT 0,
  CONSTRAINT fk_stocks_size_id FOREIGN KEY (size_id) REFERENCES sizes(id),
  CONSTRAINT fk_stocks_variant_id FOREIGN KEY (variant_id) REFERENCES variants(id),
  CONSTRAINT fk_stocks_store_id FOREIGN KEY (store_id) REFERENCES stores(id)
);

-- Tabla sale_details
CREATE TABLE sale_details (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  stock_id VARCHAR(50) NOT NULL,
  sale_id VARCHAR(50) NOT NULL,
  amount INTEGER NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  CONSTRAINT fk_sale_details_stock_id FOREIGN KEY (stock_id) REFERENCES stocks(id),
  CONSTRAINT fk_sale_details_sale_id FOREIGN KEY (sale_id) REFERENCES sales(id)
);

-- Tabla returns
CREATE TABLE returns (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  sale_detail_id VARCHAR(50) NOT NULL,
  amount INTEGER NOT NULL,
  reason VARCHAR(255),
  payment_method_id BIGINT, -- Se agregará FK más adelante, después de payment_methods
  status BOOLEAN DEFAULT FALSE NOT NULL,
  return_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Corregir nombre de columna
  CONSTRAINT fk_returns_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_returns_sale_detail_id FOREIGN KEY (sale_detail_id) REFERENCES sale_details(id)
);

-- Tabla at_asides_details
CREATE TABLE at_asides_details (
  at_aside_id VARCHAR(50) NOT NULL,
  stock_id VARCHAR(50) NOT NULL,
  amount INTEGER NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (at_aside_id, stock_id),
  CONSTRAINT fk_at_asides_details_at_aside_id FOREIGN KEY (at_aside_id) REFERENCES at_asides(id),
  CONSTRAINT fk_at_asides_details_stock_id FOREIGN KEY (stock_id) REFERENCES stocks(id)
);

-- Tabla purchase_details
CREATE TABLE purchase_details (
  stock_id VARCHAR(50) NOT NULL, -- Se corrigió 'vatchar' a 'VARCHAR'
  purchase_id VARCHAR(50) NOT NULL,
  price DECIMAL(10, 4) NOT NULL,
  amount INTEGER NOT NULL,
  PRIMARY KEY (stock_id, purchase_id),
  CONSTRAINT fk_purchase_details_stock_id FOREIGN KEY (stock_id) REFERENCES stocks(id),
  CONSTRAINT fk_purchase_details_purchase_id FOREIGN KEY (purchase_id) REFERENCES purchases(id)
);

-- Tabla coins
CREATE TABLE coins (
  id BIGSERIAL PRIMARY KEY,
  coin VARCHAR(50) NOT NULL,
  symbol CHAR(3) NOT NULL,
  is_reference_currency BOOLEAN DEFAULT FALSE NOT NULL
);  

-- Tabla payment_methods
CREATE TABLE payment_methods (
  id BIGSERIAL PRIMARY KEY,
  coin_id BIGINT NOT NULL,
  method VARCHAR(50) NOT NULL,
  is_electronic BOOLEAN DEFAULT FALSE NOT NULL,
  CONSTRAINT fk_payment_methods_coin_id FOREIGN KEY (coin_id) REFERENCES coins(id)
);

-- Añadir FK faltante a la tabla returns
ALTER TABLE returns
ADD CONSTRAINT fk_returns_payment_method_id
FOREIGN KEY (payment_method_id)
REFERENCES payment_methods(id);


-- Tabla purchase_payments
CREATE TABLE purchase_payments (
  id VARCHAR(50) NOT NULL, -- Se asume un ID para el pago
  purchase_id VARCHAR(50) NOT NULL,
  payment_method_id BIGINT NOT NULL,
  amount DECIMAL(10, 4) NOT NULL,
  exchange_rate DECIMAL(10, 4) NOT NULL,
  reference VARCHAR(100),
  paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id, purchase_id, payment_method_id), -- Clave primaria compuesta más completa
  CONSTRAINT fk_purchase_payments_purchase_id FOREIGN KEY (purchase_id) REFERENCES purchases(id),
  CONSTRAINT fk_purchase_payments_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

-- Tabla sale_payments
CREATE TABLE sale_payments (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  sale_id VARCHAR(50) NOT NULL,
  pyment_method_id BIGINT NOT NULL, -- Se corrigió a payment_method_id
  amount DECIMAL(10, 4) NOT NULL,
  exchange_rate DECIMAL(10, 4) NOT NULL,
  reference VARCHAR(100),
  paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sale_payments_sale_id FOREIGN KEY (sale_id) REFERENCES sales(id),
  CONSTRAINT fk_sale_payments_payment_method_id FOREIGN KEY (pyment_method_id) REFERENCES payment_methods(id)
);

-- Tabla at_aside_payments
CREATE TABLE at_aside_payments (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  at_aside_id VARCHAR(50) NOT NULL,
  payment_method_id BIGINT NOT NULL,
  amount DECIMAL(10, 4) NOT NULL,
  exchange_rate DECIMAL(10, 4) NOT NULL,
  reference VARCHAR(100),
  paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_at_aside_payments_at_aside_id FOREIGN KEY (at_aside_id) REFERENCES at_asides(id),
  CONSTRAINT fk_at_aside_payments_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

-- Tabla credit_payments
CREATE TABLE credit_payments (
  id VARCHAR(50) PRIMARY KEY, -- Se asume un ID no secuencial
  credit_id VARCHAR(50) NOT NULL,
  payment_method_id BIGINT NOT NULL,
  amount DECIMAL(10, 4) NOT NULL,
  exchange_rate DECIMAL(10, 4) NOT NULL,
  reference VARCHAR(100),
  paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_credit_payments_credit_id FOREIGN KEY (credit_id) REFERENCES credits(id),
  CONSTRAINT fk_credit_payments_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

-- Tabla tags
CREATE TABLE tags (
  id BIGSERIAL PRIMARY KEY,
  tag VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla hashtag
CREATE TABLE hashtags (
  variant_id VARCHAR(50) NOT NULL,
  tag_id BIGINT NOT NULL,
  PRIMARY KEY (variant_id, tag_id),
  CONSTRAINT fk_hashtag_variant_id FOREIGN KEY (variant_id) REFERENCES variants(id),
  CONSTRAINT fk_hashtag_tag_id FOREIGN KEY (tag_id) REFERENCES tags(id)
);

-- Tabla transaction_types
CREATE TABLE transaction_types (
  id BIGSERIAL PRIMARY KEY,
  type_name VARCHAR(50) UNIQUE NOT NULL,
  is_income BOOLEAN DEFAULT FALSE NOT NULL
);

-- Tabla financial_transactions
CREATE TABLE financial_transactions (
  id BIGSERIAL PRIMARY KEY,
  type_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  method_id BIGINT,
  amount DECIMAL(10, 4) NOT NULL,
  description TEXT,
  reference VARCHAR(100),
  date_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_financial_transactions_type_id FOREIGN KEY (type_id) REFERENCES transaction_types(id),
  CONSTRAINT fk_financial_transactions_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_financial_transactions_method_id FOREIGN KEY (method_id) REFERENCES payment_methods(id)
);

-- Tabla discount_target
CREATE TABLE discount_target (
  discount_id BIGINT NOT NULL,
  target_type VARCHAR(50) NOT NULL, -- Ej. 'BRAND', 'GARMENT'
  target_id VARCHAR(50) NOT NULL,
  PRIMARY KEY (discount_id, target_type, target_id),
  CONSTRAINT fk_discount_target_discount_id FOREIGN KEY (discount_id) REFERENCES discounts(id)
);

-- Tabla discounts
CREATE TABLE discounts (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  percentage DECIMAL(5, 2) NOT NULL,
  start_date TIMESTAMP WITH TIME ZONE NOT NULL,
  end_date TIMESTAMP WITH TIME ZONE,
  is_active BOOLEAN DEFAULT TRUE NOT NULL,
  applie_to VARCHAR(50) -- Ej. 'ALL', 'GARMENT', 'BRAND'
);