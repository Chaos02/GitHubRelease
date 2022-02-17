<#
.SYNOPSIS
Create GitHub releases through a script.
.DESCRIPTION
Uses the GitHub API to create releases, complete with changelog etc.
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

