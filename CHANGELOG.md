# Changelog
## V 0.6.15
- Update rexml from 3.3.2 to 3.3.7

## V 0.6.14
- Fix dependencies for ruby 2

## V 0.6.13
- Update rexml from 3.2.9 to 3.3.2

## V 0.6.12
- Update rexml from 3.2.5 to 3.2.9

## V 0.6.11
- Add 403 response to the list of mapped errors

## V 0.6.10
- Update bundler from 2.2.24 to 2.3.6
- Add rexml 3.2.5 dependency to make the Gem compatible with Ruby 3.1
- Update minitest from 5.14.0 to 5.18 to make the Gem compatible with Ruby 3.1

## V 0.6.9
- Update httparty dependency from 0.18 to 0.21

## V 0.6.8
- Fix error when the api response includes error_description instead of message key.

## V 0.6.7
- Send `access_token` in the Authorization Header instead of the query params [See Official Documentation](https://developers.mercadolibre.com.ar/es_ar/desarrollo-seguro#header)

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
