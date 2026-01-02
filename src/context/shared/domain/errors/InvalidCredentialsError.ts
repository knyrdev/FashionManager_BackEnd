import { ConflicError } from "./HttpErrors";

export class InvalidCredentialsError extends ConflicError {
    constructor(){
        super("Invalid credentials provided.");
    }
} 