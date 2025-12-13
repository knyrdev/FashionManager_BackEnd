import { ContainerBuilder, Reference } from "node-dependency-injection";

import { SequelizeUserRepository } from "../db/sequelize-pg/repositories/SequelizeUserRepository";

export function RegisterUser(container: ContainerBuilder): ContainerBuilder {
    // Registrar UserRepository
    container
        .register('user.repository', SequelizeUserRepository)
        .addArgument(new Reference('TenantConnectionManager'));
    return container;
}

