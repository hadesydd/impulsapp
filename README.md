comment call l'API pour creer des variables :
Using Postman to Create GitLab CI/CD Variables:
You can use Postman to interact with GitLab's API to create CI/CD variables.
First, obtain your Personal Access Token (PAT) from GitLab with api scope.
Set up a new request in Postman with the following details:
Method: POST
URL: https://gitlab.com/api/v4/projects/:id/variables (replace :id with your project's ID and gitlab.example.
com with your GitLab instance's URL)
Headers: Add a header with Key as PRIVATE-TOKEN and Value as your PAT.
Body: Choose raw and JSON format, then enter the variable details as a JSON object. For example:
{
"key": "MY_VARIABLE",
"value": "my_value"
}