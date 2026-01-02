export interface TenantConnectionData {
    dbName: string;
    dbHost: string;
    dbPort: string;
    dbUser: string;
    dbPass: string;
    dbDialect: string;
    dbSync?: boolean;
}