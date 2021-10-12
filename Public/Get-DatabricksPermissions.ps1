<#

.SYNOPSIS
    Gets permissions applied to objects

.DESCRIPTION
    Gets permissions applied to objects

.PARAMETER BearerToken
    Your Databricks Bearer token to authenticate to your workspace (see User Settings in Databricks WebUI)

.PARAMETER Region
    Azure Region - must match the URL of your Databricks workspace, example northeurope

.PARAMETER DatabricksObjectType
    Job, Cluster, secretScope or Instance-pool

.PARAMETER DatabricksObjectId
    JobId, ClusterId, secretScope or Instance-poolId

.EXAMPLE 
    C:\PS> Get-DatabricksPermission -BearerToken $BearerToken -Region $Region -DatabricksObjectType 'Cluster' -DatabricksObjectId "test-cluster"

    This gets the permissions for the cluster 'test-cluster'

.NOTES
    Author: Niall Langley

#>
Function Get-DatabricksPermissions
{
    [cmdletbinding()]
    param (
        [parameter(Mandatory=$false)][string]$BearerToken,
        [parameter(Mandatory=$false)][string]$Region,
        [Parameter(Mandatory=$true)][ValidateSet('job','cluster','instance-pool', 'secretScope')][string]$DatabricksObjectType,
        [Parameter(Mandatory=$true)][string]$DatabricksObjectId
    )

    $Headers = GetHeaders $PSBoundParameters

    if ($DatabricksObjectType -eq "secretScope"){
        $URI = "$global:DatabricksURI/api/2.0/secrets/acls/list"
        
        $Response = Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers
    }
    else {
        $BasePath = "$global:DatabricksURI/api/2.0/preview"
        $URI =  "$BasePath/permissions/$DatabricksObjectType" + "s/$DatabricksObjectId"

        $Response = Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers
    }
    
    return $Response
}
