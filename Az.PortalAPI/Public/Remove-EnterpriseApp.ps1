function Remove-EnterpriseApp {
    <#
    .SYNOPSIS
    Delete an Enterprise App in your Azure AD Tenant
    #>
        [CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]
        param (
            #The Id of the gallery app to delete
            [Parameter(Mandatory,ValueFromPipelineByPropertyName)]$objectID
        )

        process {
            foreach ($objectIDItem in $objectID) {
                $InvokeRequestParams = @{
                    Target = "ManagedApplications"
                    #API Quirk: Fails with invalid method if isOnPremApp is not specified. Doesn't work with Invoke-Restmethod in the body either, has to be in the URL
                    Action = "$objectIDItem" + "?isOnPremApp=false"
                    Method = "DELETE"
                }

                $result = Invoke-Request @InvokeRequestParams -Confirm:$true
                return $result
            }
        }
    }