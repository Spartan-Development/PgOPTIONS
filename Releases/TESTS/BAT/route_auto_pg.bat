@echo off

setlocal EnableDelayedExpansion

set "pg_path="

for /f "usebackq tokens=*" %%a in (`reg query HKLM\SOFTWARE\PostgreSQL\Installations /s ^| findstr /i "Base Directory"`) do (
    set "line=%%a"
    set "line=!line:*REG_SZ=!"
    set "line=!line:~1!"
    if exist "!line!\bin\pg_ctl.exe" (
        set "pg_path=!line!"
        goto :found
    )
)

:found

if defined pg_path (
    echo PostgreSQL found at: %pg_path%
	pause
) else (
    echo PostgreSQL not found.
	pause
)

endlocal & set "pg_path=%pg_path%"
