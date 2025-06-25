import { CognitoIdentityServiceProvider } from 'aws-sdk';
import { APIGatewayProxyHandler } from 'aws-lambda';
import * as dotenv from 'dotenv';
dotenv.config();

const cognito = new CognitoIdentityServiceProvider();

export const handler: APIGatewayProxyHandler = async (event) => {
  const body = JSON.parse(event.body || '{}');
  const { username, password } = body;

  const clientId = process.env.COGNITO_CLIENT_ID;

  if (!clientId) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'COGNITO_CLIENT_ID not configured' }),
    };
  }

  try {
    const result = await cognito.initiateAuth({
      AuthFlow: 'USER_PASSWORD_AUTH',
      ClientId: clientId,
      AuthParameters: {
        USERNAME: username,
        PASSWORD: password,
      },
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({ token: result.AuthenticationResult?.IdToken }),
    };
  } catch (err: any) {
    return {
      statusCode: 401,
      body: JSON.stringify({ error: 'Invalid credentials', detail: err.message }),
    };
  }
};
