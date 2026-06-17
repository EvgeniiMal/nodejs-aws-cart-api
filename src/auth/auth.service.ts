import { BadRequestException, Injectable } from '@nestjs/common';
import { createHash } from 'node:crypto';
import { UsersService } from '../users/services/users.service';
import { User } from '../users/models';

type TokenResponse = {
  token_type: string;
  access_token: string;
};

@Injectable()
export class AuthService {
  constructor(private readonly usersService: UsersService) { }

  private isReservedAdminUsername(username: string): boolean {
    return username === process.env.AUTH_USERNAME;
  }

  async register(payload: Pick<User, 'username' | 'password'>): Promise<{ userId: string }> {
    const username = payload.username?.trim();
    const password = payload.password;

    if (!username || !password) {
      throw new BadRequestException('Username and password are required');
    }

    const existingUser = await this.usersService.findOne(username);

    if (existingUser) {
      throw new BadRequestException('User with such username already exists');
    }

    const { id: userId } = await this.usersService.createOne({ username, password });
    return { userId: userId as string };
  }

  async validateUser(username: string, password: string): Promise<User | null> {
    const user = await this.usersService.findOne(username);

    if (!user || user.password !== password) {
      return null;
    }

    return user;
  }

  async validateOrCreateUser(username: string, password: string): Promise<User | null> {
    const normalizedUsername = username?.trim();

    if (!normalizedUsername || !password) {
      return null;
    }

    const user = await this.usersService.findOne(normalizedUsername);

    if (user) {
      return user.password === password ? user : null;
    }

    if (this.isReservedAdminUsername(normalizedUsername)) {
      return this.validateAdmin(normalizedUsername, password);
    }

    return this.usersService.createOne({ username: normalizedUsername, password });
  }

  async validateAdmin(username: string, password: string): Promise<User | null> {
    const validUsername = process.env.AUTH_USERNAME;
    const validPassword = process.env.AUTH_PASSWORD;

    if (username === validUsername && password === validPassword) {
      const existingAdmin = await this.usersService.findOne(validUsername);

      if (existingAdmin) {
        return existingAdmin;
      }

      const hash = createHash('md5').update(`admin:${validUsername}`).digest('hex');
      const deterministicId = [
        hash.slice(0, 8),
        hash.slice(8, 12),
        '4' + hash.slice(13, 16),
        ((parseInt(hash[16], 16) & 0x3) | 0x8).toString(16) + hash.slice(17, 20),
        hash.slice(20, 32),
      ].join('-');

      return await this.usersService.createOne({
        id: deterministicId,
        username: validUsername,
        password: validPassword,
      });
    }

    return null;
  }

  async validateBasicUser(username: string, password: string): Promise<User | null> {
    const user = await this.validateUser(username, password);

    if (user) {
      return user;
    }

    return this.validateAdmin(username, password);
  }

  login(user: User): TokenResponse {
    return this.loginBasic(user);
  }

  loginBasic(user: User): TokenResponse {
    function encodeUserToken(user: User) {
      const { username, password } = user;
      const buf = Buffer.from([username, password].join(':'), 'utf8');

      return buf.toString('base64');
    }

    return {
      token_type: 'Basic',
      access_token: encodeUserToken(user),
    };
  }
}
