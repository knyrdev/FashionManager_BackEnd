import { User } from "./User";

export interface UserRepository {
  save(user: User): Promise<User>;
  findById(id: number): Promise<User | null>;
  findByUsername(username: string): Promise<User | null>;
}