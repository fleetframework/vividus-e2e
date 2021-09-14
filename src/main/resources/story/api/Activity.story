Meta:
@smoke
@activity
@issueId VVD-1

Narrative:
Check RP activity

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

Scenario: Get Activities Using GET
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/activity'
Then the response code is equal to '200'
