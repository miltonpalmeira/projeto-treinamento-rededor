import { handler } from '../src/index';
import { vi, describe, it, expect, beforeEach } from 'vitest';
import type { APIGatewayProxyResult } from 'aws-lambda';

// Mock global
vi.mock('aws-sdk', () => {
  const initiateAuthMock = vi.fn();

  const CognitoIdentityServiceProviderMock = vi.fn(() => ({
    initiateAuth: initiateAuthMock
  }));

  return {
    CognitoIdentityServiceProvider: CognitoIdentityServiceProviderMock,
    __mocks__: {
      initiateAuthMock,
      CognitoIdentityServiceProviderMock,
    }
  };
});

// Reimporta mocks do vi.mock (depois de definido)
const { __mocks__ } = await import('aws-sdk') as any;
const initiateAuthMock = __mocks__.initiateAuthMock;

describe('lambda-auth handler', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    process.env.COGNITO_CLIENT_ID = 'dummy-client-id';
  });

  it('should return token on valid login', async () => {
    initiateAuthMock.mockReturnValue({
      promise: vi.fn().mockResolvedValue({
        AuthenticationResult: {
          IdToken: 'fake-id-token',
        },
      }),
    });

    const response = (await handler(
      {
        body: JSON.stringify({ username: 'testuser', password: '123456' }),
      } as any,
      {} as any,
      () => {}
    )) as APIGatewayProxyResult;

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.token).toBe('fake-id-token');
  });

  it('should return 401 on invalid credentials', async () => {
    initiateAuthMock.mockReturnValue({
      promise: vi.fn().mockRejectedValue(new Error('Invalid credentials')),
    });

    const response = (await handler(
      {
        body: JSON.stringify({ username: 'invalid', password: 'wrong' }),
      } as any,
      {} as any,
      () => {}
    )) as APIGatewayProxyResult;

    expect(response.statusCode).toBe(401);
    const body = JSON.parse(response.body);
    expect(body.error).toBe('Invalid credentials');
  });
});
