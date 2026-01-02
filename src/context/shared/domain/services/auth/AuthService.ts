import { AuthPayload, AuthResponse} from "./AuthPayload";

export interface AuthService {
    generatedTokens(user: AuthPayload | null): AuthResponse;
    verifyAccesToken(token: string): AuthPayload;
    verifyRefreshToken(token: string): AuthPayload;
}