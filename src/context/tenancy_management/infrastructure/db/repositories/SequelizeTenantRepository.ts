import { TenantRepository } from "../../../domain/entities/tenant/TenantRepository";
import { Tenant } from "../../../domain/entities/tenant/Tenant";

import { TenantModel } from "../models/TenantModel";

export class SequelizeTenantRepository implements TenantRepository {
    async create(tenant: Tenant): Promise<void> {
        await TenantModel.create({
            name: tenant.name,
            status: tenant.status,
            plan_id: tenant.planId,
            dbConnectionData: tenant.dbConnectionData,
            current_schema_version: tenant.currentSchemaVersion
        });  
    }

    async findById(id: string): Promise<Tenant | null> {
        const tenantModel = await TenantModel.findByPk(id);
        if (!tenantModel) return null;
        return this.toDomain(tenantModel);
    }

    async findByName(name: string): Promise<Tenant | null> {
        const tenantModel = await TenantModel.findOne({ where: { name: name } });
        if (!tenantModel) return null;
        return this.toDomain(tenantModel);
    }
    
    async update(tenant: Tenant): Promise<void> {
        await TenantModel.update({
            name: tenant.name,
            status: tenant.status,
            plan_id: tenant.planId,
            dbConnectionData: tenant.dbConnectionData,
            current_schema_version: tenant.currentSchemaVersion,       
            updated_at: new Date()
        }, {
            where: { id: tenant.id }
        });
    }

    private toDomain(model: TenantModel): Tenant {
        return new Tenant(
            model.id,
            model.name,
            model.status,
            model.plan_id,
            model.db_connection_data,
            model.current_schema_version,
            model.created_at,
            model.updated_at
        );
    }
}