import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  constructor() {}

  @Get()
  healthCheck() {
    return { status: 'ok', service: 'Agrotani API', version: '1.0.0' };
  }
}
