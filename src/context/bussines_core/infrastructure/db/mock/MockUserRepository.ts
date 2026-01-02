import { User } from "../../domain/entities/user/User";
import { UserRepository } from "../../domain/entities/user/UserRepository";

export class MockUserRepository implements UserRepository {
    private users: User[] = [];

    constructor(conectionManager: any) {
        this.initializeMockData();
    }

    private async initializeMockData(): Promise<void> {
        // Mock user 1: admin
        const adminUser = await User.create(
        1,
        1,
        1,
        "admin",
        "admin",
        new Date("2023-01-01"),
        new Date("2023-01-01")
        );

        // Mock user 2: regular user
        const regularUser = await User.create(
        2,
        2,
        2,
        "topo",
        "123",
        new Date("2023-01-02"),
        new Date("2023-01-02")
        );

        this.users.push(adminUser, regularUser);
    }

    async save(user: User): Promise<User> {
        // For mock, just add to the array if not exists, or update
        const existingIndex = this.users.findIndex(u => u.id === user.id);
        if (existingIndex >= 0) {
        this.users[existingIndex] = user;
        } else {
        this.users.push(user);
        }
        return user;
    }

    async findById(id: number): Promise<User | null> {
        return this.users.find(user => user.id === id) || null;
    }

    async findByUsername(username: string): Promise<User | null> {
        return this.users.find(user => user.username === username) || null;
    }
}