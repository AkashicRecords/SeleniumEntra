using module MSAL.PS

class PowerShellAuth {
    [string]$ClientId
    [string]$ClientSecret
    [string]$TenantId
    [string[]]$Scopes
    [string]$Authority
    [Microsoft.Identity.Client.IConfidentialClientApplication]$App

    PowerShellAuth([string]$clientId, [string]$clientSecret, [string]$tenantId, [string[]]$scopes) {
        if ([string]::IsNullOrWhiteSpace($clientId) -or [string]::IsNullOrWhiteSpace($clientSecret) -or [string]::IsNullOrWhiteSpace($tenantId)) {
            throw "ClientId, ClientSecret, and TenantId must not be null or empty"
        }
        if ($scopes.Count -eq 0) {
            throw "At least one scope must be provided"
        }

        $this.ClientId = $clientId
        $this.ClientSecret = $clientSecret
        $this.TenantId = $tenantId
        $this.Scopes = $scopes
        $this.Authority = "https://login.microsoftonline.com/$tenantId"
        $this.App = [Microsoft.Identity.Client.ConfidentialClientApplicationBuilder]::Create($clientId).
            WithClientSecret($clientSecret).
            WithAuthority($this.Authority).
            Build()
    }

    [string] GetToken() {
        try {
            $result = $this.App.AcquireTokenForClient($this.Scopes).ExecuteAsync().GetAwaiter().GetResult()
            if ($result.AccessToken) {
                return $result.AccessToken
            } else {
                Write-Error "Error: AccessToken is null or empty"
                return $null
            }
        } catch {
            Write-Error "Error acquiring token: $($_.Exception.Message)"
            return $null
        }
    }

    [PSObject] MakeRequest([string]$url, [string]$method = 'GET', [hashtable]$body = $null, [hashtable]$headers = $null) {
        $token = $this.GetToken()
        if (-not $token) {
            Write-Error "Failed to acquire token"
            return $null
        }

        if (-not $headers) {
            $headers = @{}
        }
        $headers['Authorization'] = "Bearer $token"

        $params = @{
            Uri = $url
            Method = $method
            Headers = $headers
            ContentType = 'application/json'
        }

        if ($body) {
            $params['Body'] = $body | ConvertTo-Json -Depth 10
        }

        try {
            $response = Invoke-RestMethod @params
            return $response
        } catch {
            Write-Error "Error making request: $($_.Exception.Message)"
            Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"
            Write-Error "StatusDescription: $($_.Exception.Response.StatusDescription)"
            return $null
        }
    }
}

# Simple HTTP server
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:8080/")
$listener.Start()

Write-Host "PowerShell Auth service is running on port 8080"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $response = $context.Response
    $responseString = '{"message": "PowerShell Auth service is running"}'
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseString)
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.Close()
}

$listener.Stop()
