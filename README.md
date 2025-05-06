# PowerShell Bulk File Renamer

A robust script for batch renaming files with natural number sorting and customizable naming patterns.

## Overview

This script allows users to rename multiple files while maintaining consistent naming conventions with sequential numbering. Key features include natural number sorting, customizable counter formats, multiple sorting criteria, and a safety preview system.

## Features

- **Natural Number Sorting**  
  Properly sorts files containing numbers (e.g., `file1`, `file2`, ... `file10`)
- **Custom Number Formatting**  
  Supports configurable counter digits (e.g., 001, 0001) and zero-based numbering
- **Multiple Sorting Methods**
  - File name (with natural numeric sorting)
  - Creation date
  - Modification date
  - Random order
- **Preview Mode**  
  - Shows rename preview before applying changes
- **Safety Features**
  - No direct overwrites
  - Input validation
  - Error handling
- **Cross-Platform**  
  Works on Windows PowerShell and PowerShell Core (Linux/macOS)

## Prerequisites

- PowerShell 5.1 or later
- PowerShell Core 7+ for non-Windows systems

## Usage

1. **Clone/Save the Script**
   ```powershell
   git clone https://github.com/donrusthol/BulkRenamer.git
   cd BulkRenamer
   
2. **Run the Script**
   ```powershell
   ./BulkRenamer.ps1
   
3. **Follow Prompts**
   ```
   Enter directory path (default: current location):
   Enter base name for files (e.g., 'Vacation_Photo'):
   Include sequential counter? (Y/N):
   Number of digits for counter (default: 3): 
   Select sorting criteria (1-4):
   Sort order (A)scending/D)escending):
   Enter starting number (default: 1):
   ```

4. **Example Transformation (base name prompt: "renamed_picture_")**  
   Original Files:
   ```
   Example picture 0.jpg
   Example picture 1.jpg
   ...
   Example picture 100.jpg
   ```
   Renamed Files:
   ```
   renamed_picture_000.jpg
   renamed_picture_001.jpg
   ...
   renamed_picture_100.jpg
   ```

## Parameters

| Prompt | Description | Default | Validation |
|--------|-------------|---------|------------|
| Directory Path | Target folder containing files | Current directory | Must exist |
| Base Name | Common filename prefix | - | Required input |
| Counter Inclusion | Add sequential numbering | Y/N | Boolean |
| Counter Digits | Number padding length | 3 | 1-10 digits |
| Sorting Criteria | Ordering method:<br>1. Name<br>2. Created<br>3. Modified<br>4. Random | 1 | 1-4 |
| Sort Order | Ascending/Descending | Ascending | A/D |
| Starting Number | Initial counter value | 1 | ≥0 integer |

## Limitations

- Preserves original file extensions
- Doesn't modify file timestamps
- Maximum filename length determined by OS limits
- Potential conflicts if new names already exist

---

**Disclaimer:** Always verify backups before batch operations. The author is not responsible for data loss.
