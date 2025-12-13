import { Session } from "./Session"

export interface SessionRepository {
    create(session: Session): Promise<Session>;
    findById(id: string): Promise<Session | null>;
    findByUserIdandDevice(userId: string, device: string): Promise<Session[]>;
    findByRefreshToken(refreshToken: string): Promise<Session | null>;
    update(session: Session): Promise<Session>;
    delete(id: string): Promise<void>;
}