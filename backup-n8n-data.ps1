# n8n Docker Volume Data Backup Script
# Backup data from n8n_data volume to local data directory

# Ensure data directory exists
if (-not (Test-Path -Path "./data")) {
    New-Item -ItemType Directory -Path "./data" | Out-Null
    Write-Host "Created data directory"
}

# Check if n8n container exists
$containerExists = docker ps -a --filter "name=n8n" --format "{{.Names}}" | Select-String -Pattern "^n8n$"
if (-not $containerExists) {
    Write-Host "Error: n8n container not found" -ForegroundColor Red
    exit 1
}

# Check if n8n_data volume exists
$volumeExists = docker volume ls --filter "name=n8n_data" --format "{{.Name}}" | Select-String -Pattern "^n8n_data$"
if (-not $volumeExists) {
    Write-Host "Error: n8n_data volume not found" -ForegroundColor Red
    exit 1
}

Write-Host "Starting n8n data backup..." -ForegroundColor Yellow

# Create temporary container to access volume data
Write-Host "Creating temporary container to access volume data..."
docker run --rm -v n8n_data:/source -v ${PWD}/data:/backup alpine sh -c "cd /source && tar -cf - . | (cd /backup && tar -xf -)"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Backup completed! n8n data has been backed up to ./data directory" -ForegroundColor Green
} else {
    Write-Host "Error occurred during backup process" -ForegroundColor Red
}