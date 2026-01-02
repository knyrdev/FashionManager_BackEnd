CREATE TYPE tenant_status AS ENUM ('ACTIVE', 'SUSPENDED', 'PROVISIONING', 'MAINTENANCE');
CREATE TYPE subscription_event_type AS ENUM ('SIGNUP', 'RENEWAL', 'UPGRADE', 'PAYMENT_FAILED');

-- 1. Tabla de Planes de Suscripción
CREATE TABLE plans (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    max_users INTEGER NOT NULL,
    max_storage_mb INTEGER NOT NULL,
    price_monthly DECIMAL(10, 4) NOT NULL,
    features JSONB, -- Almacenamos características adicionales en formato JSON
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla de Inquilinos (Tenants)
CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Usamos UUID por seguridad en SaaS
    name VARCHAR(255) NOT NULL,
    status tenant_status NOT NULL DEFAULT 'PROVISIONING',
    plan_id BIGINT NOT NULL,
    db_connection_data JSONB, 
    current_schema_version VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (plan_id) REFERENCES plans (id)
);

-- 3. Tabla de Métricas de Inquilinos
CREATE TABLE tenant_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    metric_type VARCHAR(100) NOT NULL, -- ej: "db_size", "request_count"
    value DECIMAL(10, 4) NOT NULL,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants (id)
);

-- 4. Tabla de Log de Suscripciones (Historial)
CREATE TABLE subscriptions_logs ( 
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    event subscription_event_type NOT NULL,
    amount DECIMAL(10, 4) NOT NULL,
    next_billing_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants (id)
);

INSERT INTO plans (name, max_users, max_storage_mb, price_monthly, features) VALUES
('Basic', 5, 512, 50.0000, '{"api_access": true, "custom_reports": true, "support": "community"}'),
('Fiscal', 10, 10240, 80.0000, '{"api_access": true, "custom_reports": true, "support": "email"}'),
('Enterprise', 100, 102400, 149.9900, '{"api_access": true, "custom_reports": true, "support": "24/7 phone"}')
ON CONFLICT DO NOTHING;

INSERT INTO tenants (name, plan_id, db_connection_data, current_schema_version) VALUES
('RIVERS', (SELECT id FROM plans WHERE name = 'Basic'), '{"dbHost": "pstg-business", "dbPort": 5432, "dbName": "fashion_manager_business", "dbUser": "postgres", "dbPass": "postgres", "dbDialect": "postgres"}', 'v1.0.0'),
('Tenant B', (SELECT id FROM plans WHERE name = 'Fiscal'), '{"dbHost": "localhost", "dbPort": 5433, "dbName": "fashion_manager_business", "dbUser": "postgres", "dbPass": "postgres"}', 'v1.0.0'),
('Tenant C', (SELECT id FROM plans WHERE name = 'Enterprise'), '{"dbHost": "localhost", "dbPort": 5433, "dbName": "fashion_manager_business", "dbUser": "postgres", "dbPass": "postgres"}', 'v1.0.0')

SELECT * FROM tenants WHERE name = 'RIVERS';
