# Windows: bootstrap with the Rust compiler, then let halppp rebuild itself.
# Needs cargo and a g++-compatible compiler on PATH (e.g. MinGW-w64 / MSYS2).
# Set HALPPP_CXX (or CXX) to choose the C++ compiler, HALPPP_LIB for the library folder.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

function Invoke-Checked([string]$exe, [string[]]$arguments) {
    & $exe @arguments
    if ($LASTEXITCODE -ne 0) { throw "$exe failed with exit code $LASTEXITCODE" }
}

Invoke-Checked "cargo" @("run", "--", "main.ha")
# A running .exe can't overwrite itself on Windows, so rebuild from a copy
foreach ($i in 1..2) {
    Copy-Item -Force "main.exe" "main-stage.exe"
    Invoke-Checked ".\main-stage.exe" @("main.ha", "-r")
}
Remove-Item -Force "main-stage.exe"

$lib = if ($env:HALPPP_LIB) { $env:HALPPP_LIB } else { Join-Path $env:USERPROFILE ".local\lib\halppp" }
New-Item -ItemType Directory -Force $lib | Out-Null
Copy-Item -Recurse -Force "..\lib\*" $lib
