import { AppError } from "./AppError";

export abstract class UnauthorizedError extends AppError {
    public readonly statusCode = 401;
}

export abstract class ConflicError extends AppError {
    public readonly statusCode = 409;
}

export abstract class NotFoundError extends AppError {
    public readonly statusCode = 404;
}
