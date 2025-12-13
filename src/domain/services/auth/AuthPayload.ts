export interface AuthPayload {
    tenantId: string;
    userId: number;
    personalId: number;
    roleId: number;
    username: string;
}

export interface AuthResponse {
    accessToken: string;
    refreshToken: string;
}