import { ContainerBuilder, Reference } from 'node-dependency-injection';

import { SequelizeTenantRepository } from '../../../tenancy_management/infrastructure/db/repositories/SequelizeTenantRepository';
import { TenantMiddleware } from '../http/middelware/TenantMiddelware';


export function RegisterMiddlewareTenancy(container: ContainerBuilder): ContainerBuilder{
    // Registrar TenantRepository
    container
        .register('TenantRepository', SequelizeTenantRepository);
    // Registrar TenantMiddleware
    container
        .register('TenantMiddleware', TenantMiddleware)
        .addArgument(new Reference('TenantRepository'));

    return container;
}