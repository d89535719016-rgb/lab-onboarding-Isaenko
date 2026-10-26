@echo off
chcp 65001 >nul
REM =====================================================
REM Практическая работа: диагностика клиентского компьютера
REM Автор: Исаенко
REM Дата: 26.10.2026
REM =====================================================

REM --- Файл отчёта лежит рядом с этим файлом
set "REPORT=%~dp0pc_report.txt"
echo Сбор данных, подождите несколько секунд...

REM --- Заголовок (одна > создаёт или перезаписывает файл)
>"%REPORT%" echo ==================================================
>>"%REPORT%" echo    Диагностика компьютера
>>"%REPORT%" echo ==================================================
>>"%REPORT%" echo.

REM --- Операционная система
>>"%REPORT%" echo Операционная система
>>"%REPORT%" echo --------------------------------------------------
for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Caption"`) do >>"%REPORT%" echo Название: %%b
for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Version"`) do >>"%REPORT%" echo Версия: %%b
>>"%REPORT%" echo.

REM --- Процессор
>>"%REPORT%" echo Процессор
>>"%REPORT%" echo --------------------------------------------------
for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor | Select-Object -First 1).Name"`) do >>"%REPORT%" echo %%b
>>"%REPORT%" echo.

REM --- Оперативная память (значения в КБ переводим в ГБ делением на 1048576)
for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize"`) do set /a MEM_TOTAL=%%b/1048576
for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory"`) do set /a MEM_FREE=%%b/1048576
>>"%REPORT%" echo Оперативная память
>>"%REPORT%" echo --------------------------------------------------
>>"%REPORT%" echo Всего памяти: %MEM_TOTAL% ГБ
>>"%REPORT%" echo Свободно памяти: %MEM_FREE% ГБ
>>"%REPORT%" echo.

REM --- Диск C (байты переводим в ГБ внутри PowerShell: set /a не умеет числа больше 2 млрд)
for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "[math]::Floor((Get-CimInstance Win32_LogicalDisk | Where-Object DeviceID -eq 'C:').Size/1GB)"`) do set "DISK_SIZE_GB=%%b"
for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "[math]::Floor((Get-CimInstance Win32_LogicalDisk | Where-Object DeviceID -eq 'C:').FreeSpace/1GB)"`) do set "DISK_FREE_GB=%%b"
>>"%REPORT%" echo Диск C
>>"%REPORT%" echo --------------------------------------------------
>>"%REPORT%" echo Размер диска: %DISK_SIZE_GB% ГБ
>>"%REPORT%" echo Свободно: %DISK_FREE_GB% ГБ
>>"%REPORT%" echo.

REM --- Установленные программы (через реестр, 64-битные и 32-битные)
>>"%REPORT%" echo Установленные программы
>>"%REPORT%" echo --------------------------------------------------
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do >>"%REPORT%" echo %%b
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do >>"%REPORT%" echo %%b
>>"%REPORT%" echo.

REM --- Показываем отчёт в окне (тот же текст, что в файле)
cls
type "%REPORT%"
echo.
echo Отчёт сохранён
echo.
pause