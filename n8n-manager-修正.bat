@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo n8n Docker 管理腳本
echo ==================

IF "%~1"=="" GOTO MENU
IF "%~1"=="start" GOTO START
IF "%~1"=="stop" GOTO STOP
IF "%~1"=="restart" GOTO RESTART
IF "%~1"=="logs" GOTO LOGS
IF "%~1"=="status" GOTO STATUS
GOTO MENU

:MENU
echo 請選擇操作:
echo 1. 啟動 n8n
echo 2. 停止 n8n
echo 3. 重啟 n8n
echo 4. 查看日誌
echo 5. 查看狀態
echo 6. 退出

set /p choice=請輸入選項 (1-6): 

IF "%choice%"=="1" GOTO START
IF "%choice%"=="2" GOTO STOP
IF "%choice%"=="3" GOTO RESTART
IF "%choice%"=="4" GOTO LOGS
IF "%choice%"=="5" GOTO STATUS
IF "%choice%"=="6" GOTO EOF

echo 無效選項，請重試
GOTO MENU

:START
echo 正在啟動 n8n...
docker-compose up -d
echo n8n 已啟動，可通過 http://localhost:5678 訪問
GOTO EOF

:STOP
echo 正在停止 n8n...
docker-compose down
echo n8n 已停止
GOTO EOF

:RESTART
echo 正在重啟 n8n...
docker-compose restart
echo n8n 已重啟
GOTO EOF

:LOGS
echo 顯示 n8n 日誌 (按 CTRL+C 退出)...
docker-compose logs -f n8n
GOTO EOF

:STATUS
echo 當前 n8n 狀態:
docker-compose ps
GOTO EOF

:EOF
endlocal