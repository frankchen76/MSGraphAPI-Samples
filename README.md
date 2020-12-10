# Introduction 
Samples for MS Graph API access

# Client Credential with Cert
## Description
This ps demonstrated how to access MS Graph API with certificate. As Client Credential with Cert flow requires to generate clientAssertion for token request, we used Microsoft.IdentityModel.JsonWebTokens.dll, Microsoft.IdentityModel.Logging.dll and Microsoft.IdentityModel.Tokens.dll to generate that. 

## Instrucuture
* download all the files from "ClientCredentialWithCert" folder including "DLL" folder
* Update CallMSGraphAPI-ClientCredentialWithCert.ps1 for the following: 
* * $tenantId: Tenant Id
* * $clientId: AAD App client id. 
* * $certPath: the .pfx certificate path. 
* * $graphAPIUrl: update the graph api to your need. 
* Run below script to test
  ```PowerShell
  .\CallMSGraphAPI-ClientCredentialWithCert.ps1
  ```

