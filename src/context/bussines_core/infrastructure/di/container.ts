import { ContainerBuilder } from 'node-dependency-injection';

import * as path from 'path';
import * as fs from 'fs';

type RegisterFunction = (container: ContainerBuilder) => ContainerBuilder;

/**
 * Crea, configura y compila el Container de Inyección de Dependencias.
 * @returns Una promesa que resuelve con el ContainerBuilder compilado.
*/
export async function createContainer(): Promise<ContainerBuilder>{
  let container = new ContainerBuilder();
  const diDir = __dirname;

  console.log('Loading dynamic records for the dependency injection container');
  const files = fs.readdirSync(diDir);

  for (const file of files) {
    // Filtrar solo archivos TypeScript/JavaScript (excluyendo este archivo)
    if (file === 'container.ts' || !/\.(t|j)s$/.test(file)) {
      continue;
    }
    // Determinar el nombre esperado de la función
    const functionName = path.basename(file, path.extname(file));
    // Importar el módulo dinámicamente
    const modulePath = path.join(diDir, file);
    try {
        const module = await import(modulePath);
        // Verificar si la función existe y ejecutarla
        const registerFn: RegisterFunction = module[functionName];

        if (typeof registerFn === 'function') {
            console.log(`🔌 Ejecutando función de registro: ${functionName} en ${file}`);
            container = registerFn(container); // <--- Ejecución de la lógica de registro
        } else {
            console.warn(`⚠️ Archivo ${file} no exporta una función llamada '${functionName}'.`);
        }
    } catch (error) {
        console.error(`❌ Error al cargar/ejecutar el módulo ${file}:`, error);
    }
  }
  await container.compile();
  return container;
}