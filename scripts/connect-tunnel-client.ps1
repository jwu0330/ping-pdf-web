param(
    [Parameter(Mandatory = $true)]
    [string]$TunnelName,
    [string]$RemotePath = "C:/"
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

Info "準備連線 Tunnel: $TunnelName"
Info "遠端路徑: $RemotePath"
Info "第一次使用時，VS Code 可能會要求你登入同一個帳號。"

& code --remote "tunnel+$TunnelName" "$RemotePath"
if ($LASTEXITCODE -ne 0) {
    Fail "連線失敗。請確認主機端 tunnel 正在執行，且兩端登入同一帳號。"
}
