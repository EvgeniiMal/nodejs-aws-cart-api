import * as cdk from 'aws-cdk-lib/core';
import { Construct } from 'constructs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { CorsHttpMethod, HttpApi, HttpMethod } from 'aws-cdk-lib/aws-apigatewayv2';
import { HttpLambdaIntegration } from 'aws-cdk-lib/aws-apigatewayv2-integrations';
import path from 'node:path';

export class CartApiStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const cartLambda = new lambda.Function(this, 'CartLambda', {
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: 'src/main.handler',
      code: lambda.Code.fromAsset(path.join(__dirname, '../../dist')),
      memorySize: 512,
      timeout: cdk.Duration.seconds(15),
    });

    const cartLambdaIntegration = new HttpLambdaIntegration('CartLambdaIntegration', cartLambda);

    const api = new HttpApi(this, 'CartApi', {
      corsPreflight: {
        allowHeaders: ['*'],
        allowMethods: [CorsHttpMethod.ANY],
        allowOrigins: ['*'],
      }
    })

    api.addRoutes({
      'path': '/{proxy+}',
      'methods': [HttpMethod.ANY],
      'integration': cartLambdaIntegration,
    });

    new cdk.CfnOutput(this, 'ApiEndpoint', {
      value: api.apiEndpoint,
    });
  }
}