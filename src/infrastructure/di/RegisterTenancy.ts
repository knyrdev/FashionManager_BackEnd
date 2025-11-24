import { ContainerBuilder } from 'node-dependency-injection';

import { TenantConnectionManager } from '../tenancy/TenantConnectionManager';
import { SequelizeTenantRepository } from '../db/tenant-db/SequelizeTenantRepository';
import { TenantMiddleware } from '../tenancy/TenantMiddelware';

import { DB_DIALECT, DB_HOST, DB_NAME, DB_PASSWORD, DB_PORT, DB_LOGGING,DB_SYNC, DB_USER } from '../../config';

export function RegisterTenancy(container: ContainerBuilder): void{
    // Configuración global de Sequelize
    const globalConfig = {
        dbName: DB_NAME,
        dbUser: DB_USER,
        dbPass: DB_PASSWORD,
        host: DB_HOST,
        port: DB_PORT ? Number(DB_PORT) : undefined,
        dialect: DB_DIALECT as any,
        logging: DB_LOGGING === 'true' ? console.log : false,
        sync: DB_SYNC === 'true' ? true : false,
    };
    container
        .setParameter('sequelize.global_config', globalConfig);

    // Registrar TenantConnectionManager con configuración global de DB
    container
        .register('TenantConnectionManager', TenantConnectionManager)
        .addArgument('%sequelize.global_config%');

    // Registrar TenantRepository
    container
        .register('TenantRepository', SequelizeTenantRepository);

    // Registrar TenantMiddleware
    container
        .register('TenantMiddleware', TenantMiddleware)
        .addArgument('@TenantRepository');
}