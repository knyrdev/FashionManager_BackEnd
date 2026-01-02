import { TenantConnectionData } from "../../value-objects/TenantConectionData";

import { TenantStatus } from "../../types/TenantStatus";

export class Tenant {
    readonly id: string;
    readonly name: string;
    readonly status: TenantStatus;
    readonly planId: number;
    readonly dbConnectionData: TenantConnectionData;
    readonly currentSchemaVersion?: string;
    readonly createdAt?: Date;
    readonly updatedAt?: Date;

    constructor(
        id: string,
        name: string,
        status: TenantStatus,
        planId: number,
        dbConnectionData: TenantConnectionData,
        currentSchemaVersion?: string,
        createdat?: Date,
        updatedat?: Date
    ) {
        this.id = id;
        this.status = status;
        this.name = name;
        this.planId = planId;
        this.dbConnectionData = dbConnectionData;
        this.currentSchemaVersion = currentSchemaVersion;
        this.createdAt = createdat;
        this.updatedAt = updatedat;
    }
    static create(
        id: string,
        status: TenantStatus,
        name: string,
        planId: number,
        dbConnectionData: TenantConnectionData,
        currentSchemaVersion?: string,
        createdat?: Date,
        updatedat?: Date
    ): Tenant {
        return new Tenant(id, name, status, planId, dbConnectionData, currentSchemaVersion, createdat, updatedat);
    }
    isActive(): TenantStatus {
        return this.status;
    }
}