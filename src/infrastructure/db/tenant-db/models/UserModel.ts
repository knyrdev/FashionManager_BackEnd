import { TenantModel } from "./TenantModel"
import { DataTypes, Model, Sequelize } from "sequelize";

export class UserModel extends Model {
    public id!: number;
    public tenant_id!: string;
    public user_id!: number;

    public static initModel(sequelize: Sequelize): typeof UserModel {
        UserModel.init(
            {
                id: {
                    type: DataTypes.BIGINT,
                    primaryKey: true,
                    autoIncrement: true,
                },
                tenant_id: {
                    type: DataTypes.STRING,
                    allowNull: false,
                    references: {
                    model: TenantModel,
                    key: "id",
                    },
                },
                user_id: {
                    type: DataTypes.BIGINT,
                    allowNull: false,
                },
            },
            {
                sequelize,
                tableName: "users",
                timestamps: false,
            }
        );
        return UserModel;
    }
}