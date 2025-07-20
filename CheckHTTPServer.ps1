$proc = Get-Process -Name python -ErrorAction SilentlyContinue | Where-Object { $_.Path -match "http\.server" }
if (-not $proc) {
    Start-Process -FilePath "C:\Scripts\StartHTTPServer.bat"
}
