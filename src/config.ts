import "dotenv/config"
export const {
    PORT,
    SALT_ROUNDS,

    TYPE_ORM,
    DB_DIALECT,
    DB_PORT,
    DB_HOST,
    DB_NAME,
    DB_USER,
    DB_PASSWORD,
    DB_LOGGING,
    DB_SYNC,
} = process.env;