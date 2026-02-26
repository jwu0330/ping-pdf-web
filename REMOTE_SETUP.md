# VS Code 雙向協作與遠端連線（Windows）

## 你會用到的腳本
- `scripts/setup-vscode-collab.ps1`
- `scripts/start-tunnel-host.ps1`
- `scripts/connect-tunnel-client.ps1`

## 0) 兩邊先做（A 電腦與 B 電腦都要）
在 PowerShell 進入此資料夾後執行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup-vscode-collab.ps1
```

完成後，兩邊都在 VS Code 右上角登入（GitHub 或 Microsoft）。

---

## 1) 讓 A 電腦可被遠端連線（Tunnel 主機端）
在 A 電腦執行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\start-tunnel-host.ps1 -TunnelName "my-home-pc" -WorkspacePath "E:\code\新增資料夾"
```

第一次會跳出登入授權，完成後 Tunnel 會保持在線（此視窗不要關）。

### 可選：安裝成背景服務（重開機後仍可用）
```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\start-tunnel-host.ps1 -TunnelName "my-home-pc" -InstallAsService
```

---

## 2) 從 B 電腦連回 A 電腦（Tunnel 客戶端）
在 B 電腦執行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\connect-tunnel-client.ps1 -TunnelName "my-home-pc" -RemotePath "C:/"
```

如果 A 電腦有開著 tunnel 且雙方同帳號，VS Code 會開啟遠端視窗。

---

## 3) 兩人同時編輯（Live Share）
1. 主機端按 `Ctrl+Shift+P` → `Live Share: Start Collaboration Session`
2. 複製連結給對方
3. 對方點連結即可加入協作

---

## 常見問題
- `code` 指令找不到：先在 VS Code 執行 `Shell Command: Install 'code' command in PATH`。
- 連不上 tunnel：確認主機端視窗仍在跑，且兩端登入同一個帳號。
- 權限問題：重新開 PowerShell 後再執行一次 `Set-ExecutionPolicy -Scope Process Bypass`。
