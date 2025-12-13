import { User } from './User';

export interface UserRepository {
    create(users: User): Promise<void>;
    findByTenantAndUserId(tenantId: string, userId: Number): Promise<User | null>;
    findByTenantAndUsername(tenantId: string, username: string): Promise<User | null>;
    update(users: Partial<User>): Promise<User | null>;
}