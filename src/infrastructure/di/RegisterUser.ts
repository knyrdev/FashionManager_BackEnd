import { ContainerBuilder } from "node-dependency-injection";

import { SequelizeUserRepository } from "../db/sequelize-pg/repositories/SequelizeUserRepository";

export function RegisterUser(container: ContainerBuilder): void {
    // Registrar UserRepository
    container
        .register('user.repository', SequelizeUserRepository)
        .addArgument('@TenantConnectionManager');

}

