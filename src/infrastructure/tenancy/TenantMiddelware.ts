import {Request, Response, NextFunction} from 'express';
import {TenantRepository} from '../../domain/tenant/TenantRepository';
import {TenantContext} from './TenantContext';  

export class TenantMiddleware {
    private repository: TenantRepository;

    constructor(repository: TenantRepository) {
        this.repository = repository;
    }

    public handle = async (req: Request, res: Response, next: NextFunction) => {
        const tenantId = req.headers['x-tenant-id'] as string;
        if (!tenantId) {
            return res.status(400).send({message: 'Tenant ID is required'});
        }
        try {
            await this.repository.findById(tenantId);
        }catch (error) {
            return res.status(500).send({message: 'Error retrieving tenant information'});
        }

        // if (!tenant) {
        //     return res.status(404).send({message: 'Tenant ${tenantId} not found'});
        // } 

        // if (!tenant.isActive()) {
        //     return res.status(403).send({message: `Tenant ${tenantId} subscription is inactive.`});
        // }
        // TenantContext.run(tenant, next);
        next();
    }
}