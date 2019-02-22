function Add-GalleryApp {
<#
.SYNOPSIS
Add an Enterprise Gallery App to the
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        #The Id of the gallery app to add
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]$ID,

        #What to name the app in your tenant. Defaults to the app's existing name
        $Name
    )

    $galleryApp = Get-GalleryApp -id $ID

    if ($GalleryApp) {
        if ($Name) {
            $displayName = $Name
        } else {
            $displayName = $galleryApp.displayName
        }

        $InvokeRequestParams = @{
            Target = "GalleryApplications"
            Action = "galleryApplications"
            Method = "POST"
            Body = ConvertTo-JSON @{
                displayname = $displayName
                id = $galleryApp.id
                appkey = $galleryApp.appkey
            }
        }

        $result = Invoke-Request @InvokeRequestParams
        return $result
    }


}