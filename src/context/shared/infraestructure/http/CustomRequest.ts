import { Request } from "express";

import { ContainerBuilder } from 'node-dependency-injection';

export interface CustomRequest extends Request {
    container: ContainerBuilder;
}