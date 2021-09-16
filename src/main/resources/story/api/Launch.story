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
When I save JSON element from context by JSON path `id` to scenario variable `runUUID`

When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And the condition '#{evalGroovy("<mode>" == "DEBUG")}' is true I do
| step                                                                                                                                            |
| When I save JSON element from context by JSON path `id` to story variable `debugRunUUID`                                                        |
| And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/uuid/#{removeWrappingDoubleQuotes(${debugRunUUID})}' |
| Then the response code is equal to '200'                                                                                                        |
| When I save JSON element from context by JSON path `id` to story variable `debugRunId`
And the condition '#{evalGroovy("<mode>" == "DEFAULT")}' is true I do
| step                                                                                                                                               |
| When I save JSON element from context by JSON path `id` to story variable `defaultRunUUID`                                                         |
| And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/uuid/#{removeWrappingDoubleQuotes(${defaultRunUUID})}' |
| Then the response code is equal to '200'                                                                                                           |
| When I save JSON element from context by JSON path `id` to story variable `defaultRunId`                                                           |

When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${runUUID})}'
Then the response code is equal to '200'
And JSON element by JSON path `$.status` is equal to `<status>`ignoring extra fields
And JSON element by JSON path `$.name` is equal to `<name>`ignoring extra fields
And JSON element by JSON path `$.mode` is equal to `<mode>`ignoring extra fields
Examples:
| mode    | status      | name            |
| DEBUG   | IN_PROGRESS | Vividus Debug   |
| DEFAULT | IN_PROGRESS | Vividus Default |


Scenario: Check launch names
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/names?filter.cnt.name=<runName>'
Then the response code is equal to '200'
And JSON element by JSON path `$.*` is equal to `<runName>`ignoring values
Examples:
| runName         |
| Vividus Default |


Scenario: Check debug launch modes
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/mode'
Then the response code is equal to '200'
When I set number of elements found by JSON path `$.content[*].mode` to scenario variable `numberOfRuns`
When I execute steps while counter is < '${numberOfRuns}' with increment '1' starting from '0':
| step                                                                                                     |
| Then JSON element by JSON path `$.content[${iterationVariable}].mode` is equal to `DEBUG`ignoring values |


Scenario: Finish launch
Given request body:
{
    "endTime": "#{toEpochSecond(#{generateDate(P, yyyy-MM-dd'T'HH:mm:ss)})}000"
}
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP PUT request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${defaultRunUUID})}/finish'
Then the response code is equal to '200'
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${defaultRunUUID})}'
Then the response code is equal to '200'
And JSON element by JSON path `$.status` is equal to `PASSED`ignoring extra fields


Scenario: Force finish
Given request body:
{
    "endTime": "#{toEpochSecond(#{generateDate(P, yyyy-MM-dd'T'HH:mm:ss)})}000"
}
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP PUT request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${debugRunId})}/stop'
Then the response code is equal to '200'
And JSON element by JSON path `$.message` is equal to `Launch with ID = \'${debugRunId}\' successfully stopped.`ignoring extra fields
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${debugRunUUID})}'
Then the response code is equal to '200'
And JSON element by JSON path `$.status` is equal to `STOPPED`ignoring extra fields


Scenario: Delete launch
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP DELETE request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${defaultRunId})}'
Then the response code is equal to '200'
And JSON element by JSON path `$.message` is equal to `Launch with ID = \'${defaultRunId}\' successfully deleted.`ignoring extra fields
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${defaultRunId})}'
Then the response code is equal to '404'
And JSON element by JSON path `$.message` is equal to `Launch \'#{removeWrappingDoubleQuotes(${defaultRunId})}\' not found. Did you use correct Launch ID?`ignoring extra fields


Scenario: Delete launches
Given request body:
{
    "ids": [#{removeWrappingDoubleQuotes(${debugRunId})}]
}
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP DELETE request for a resource with the URL '${url}api/v1/${project}/launch'
Then the response code is equal to '200'
When I set request headers:
| name             | value                                          |
| Content-Type     | application/json                               |
| Authorization    | bearer #{removeWrappingDoubleQuotes(${token})} |
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/launch/#{removeWrappingDoubleQuotes(${debugRunId})}'
Then the response code is equal to '404'
And JSON element by JSON path `$.message` is equal to `Launch \'#{removeWrappingDoubleQuotes(${debugRunId})}\' not found. Did you use correct Launch ID?`ignoring extra fields
