import { Tenant } from "../../../domain/tenant/Tenant";
import { TenantRepository } from "../../../domain/tenant/TenantRepository";
import { TenantModel } from "./TenantModel";

export class SequelizeTenantRepository implements TenantRepository {
    async create(tenant: Tenant): Promise<void> {
        await TenantModel.create({
            id: tenant.id,
            status: tenant.status,
            db_name: tenant.dbName,
            db_host: tenant.dbHost,
            db_port: tenant.dbPort,
            db_user: tenant.dbUser,
            db_pass: tenant.dbPass,
            db_dialect: tenant.dbDialect,
            db_sync: tenant.dbSync
        });
    }

    async findById(id: string): Promise<Tenant | null> {
        const tenantModel = await TenantModel.findByPk(id);
        if (!tenantModel) return null;
        return this.toDomain(tenantModel);
    }

    async findByDbName(dbname: string): Promise<Tenant | null> {
        const tenantModel = await TenantModel.findOne({ where: { db_name: dbname } });
        if (!tenantModel) return null;
        return this.toDomain(tenantModel);
    }

    async findByDbStatus(status: boolean): Promise<Tenant[]> {
        const tenantModels = await TenantModel.findAll({ where: { status: status } });
        return tenantModels.map(model => this.toDomain(model));
    }

    async findAll(): Promise<Tenant[]> {
        const tenantModels = await TenantModel.findAll();
        return tenantModels.map(model => this.toDomain(model));
    }

    async update(tenant: Tenant): Promise<void> {
        await TenantModel.update({
            status: tenant.status,
            db_name: tenant.dbName,
            db_host: tenant.dbHost,
            db_port: tenant.dbPort,
            db_user: tenant.dbUser,
            db_pass: tenant.dbPass,
            db_dialect: tenant.dbDialect,
            db_sync: tenant.dbSync
        }, {
            where: { id: tenant.id }
        });
    }

    private toDomain(model: TenantModel): Tenant {
        return new Tenant(
            model.id,
            model.status,
            model.db_host,
            model.db_port,
            model.db_name,
            model.db_user,
            model.db_pass,
            model.db_dialect,
            model.db_sync
        );
    }
}