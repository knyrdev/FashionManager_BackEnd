export interface AuthPayload {
    sub: number;
    role: number;
}

export interface AuthResponse {
    accessToken: string;
    refreshToken: string;
}