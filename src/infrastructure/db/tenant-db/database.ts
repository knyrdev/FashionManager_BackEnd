import { Sequelize } from 'sequelize';
import { DB_DIALECT, DB_HOST, DB_PORT,DB_NAME, DB_USER, DB_PASSWORD, DB_LOGGING, DB_SYNC } from '../../../config';

const dbDialect = DB_DIALECT;
const dbHost = DB_HOST;
const dbPort = Number(DB_PORT);
const dbName = DB_NAME || '';
const dbUser = DB_USER || '';
const dbPassword = DB_PASSWORD;
const dbLogging = DB_LOGGING;
const dbSync = DB_SYNC;

export const sequelize = new Sequelize(dbName, dbUser, dbPassword, {
    host: dbHost,
    port: dbPort,
    dialect: dbDialect as any,
    logging: dbLogging === 'true' ? console.log : false,
});

export const connectSequelizeDB = async () => {
    try {
        await sequelize.authenticate();
        console.log('Database connected successfully.');
        if(dbSync === 'true') {
            await sequelize.sync({ force: false });
            console.log('Database synchronized successfully.');
        }
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
};