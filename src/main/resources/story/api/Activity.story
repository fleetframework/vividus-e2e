Meta:
@api
@smoke
@activity
@issueId VVD-1

Narrative:
Check RP activity

Lifecycle:
Scope: SCENARIO
Before:
Given get token

Scenario: Get Activities Using GET
When I set request headers with token
And I issue a HTTP GET request for a resource with the URL '${url}api/v1/${project}/activity'
Then the response code is equal to '200'
