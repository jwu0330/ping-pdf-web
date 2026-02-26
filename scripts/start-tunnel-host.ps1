param(
    [string]$TunnelName = $env:COMPUTERNAME,
    [string]$WorkspacePath = (Get-Location).Path,
    [switch]$InstallAsService
)

$ErrorActionPreference = "Stop"

function Fail {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
    exit 1
}

function Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Fail "找不到 'code' 指令。請先在 VS Code 執行: Ctrl+Shift+P -> Shell Command: Install 'code' command in PATH"
}

if (-not (Test-Path -LiteralPath $WorkspacePath)) {
    Fail "WorkspacePath 不存在: $WorkspacePath"
}

Info "Tunnel Name: $TunnelName"
Info "Workspace: $WorkspacePath"

if ($InstallAsService) {
    Info "安裝 Tunnel 為背景服務（需要一次登入授權）..."
    & code tunnel service install --name "$TunnelName" --accept-server-license-terms
    if ($LASTEXITCODE -ne 0) {
        Fail "Tunnel service install 失敗。"
    }

    Info "顯示目前 tunnel 狀態..."
    & code tunnel status
    exit 0
}

Set-Location -LiteralPath $WorkspacePath

Info "即將啟動 Tunnel（第一次會要求登入 GitHub/Microsoft）..."
Info "要停止連線請在這個視窗按 Ctrl+C"

& code tunnel --name "$TunnelName" --accept-server-license-terms
if ($LASTEXITCODE -ne 0) {
    Fail "Tunnel 啟動失敗。"
}
