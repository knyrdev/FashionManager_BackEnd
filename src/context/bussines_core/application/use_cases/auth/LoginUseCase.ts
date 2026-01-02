import { UserRepository } from "../../../domain/entities/user/UserRepository";

import { InvalidCredentialsError } from "@shared/domain/errors/InvalidCredentialsError";
import { AuthResponse } from "@shared/domain/services/auth/AuthPayload";
import { AuthService } from "@shared/domain/services/auth/AuthService";

export class LoginUseCase {
    public UserRepository: UserRepository;
    public AuthService: AuthService;

    constructor(userRepository: UserRepository, authService: AuthService) {
        this.UserRepository = userRepository;
        this.AuthService = authService;
    }
    public async execute(username: string, password: string): Promise<AuthResponse> {
        const user = await this.UserRepository.findByUsername(username);
        if (!user) {
            throw new InvalidCredentialsError();
        }
        if (!await user.comparePassword(password)) {
            throw new InvalidCredentialsError();
        }
        const tokens = this.AuthService.generatedTokens({ sub: user.id, role: user.roleId });
        return tokens;
    }
}