import { Sequelize } from "sequelize";

import { TenantContext } from "./TenantContext";

interface ConectionCache {
    [tenantId: string]: Sequelize;
}

export class TenantConnectionManager {
    //Almacén Estático de conexiones por tenant
    private static connections: ConectionCache = {};
    // Configuración global de la base de datos
    private readonly globalConfig: object;

    constructor(globalConfig: object) {
        this.globalConfig = globalConfig;
    }
    /**
   * Obtiene la instancia de Sequelize para el Tenant de la petición actual.
   * Si no existe, crea una nueva conexión y la cachea.
   */
    public getConnection(): Sequelize | undefined {
        const tenant = TenantContext.get();

        if (!tenant) {
            throw new Error("Tenant context not set. Request must pass through TenantMiddleware.");
        }

        const {id: tenantId, dbName, dbUser, dbPass, dbHost, dbPort, dbDialect} = tenant;
        // Verificar si ya existe una conexión para este tenant
        if (TenantConnectionManager.connections[tenantId]){
            return TenantConnectionManager.connections[tenantId];
        }else{
            try {
                // Usar la configuración específica del tenant
                const tenantDbConnection = new Sequelize(dbName, dbUser, dbPass, {
                    host: dbHost,
                    port: Number(dbPort),
                    dialect: dbDialect as any,
                    logging: false
                });
                
                TenantConnectionManager.connections[tenantId] = tenantDbConnection;
                return tenantDbConnection;
            }catch (err) {
                console.error(`Error al conectar a la DB del Tenant ${tenantId}:`, err);
                throw new Error('Database connection failed for tenant.');
            }
        }
    }
}