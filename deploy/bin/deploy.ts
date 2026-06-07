#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib/core';
import { CartApiStack } from '../lib/cart-api';
import 'dotenv/config';
import getEnv from '../util/get-env';

const app = new cdk.App();
new CartApiStack(app, 'DeployStack', {
  env: {
    region: process.env.CDK_DEFAULT_REGION,
    account: process.env.CDK_DEFAULT_ACCOUNT,
  },
});
