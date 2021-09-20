Meta:
@smoke
@user

Narrative:
Check RP user

Lifecycle:
Scope: SCENARIO
Before:
Given get token


Scenario: Change Password Negative
Given request body:
{
    "newPassword": "<newPassword>",
    "oldPassword": "<oldPassword>"
}
When I set request headers with token
And I issue a HTTP POST request for a resource with the URL '${url}api/v1/user/password/change'
Then the response code is equal to '<statusCode>'
And JSON element by JSON path `$.errorCode` is equal to `<errorCode>`ignoring extra fields
And JSON element by JSON path `$.message` is equal to `<message>`ignoring extra fields

Examples:
| oldPassword | newPassword  | statusCode | errorCode | message                                                                         |
| wrong       | new          | 400        | 4001      | "Incorrect Request. [Field 'newPassword' should have size from '4' to '256'.] " |
| wrong       | new password | 400        | 40010     | "Forbidden operation. Old password not match with stored."                        |
