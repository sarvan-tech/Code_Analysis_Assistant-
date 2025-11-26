# ============================================
# GitHub Copilot CLI Batch Modernization Script
# Phase 3: Apply migration using MCP server
# ============================================

param(
    [string]$UserPrompt = "Upgrade this project to JDK 21 and Spring Boot 3.2"
)

# Root paths
$rootDir   = Split-Path -Parent $MyInvocation.MyCommand.Definition
$baseDir   = Join-Path $rootDir "sample-projects"
$reportDir = Join-Path $rootDir "reports"
$logFile   = Join-Path $reportDir "run-log.txt"

# Ensure reports folder exists
if (!(Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
}

"============================================" | Out-File $logFile
"Phase 3 Migration Run - $(Get-Date)" | Out-File $logFile -Append
"Prompt used: $UserPrompt" | Out-File $logFile -Append
"============================================" | Out-File $logFile -Append

# Get all subfolders under sample-projects (each is a repo)
$projects = Get-ChildItem -Path $baseDir -Directory | Select-Object -ExpandProperty Name

foreach ($project in $projects) {
    Write-Output "Starting migration for ${project}..."
    "[$(Get-Date)] Starting migration for ${project}" | Out-File $logFile -Append

    $projectPath = Join-Path $baseDir $project

    try {
        # --- Run migration prompt via MCP server ---
        $migrationOutput = copilot -p "$UserPrompt" `
            --add-dir $projectPath `
            --allow-tool write `
            --allow-all-tools `
            --enable-all-github-mcp-tools `
            --log-level debug


        if ([string]::IsNullOrWhiteSpace($migrationOutput)) {
            $migrationOutput = "❌ No migration output."
        }

        $migrationOutput | Out-File (Join-Path $reportDir "${project}_migration.txt")
        "[$(Get-Date)] Migration applied for ${project}" | Out-File $logFile -Append

    } catch {
        "❌ Error during migration for ${project}: $($_.Exception.Message)" | Out-File (Join-Path $reportDir "${project}_error.txt")
        "[$(Get-Date)] Migration failed for ${project}" | Out-File $logFile -Append
    }

    Write-Output "Reports generated for ${project}:"
    Write-Output "   - $reportDir/${project}_migration.txt"
}

"============================================" | Out-File $logFile -Append
"Run completed at $(Get-Date)" | Out-File $logFile -Append
"============================================" | Out-File $logFile -Append

Write-Output "Phase 3 migration completed!"
Write-Output "Reports available in $reportDir"
Write-Output "Detailed logs saved in $logFile"


# # ============================================
# # GitHub Copilot CLI Batch Modernization Script
# # Phase 2: User-provided prompt + detailed logging
# # ============================================

# param(
#     [string]$UserPrompt = "Upgrade this project to JDK 21 and Spring Boot 3.2"
# )

# # Root paths
# $rootDir   = Split-Path -Parent $MyInvocation.MyCommand.Definition
# $baseDir   = Join-Path $rootDir "sample-projects"
# $reportDir = Join-Path $rootDir "reports"
# $logFile   = Join-Path $reportDir "run-log.txt"

# # Ensure reports folder exists
# if (!(Test-Path $reportDir)) {
#     New-Item -ItemType Directory -Path $reportDir | Out-Null
# }

# "============================================" | Out-File $logFile
# "Phase 3 Migration Run - $(Get-Date)" | Out-File $logFile -Append
# "Prompt used: $UserPrompt" | Out-File $logFile -Append
# "============================================" | Out-File $logFile -Append

# # Get all subfolders under sample-project (each is a repo)
# $projects = Get-ChildItem -Path $baseDir -Directory | Select-Object -ExpandProperty Name

# foreach ($project in $projects) {
#     $projectPath = Join-Path $baseDir $project

#     Write-Output "Starting migration for ${project}..."
#     "[$(Get-Date)] Starting migration for ${project}" | Out-File $logFile -Append

#     # Build the exact command string for logging
#     $commandString = "copilot -p `"$UserPrompt`" --add-dir `"$projectPath`" --allow-tool write --allow-all-tools --enable-all-github-mcp-tools"

#     Write-Output "Executing: $commandString"
#     "[$(Get-Date)] Executing: $commandString" | Out-File $logFile -Append

#     try {
#         # Run Copilot CLI with user prompt
#         $migrationOutput = & copilot -p "$UserPrompt" `
#             --add-dir $projectPath `
#             --allow-tool write `
#             --allow-all-tools `
#             --enable-all-github-mcp-tools

#         if ([string]::IsNullOrWhiteSpace($migrationOutput)) {
#             $migrationOutput = "❌ No migration output."
#         }

#         $migrationOutput | Out-File (Join-Path $reportDir "${project}_migration.txt")
#         "[$(Get-Date)] Migration applied for ${project}" | Out-File $logFile -Append

#     } catch {
#         $errorMsg = "❌ Error during migration for ${project}: $($_.Exception.Message)"
#         Write-Output $errorMsg
#         $errorMsg | Out-File (Join-Path $reportDir "${project}_error.txt")
#         "[$(Get-Date)] Migration failed for ${project}" | Out-File $logFile -Append
#     }

#     Write-Output "Reports generated for ${project}: $reportDir/${project}_migration.txt"
# }

# "============================================" | Out-File $logFile -Append
# "Run completed at $(Get-Date)" | Out-File $logFile -Append
# "============================================" | Out-File $logFile -Append

# Write-Output "Phase 3 migration completed!"
# Write-Output "Reports available in $reportDir"
# Write-Output "Detailed logs saved in $logFile"



# # ============================================
# # GitHub Copilot CLI Batch Modernization Script
# # Phase 1: Apply migration using MCP server
# # ============================================

# # Root paths
# $rootDir   = Split-Path -Parent $MyInvocation.MyCommand.Definition
# $baseDir   = Join-Path $rootDir "sample-projects"
# $reportDir = Join-Path $rootDir "reports"
# $logFile   = Join-Path $reportDir "run-log.txt"

# # Ensure reports folder exists
# if (!(Test-Path $reportDir)) {
#     New-Item -ItemType Directory -Path $reportDir | Out-Null
# }

# "============================================" | Out-File $logFile
# "Phase 3 Migration Run - $(Get-Date)" | Out-File $logFile -Append
# "============================================" | Out-File $logFile -Append

# # Get all subfolders under sample-project (each is a repo)
# $projects = Get-ChildItem -Path $baseDir -Directory | Select-Object -ExpandProperty Name

# foreach ($project in $projects) {
#     Write-Output "Starting migration for ${project}..."
#     "[$(Get-Date)] Starting migration for ${project}" | Out-File $logFile -Append

#     $projectPath = Join-Path $baseDir $project

#     try {
#         # --- Run migration prompt via MCP server ---
#         $migrationOutput = copilot -p "Upgrade this project to JDK 21 and Spring Boot 3.2" `
#             --add-dir $projectPath `
#             --allow-tool write `
#             --allow-all-tools `
#             --enable-all-github-mcp-tools

#         if ([string]::IsNullOrWhiteSpace($migrationOutput)) {
#             $migrationOutput = "❌ No migration output."
#         }

#         $migrationOutput | Out-File (Join-Path $reportDir "${project}_migration.txt")
#         "[$(Get-Date)] Migration applied for ${project}" | Out-File $logFile -Append

#     } catch {
#         "❌ Error during migration for ${project}: $($_.Exception.Message)" | Out-File (Join-Path $reportDir "${project}_error.txt")
#         "[$(Get-Date)] Migration failed for ${project}" | Out-File $logFile -Append
#     }

#     Write-Output "Reports generated for ${project}:"
#     Write-Output "   - $reportDir/${project}_migration.txt"
# }

# "============================================" | Out-File $logFile -Append
# "Run completed at $(Get-Date)" | Out-File $logFile -Append
# "============================================" | Out-File $logFile -Append

# Write-Output "Phase 3 migration completed!"
# Write-Output "Reports available in $reportDir"
# Write-Output "Detailed logs saved in $logFile"