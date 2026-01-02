import { Request, Response, NextFunction } from "express";
import { AuthService } from "../../../domain/services/auth/AuthService";

export class AuthMiddelware {
    private authService: AuthService;
    constructor(authService: AuthService) {
        this.authService = authService;
    }
    public handle = (req: Request, res: Response, next: NextFunction) => {
        const authHeader = req.headers.authorization?.split(" ")[0] === "Bearer" ? req.headers.authorization : null;
        if (!authHeader && !authHeader?.split(" ")[1]) {
            return res.status(401).send({ message: "Access Denied" });
        }
        const token = authHeader.split(" ")[1];
        try {
            const payload = this.authService.verifyAccesToken(token);
            req.body.user = payload;
            next();
        } catch (error) {
            return res.status(401).send({ message: "Invalid token" });
        }
    }
} 