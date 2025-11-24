import { User } from "./User";

export interface UserRepository {
  save(user: User): Promise<User>;
  findByUsername(username: string): Promise<User | null>;
  findById(id: number): Promise<User | null>;
}