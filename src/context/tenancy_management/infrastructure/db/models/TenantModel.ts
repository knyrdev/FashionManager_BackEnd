import { DataTypes, Model } from 'sequelize';
import { sequelize } from '../database';

import { TenantStatus } from '../../../domain/types/TenantStatus';
import { TenantConnectionData } from "../../../domain/value-objects/TenantConectionData";

export class TenantModel extends Model {
    public id!: string;
    public name!: string;
    public status!: TenantStatus;
    public plan_id!: number;
    public db_connection_data!: TenantConnectionData;
    public current_schema_version!: string;
    public created_at!: Date;
    public updated_at!: Date;
}

TenantModel.init(
    {
        id: {
            type: DataTypes.STRING,
            primaryKey: true,
        },
        name: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        status: {
            type: DataTypes.ENUM(...Object.values(TenantStatus)),
            allowNull: false,
            defaultValue: TenantStatus.PROVISIONING
        },
        plan_id: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },
        db_connection_data: {
            type: DataTypes.JSONB,
            allowNull: false,
        },
        current_schema_version: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        created_at: {
            type: DataTypes.DATE,
            allowNull: false,
            defaultValue: DataTypes.NOW
        },
        updated_at: {
            type: DataTypes.DATE,
            allowNull: false,
            defaultValue: DataTypes.NOW
        }
    },
    {
        sequelize,
        tableName: 'tenants',
        modelName: 'Tenant',
        timestamps: false
    }
);

export default TenantModel;