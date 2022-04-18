
# Available Locations
# az account list-locations --query "[].name" -o json | Sort

$env:TF_VAR_AZ_Location="westeurope"
$env:TF_VAR_AZ_ResourceGroupName="codetalks-terraform-rg"
$env:TF_VAR_AZ_StorageAccountName="codetalksterraformsa"

az group create `
    --name $env:TF_AZ_ResourceGroupName `
    --location $env:TF_AZ_Location

az storage account create `
    --name $env:TF_AZ_StorageAccountName `
    --resource-group $env:TF_AZ_ResourceGroupName `
    --location $env:TF_AZ_Location `
    --sku Standard_LRS `
    --encryption-services blob

az role assignment create `
    --role "Storage Blob Data Contributor" `
    --assignee "milos.slavic@seavus.com" `
    --scope "/subscriptions/$Env:ARM_SUBSCRIPTION_ID/resourceGroups/$env:TF_VAR_AZ_ResourceGroupName/providers/Microsoft.Storage/storageAccounts/$env:TF_VAR_AZ_StorageAccountName/blobServices/default/containers/tfplan"

az storage container create `
    --name tfplan `
    --account-name $env:TF_VAR_AZ_StorageAccountName `
    --auth-mode login

