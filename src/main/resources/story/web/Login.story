Meta:
@web
@smoke
@login
Narrative: Check login

Scenario: Open application under test
Given I am on the main application page
When I log in
And I wait `PT5S` with `PT1S` polling until element located `By.cssSelector(div[class*=userBlock__avatar])` becomes visible
And I click on element located `By.cssSelector(div[class*=userBlock__avatar])`
And I change context to element located `By.cssSelector(div[class*=userBlock__username])`
Then the text '#{toUpperCase(${username})}' exists
