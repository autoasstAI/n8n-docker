# Script to remove .env file from Git history

# Warning: This script will rewrite Git history, make sure you understand the implications before running
# It is recommended to backup your repository before proceeding

# Confirm user intent
Write-Host "WARNING: This script will permanently remove .env file from Git history." -ForegroundColor Red
Write-Host "This will rewrite Git history, and if you have pushed to a remote repository, you will need to force push." -ForegroundColor Red
Write-Host "Please make sure you have backed up important data." -ForegroundColor Red
$confirmation = Read-Host "Are you sure you want to continue? (y/n)"

if ($confirmation -ne 'y') {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    exit
}

# Check if git-filter-repo is installed
try {
    pip show git-filter-repo | Out-Null
    Write-Host "git-filter-repo is installed, continuing..." -ForegroundColor Green
}
catch {
    Write-Host "git-filter-repo not found, installing..." -ForegroundColor Yellow
    pip install git-filter-repo
}

# Check for unstaged changes
$hasChanges = git status --porcelain
if ($hasChanges) {
    Write-Host "`nWARNING: You have unstaged changes in your repository." -ForegroundColor Yellow
    Write-Host "It is recommended to commit or stash your changes before proceeding." -ForegroundColor Yellow
    $proceedWithChanges = Read-Host "Do you want to proceed anyway? (y/n)"
    
    if ($proceedWithChanges -ne 'y') {
        Write-Host "Operation cancelled. Please commit or stash your changes and try again." -ForegroundColor Yellow
        exit
    }
}

# Run git-filter-repo to remove .env file
Write-Host "`nRemoving .env file from Git history..." -ForegroundColor Cyan
git filter-repo --path .env --invert-paths --force

# Check if operation was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully removed .env file from Git history!" -ForegroundColor Green
    
    # Prompt user to force push to remote repository
    Write-Host "`nIf you need to update the remote repository, run the following command:" -ForegroundColor Cyan
    Write-Host "git push origin --force" -ForegroundColor White
    
    # Prompt user to change sensitive information
    Write-Host "`nIMPORTANT: Make sure to change all sensitive information in your .env file, especially:" -ForegroundColor Yellow
    Write-Host "1. N8N_BASIC_AUTH_PASSWORD" -ForegroundColor White
    Write-Host "2. N8N_ENCRYPTION_KEY" -ForegroundColor White
    
    # Prompt user to check .gitignore
    Write-Host "`nVerify that .env is included in your .gitignore file:" -ForegroundColor Cyan
    Get-Content .gitignore | Select-String ".env"
}
else {
    Write-Host "Operation failed, please check the error messages above." -ForegroundColor Red
    Write-Host "If you see 'Refusing to destructively overwrite repo history' error, try running the script again with --force option." -ForegroundColor Yellow
}