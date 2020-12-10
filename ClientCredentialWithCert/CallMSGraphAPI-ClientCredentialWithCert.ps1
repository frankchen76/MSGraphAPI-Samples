# OAuth 2.0 Client Credential Auth flow Application permission 
$tenantId = "[tenant-id]";
$clientId = "[client id]"
$certPath = "[.pfx path]"

$clientAssertionType = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
$grantType = "client_credentials"
$scope = "https://graph.microsoft.com/.default"
$tokenUrl = [System.String]::Format("https://login.microsoftonline.com/{0}/oauth2/v2.0/token", $tenantId)

## generate JWT Assertion
$scriptFullPath = $MyInvocation.MyCommand.Path
$scriptPath = Split-Path $scriptFullPath

Add-Type -Path $([System.String]::Format("{0}\DLL\Microsoft.IdentityModel.Tokens.dll", $scriptPath ))
Add-Type -Path $([System.String]::Format("{0}\DLL\Microsoft.IdentityModel.JsonWebTokens.dll", $scriptPath ))
Add-Type -Path $([System.String]::Format("{0}\DLL\Microsoft.IdentityModel.Logging.dll", $scriptPath ))

$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate -ArgumentList ($certPath, "2020", [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::DefaultKeySet)

$aud = [System.String]::Format("https://login.microsoftonline.com/{0}/oauth2/token", $tenantId);

## no need to add exp, nbf as JsonWebTokenHandler will add them by default.
$claims = New-Object "System.Collections.Generic.Dictionary[[String],[Object]]"
$claims.Add("aud", $aud)
$claims.Add("iss", $clientId)
$claims.Add("jti", [System.Guid]::NewGuid().ToString())
$claims.Add("sub", $clientId)

$securityTokenDescriptor = New-Object Microsoft.IdentityModel.Tokens.SecurityTokenDescriptor
$securityTokenDescriptor.Claims = $claims
$securityTokenDescriptor.SigningCredentials = New-Object Microsoft.IdentityModel.Tokens.X509SigningCredentials -ArgumentList ($cert)

$handler = New-Object Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler
$signedClientAssertion = $handler.CreateToken($securityTokenDescriptor)
$signedClientAssertion

$body = [System.String]::Format("client_id={0}&client_assertion_type={1}&client_assertion={2}&grant_type={3}&scope={4}", $clientId, $clientAssertionType, $signedClientAssertion, $grantType, $scope)

$tokenResult = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $body -ContentType "application/x-www-form-urlencoded"

$headers = @{
    'Authorization' = 'Bearer ' + $tokenResult.access_token
    'ContentType'   = 'application/json'
    'Accept'        = 'application/json'
}
$graphAPIUrl = "https://graph.microsoft.com/v1.0/users/frank@m365x725618.onmicrosoft.com"
Invoke-RestMethod -Uri $graphAPIUrl -Method Get -Headers $headers | fl
