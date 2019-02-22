function Get-GalleryApp {
    [CmdletBinding(DefaultParameterSetName="Filter")]
    param (
        #Search by Display Name
        [Parameter(Position=0,ParameterSetName="Filter")]
        [String]$Filter,

        #Specify a specific app
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName="ID")]
        [String]$ID
    )

    $SearchByID = $PSCmdlet.ParameterSetName -eq 'ID'

    $InvokeApiRequestParams = @{
        Target = "applications"
        Action = "gallery"
        Method = "GET"
        Body = @{
            searchtext=$Filter
        }
    }

    #Different behavior for ID search
    if ($SearchByID) {
        $InvokeApiRequestParams.Action = $InvokeApiRequestParams.Action + '/' + $ID
        $InvokeApiRequestParams.Body = $null
    }

    $result = Invoke-Request @InvokeApiRequestParams
    if ($SearchByID) {
        return $result
    } else {
        return $result.items
    }

}