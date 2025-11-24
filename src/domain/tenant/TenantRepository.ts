import { Tenant } from './Tenant';

export interface TenantRepository {
    create(tenant: Tenant): Promise<void>;
    findById(id: string): Promise<Tenant | null>;
    findByDbName(dbname: string): Promise<Tenant | null>;
    findByDbStatus(status: boolean): Promise<Tenant[]>;
    findAll(): Promise<Tenant[]>;
    update(tenant: Tenant): Promise<void>;
}