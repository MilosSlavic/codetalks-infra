
# Available Locations
# az account list-locations --query "[].name" -o json | Sort

$AZ_Location="westeurope"
$AZ_ResourceGroupName="codetalks-terraform-rg"
$AZ_StorageAccountName="codetalksterraformsa"

az group create `
    --name $AZ_ResourceGroupName `
    --location $AZ_Location

az storage account create `
    --name $AZ_StorageAccountName `
    --resource-group $AZ_ResourceGroupName `
    --location $AZ_Location `
    --sku Standard_LRS `
    --encryption-services blob

az role assignment create `
    --role "Storage Blob Data Contributor" `
    --assignee "milos.slavic@seavus.com" `
    --scope "/subscriptions/$Env:ARM_SUBSCRIPTION_ID/resourceGroups/$AZ_ResourceGroupName/providers/Microsoft.Storage/storageAccounts/$AZ_StorageAccountName/blobServices/default/containers/tfplan"

az storage container create `
    --name tfplan `
    --account-name $AZ_StorageAccountName `
    --auth-mode login

