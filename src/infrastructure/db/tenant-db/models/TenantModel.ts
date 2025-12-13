import { DataTypes, Model } from 'sequelize';
import { sequelize } from './database';

export class TenantModel extends Model {
    public id!: string;
    public status!: boolean;
    public db_name!: string;
    public db_host!: string;
    public db_port!: string;
    public db_user!: string;
    public db_pass!: string;
    public db_dialect!: string;
    public db_sync!: boolean;
    public created_at!: Date;
    public updated_at!: Date;
}

TenantModel.init(
    {
        id: {
            type: DataTypes.STRING,
            primaryKey: true,
        },
        status: {
            type: DataTypes.BOOLEAN,
            allowNull: false,
            defaultValue: true
        },
        db_name: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        db_host: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        db_port: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        db_user: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        db_pass: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        db_dialect: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        db_sync: {
            type: DataTypes.BOOLEAN,
            allowNull: false,
            defaultValue: false
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