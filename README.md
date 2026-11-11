# aniGamerPlus Docker

將 [miyouzi/aniGamerPlus](https://github.com/miyouzi/aniGamerPlus)（巴哈姆特動畫瘋下載工具）包成 Docker 執行。

## 快速開始

```bash
./setup.sh                 # 建立 config.json / cookie.txt / sn_list.txt / aniGamer.db / .env
# 把巴哈姆特登入後的 cookie 貼到 cookie.txt，依需要修改 config.json、sn_list.txt
docker compose up -d --build
```

Web 控制台：http://localhost:5000

> `setup.sh` 只會建立不存在的檔案，重複執行不會覆蓋設定。
> Windows 請用 Git Bash 或 WSL 執行。

## 設定 (.env)

| 變數 | 預設 | 說明 |
| --- | --- | --- |
| `TZ` | `Asia/Taipei` | 時區 |
| `PORT` | `5000` | Web 控制台對外 port |
| `BANGUMI_DIR` | `./bangumi` | 下載目錄 |
| `ANIGAMER_REF` | `master` | 上游版本 (branch / tag / commit) |
| `IMAGE_TAG` | `latest` | 映像檔 tag |

## 更新

```bash
./build.sh                 # 抓上游最新版，標上 latest 與版本 tag (例: v25.2-e8f1f56)
docker compose up -d
```

指定版本：`./build.sh v25.2`

## 從「我的動畫」產生 sn_list

需要 PHP (含 curl)，或用 Docker 執行：

```bash
docker run --rm -v "$PWD":/w -w /w php:8.3-cli php get_mygather.php 1 >> sn_list.txt
```

參數為收藏列表頁數，預設 1。

## 檔案說明

| 檔案 | 用途 |
| --- | --- |
| `config.json` | aniGamerPlus 設定 |
| `cookie.txt` | 巴哈姆特 cookie |
| `sn_list.txt` | 自動下載清單 |
| `aniGamer.db` | 下載紀錄資料庫 |
| `bangumi/` | 下載的影片 |
| `logs/` | 程式日誌 |
