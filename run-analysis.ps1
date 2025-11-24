# ============================================
# GitHub Copilot CLI Batch Analysis & Migration
# ============================================

$projects = @("java-app1","java-app2","dotnet-app1","dotnet-app2")

# Root paths
$rootDir   = Split-Path -Parent $MyInvocation.MyCommand.Definition
$baseDir   = Join-Path $rootDir "projects"
$reportDir = Join-Path $rootDir "reports"
$logFile   = Join-Path $reportDir "run-log.txt"

# Ensure reports folder exists
if (!(Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
}

"============================================" | Out-File $logFile
"Batch Analysis & Migration Run - $(Get-Date)" | Out-File $logFile -Append
"============================================" | Out-File $logFile -Append

# --- Step 1: Trigger login ---
Write-Output "Checking Copilot authentication..."
try {
    # Run a harmless prompt to trigger login if needed
    $authTest = copilot -p "Say hello" --allow-all-tools
    if ($authTest -match "login" -or $authTest -match "unauthorized") {
        Write-Output "❌ Copilot CLI not authenticated. Please run 'copilot' interactively once to log in."
        "[$(Get-Date)] Authentication required" | Out-File $logFile -Append
        exit 1
    } else {
        "[$(Get-Date)] Copilot CLI authenticated" | Out-File $logFile -Append
    }
} catch {
    "[$(Get-Date)] Authentication check failed: $($_.Exception.Message)" | Out-File $logFile -Append
    exit 1
}

# --- Step 2: Loop through projects ---
foreach ($project in $projects) {
    Write-Output "Starting analysis for ${project}..."
    "[$(Get-Date)] Starting analysis for ${project}" | Out-File $logFile -Append

    if ($project -like "java*") {
        $analysisPrompt  = "Analyze this Java project for code smells, performance issues, and migration blockers to Java 17."
        $migrationPrompt = "Suggest migration steps to upgrade this Java project from Java 8 to Java 17, replacing deprecated APIs."
    } else {
        $analysisPrompt  = "Analyze this .NET project for outdated APIs, performance issues, and migration blockers to .NET 8."
        $migrationPrompt = "Suggest migration steps to upgrade this .NET project to .NET 8, including dependency updates and async/await adoption."
    }

    try {
        $analysisOutput = copilot -p "$analysisPrompt" --add-dir (Join-Path $baseDir $project) --allow-all-tools
        if ([string]::IsNullOrWhiteSpace($analysisOutput)) {
            $analysisOutput = "❌ Copilot returned no output for ${project} analysis."
        }
        $analysisOutput | Out-File (Join-Path $reportDir "${project}_analysis.txt")
        "[$(Get-Date)] Analysis completed for ${project}" | Out-File $logFile -Append
    } catch {
        "❌ Error during analysis for ${project}: $($_.Exception.Message)" | Out-File (Join-Path $reportDir "${project}_analysis.txt")
        "[$(Get-Date)] Analysis failed for ${project}" | Out-File $logFile -Append
    }

    try {
        $migrationOutput = copilot -p "$migrationPrompt" --add-dir (Join-Path $baseDir $project) --allow-all-tools
        if ([string]::IsNullOrWhiteSpace($migrationOutput)) {
            $migrationOutput = "❌ Copilot returned no output for ${project} migration."
        }
        $migrationOutput | Out-File (Join-Path $reportDir "${project}_migration.txt")
        "[$(Get-Date)] Migration completed for ${project}" | Out-File $logFile -Append
    } catch {
        "❌ Error during migration for ${project}: $($_.Exception.Message)" | Out-File (Join-Path $reportDir "${project}_migration.txt")
        "[$(Get-Date)] Migration failed for ${project}" | Out-File $logFile -Append
    }

    Write-Output "Reports generated for ${project}:"
    Write-Output "   - $reportDir/${project}_analysis.txt"
    Write-Output "   - $reportDir/${project}_migration.txt"
}

"============================================" | Out-File $logFile -Append
"Run completed at $(Get-Date)" | Out-File $logFile -Append
"============================================" | Out-File $logFile -Append

Write-Output "Batch analysis & migration completed!"
Write-Output "Reports available in $reportDir"
Write-Output "Detailed logs saved in $logFile"