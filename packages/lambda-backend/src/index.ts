import { APIGatewayProxyHandler } from 'aws-lambda';

export const handler: APIGatewayProxyHandler = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Backend funcionando com sucesso!',
      user: event.requestContext.authorizer,
    }),
  };
};
