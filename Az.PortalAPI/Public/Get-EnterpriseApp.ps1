function Get-EnterpriseApp {
    [CmdletBinding()]
    param (
        #Filter by display name or application ID
        [String]$Filter,
        #Set the result size. Default is first 50 results
        [int]$ResultSize=50
    )

    $InvokeApiRequestParams = @{
        Target = "ManagedApplications"
        Action = "List"
        Method = "POST"
        Body = ConvertTo-jSON @{
            appListQuery=0
            top=$resultSize
            searchtext=$Filter
        }
    }

    $result = Invoke-Request @InvokeApiRequestParams
    return $result.appList
}