import { ContainerBuilder, Reference } from "node-dependency-injection";

import { LoginUseCase } from "../../application/use_cases/auth/LoginUseCase";

export function RegisterLoginUseCase(container: ContainerBuilder): ContainerBuilder {
    container
        .register('LoginUseCase', LoginUseCase)
        .addArgument(new Reference('UserRepository'))
        .addArgument(new Reference('AuthService'));
    return container;
}