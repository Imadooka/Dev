# Build all services in docker-compose.yml
docker compose build

# Output the result
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Docker Compose build completed successfully."
} else {
    Write-Host "❌ Failed to build Docker Compose services."
    exit 1  # ทำให้ Terraform หยุดถ้า Build Fail
}
