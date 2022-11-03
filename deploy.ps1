$rg = Get-AzResourceGroup
$rgname = $rg.ResourceGroupName
$location = $rg.Location
Set-AzDefault -ResourceGroupName $rgname

$randomgen = $TokenSet = @{
    U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
    N = [Char[]]'0123456789'
    S = [Char[]]'!#'
}

$Upper = Get-Random -Count 5 -InputObject $TokenSet.U
$Lower = Get-Random -Count 5 -InputObject $TokenSet.L
$Number = Get-Random -Count 5 -InputObject $TokenSet.N
$Special = Get-Random -Count 5 -InputObject $TokenSet.S

$StringSetSpecial = $Upper + $Lower + $Number + $Special
$StringSet = $Upper + $Lower + $Number

$randomvmuser = (Get-Random -Count 12 -InputObject $StringSet) -join ''
$randomvmpassword = (Get-Random -Count 14 -InputObject $StringSetSpecial) -join ''
$kvNameRandom = (Get-Random -Count 12 -InputObject $StringSet) -join ''
$kvName = 'kv-core-' + $kvNameRandom

New-AzKeyVault `
  -VaultName $kvName `
  -resourceGroupName $rgname `
  -Location $location `
  -EnabledForTemplateDeployment
$secretvalue = ConvertTo-SecureString $randomvmuser -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $kvName -Name 'username' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $randomvmpassword -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $kvName -Name 'password' -SecretValue $secretvalue

$username = Get-AzKeyVaultSecret -VaultName $kvName -Name "username" -AsPlainText
$password = Get-AzKeyVaultSecret -VaultName $kvName -Name "password" -AsPlainText

Write-Output 'CoreVM username =' $username
Write-Output 'CoreVM password =' $password

New-AzResourceGroupDeployment -TemplateFile main.bicep -kvname "$kvName"