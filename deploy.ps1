$rg = Get-AzResourceGroup
$rgname = $rg.ResourceGroupName
$location = $rg.Location
Set-AzDefault -ResourceGroupName $rgname

$password = $TokenSet = @{
    U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
    N = [Char[]]'0123456789'
    S = [Char[]]'!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
}

$Upper = Get-Random -Count 5 -InputObject $TokenSet.U
$Lower = Get-Random -Count 5 -InputObject $TokenSet.L
$Number = Get-Random -Count 5 -InputObject $TokenSet.N
$Special = Get-Random -Count 5 -InputObject $TokenSet.S

$StringSet = $Upper + $Lower + $Number + $Special

(Get-Random -Count 15 -InputObject $StringSet) -join ''

New-AzKeyVault `
  -VaultName CoreVault124578 `
  -resourceGroupName $rgname `
  -Location $location `
  -EnabledForTemplateDeployment
$secretvalue = ConvertTo-SecureString "hVFkk965BuUv" -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "CoreVault124578" -Name $password -SecretValue $secretvalue

Write-Output $password

# New-AzResourceGroupDeployment -TemplateFile main.bicep