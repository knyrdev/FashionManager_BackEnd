import { Request, Response, NextFunction } from 'express';
import { ZodObject, ZodError } from 'zod';

export const ValidatorMiddleware = (schema: ZodObject) => {
    return async (req: Request, res: Response, next: NextFunction) => {
        try{
            await schema.parse({
                body: req.body,
                query: req.query,
                params: req.params
            });
            next();
        }catch(error){
            if(error instanceof ZodError){
                return res.status(400).json({
                    status: 'fail',
                    errors: error.issues.map((err) => ({
                        field: err.path[1],
                        property: err.path[2],
                        message: err.message
                    }))
                })
            }
            return res.status(500).json({
                status: 'error',
                message: 'Internal Server Error'
            })
        }
    }
}