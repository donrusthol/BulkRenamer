<#
.SYNOPSIS
Bulk file renamer with configurable naming format and sorting options

.DESCRIPTION
Allows users to rename multiple files with a consistent naming pattern,
including sequential numbering and various sorting options.
#>

# Get directory path
$directory = Read-Host "Enter directory path (default: current location)"
if (-not $directory) { $directory = Get-Location }
if (-not (Test-Path $directory)) {
    Write-Host "Directory does not exist!" -ForegroundColor Red
    exit
}

# Get all files in the directory
$files = Get-ChildItem -Path $directory -File

# Show file count and exit if no files
if ($files.Count -eq 0) {
    Write-Host "No files found in the directory!" -ForegroundColor Red
    exit
}
Write-Host "Found $($files.Count) files in directory" -ForegroundColor Cyan

# Get naming parameters
$baseName = Read-Host "Enter base name for files (e.g., 'Vacation_Photo')"
$includeCounter = Read-Host "Include sequential counter? (Y/N)"
$counterDigits = 3  # default to 3-digit counter
if ($includeCounter -eq 'Y') {
    $counterDigits = [int](Read-Host "Number of digits for counter (default: 3)")
    if (-not $counterDigits) { $counterDigits = 3 }
}

# Get sorting options
Write-Host "`nSorting options:"
Write-Host "1) Name"
Write-Host "2) Creation Time"
Write-Host "3) Last Write Time"
Write-Host "4) Random"
$sortChoice = Read-Host "Select sorting criteria (1-4)"
$sortOrder = Read-Host "Sort order (A)scending/D)escending)"

# Get starting number for counter
do {
    $startInput = Read-Host "Enter starting number (default: 1)"
    if ([string]::IsNullOrWhiteSpace($startInput)) {
        $startNumber = 1
        break
    }
    try {
        $startNumber = [int]$startInput
        if ($startNumber -lt 0) {
            throw "Negative number"
        }
        break
    }
    catch {
        Write-Host "Invalid input! Please enter a positive integer or zero." -ForegroundColor Red
    }
} while ($true)

# Sorting section with natural number sort
switch ($sortChoice) {
    1 { 
        # Natural number sort for filenames
        $sorted = $files | Sort-Object { 
            # Extract numeric portion from filename using regex
            if ($_.BaseName -match '(\d+)(?!.*\d)') {
                [int]$matches[1]
            } else {
                0  # Fallback for files without numbers
            }
        }
     }
    2 { $sorted = $files | Sort-Object CreationTime }
    3 { $sorted = $files | Sort-Object LastWriteTime }
    4 { $sorted = $files | Get-Random -Count $files.Count }
}

# Apply sort order
if ($sortOrder -eq 'D' -and $sortChoice -ne 4) {
    $sorted = $sorted | Sort-Object -Descending
}

# Generate preview
Write-Host "`nPreview of changes:" -ForegroundColor Yellow
$counter = $startNumber
foreach ($file in $sorted) {
    $newName = $baseName
    
    if ($includeCounter -eq 'Y') {
        $counterString = $counter.ToString().PadLeft($counterDigits, '0')
        $newName += "$counterString"
        $counter++
    }
    
    $newName += $file.Extension
    Write-Host "$($file.Name) => $newName"
}

# Confirmation
$confirm = Read-Host "`nConfirm rename operation? (Y/N)"
if ($confirm -ne 'Y') {
    Write-Host "Operation cancelled" -ForegroundColor Yellow
    exit
}

# Perform rename
$counter = $startNumber
foreach ($file in $sorted) {
    $newName = $baseName
    
    if ($includeCounter -eq 'Y') {
        $counterString = $counter.ToString().PadLeft($counterDigits, '0')
        $newName += "$counterString"
        $counter++
    }
    
    $newName += $file.Extension
    $newPath = Join-Path -Path $directory -ChildPath $newName
    
    try {
        Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop
        Write-Host "Renamed: $newName" -ForegroundColor Green
    }
    catch {
        Write-Host "Error renaming $($file.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`nOperation completed!" -ForegroundColor Cyan