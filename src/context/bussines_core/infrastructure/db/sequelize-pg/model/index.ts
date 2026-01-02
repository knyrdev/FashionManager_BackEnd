import { readdirSync } from "node:fs";
import { Sequelize } from "sequelize";

const PATH_ROUTES = __dirname;

const models: { [key: string]: any } = {};

function removeExtension(fileName: string): string {
    const cleanFileName = fileName.split(".").shift() as string;
    return cleanFileName;
}

function loadModels(file: string, sequelize: Sequelize): void {
    const name = removeExtension(file);
    if (name !== "index") {
        import(`./${file}`).then((modelModule) => {
            if (modelModule && typeof modelModule.initModel === "function") {
                models[name] = modelModule.initModel(sequelize);
            }
        });
    }
}

export function initModels(sequelize: Sequelize): { [key: string]: any } {
    readdirSync(PATH_ROUTES).forEach((file) => loadModels(file, sequelize));
    Object.keys(models).forEach((modelName) => {
        if (typeof models[modelName].associate === "function") {
            models[modelName].associate(models);
        }
    });
    return models;
}

