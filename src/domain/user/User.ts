export class User {
  readonly id: number | null;
  readonly personalId: number;
  readonly roleId: number;
  readonly username: string;
  readonly password?: string;

  constructor(
    id: number | null,
    personalId: number,
    roleId: number,
    username: string,
    password?: string
  ) {
    this.id = id;
    this.personalId = personalId;
    this.roleId = roleId;
    this.username = username;
    this.password = password;
  }

  static create(personalId: number, roleId: number, username: string, password?: string): User {
    return new User(null, personalId, roleId, username, password);
  }
}