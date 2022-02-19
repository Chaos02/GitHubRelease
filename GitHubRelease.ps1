<#
.SYNOPSIS
Create GitHub releases through a script.
.DESCRIPTION
Uses the GitHub API to create releases, complete with changelog etc.
.PARAMETER debug
Turns on PowerShell debugging mode.
.PARAMETER Owner
(Mandatory) Owner name of the repository. Can also be supplied through -OwnRep.
.PARAMETER Repo
(Mandatory) Repository name. Can also be supplied through -OwnRep.
.PARAMETER OwnRep
(Mandatory) Meant to be supplied by GitHub Workflow Actions in format.
.PARAMETER Token
Mandatory. Generate on https://github.com/settings/tokens with full Repo access.
Either String or path to a file containing the token.
.PARAMETER File
Mandatory. Provide the path to the file to be uploaded to the project.
.PARAMETER TagName
Mandatory. Provide GitHub release tag.
.PARAMETER PreRelease
Create as a prerelease instead of regular release.
Default: 'false'
.PARAMETER Draft
Wether or not to make the release a draft rather than a regular release.
Default: 'false'
.PARAMETER ChangeLog
Provide a String of change notes that is prefixed to GitHub's automatic ones. See -GenReleaseNotes.
.PARAMETER GenReleaseNotes
Wether or not to auto generate release notes from commit messages.
Default: 'true'
#>

param(
	[CmdletBinding(DefaultParameterSetName = 'Manual')]

	[Parameter(Mandatory, ParameterSetName = 'Manual')][string]$Owner,
	[Parameter(Mandatory, ParameterSetName = 'Manual')][string]$Repo,
	[Parameter(Mandatory, ParameterSetName = 'Auto')][string]$OwnRep,
	[Parameter(Mandatory)][string]$Token,
	[Parameter(Mandatory)][string]$File,
	[Parameter(Mandatory)][string]$TagName,
	[switch]$PreRelease=$false,
	[switch]$Draft=$false,
	[string]$ChangeLog='',
	[switch]$GenReleaseNotes=$true
)

if ($DebugPreference) {
	Set-PSDebug -Trace 2
}

if ( $OwnRep ) {
	$OwnRep -match '.*(?=\/[^\/]*)' *>$Null
	$Owner = $Matches[0]
	$Matches.Clear()
	$OwnRep -match '(?<=[^\/]*\/).*' *>$Null
	$Repo = $Matches[0]
	$Matches.Clear()
} else {
	Write-Host 'Using Manual Repo information, pipe github.repository into $OwnRep for automatic.'
}

if ( Test-Path $Token -PathType Leaf ) {
	Write-Host 'Reading token from file: $Token'
	$Token = (Get-Content -Raw -Path ((Split-Path -Parent $PSScriptRoot) + '/' + $Token))
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

