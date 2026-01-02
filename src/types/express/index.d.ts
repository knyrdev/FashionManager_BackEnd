import { ContainerBuilder } from 'node-dependency-injection';

declare global {
    namespace Express {
        interface Request {
            container: ContainerBuilder;
        }
    }
}