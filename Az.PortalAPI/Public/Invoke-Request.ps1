function Invoke-Request {
    <#
    .SYNOPSIS
        Runs a command against the Azure Portal API
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        #The target of your request. This is appended to the Portal API URI. Example: Permissions
        [Parameter(Mandatory)]$Target,

        #The command you wish to execute. Example: GetUserSystemRoleTemplateIds
        [Parameter()]$Action,

        #The body of your request. This is usually in JSON format
        $Body,

        #Specify the HTTP Method you wish to use. Defaults to GET
        [ValidateSet("GET","POST","OPTIONS","DELETE")]
        $Method = "GET",

        #Your Azure Context. This will be discovered automatically if you have already logged in with Connect-AzAccount
        [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]
        $Context = (Get-AzContext | select -first 1),

        #Your Access token. By default this is discovered from your Azure Context.
        $apiToken = (Get-Token),

        #The base URI for the Portal API. Typically you don't need to change this
        [Uri]$baseURI = 'https://main.iam.ad.ext.azure.com/api/',

        [URI]$requestOrigin = 'https://iam.hosting.portal.azure.net',

        #The request ID for the session. You can generate one with [guid]::NewGuid().guid.
        #Typically you only specify this if you're trying to retry an operation and don't want to duplicate the request, such as for a POST operation
        $requestID = [guid]::NewGuid().guid
    )

    #Combine the BaseURI and Target
    [String]$ApiAction = $Target

    if ($Action) {
        $ApiAction = $ApiAction + '/' + $Action
    }

    $InvokeRestMethodParams = @{
        Uri = [Uri]::New($baseURI,$ApiAction)
        Method = $Method
        Header = [ordered]@{
            Authorization = 'Bearer ' + $apiToken.AccessToken.tostring()
            'Content-Type' = 'application/json'
            'x-ms-client-request-id' = $requestID
            'Host' = $baseURI.Host
            'Origin' = 'https://iam.hosting.portal.azure.net'
        }
        Body = $Body
    }

    #Only care about Whatif for POST and DELETE. Other commands don't change data
    if ($Method -match "POST|DELETE") {
        $shouldProcessMessage = $METHOD
        if ($action) {$shouldProcessMessage = $shouldProcessMessage,$action -join ' '}
        if ($body) {$shouldProcessMessage = $shouldProcessMessage,$body -join ': '}

        if ($PSCmdlet.ShouldProcess($target,$shouldProcessMessage)) {
            Invoke-RestMethod @InvokeRestMethodParams
        }
    } else {
        Invoke-RestMethod @InvokeRestMethodParams
    }
}
