Meta:
@web
@smoke
@debug
Narrative: Check Debug section

Scenario: Check redirect to Debug section
Given I am on the main application page
When I log in
And I wait `PT5S` with `PT1S` polling until element located `By.cssSelector(a[href*=debug])` becomes visible
And I click on element located `By.cssSelector(a[href*=debug])`
Then the page with the URL containing 'userdebug/all' is loaded
