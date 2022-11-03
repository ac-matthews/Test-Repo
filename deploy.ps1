$rg = Get-AzResourceGroup
$rgname = $rg.ResourceGroupName
$location = $rg.Location
Set-AzDefault -ResourceGroupName $rgname

$testcred = 'Hellobye12345!'

$randomgen = $TokenSet = @{
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
  -VaultName CoreVaultQualExercise104 `
  -resourceGroupName $rgname `
  -Location $location `
  -EnabledForTemplateDeployment
$secretvalue = ConvertTo-SecureString $testcred -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "CoreVaultQualExercise104" -Name 'username' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString $testcred -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "CoreVaultQualExercise104" -Name 'password' -SecretValue $secretvalue

$username = Get-AzKeyVaultSecret -VaultName "CoreVaultQualExercise104" -Name "username" -AsPlainText
$password = Get-AzKeyVaultSecret -VaultName "CoreVaultQualExercise104" -Name "password" -AsPlainText

Write-Output 'CoreVM username =' $username
Write-Output 'CoreVM password =' $password

New-AzResourceGroupDeployment -TemplateFile main.bicep