# Arquitectura DDD y Decisiones del Proyecto

Hola, he configurado la base de tu proyecto siguiendo los principios de **Domain-Driven Design (DDD)** y **Arquitectura Hexagonal**. Aquí te explico el "por qué" de cada decisión para que puedas aprender y continuar el desarrollo.

## 1. Estructura de Carpetas (Capas)

Hemos dividido el código en tres capas principales para desacoplar la lógica de negocio de las herramientas externas (como la base de datos o el framework web).

### `src/domain` (El Corazón)
Aquí viven tus **Entidades** (como `User`) y las **Interfaces de tus Repositorios** (`UserRepository`).
*   **¿Por qué?**: El dominio no debe saber nada de bases de datos ni de HTTP. Es JavaScript/TypeScript puro. Si mañana cambias Sequelize por TypeORM, o MySQL por Mongo, esta carpeta **NO** debería cambiar.
*   **Contratos**: `UserRepository` es un contrato (interface). Dice *qué* se puede hacer (guardar, buscar), pero no *cómo*.

### `src/application` (Los Casos de Uso)
Aquí están las acciones que tu aplicación puede realizar, como `UserRegister`.
*   **¿Por qué?**: Orquesta el flujo. Recibe datos, valida reglas de negocio y llama al repositorio.
*   **Inyección**: Fíjate que `UserRegister` recibe `UserRepository` en su constructor. No importa si es Sequelize o un archivo de texto, él solo sabe que cumple con la interfaz.

### `src/infraestructure` (Los Detalles)
Aquí está todo lo "sucio" y concreto: Bases de datos, Frameworks (Express), Librerías externas.
*   **Implementación**: `SequelizeUserRepository` implementa la interfaz del dominio usando Sequelize.
*   **Controladores**: Reciben la petición HTTP, extraen datos y llaman al Caso de Uso.

## 2. Inyección de Dependencias (`node-dependency-injection`)

En `src/infraestructure/di/container.ts` configuramos el contenedor.
*   **¿Qué hace?**: En lugar de hacer `new UserRegister(new SequelizeUserRepository())` manualmente en cada controlador, el contenedor lo hace por ti.
*   **Beneficio**: Facilita el testing y el cambio de implementaciones. Si quieres cambiar la base de datos, solo cambias la clase que se registra en el contenedor, y toda la app se actualiza automáticamente.

## 3. Sequelize y Modelos

Hemos separado el **Modelo de Sequelize** (`UserModel`) de la **Entidad de Dominio** (`User`).
*   **¿Por qué duplicar?**: `UserModel` está atado a la librería Sequelize y a la estructura de la tabla. `User` es tu objeto de negocio puro. Al separarlos (y mapearlos en el repositorio), proteges tu lógica de negocio de cambios en la librería de base de datos.

## 4. Flujo de una Petición (Ejemplo: Registro)

1.  **Router** (`auth.ts`): Recibe `POST /auth/register`.
2.  **Controller** (`AuthController`): Pide al contenedor el caso de uso `user.register`.
3.  **Caso de Uso** (`UserRegister`):
    *   Verifica si el usuario existe.
    *   Hashea la contraseña.
    *   Crea la entidad `User`.
    *   Llama a `repo.save(user)`.
4.  **Repositorio** (`SequelizeUserRepository`): Convierte la entidad `User` a un modelo de Sequelize y lo guarda en la BD.

## Próximos Pasos Sugeridos

1.  **JWT**: Implementar un caso de uso `UserLogin` que genere un token JWT usando la librería `jsonwebtoken` que ya instalamos.
2.  **Middlewares**: Crear un middleware de Express que verifique el token JWT para proteger rutas.
3.  **Más Dominios**: Crear carpetas para `Product`, `Sale`, etc., siguiendo este mismo patrón.

¡Espero que esto te sirva de guía para dominar DDD!