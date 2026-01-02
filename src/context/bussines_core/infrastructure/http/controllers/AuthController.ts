import { NextFunction, Request, Response } from "express";

import { CustomRequest } from "@shared/infraestructure/http/CustomRequest";
import { AsyncCatchHandler } from "@shared/infraestructure/utils/AsynCatchHandler";
import { AuthResponse } from "@shared/domain/services/auth/AuthPayload";

const login = AsyncCatchHandler(
    async (req: Request, res: Response, next: NextFunction) => {
        const reqTyped = req as CustomRequest;
        const LoginUseCase = reqTyped.container.get('LoginUseCase');
        const { username, password} = req.body;
        const login: AuthResponse = await LoginUseCase.execute(username, password);
        return res.status(200).json({ login })
    }
)

export const AuthController = {
    login
}