import { User } from "../../../../domain/user/User";
import { UserRepository } from "../../../../domain/user/UserRepository";
import { UserModel } from "../model/UserModel";
import { TenantConnectionManager } from "../../../tenancy/TenantConnectionManager";

export class SequelizeUserRepository implements UserRepository {
  private connectionManager: TenantConnectionManager;

  constructor(connectionManager: TenantConnectionManager) {
    this.connectionManager = connectionManager;
  }

  private getModel() {
    const sequelize = this.connectionManager.getConnection();
    if (!sequelize) {
      throw new Error("No active tenant connection found");
    }
    
    return UserModel.initModel(sequelize);
  }

  async save(user: User): Promise<User> {
    const Model = this.getModel();
    const newUser = await Model.create({
      personal_id: user.personalId,
      role_id: user.roleId,
      username: user.username,
      password: user.password,
    });
    
    return new User(
      newUser.id,
      newUser.personal_id,
      newUser.role_id,
      newUser.username,
      newUser.password
    );
  }

  async findByUsername(username: string): Promise<User | null> {
    const Model = this.getModel();
    const user = await Model.findOne({ where: { username } });
    if (!user) return null;
    return new User(
      user.id,
      user.personal_id,
      user.role_id,
      user.username,
      user.password
    );
  }

  async findById(id: number): Promise<User | null> {
    const Model = this.getModel();
    const user = await Model.findByPk(id);
    if (!user) return null;
    return new User(
      user.id,
      user.personal_id,
      user.role_id,
      user.username,
      user.password
    );
  }
}