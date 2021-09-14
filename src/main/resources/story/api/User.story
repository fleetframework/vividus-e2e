Meta:
@smoke
@user

Narrative:
Check RP user

Lifecycle:
Scope: SCENARIO
Before:
Given request body:
grant_type=password&username=${username}&password=${password}
When I set request headers:
| name             | value                             |
| Content-Type     | application/x-www-form-urlencoded |
| Content-Encoding | br                                |
| Authorization    | Basic dWk6dWltYW4                 |
And I issue a HTTP POST request for a resource with the URL '${url}uat/sso/oauth/token'
Then the response code is equal to '200'
When I save JSON element from context by JSON path `access_token` to scenario variable `token`

Scenario: Change Password Negative
Given request body:
{
    "newPassword": "<newPassword>",
    "oldPassword": "<oldPassword>"
}
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP POST request for a resource with the URL '${url}api/v1/user/password/change'
Then the response code is equal to '<statusCode>'
Then JSON element by JSON path `$.errorCode` is equal to `<errorCode>`ignoring extra fields
Then JSON element by JSON path `$.message` is equal to `<message>`ignoring extra fields

Examples:
| oldPassword | newPassword  | statusCode | errorCode | message                                                                         |
| wrong       | new          | 400        | 4001      | "Incorrect Request. [Field 'newPassword' should have size from '4' to '256'.] " |
| wrong       | new password | 400        | 40010     | "Forbidden operation. Old password not match with stored."                        |
