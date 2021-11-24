[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, ParameterSetName = 'PersonAccessToken')]
    [Parameter(Mandatory=$true, ParameterSetName = 'SystemAccessToken')]
    [string]
    $OrganizationUri,

    [Parameter(Mandatory=$true, ParameterSetName = 'PersonAccessToken')]
    [Parameter(Mandatory=$true, ParameterSetName = 'SystemAccessToken')]
    [string]
    $Project,

    [Parameter(Mandatory=$true, ParameterSetName = 'PersonAccessToken')]
    [string]
    $PersonAccessToken,

    [Parameter(Mandatory=$true, ParameterSetName = 'SystemAccessToken')]
    [string]
    $SystemAccessToken,

    [Parameter(Mandatory=$true, ParameterSetName = 'PersonAccessToken')]
    [Parameter(Mandatory=$true, ParameterSetName = 'SystemAccessToken')]
    [string]
    $RepositoryId,

    [Parameter(Mandatory=$true, ParameterSetName = 'PersonAccessToken')]
    [Parameter(Mandatory=$true, ParameterSetName = 'SystemAccessToken')]
    [string]
    $PullRequestId,

    [Parameter(Mandatory=$true, ParameterSetName = 'PersonAccessToken')]
    [Parameter(Mandatory=$true, ParameterSetName = 'SystemAccessToken')]
    [string]
    $BuildId,

    [Parameter(Mandatory=$true, ParameterSetName = 'PersonAccessToken')]
    [Parameter(Mandatory=$true, ParameterSetName = 'SystemAccessToken')]
    [string]
    $CommentContent
)

try {
    $newThreadEndpoint = "$( $OrganizationUri )/$( $Project )/_apis/git/repositories/$( $RepositoryId )/pullRequests/$( $PullRequestId )/threads?api-version=6.0"
  
    if( $SystemAccessToken) {
        $header = @{
            Authorization = "Bearer $SystemAccessToken"
        }
    }else {
        $header = @{
            Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)")) 
        }
    }

    $newThread = @{
        Comments = @(
            @{
                ParentCommentId = 0
                Content         = $CommentContent
                CommentType     = "text"
            }
        )
        Status = "Active"
    } 

    $newThreadBody = $newThread | ConvertTo-Json -Depth 10

    $newThreadBody 

    $thread = Invoke-RestMethod -Uri $newThreadEndpoint -Headers $header -Method Post -Body $newThreadBody -ContentType 'application/json'

    $thread
}
catch {
    Get-Error
    Write-Error -Message "Failed to add PR comment"
}
