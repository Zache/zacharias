$env:Path += ";$((get-itemproperty HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\4.0).MSBuildToolsPath)"
$env:path += ";C:\ProgramFiles (x86)\Git\bin;"

# RemoteX Specific

$env:path += ";C:\src\samples\commands;C:\src\configurations\publicscripts;C:\src\configurations\datacenter;C:\src\configurations\customizationscripts;"

Set-Location "C:\src\"

# remove stupid curl alias
rm alias:curl
Set-Alias subl 'C:\Program Files\Sublime Text 3\subl.exe'


#PSUnit: Defining functions to set debug options
function Set-DebugMode()
{
    $Global:DebugPreference = "Continue"
    set-strictmode -version Latest
}

function Set-ProductionMode()
{
    $Global:DebugPreference = "SilentlyContinue"
    set-strictmode -Off
}

function gs() { git status }
function gpr() { git pull --rebase }
function gsu() { git submodule update } 
function gsi() { git submodule update --init } 

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "C:\tools\poshgit\dahlbyk-posh-git-869d4c5\posh-git.psm1"

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Enable-GitColors

Pop-Location

Start-SshAgent -Quiet
