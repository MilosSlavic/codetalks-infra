az group create `
    --name codetalks-proto `
    --location westeurope

az storage account create `
    --name codetalksprotostorage `
    --resource-group codetalks-proto `
    --location westeurope `
    --kind StorageV2 `
    --sku Standard_LRS `
    --enable-large-file-share

az storage share-rm create `
    --name protoshare `
    --storage-account codetalksprotostorage `
    --resource-group codetalks-proto `
    --access-tier Hot `
    --enabled-protocols SMB `
    --quota 10