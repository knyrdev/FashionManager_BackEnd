import { SequelizeBaseRepository } from "./SequelizeBaseRepository";

import { User } from "../../../../domain/entities/user/User";
import { UserModel } from "../model/UserModel";
import { UserRepository } from "../../../../domain/entities/user/UserRepository";

export class SequelizeUserRepository extends SequelizeBaseRepository<User, typeof UserModel> implements UserRepository {

  protected getModel(models: any): typeof UserModel {
    return models.UserModel
  }

  async save(user: User): Promise<User> {
    const models = this.getModels();
    const Model = this.getModel(models);
    const newUser = await Model.create({
      personnel_id: user.personnelId,
      role_id: user.roleId,
      username: user.username,
      password: user.password,
    });
    return this.toDomain(newUser);
  } 
  
  async findById(id: number): Promise<User | null> {
    const models = this.getModels();
    const Model = this.getModel(models);
    const user = await Model.findByPk(id);
    if (!user) return null;
    return this.toDomain(user);
  }

  async findByUsername(username: string): Promise<User | null> {
    const models = this.getModels();
    const Model = this.getModel(models);
    const user = await Model.findOne({ where: { username } });
    if (!user) return null;
    return this.toDomain(user);
  } 
  
  protected toDomain(user: any): User {
    return new User(
      user.id,
      user.personal_id,
      user.role_id,
      user.username,
      user.password
    );
  }
}