import express from 'express';
import cors from 'cors';
import 'reflect-metadata';
import { createContainer } from './infrastructure/di/container';
import  routes  from "./infrastructure/http/router";
import { connectSequelizeDB } from './infrastructure/db/tenant-db/database';
import { PORT, TYPE_ORM } from './config'

const app = express();
createContainer().then((container) => {
    app.set("container", container)
});
// 1) Enable CORS for all origins
app.use(cors({
    origin: "*",
    methods: ["GET","POST","OPTIONS"]
}))
// 2) Parse JSON request bodies
app.use(express.json())
// 3) Tenant Middleware
app.use(async (req, res, next) => {
    const tenantMiddleware = app.get("container").get('TenantMiddleware');
    await tenantMiddleware.handle(req, res, next);
});
// 4) Router
app.use("/api/", routes)
// 5) Start server
if (TYPE_ORM == "sequelize"){
    connectSequelizeDB().then(() => {
        app.listen(PORT, () => {
            console.log(`Server running on port ${PORT}`)
        })
    });
}