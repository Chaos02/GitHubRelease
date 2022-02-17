<#
.SYNOPSIS
Create GitHub releases through a script.
.DESCRIPTION
Uses the GitHub API to create releases, complete with changelog etc.
.PARAMETER debug
Turns on PowerShell debugging mode.
.PARAMETER Token
Mandatory. Generate on https://github.com/settings/tokens with full Repo access.
.PARAMETER ProjectID
Mandatory. Provide the ProjectID of your project on CurseForge as a string.
.PARAMETER File
Mandatory. Provide the path to the file to be uploaded to the project.
.PARAMETER GameVersions
Mandatory. Provide a string array of supported game Versions. See 
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
	[Parameter(Mandatory)][string]$Token=(Get-Content -Raw -Path ((Split-Path -Parent $PSScriptRoot) + '/GitHub_token.key')),
	[Parameter(Mandatory)][string]$Owner,
	[Parameter(Mandatory)][string]$Repo,
	[Parameter(Mandatory)][string]$File,
	[Parameter(Mandatory)][string[]]$GameVersions,
	[switch]$PreRelease=$false,
	[switch]$Draft=$false,
	[string]$ChangeLog='',
	[switch]$GenReleaseNotes=$true
)

if ($DebugPreference) {
	Set-PSDebug -Trace 2
}

$Body = @{
	'accept' 		= 'application/vnd.github.v3+json'
	'owner' 			= "$Owner"
	'repo' 			= "$Repo"
	'tag_name' 		= "$TagName"
	'name' 			= "$File"
	'body' 			= "$ChangeLog"
	'draft' 			= $Draft
	'prerelease' 	= $PreRelease
	'genereate_release_notes' = $GenReleaseNotes;
}

curl -u $Owner:$Token -X POST -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/$Owner/$Repo/releases -d "{$Body}"

