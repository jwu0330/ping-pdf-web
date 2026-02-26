$ErrorActionPreference = "Stop"

function Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] 找不到 'code' 指令。請先在 VS Code 執行: Ctrl+Shift+P -> Shell Command: Install 'code' command in PATH" -ForegroundColor Red
    exit 1
}

$extensions = @(
    "ms-vsliveshare.vsliveshare",
    "ms-vscode.remote-server"
)

Info "開始安裝/更新必要擴充套件..."
foreach ($ext in $extensions) {
    Info "安裝: $ext"
    & code --install-extension $ext --force
    if ($LASTEXITCODE -ne 0) {
        Warn "安裝失敗: $ext（可稍後手動安裝）"
    }
}

Info "完成。請在 VS Code 右上角 Account 登入 GitHub 或 Microsoft 帳號。"
Info "主機端接著執行 scripts/start-tunnel-host.ps1；客戶端執行 scripts/connect-tunnel-client.ps1"
