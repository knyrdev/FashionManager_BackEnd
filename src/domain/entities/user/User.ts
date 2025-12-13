import bcrypt from 'bcryptjs';
import { SALT_ROUNDS } from "../../../config";

export class User {
  readonly id: number;
  readonly personalId: number;
  readonly roleId: number;
  readonly username: string;
  readonly password: string;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;

  constructor(
    id: number,
    personalId: number,
    roleId: number,
    username: string,
    password: string,
    createdAt?: Date,
    updatedAt?: Date
  ) {
    this.id = id;
    this.personalId = personalId;
    this.roleId = roleId;
    this.username = username;
    this.password = password;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  static async create(
    id: number,
    personalId: number,
    roleId: number,
    username: string,
    password: string,
    createdAt?: Date,
    updatedAt?: Date
  ): Promise < User > {
    const hashPassword = await bcrypt.hash(password, Number(SALT_ROUNDS));
    return new User(id, personalId, roleId, username, hashPassword, createdAt, updatedAt);
  }
  
  async comparePassword(password: string): Promise<boolean> {
    return bcrypt.compare(password, this.password);
  }
}