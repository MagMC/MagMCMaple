# Exit on any error
$ErrorActionPreference = "Stop"

$ImageName = "cosmic-rpi4-jarbuilder"
$ContainerName = "cosmic-rpi4-temp"
$Dockerfile = "Dockerfile-rpi4JarBuilder"
$JarPathInContainer = "/opt/cosmic/target/Cosmic.jar"
$OutputJar = "Cosmic.jar"

Write-Host "Building Docker image..."
docker build -f $Dockerfile -t $ImageName .

Write-Host "Creating temporary container..."
docker create --name $ContainerName $ImageName | Out-Null

Write-Host "Copying JAR from container to repo root..."
docker cp "$($ContainerName):$JarPathInContainer" $OutputJar

Write-Host "Cleaning up..."
docker rm $ContainerName | Out-Null

Write-Host "Build complete. Cosmic.jar saved to repo root."
