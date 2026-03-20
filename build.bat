@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title CipherTalk 构建脚本

echo.
echo ============================================
echo   CipherTalk 一键构建脚本
echo ============================================
echo.

:: 检查 Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Node.js
    echo.
    echo 请先安装 Node.js ^(版本 ^>= 18^)
    echo 下载地址: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

:: 检查 Node.js 版本
for /f "tokens=1 delims=v" %%a in ('node -v') do set "NODE_VER=%%a"
echo [信息] Node.js 版本: v%NODE_VER%

:: 检查 npm
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到 npm
    pause
    exit /b 1
)

:: 进入项目目录
cd /d "%~dp0"
echo [信息] 项目目录: %cd%

:: 安装依赖
if not exist "node_modules\" (
    echo.
    echo [步骤 1/2] 正在安装依赖（首次构建需要，可能需要几分钟）...
    call npm install
    if %errorlevel% neq 0 (
        echo [错误] 依赖安装失败
        pause
        exit /b 1
    )
    echo [完成] 依赖安装成功
) else (
    echo [步骤 1/2] 依赖已存在，跳过安装
)

:: 构建
echo.
echo [步骤 2/2] 正在构建安装包（需要几分钟）...
call npm run build
if %errorlevel% neq 0 (
    echo.
    echo [错误] 构建失败，请检查上方的错误信息
    pause
    exit /b 1
)

:: 完成
echo.
echo ============================================
echo   构建完成!
echo ============================================
echo.
echo 安装包位置: %cd%\release\
echo.
echo 在 release 目录中找到 CipherTalk-*-Setup.exe
echo 将该安装包复制到目标电脑上运行即可，无需安装 Node.js
echo.

pause
