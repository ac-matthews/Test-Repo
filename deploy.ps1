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
$sqluser1 = (Get-Random -Count 12 -InputObject $StringSet) -join ''
$sqlpassword1 = (Get-Random -Count 14 -InputObject $StringSetSpecial) -join ''
$sqluser2 = (Get-Random -Count 12 -InputObject $StringSet) -join ''
$sqlpassword2 = (Get-Random -Count 14 -InputObject $StringSetSpecial) -join ''
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
$secretvalue = ConvertTo-SecureString $sqluser1 -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $kvName -Name 'sqluser1' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $sqlpassword1 -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $kvName -Name 'sqlpassword1' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $sqluser2 -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $kvName -Name 'sqluser2' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $sqlpassword2 -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $kvName -Name 'sqlpassword2' -SecretValue $secretvalue

$username = Get-AzKeyVaultSecret -VaultName $kvName -Name "username" -AsPlainText
$password = Get-AzKeyVaultSecret -VaultName $kvName -Name "password" -AsPlainText
$sqlusernamedev = Get-AzKeyVaultSecret -VaultName $kvName -Name "sqlusernamedev"
$sqlpassworddev = Get-AzKeyVaultSecret -VaultName $kvName -Name "sqlpassworddev"
$sqlusernameprod = Get-AzKeyVaultSecret -VaultName $kvName -Name "sqlusernameprod"
$sqlpasswordprod = Get-AzKeyVaultSecret -VaultName $kvName -Name "sqlpasswordprod"

Write-Output 'CoreVM username =' $username
Write-Output 'CoreVM password =' $password
Write-Output 'SQL dev username =' $sqlusernamedev
Write-Output 'SQL dev password =' $sqlpassworddev
Write-Output 'SQL prod username =' $sqlusernameprod
Write-Output 'SQL prod password =' $sqlpasswordprod

New-AzResourceGroupDeployment -TemplateFile main.bicep -kvname "$kvName"