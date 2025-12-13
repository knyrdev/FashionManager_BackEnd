import { User } from "../../../../domain/services/tenancy/users/User"
import { UserRepository } from "../../../../domain/services/tenancy/users/UserRepository"
import { UserModel } from "../models/UserModel"

export class SequelizeUserRepository implements UserRepository {
  async create(users: User): Promise<void> {
    const userModel = await UserModel.create({
        id: users.id,
        tenant_id: users.tenantId,
        user_id: users.userId,
    })
  }

  async findByTenantAndUserId(tenantId: string, userId: Number): Promise<User | null> {
    const userModel = await UserModel.findOne({ where: { tenant_id: tenantId, user_id: userId } })
    return userModel ? userModel.toJSON() : null
  }

  async update(user: Partial<User>): Promise<User | null> {
    const [affectedRows] = await UserModel.update(user, { where: { id: user } })
    if (affectedRows === 0) return null
    const updatedUser = await UserModel.findOne({ where: { id: user.id } })
    return updatedUser ? updatedUser.toJSON() : null
  }
}