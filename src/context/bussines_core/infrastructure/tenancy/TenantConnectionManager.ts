import { Sequelize } from "sequelize";

import { LRUCache} from "lru-cache";

import { TenantContext } from "./TenantContext";
import { initModels } from "../db/sequelize-pg/model";

interface TenantInstance {
    sequelize: Sequelize;
    models: { [key: string]: any };
}

export class TenantConnectionManager {
    //Almacén Estático de conexiones por tenant
    private static connections = new LRUCache<string, TenantInstance>({
        max: 100,
        ttl: 1000 * 60 * 10, // 10 minutos
        dispose: (tenantId) => {
            tenantId.sequelize.close();
        },
        updateAgeOnGet: true,
    });

    /**
   * Obtiene la instancia de Sequelize para el Tenant de la petición actual.
   * Si no existe, crea una nueva conexión y la cachea.
   */
    public getConnection(): TenantInstance | undefined {
        const tenant = TenantContext.get();

        if (!tenant) {
            throw new Error("Tenant context not set.");
        }

        const {id: tenantId, dbConnectionData} = tenant;
        // Verificar si ya existe una conexión para este tenant
        if (TenantConnectionManager.connections.get(tenantId)) {
            return TenantConnectionManager.connections.get(tenantId);
        }else{  
            try {
                // Usar la configuración específica del tenant
                const sequelize = new Sequelize(dbConnectionData.dbName, dbConnectionData.dbUser, dbConnectionData.dbPass,
                {
                    host: dbConnectionData.dbHost,
                    port: Number(dbConnectionData.dbPort),
                    dialect: dbConnectionData.dbDialect as any,
                    pool:{
                        max: 3,
                        min: 0,
                        idle: 10000,
                        acquire: 30000
                    },
                    logging: false
                });
                TenantConnectionManager.connections.set(tenantId, { sequelize, models: initModels(sequelize) });
                return TenantConnectionManager.connections.get(tenantId);
            }catch (err) {
                console.error(`Error al conectar a la DB del Tenant ${tenantId}:`, err);
                throw new Error('Database connection failed for tenant.');
            }
        }
    }
}