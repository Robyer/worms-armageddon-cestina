@ECHO OFF
SET "version=3.8"

REM Delete old output directory
rmdir "output" /S /Q

REM Create directory for current version
mkdir "output\Worms Armageddon\DATA\User\Languages\%version%\"

REM Prepare and copy the language file
xcopy ".\strings\Czech.txt" "tools\"
.\tools\sfk replace .\tools\Czech.txt -bylist .\tools\na_zastupne_znaky.txt -yes
move ".\tools\Czech.txt" "output\Worms Armageddon\DATA\User\Languages\%version%\"

REM Copy also the fonts and media files
xcopy "fonts" "output" /S /I /Y
xcopy "media" "output" /S /I /Y

REM Make the zip archive
7z a -tzip "output\wa_cestina.zip" ".\output\*"

REM Open output folder
start .\output