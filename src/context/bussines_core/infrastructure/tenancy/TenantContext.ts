import { Tenant } from '../../../tenancy_management/domain/entities/tenant/Tenant';

import { AsyncLocalStorage } from 'node:async_hooks';

// Almacén para aislar el Tenant por cada petición HTTP
const tenantStore = new AsyncLocalStorage<Tenant>();

export class TenantContext {

    /**
   * Inicializa el contexto del Tenant para la solicitud actual.
   * @param tenant La entidad Tenant ya cargada.
   * @param callback La función a ejecutar dentro de este contexto aislado.
   */
    public static run(tenant: Tenant, callback: () => void): void {
        tenantStore.run(tenant, callback);
    }

    /**
   * Obtiene la entidad Tenant del contexto de la solicitud actual.
   * @returns La entidad Tenant o null si no está definida.
   */
    public static get(): Tenant | null {
        return tenantStore.getStore() || null;
    }

    /**
   * Verifica si el contexto tiene un Tenant activo.
   */
    public static hasTenant(): boolean {
        return this.get() !== null;
    }
}