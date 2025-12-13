export class Session {
    readonly id: string;
    readonly userId: string;
    readonly device: string;
    readonly refreshToken: string;
    readonly active: boolean;
    readonly createdAt?: Date;
    readonly updatedAt?: Date;

    constructor(
        id: string,
        userId: string,
        device: string,
        refreshToken: string,
        active: boolean,
        createdAt?: Date,
        updatedAt?: Date
    ) {
        this.id = id;
        this.userId = userId;
        this.device = device;
        this.refreshToken = refreshToken;
        this.active = active;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    static create(
        id: string,
        userId: string,
        device: string,
        refreshToken: string,
        active: boolean,
        createdAt?: Date,
        updatedAt?: Date
    ): Session {
        return new Session(id, userId, device, refreshToken, active, createdAt, updatedAt);
    }
}