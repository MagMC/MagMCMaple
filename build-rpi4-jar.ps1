# --- Settings ---
$ImageName = "cosmic-rpi4-jarbuilder"
$ContainerName = "cosmic-rpi4-builder"
$OutputDir = "built-jar"

# --- Build image ---
Write-Host "Building Docker image..."
docker build -f Dockerfile-rpi4JarBuilder -t $ImageName .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed."
    exit 1
}

# --- Run container ---
Write-Host "Running builder container..."
docker run --name $ContainerName $ImageName

# --- Wait a moment for container to finish ---
Start-Sleep -Seconds 2

# --- Create output directory ---
if (-Not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# --- Copy jar from container ---
Write-Host "Extracting JAR file..."
docker cp "${ContainerName}:/opt/cosmic/target" "$OutputDir"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to copy JAR from container."
}

Write-Host "JAR copied to $OutputDir"

# --- Cleanup ---
Write-Host "Cleaning up container..."
docker rm $ContainerName | Out-Null

Write-Host "Done."