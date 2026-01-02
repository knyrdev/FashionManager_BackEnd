import { TenantConnectionManager } from "../../../tenancy/TenantConnectionManager";
import { initModels } from "../model";

export abstract class SequelizeBaseRepository<T, M>{
    protected connectionManager: TenantConnectionManager;

    constructor(connectionManager: TenantConnectionManager) {
        this.connectionManager = connectionManager;
    }

    protected getModels(){
        return this.connectionManager.getConnection()?.models;
    }

    protected abstract getModel(models: ReturnType<typeof initModels>): M;

    protected abstract toDomain(model: M): T;
}