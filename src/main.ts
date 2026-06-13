import { NestFactory } from '@nestjs/core';
import serverlessExpress from '@codegenie/serverless-express';
import { Callback, Context, Handler } from 'aws-lambda';
import { AppModule } from './app.module';

let server: Handler;

async function bootstrap(): Promise<Handler> {
  const app = await NestFactory.create(AppModule);

  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token',
    preflightContinue: false,
    optionsSuccessStatus: 204,
  });

  const expressApp = app.getHttpAdapter().getInstance();

  await app.init();
  return serverlessExpress({ app: expressApp });
}

export const handler: Handler = async (
  event: any,
  context: Context,
  callback: Callback,
) => {
  console.log('REQUEST:', {
    method: event.requestContext?.http?.method,
    path: event.rawPath,
    headers: event.headers,
  });
  server = server ?? (await bootstrap());
  return server(event, context, callback);
};
