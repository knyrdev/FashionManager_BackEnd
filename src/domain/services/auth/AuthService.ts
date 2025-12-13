import { User } from "../../entities/user/User";
import { AuthPayload, AuthResponse} from "./AuthPayload";

export interface AuthService {
    generatedToken(user: AuthPayload | null): AuthResponse;
    refreshToken(token: string): AuthResponse;
    verifyToken(token: string): AuthPayload;
}