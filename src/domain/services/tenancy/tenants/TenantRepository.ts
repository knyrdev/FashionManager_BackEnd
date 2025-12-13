import { Tenant } from './Tenant';

export interface TenantRepository {
    create(tenant: Tenant): Promise<void>;
    findById(id: string): Promise<Tenant | null>;
    update(tenant: Tenant): Promise<void>;
}