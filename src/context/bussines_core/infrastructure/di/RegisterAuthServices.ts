import { ContainerBuilder, Reference } from "node-dependency-injection";

import { JwtAuthServices } from "@shared/infraestructure/services/JwtAuthServices";

export function RegisterAuthServices(container: ContainerBuilder): ContainerBuilder {
    container
        .register('AuthService', JwtAuthServices)
    return container;
}