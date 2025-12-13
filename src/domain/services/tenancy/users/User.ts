export class User {
    readonly id: Number;
    readonly tenantId: string;
    readonly userId: Number;
    readonly username: string;
    readonly password: string
    
    constructor(
        id: Number,
        tenantId: string,
        userId: Number,
        username: string,
        password: string
    ) {
        this.id = id;
        this.tenantId = tenantId;
        this.userId = userId;
        this.username = username;
        this.password = password;
    }

    static create(
        id: Number,
        tenantId: string,
        userId: Number,
        username: string,
        password: string
    ): User {
        return new User(id, tenantId, userId, username, password);
    }
}