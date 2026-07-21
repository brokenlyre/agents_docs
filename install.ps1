# Installs the agent-docs-scaffold skill into %USERPROFILE%\.claude\skills
# (personal, default) or <project>\.claude\skills (with -ProjectPath <path>).
#
# Works two ways:
#   - Run locally after `git clone` (uses the skills\ folder next to this script)
#   - Run via irm | iex with no local clone (shallow-clones to a temp dir)
param(
    [string]$ProjectPath
)

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/brokenlyre/agents_docs.git"
$SkillName = "agent-docs-scaffold"

if ($ProjectPath) {
    $TargetDir = Join-Path $ProjectPath ".claude\skills"
} else {
    $TargetDir = Join-Path $env:USERPROFILE ".claude\skills"
}

$Src = $null
if ($PSScriptRoot) {
    $candidate = Join-Path $PSScriptRoot "skills\$SkillName"
    if (Test-Path $candidate) {
        $Src = $candidate
    }
}

$CleanupDir = $null
if (-not $Src) {
    Write-Host "Local skill source not found next to this script -- fetching from $RepoUrl..."
    $CleanupDir = Join-Path $env:TEMP ([System.Guid]::NewGuid())
    git clone --depth 1 --quiet $RepoUrl $CleanupDir
    $Src = Join-Path $CleanupDir "skills\$SkillName"
}

if (-not (Test-Path $Src)) {
    Write-Error "Could not locate $SkillName source. Aborting."
    if ($CleanupDir -and (Test-Path $CleanupDir)) { Remove-Item -Recurse -Force $CleanupDir }
    exit 1
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
$DestSkill = Join-Path $TargetDir $SkillName
if (Test-Path $DestSkill) { Remove-Item -Recurse -Force $DestSkill }
Copy-Item -Recurse -Force $Src $DestSkill

if ($CleanupDir -and (Test-Path $CleanupDir)) { Remove-Item -Recurse -Force $CleanupDir }

Write-Host "Installed $SkillName to $DestSkill"
if ($ProjectPath) {
    Write-Host "This is a project-scoped install -- commit it so teammates get it too:"
    Write-Host "  cd `"$ProjectPath`"; git add .claude/skills/$SkillName; git commit -m `"Add $SkillName skill`""
}
Write-Host "Open (or restart) a Claude Code session in the target repo and run /$SkillName to verify."
