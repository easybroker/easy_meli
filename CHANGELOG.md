# Changelog

## V 0.5.0
- `self.api_client` Prevent access_token override when initialize together with a refresh_token.
- Raises a EasyMeli::TooManyRequestsError if a 429 response status is returned.
