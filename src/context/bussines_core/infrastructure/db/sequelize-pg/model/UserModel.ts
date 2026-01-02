import { DataTypes, Model, Sequelize } from 'sequelize';

export class UserModel extends Model {
  public id!: number;
  public personnel_id!: number;
  public role_id!: number;
  public username!: string;
  public password!: string;

  public static initModel(sequelize: Sequelize): typeof UserModel {
    UserModel.init(
      {
        id: {
          type: DataTypes.BIGINT,
          autoIncrement: true,
          primaryKey: true,
        },
        personnel_id: {
          type: DataTypes.BIGINT,
          allowNull: false,
          unique: true,
        },
        role_id: {
          type: DataTypes.BIGINT,
          allowNull: false,
        },
        username: {
          type: DataTypes.STRING(50),
          allowNull: false,
          unique: true,
        },
        password: {
          type: DataTypes.STRING(255),
          allowNull: false,
        },
      },
      {
        sequelize,
        tableName: 'users',
        timestamps: true,
        createdAt: 'created_at',
        updatedAt: 'updated_at',
      }
    );
    return UserModel;
  }
  public static associate(models: { [key: string]: any }): void {
    UserModel.belongsTo(models.PersonnelModel, {
      foreignKey: 'personnel_id',
      as: 'personnel',
    });
    UserModel.belongsTo(models.RoleModel, {
      foreignKey: 'role_id',
      as: 'roles',
    });
  }
}