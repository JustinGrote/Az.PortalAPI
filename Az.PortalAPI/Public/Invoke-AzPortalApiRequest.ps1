function Invoke-AzPortalApiRequest {
    <#
    .SYNOPSIS
        Runs a command against the Azure Portal API
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        #The target of your request. This is appended to the Portal API URI. Example: GalleryApplications/galleryApplications
        [Parameter(Mandatory)]$Target,

        #The body of your request. This is usually in JSON format
        $Body,

        #Specify the HTTP Method you wish to use. Defaults to GET
        [ValidateSet("GET","POST","OPTIONS")]
        $Method = "GET",

        #Your Azure Context. This will be discovered automatically if you have already logged in with Connect-AzAccount
        [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]
        $Context = (Get-AzContext | select -first 1),

        #Your Access token. By default this is discovered from your Azure Context.
        $apiToken = (Get-AzApiToken),

        #The base URI for the Portal API. Typically you don't need to change this
        [Uri]$baseURI = 'https://main.iam.ad.ext.azure.com/api/'
    )

    $InvokeRestMethodParams = @{
        #Combine the BaseURI and Target
        Uri = [Uri]::New($baseURI,$Target)
        Method = "POST"
        Header = [ordered]@{
            Authorization = 'Bearer ' + $apiToken.AccessToken.tostring()
            'Content-Type' = 'application/json'
        }
        Body = $Body
    }

    if ($PSCmdlet.ShouldProcess($target,"$METHOD - $Body")) {
        Invoke-RestMethod @InvokeRestMethodParams
    }
}
