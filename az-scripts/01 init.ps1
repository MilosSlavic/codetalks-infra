$login = az login --output json | ConvertFrom-Json

$SubscriptionId = $login.id

az account set --subscription $SubscriptionId

$subscription = "/subscriptions/$SubscriptionId"
$principal = az ad sp create-for-rbac --role="Contributor" --scopes=$subscription | ConvertFrom-Json

$Env:ARM_CLIENT_ID = $principal.appId
$Env:ARM_CLIENT_SECRET = $principal.password
$Env:ARM_SUBSCRIPTION_ID = $SubscriptionId
$Env:ARM_TENANT_ID = $principal.tenant