import { User } from "../../../domain/user/User";
import { UserRepository } from "../../../domain/user/UserRepository";

import bcrypt from 'bcryptjs';

import { SALT_ROUNDS } from "../../../config";

export class UserRegister {
  constructor(private readonly userRepository: UserRepository) {}

  async run(personalId: number, roleId: number, username: string, password?: string): Promise<User> {
    const existingUser = await this.userRepository.findByUsername(username);
    if (existingUser) {
      throw new Error("User already exists");
    }

    let hashedPassword;
    if (password) {
      hashedPassword = await bcrypt.hash(password, Number(SALT_ROUNDS));
    } else{
      throw new Error("Password is required");
    }

    const user = User.create(personalId, roleId, username, hashedPassword);
    return this.userRepository.save(user);
  }
}