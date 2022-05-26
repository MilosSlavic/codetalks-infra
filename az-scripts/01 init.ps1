$login = az login --output json | ConvertFrom-Json
$user = az ad user show --id ($env:MY_EMAIL) | ConvertFrom-Json
$SubscriptionId = $login.id;
az account set --subscription $SubscriptionId;
$subscription = "/subscriptions/$SubscriptionId"
$principal = az ad sp create-for-rbac --role="Contributor" --scopes=$subscription | ConvertFrom-Json

$env:ARM_CLIENT_ID = $principal.appId
$env:ARM_CLIENT_SECRET = $principal.password
$env:ARM_SUBSCRIPTION_ID = $SubscriptionId
$env:ARM_TENANT_ID = $principal.tenant
$env:TF_VAR_user_object_id=$user.objectId
$env:TF_VAR_AZ_Location="westeurope"

$env:AZURE_CREDENTIALS = "{""clientId"" :""${env:ARM_CLIENT_ID}"", ""clientSecret"": ""${env:ARM_CLIENT_SECRET}"", ""subscriptionId"": ""${env:ARM_SUBSCRIPTION_ID}"", ""tenantId"": ""${env:ARM_TENANT_ID}"", ""resourceManagerEndpointUrl"": ""https://management.azure.com/""}"