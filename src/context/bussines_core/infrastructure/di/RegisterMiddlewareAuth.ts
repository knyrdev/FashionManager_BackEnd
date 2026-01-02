import { ContainerBuilder, Reference } from "node-dependency-injection";

import { JwtAuthServices } from "@shared/infraestructure/services/JwtAuthServices";
import { AuthMiddelware } from "@shared/infraestructure/http/middlewares/AuthMiddelware";

export function RegisterMiddlewareAuth(container: ContainerBuilder): ContainerBuilder {
    container.
        register('AuthServices', JwtAuthServices);

    container
        .register('AuthMiddleware', AuthMiddelware)
        .addArgument(new Reference('AuthServices'));
    return container;
}