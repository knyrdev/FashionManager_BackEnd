import { ContainerBuilder, Reference } from "node-dependency-injection";

import { TenantConnectionManager } from "../tenancy/TenantConnectionManager";

import { SequelizeUserRepository } from "../db/sequelize-pg/repositories/SequelizeUserRepository";

import { MockUserRepository} from "../mock/MockUserRepository";

export function RegisterRepositories(container: ContainerBuilder): ContainerBuilder {
    container
        .register('TenantConnectionManager', TenantConnectionManager);
    // User Repository
    container
        .register('UserRepository', MockUserRepository)
        .addArgument(new Reference('TenantConnectionManager'));
    return container;
}