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
    readonly createdAt?: Date;
    readonly updatedAt?: Date;

    constructor(
        id: string,
        status: boolean,
        dbhost: string,
        dbport: string,
        dbname: string,
        dbuser: string,
        dbpass: string,
        dbdialect: string,
        dbsync: boolean,
        createdat?: Date,
        updatedat?: Date
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
        this.createdAt = createdat;
        this.updatedAt = updatedat;
    }
    static create(
        id: string,
        status: boolean,
        dbhost: string,
        dbport: string,
        dbname: string,
        dbuser: string,
        dbpass: string,
        dbdialect: string,
        dbsync: boolean,
        createdat?: Date,
        updatedat?: Date
    ): Tenant {
        return new Tenant(id, status, dbhost, dbport, dbname, dbuser, dbpass, dbdialect, dbsync, createdat, updatedat);
    }
    isActive(): boolean {
        return this.status;
    }
}