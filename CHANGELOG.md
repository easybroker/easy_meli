# Changelog

## V 0.6.6
- Classify status code 401 as EasyMeli::InvalidTokenError.

## V 0.6.5
- Move Error class search to its own class and reuse it for ApiClient and AuthorizationClient
- Raise EasyMeli exceptions for server side errors.

## V 0.6.4
- Add Unknown error support

## V 0.6.3
- Fix error when the api response doesn't include error or message keys.
- Add right error message for forbidden error.

## V 0.6.2
- Update Error classification mechanism to use error message as first option

## V 0.6.1
- Fix a bug in the error raising in the authorization client introduced in V 0.6.0

## V 0.6.0
- Classify an `invalid_token` response as an `InvalidTokenError`.
- `Malformed access_token` error changed from `AuthenticationError` to `InvalidTokenError`.

## V 0.5.0
- `self.api_client` Prevent access_token override when initialize together with a refresh_token.
- Raises a EasyMeli::TooManyRequestsError if a 429 response status is returned.
