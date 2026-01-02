import * as jwt from "jsonwebtoken";

import { AuthService } from "../../domain/services/auth/AuthService";
import { AuthPayload, AuthResponse } from "../../domain/services/auth/AuthPayload";

import {
    JWT_SECRET,
    JWT_DAYS_EXPIRATION,
    JWT_HOURS_EXPIRATION,
    JWT_MINUTES_EXPIRATION,
    JWT_REFRESH_SECRET,
    JWT_REFRESH_DAYS_EXPIRATION,
    JWT_REFRESH_HOURS_EXPIRATION,
    JWT_REFRESH_MINUTES_EXPIRATION
} from "../../config";
export class JwtAuthServices implements AuthService {
    public generatedTokens(user: AuthPayload | null): AuthResponse {
        if (!user) {
            throw new Error("User not found");
        }
        const accessToken = jwt.sign(
            { ...user, iat: Math.floor(Date.now() / 1000), exp: Math.floor(Date.now() / 1000) + (Number(JWT_DAYS_EXPIRATION) * 86400) + (Number(JWT_HOURS_EXPIRATION) * 3600) + (Number(JWT_MINUTES_EXPIRATION) * 60) },
            JWT_SECRET,
        );
        const refreshToken = jwt.sign(
            { ...user, iat: Math.floor(Date.now() / 1000), exp: Math.floor(Date.now() / 1000) + (Number(JWT_REFRESH_DAYS_EXPIRATION) * 86400) + (Number(JWT_REFRESH_HOURS_EXPIRATION) * 3600) + (Number(JWT_REFRESH_MINUTES_EXPIRATION) * 60) },
            JWT_REFRESH_SECRET,
        );
        return { accessToken, refreshToken };
    }

    public verifyAccesToken(token: string): AuthPayload {
        try {
            const decoded = jwt.verify(token, JWT_SECRET);
            return {  sub: (decoded as any).sub, role: (decoded as any).role };
        } catch (error) {
            throw new Error("Invalid token");
        }
    }

    public verifyRefreshToken(token: string): AuthPayload {
        try {
            const decoded = jwt.verify(token, JWT_REFRESH_SECRET);
            return {  sub: (decoded as any).sub, role: (decoded as any).role };
        } catch (error) {
            throw new Error("Invalid token");
        }
    }
}