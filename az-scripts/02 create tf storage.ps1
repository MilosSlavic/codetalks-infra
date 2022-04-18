
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
    --sku Standard_LRS


