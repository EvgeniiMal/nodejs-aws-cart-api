import * as cdk from 'aws-cdk-lib/core';
import { Construct } from 'constructs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import { CorsHttpMethod, HttpApi, HttpMethod } from 'aws-cdk-lib/aws-apigatewayv2';
import { HttpLambdaIntegration } from 'aws-cdk-lib/aws-apigatewayv2-integrations';
import path from 'node:path';
import getEnv from '../util/get-env';

export class CartApiStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const vpc = ec2.Vpc.fromLookup(this, 'CartApiVpc', {
      vpcId: getEnv('VPC_ID'),
    });

    const lambdaSecurityGroup = new ec2.SecurityGroup(this, 'CartLambdaSG', {
      vpc,
      securityGroupName: 'CartLambdaSG',
    });

    const dbSecurityGroup = ec2.SecurityGroup.fromSecurityGroupId(
      this,
      'DbSecurityGroup',
      'sg-0c73c4403ecbc0cee',
    );

    dbSecurityGroup.addIngressRule(
      lambdaSecurityGroup,
      ec2.Port.tcp(5432),
      'Allow PostgreSQL access from Cart Lambda',
    );

    const cartLambda = new lambda.Function(this, 'CartLambda', {
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: 'src/main.handler',
      code: lambda.Code.fromAsset(path.join(__dirname, '../../dist')),
      memorySize: 512,
      timeout: cdk.Duration.seconds(15),
      vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.PUBLIC },
      allowPublicSubnet: true,
      securityGroups: [lambdaSecurityGroup],
      environment: {
        PGHOST: getEnv('PGHOST'),
        PGUSER: getEnv('PGUSER'),
        PGPASSWORD: getEnv('PGPASSWORD'),
        PGDATABASE: getEnv('PGDATABASE'),
        PGPORT: getEnv('PGPORT'),
        AUTH_USERNAME: getEnv('AUTH_USERNAME'),
        AUTH_PASSWORD: getEnv('AUTH_PASSWORD'),
      },
    });

    const cartLambdaIntegration = new HttpLambdaIntegration('CartLambdaIntegration', cartLambda);

    const api = new HttpApi(this, 'CartApi', {
      corsPreflight: {
        allowOrigins: ['*'],
        allowMethods: [CorsHttpMethod.ANY],
        allowHeaders: [
          'Content-Type',
          'Authorization',
          'X-Amz-Date',
          'X-Api-Key',
          'X-Amz-Security-Token',
        ],
      },
    })

    api.addRoutes({
      'path': '/',
      'methods': [HttpMethod.ANY],
      'integration': cartLambdaIntegration,
    });

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