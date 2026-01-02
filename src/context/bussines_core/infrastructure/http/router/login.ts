import { Router } from 'express';
import { AuthController } from '../controllers/AuthController';

import { ValidatorMiddleware } from '@shared/infraestructure/http/middlewares/ValidatorMiddleware';
import { LoginSchema } from '../../services/validations/LoginSchema';

const router = Router();
// http://localhost:3000/api/auth/login
router.post('/', ValidatorMiddleware(LoginSchema), AuthController.login.bind(AuthController));

export { router }; 