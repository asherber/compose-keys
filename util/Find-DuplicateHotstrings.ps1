<#
.SYNOPSIS
    Finds duplicate hotstring triggers in an AutoHotkey v2 hotstring definition file.

.DESCRIPTION
    Reads a file containing lines of the form:
        ::trigger::SomeReplacementOrCall()   ; optional comment
    Extracts the trigger (the text between the first "::" and the next "::"),
    and reports any triggers that appear more than once, including line numbers.

.PARAMETER Path
    Path to the .ahk file to scan.

.EXAMPLE
    .\Find-DuplicateHotstrings.ps1 -Path .\keys.ahk

.EXAMPLE
    .\Find-DuplicateHotstrings.ps1 .\keys.ahk
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path
)

if (-not (Test-Path -LiteralPath $Path)) {
    Write-Error "File not found: $Path"
    exit 1
}

# Matches lines like: ::trigger::rest
# Trigger = everything between the first '::' and the LAST '::' on the line (greedy).
# Greedy matching is required because AHK hotstrings can escape a literal colon
# inside the trigger using a backtick (e.g. ::-`:::cp("÷")  -> trigger is  -`: ).
# A non-greedy match would stop at that escaped colon instead of the real
# closing delimiter. Greedy assumes the replacement/comment portion of the
# line doesn't itself contain "::", which holds for typical cp(...)/comment text.
$pattern = '^\s*::(.+)::'

$entries = @()
$lineNum = 0

Get-Content -LiteralPath $Path | ForEach-Object {
    $lineNum++
    $line = $_

    $match = [regex]::Match($line, $pattern)
    if ($match.Success) {
        $trigger = $match.Groups[1].Value
        $entries += [PSCustomObject]@{
            Trigger = $trigger
            LineNumber = $lineNum
            Line = $line.Trim()
        }
    }
}

if ($entries.Count -eq 0) {
    Write-Host "No hotstring definitions found in '$Path'."
    exit 0
}

Write-Host "Scanned $($entries.Count) hotstring definition(s) in '$Path'." -ForegroundColor Cyan

$duplicateGroups = $entries | Group-Object -Property Trigger -CaseSensitive | Where-Object { $_.Count -gt 1 }

if ($duplicateGroups.Count -eq 0) {
    Write-Host "No duplicate triggers found." -ForegroundColor Green
    exit 0
}

Write-Host "`nFound $($duplicateGroups.Count) duplicate trigger(s):" -ForegroundColor Yellow

foreach ($group in $duplicateGroups) {
    Write-Host "`nTrigger: '$($group.Name)'  (appears $($group.Count) times)" -ForegroundColor Red
    foreach ($item in $group.Group) {
        Write-Host ("  Line {0,5}: {1}" -f $item.LineNumber, $item.Line)
    }
}

# Set an exit code so this can be used in CI (e.g., fail a build step on duplicates)
exit $duplicateGroups.Count