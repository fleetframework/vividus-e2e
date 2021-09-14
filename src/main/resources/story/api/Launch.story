Meta:
@smoke
@launch

Narrative:
Check RP launch

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

Scenario: Start launch in different modes
Given request body:
{
    "name": "<name>",
    "mode": "<mode>",
    "startTime": "#{toEpochSecond(#{generateDate(P, yyyy-MM-dd'T'HH:mm:ss)})}000"
}
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP POST request for a resource with the URL '${url}api/v1/${project}/launch'
Then the response code is equal to '201'
When I save JSON element from context by JSON path `id` to scenario variable `runId`

When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${runId})}'
Then the response code is equal to '200'
And JSON element by JSON path `$.status` is equal to `<status>`ignoring extra fields
And JSON element by JSON path `$.name` is equal to `<name>`ignoring extra fields
And JSON element by JSON path `$.mode` is equal to `<mode>`ignoring extra fields
Examples:
| mode    | status      | name            |
| DEBUG   | IN_PROGRESS | Vividus Debug   |
| DEFAULT | IN_PROGRESS | Vividus Default |