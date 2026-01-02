export abstract class AppError extends Error {
    public abstract readonly statusCode: number;

    constructor(message: string) {
        super(message);
        Object.setPrototypeOf(this, AppError.prototype);
    }
}