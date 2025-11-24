import {Request, Response} from 'express';
import { Tenant } from '../../domain/tenant/Tenant';

import { AsyncLocalStorage } from 'node:async_hooks';

// Almacén para aislar el Tenant por cada petición HTTP
export const tenantStore = new AsyncLocalStorage<Tenant>();

/**
   * Inicializa el contexto del Tenant para la solicitud actual.
   * @param tenant La entidad Tenant ya cargada.
   * @param callback La función a ejecutar dentro de este contexto aislado.
   */
export class TenantContext {
    public static run(tenant: Tenant, callback: () => void):void {
        tenantStore.run(tenant, callback);
    }
}