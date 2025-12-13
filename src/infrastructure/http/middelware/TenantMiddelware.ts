import {Request, Response, NextFunction} from 'express';
import {TenantRepository} from '../../../domain/services/tenancy/tenants/TenantRepository';
import {Tenant} from '../../../domain/services/tenancy/tenants/Tenant';
import {TenantContext} from '../../tenancy/TenantContext';  

export class TenantMiddleware {
    private repository: TenantRepository;
    private tenant: Tenant | null = null;

    constructor(repository: TenantRepository) {
        this.repository = repository;   
    }
    public handle = async (req: Request, res: Response, next: NextFunction) => {
        const tenantId = req.headers['x-tenant-id'] as string;
        if (!tenantId) {
            return res.status(400).send({message: 'Tenant ID is required'});
        }
        try {
            this.tenant = await this.repository.findById(tenantId);
        }catch (error) {
            console.error(error);
            return res.status(500).send({message: 'Error retrieving tenant information'});
        }
        console.log(this.tenant);
        if (!this.tenant) {
            return res.status(404).send({message: `Tenant ${tenantId} not found`});
        } 

        if (!this.tenant.isActive()) {
            return res.status(403).send({message: `Tenant ${tenantId} subscription is inactive.`});
        }
        TenantContext.run(this.tenant, next);
    }
}