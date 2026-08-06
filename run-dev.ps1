# Sets JAVA_HOME for this terminal session only (no admin/policy changes needed)
# and runs the app via the Maven wrapper. Re-run this script in each new terminal
# instead of retyping the env var - System Properties env var editing is locked
# down here, so this is the practical per-session workaround.

$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"

Write-Host "JAVA_HOME set to $env:JAVA_HOME for this session"
Write-Host "Starting Spring Boot app via Maven wrapper..."

& .\mvnw.cmd spring-boot:run
