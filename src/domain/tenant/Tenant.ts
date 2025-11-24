export class Tenant {
    readonly id: string;
    readonly status: boolean;
    readonly dbName: string;
    readonly dbHost: string;
    readonly dbPort: string;
    readonly dbUser: string;
    readonly dbPass: string;
    readonly dbDialect: string;
    readonly dbSync: boolean;

    constructor(
        id: string,
        status: boolean,
        dbhost: string,
        dbport: string,
        dbname: string,
        dbuser: string,
        dbpass: string,
        dbdialect: string,
        dbsync: boolean
    ) {
        this.id = id;
        this.status = status;
        this.dbName = dbname;
        this.dbUser = dbuser;
        this.dbPass = dbpass;
        this.dbHost = dbhost;
        this.dbPort = dbport;
        this.dbDialect = dbdialect;
        this.dbSync = dbsync;
    }
    static create(
        id: string,
        status: boolean,
        dbhost: string,
        dbport: string,
        dbname: string,
        dbuser: string,
        dbpass: string,
        db_dialect: string,
        db_sync: boolean
    ): Tenant {
        return new Tenant(id, status, dbhost, dbport, dbname, dbuser, dbpass, db_dialect, db_sync);
    }
    isActive(): boolean {
        return this.status;
    }
}