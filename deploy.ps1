$rg = Get-AzResourceGroup
$rgname = $rg.ResourceGroupName
$location = $rg.Location
Set-AzDefault -ResourceGroupName $rgname

$TokenSet = @{
    U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
    N = [Char[]]'0123456789'
    S = [Char[]]'#+!'
}

$Upper = Get-Random -Count 5 -InputObject $TokenSet.U
$Lower = Get-Random -Count 5 -InputObject $TokenSet.L
$Number = Get-Random -Count 5 -InputObject $TokenSet.N
$Special = Get-Random -Count 5 -InputObject $TokenSet.S

$StringSetSpecial = $Upper + $Lower + $Number + $Special
$StringSet = $Upper + $Lower + $Number

$randomvmuser = (Get-Random -Count 12 -InputObject $StringSet) -join ''
$randomvmpassword = (Get-Random -Count 14 -InputObject $StringSetSpecial) -join ''
$sqluser1 = (Get-Random -Count 12 -InputObject $StringSet) -join ''
$sqlpassword1 = (Get-Random -Count 14 -InputObject $StringSetSpecial) -join ''
$sqluser2 = (Get-Random -Count 12 -InputObject $StringSet) -join ''
$sqlpassword2 = (Get-Random -Count 14 -InputObject $StringSetSpecial) -join ''
$keyvaultNameRandom = (Get-Random -Count 12 -InputObject $StringSet) -join ''
$keyvaultName = 'kv-core-' + $keyvaultNameRandom

New-AzKeyVault `
  -VaultName $keyvaultName `
  -resourceGroupName $rgname `
  -Location $location `
  -EnabledForTemplateDeployment
$secretvalue = ConvertTo-SecureString $randomvmuser -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $keyvaultName -Name 'username' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $randomvmpassword -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $keyvaultName -Name 'password' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $sqluser1 -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $keyvaultName -Name 'sqluser1' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $sqlpassword1 -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $keyvaultName -Name 'sqlpassword1' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $sqluser2 -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $keyvaultName -Name 'sqluser2' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $sqlpassword2 -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $keyvaultName -Name 'sqlpassword2' -SecretValue $secretvalue

$username = Get-AzKeyVaultSecret -VaultName $keyvaultName -Name "username" -AsPlainText
$password = Get-AzKeyVaultSecret -VaultName $keyvaultName -Name "password" -AsPlainText
$sqlusernamedev = Get-AzKeyVaultSecret -VaultName $keyvaultName -Name "sqluser1" -AsPlainText
$sqlpassworddev = Get-AzKeyVaultSecret -VaultName $keyvaultName -Name "sqlpassword1" -AsPlainText
$sqlusernameprod = Get-AzKeyVaultSecret -VaultName $keyvaultName -Name "sqluser2" -AsPlainText
$sqlpasswordprod = Get-AzKeyVaultSecret -VaultName $keyvaultName -Name "sqlpassword2" -AsPlainText

Write-Output 'CoreVM username =' $username
Write-Output 'CoreVM password =' $password
Write-Output 'SQL dev username =' $sqlusernamedev
Write-Output 'SQL dev password =' $sqlpassworddev
Write-Output 'SQL prod username =' $sqlusernameprod
Write-Output 'SQL prod password =' $sqlpasswordprod

New-AzResourceGroupDeployment -TemplateFile main.bicep -kvname "$keyvaultName"

Get-AzRecoveryServicesVault `
    -Name "coreRecoveryVault" | Set-AzRecoveryServicesVaultContext

$backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName "vmcoredc1"

$item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"

Backup-AzRecoveryServicesBackupItem -Item $item