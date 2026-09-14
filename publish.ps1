# おかねクイズ大会を GitHub Pages に公開する（手動用）
#   1) _build\お金のクイズ大会\fetch_rates.py で為替を更新（失敗しても続行）
#   2) merge.py --write で問題データを検証・結合し index.html を作り直す
#   3) commit → push（1分ほどで https://masatopapa.github.io/okane-quiz/ に反映。
#      sw.js がネット優先なので、使っている人は次に開いたときに自動で新版になる）
# 毎週金曜18:00の自動更新は _build\お金のクイズ大会\weekly_check.ps1（データ確認込み）。
# 使い方: publish.cmd をダブルクリック、または  powershell -File publish.ps1 "コミットメッセージ"
$ErrorActionPreference = "Stop"
$env:Path = "$env:LOCALAPPDATA\Programs\MinGit\cmd;$env:LOCALAPPDATA\Programs\gh\bin;$env:Path"

$root  = Split-Path -Parent $MyInvocation.MyCommand.Path
$build = Join-Path (Split-Path -Parent $root) "_build\お金のクイズ大会"

python (Join-Path $build "fetch_rates.py")
python (Join-Path $build "merge.py") --write
if ($LASTEXITCODE -ne 0) { throw "merge.py failed" }

Set-Location $root
git add -A
$msg = if ($args.Count -gt 0) { ($args -join " ") } else { "update " + (Get-Date -Format "yyyy-MM-dd HH:mm") }
git commit -m $msg
git push
Write-Host ""
Write-Host "公開しました → https://masatopapa.github.io/okane-quiz/  （反映まで1分ほど）"
