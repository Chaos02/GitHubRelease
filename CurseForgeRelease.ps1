<#
.SYNOPSIS
Upload to existing CurseForge projects through a script
.DESCRIPTION
Uses the CurseForge API to upload files to an existing project, complete with changelog etc.
.PARAMETER debug
Turns on PowerShell debugging mode.
.PARAMETER APIKey
Mandatory. Generate on https://authors.curseforge.com/account/api-tokens.
.PARAMETER ProjectID
Mandatory. Provide the ProjectID of your project on CurseForge as a string.
.PARAMETER File
Mandatory. Provide the path to the file to be uploaded to the project.
.PARAMETER GameVersions
Mandatory. Provide a string array of supported game Versions. See https://support.curseforge.com/en/support/solutions/articles/9000197321-curseforge-upload-api#:~:text=JavaScript-,Game%20Versions%20API,-To%20retrieve%20a
.PARAMETER ChangeLogType
Provide the type of changelog: One of "text", "html", "markdown".
Default: 'text'
.PARAMETER ReleaseType
Provide the type of release: One of "alpha", "beta", "release".
Default: 'release'
.PARAMETER ChangeLog
Provide a String of change notes.
#>

param(
	[Parameter(Mandatory)][string]$APIKey,
	[Parameter(Mandatory)][string]$ProjectID,
	[Parameter(Mandatory)][string]$File,
	[Parameter(Mandatory)][string[]]$GameVersions,
	[string]$ChangeLogType='text',
	[string]$ReleaseType='release',
	[string]$ChangeLog=''
)

if ($DebugPreference) {
	Set-PSDebug -Trace 2
}

# Documentation: https:#support.curseforge.com/en/support/solutions/articles/9000197321-curseforge-upload-api
$metadata= @{
	changelog: "$ChangeLog", # Can be HTML or markdown if changelogType is set.
	changelogType: "$ChangeLogType", # Optional: defaults to text
	displayName: '', # Optional: A friendly display name used on the site if provided.
	parentFileID: '', # Optional: The parent file of this file.
	gameVersions: "$GameVersions", # A list of supported game versions, see the Game Versions API for details. Not supported if parentFileID is provided.
	releaseType: "$ReleaseType", # One of "alpha", "beta", "release".
	relations: {} <#
		projects: [{
			slug: "mantle", # Slug of related plugin.
			type: ["embeddedLibrary", "incompatible", "optionalDependency", "requiredDependency", "tool"] # Choose one
		}]
	} # Optional: An array of project relations by slug and type of dependency for inclusion in your project. #>
}

Write-Host -BackgroundColor DarkCyan ($metadata | Format-List | Out-String)
$postParams = @{metadata="$metadata";file=(Get-Content -Raw -Path $File)}
Invoke-WebRequest -Uri /api/projects/$projectId/upload-file -Method POST -Body $postParams
