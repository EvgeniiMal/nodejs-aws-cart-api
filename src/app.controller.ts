import {
  Body,
  Controller,
  Get,
  HttpCode,
  Request,
  Post,
  UseGuards,
  HttpStatus,
} from '@nestjs/common';
import {
  AuthService,
  BasicAuthGuard,
  LocalAuthGuard,
} from './auth';
import { AppRequest } from './shared';
import { User } from './users';

@Controller()
export class AppController {
  constructor(private readonly authService: AuthService) { }

  @Get(['', 'ping'])
  healthCheck() {
    return {
      statusCode: HttpStatus.OK,
      message: 'OK',
    };
  }

  @Post('api/auth/register')
  @HttpCode(HttpStatus.CREATED)
  register(@Body() body: { username: string; password: string }) {
    return this.authService.register({
      username: body.username,
      password: body.password,
    });
  }

  @UseGuards(LocalAuthGuard)
  @HttpCode(HttpStatus.OK)
  @Post('api/auth/login')
  login(@Request() req: AppRequest) {
    return this.authService.login(req.user as User);
  }

  @UseGuards(BasicAuthGuard)
  @Get('api/profile')
  async getProfile(@Request() req: AppRequest) {
    return {
      user: req.user,
    };
  }
}
