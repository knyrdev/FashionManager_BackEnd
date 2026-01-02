import 'module-alias/register';

import express from 'express';
import cors from 'cors';
import 'reflect-metadata';

import { connectSequelizeDB } from './context/tenancy_management/infrastructure/db/database';

import { createContainer } from './context/bussines_core/infrastructure/di/container';
import { CustomRequest } from './context/shared/infraestructure/http/CustomRequest';
import { ErrorHandler } from './context/shared/infraestructure/http/middlewares/ErrorHandler';

import routesBussinesCore from './context/bussines_core/infrastructure/http/router';
import  routesTenant  from "./context/bussines_core/infrastructure/http/router";

import { PORT } from './context/shared/config'

const app = express();
// Enable CORS for all origins
app.use(cors({
    origin: "*",
    methods: ["GET","POST","PATCH"]
}))

// Parse JSON request bodies
app.use(express.json())

// Dependency Injection Container
createContainer().then((container) => {
    app.set("container", container)
});

// Middleware to attach DI container to each request
app.use((req, res, next) => {
    const reqTyped = req as CustomRequest;
    reqTyped.container = app.get("container");
    next();
});

// Business Core Routes
app.use("/core/", routesBussinesCore)

// Router API's for Tenancy with Tenant Middleware
app.use("/api/",async (req, res, next) => {
    const tenantMiddleware   = app.get("container").get('TenantMiddleware');
    await tenantMiddleware.handle(req, res, next);
}, routesTenant)

// Global Error Handler
app.use(ErrorHandler)

// Start server after DB connection
connectSequelizeDB().then(() => {
    app.listen(PORT, () => {
        console.log(`Server running on port ${PORT}`)
    })
});