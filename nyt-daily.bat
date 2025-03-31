@echo off
setlocal

:: Get the current date and time
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set "datetime=%%I"

:: Extract year, month, and day
set "year=%datetime:~0,4%"
set "month=%datetime:~4,2%"
set "day=%datetime:~6,2%"

:: Convert month number to month abbreviation
set "monthname="
for %%m in (01 02 03 04 05 06 07 08 09 10 11 12) do (
    if "%month%"=="%%m" set "monthname=%%m"
)

if "%month%"=="01" set "monthname=Jan"
if "%month%"=="02" set "monthname=Feb"
if "%month%"=="03" set "monthname=Mar"
if "%month%"=="04" set "monthname=Apr"
if "%month%"=="05" set "monthname=May"
if "%month%"=="06" set "monthname=Jun"
if "%month%"=="07" set "monthname=Jul"
if "%month%"=="08" set "monthname=Aug"
if "%month%"=="09" set "monthname=Sep"
if "%month%"=="10" set "monthname=Oct"
if "%month%"=="11" set "monthname=Nov"
if "%month%"=="12" set "monthname=Dec"

:: Generate three-letter abbreviated day name
for /f "tokens=1" %%a in ('wmic path win32_localtime get dayofweek ^| findstr /r "[0-6]"') do set dow=%%a

rem Map number to abbreviated day
set dayname=
if %dow%==0 set dayname=SUN
if %dow%==1 set dayname=MON
if %dow%==2 set dayname=TUE
if %dow%==3 set dayname=WED
if %dow%==4 set dayname=THU
if %dow%==5 set dayname=FRI
if %dow%==6 set dayname=SAT

echo %dayname%

:: Format year to two digits
set "year_short=%year:~2,2%"

:: Combine into desired format
set "formatted_date=%monthname%%day%%year_short%"
set fileNameStr=%year%_%month%_%day%_%dayname%
if not exist "D:\Dropbox\NYT_Crosswords\%year%-%month%" mkdir "D:\Dropbox\NYT_Crosswords\%year%-%month%"

:: Output the result
echo %formatted_date%

:: Define the URL of the file you want to download
:: Replace this URL with the actual URL of the file
set CROSSWORD_URL=https://www.nytimes.com/svc/crosswords/v2/puzzle/print/%formatted_date%.pdf

echo %CROSSWORD_URL%

:: Define the filename for the downloaded file
set OUTPUT_FILE="D:\Dropbox\NYT_Crosswords\%year%-%month%\%fileNameStr%.pdf"


:: Define the path to the cookies file
set COOKIES_FILE="D:\Dropbox\Projects\Programming\nyt_daily\nyt-cookies.txt"

:: Use curl to download the file using the cookies file
echo Downloading file using cookies...
curl -b %COOKIES_FILE% -o %OUTPUT_FILE% %CROSSWORD_URL%

:: Check if the download was successful
if %ERRORLEVEL% equ 0 (
    echo Download completed successfully: %OUTPUT_FILE%
) else (
    echo Failed to download the file.
)

endlocal
