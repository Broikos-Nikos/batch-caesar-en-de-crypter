@ECHO OFF
mode con cols=102 lines=4
setlocal EnableDelayedExpansion
cls
TITLE MD5/Caesar

@echo off & setlocal enabledelayedexpansion
IF EXIST "mytextx.txt" (
	for /f "tokens=*" %%c in (mytextx.txt) do (
		set md5fromfile=%%c
	)
) ELSE IF EXIST "mytextx.encr" (
	for /f "tokens=*" %%c in (mytextx.encr) do (
		set md5fromfile=%%c
	)
) ELSE (
	mode con cols=102 lines=5
	ECHO No file exists.
	ECHO Create a mytextx.txt file. Add password encrypted in MD5, in the last line.
	ECHO Start using this encrypter/decrypter
	TIMEOUT 10
	GOTO :EOF
)

set enteredpass=
:type_password
SET/P enteredpass=Password:
cls


echo|set /p ans="%enteredpass%">"_md5.tmp"

set "md5frompassword="
for /f "skip=1 tokens=* delims=" %%# in ('certutil -hashfile "_md5.tmp" MD5') do (
	if not defined md5frompassword (
		for %%Z in (%%#) do set "md5frompassword=!md5frompassword!%%Z"
	)
)

del "_md5.tmp"




IF NOT "%md5fromfile%"=="%md5frompassword%" (
	echo Wrong Password.
	GOTO :type_password
)
cls
echo MD5 Password ciphering: 10/100
echo [##########------------------------------------------------------------------------------------------]
echo Generating dictionary


SET mystring=%enteredpass%%md5frompassword%
SET finalstr=
SET prevchar=
SET /A repetition=0



:loop
SET char=%mystring:~0,1%
SET mystring=%mystring:~1%
SET combination=%char%%prevchar%%char%
SET finalstr=%prevchar%s1t%prevchar%%finalstr%u2p%repetition%m3%combination%b4o%prevchar%%combination%e5n%tomultiply%f7t%char%t8w
SET prevchar=%char%
SET /A repetition=%repetition%+1
IF NOT "%mystring%" == "" GOTO loop

cls
echo MD5 Password ciphering: 30/100
echo [##############################----------------------------------------------------------------------]
echo Populating array

SET /A array_cell=0
:populate_array
SET arrayline[%array_cell%]=%finalstr:~0,8%
SET finalstr=%finalstr:~7%
SET /A array_cell=%array_cell%+1
IF NOT "%finalstr%" == "" GOTO populate_array
for /l %%n in (0,1,85) do ( 
   (echo !arrayline[%%n]!)>>myarray
)


cls
echo MD5 Password ciphering: 50/100
echo [##################################################--------------------------------------------------]
echo Sorting dictionary

setlocal disableDelayedExpansion
set "file=myarray"
set "sorted=%file%.sorted"
set "deduped=%file%.deduped"
set LF=^


::The 2 blank lines above are critical, do not remove
sort "%file%" >"%sorted%"
>"%deduped%" (
  set "prev="
  for /f usebackq^ eol^=^%LF%%LF%^ delims^= %%A in ("%sorted%") DO (
    set "ln=%%A"
    setlocal enableDelayedExpansion
    if /i "!ln!" neq "!prev!" (
      endlocal
      (echo %%A)
      set "prev=%%A"
    ) else endlocal
  )
)
cls
echo MD5 Password ciphering: 70/100
echo [######################################################################------------------------------]
echo Cleaning dictionary


>nul move /y "%deduped%" "%file%"
del "%sorted%"
SET dictionary=
FOR /f "delims=" %%a IN (myarray) DO (
	(echo | set /p dummyName=%%a)>>chr.tmp
)
FOR /f "delims=" %%a IN (chr.tmp) DO (
	SET dictionary=%%a
)
cls
echo MD5 Password ciphering: 85/100
echo [#####################################################################################---------------]
echo Finalizing dictionary


set num=0
SET revstr=%dictionary%
SET rline=
:reversal
call set tmpa=%%revstr:~%num%,1%%%
set /a num+=1
if not "%tmpa%" equ "" (
set rline=%tmpa%%rline%
goto reversal
)
SET dictionary=%dictionary%%rline%



setlocal EnableDelayedExpansion
SET finalstr=%dictionary%
SET /A array_cell=0
:populate_my_array
SET arrayline[%array_cell%]=%finalstr:~0,8%
SET finalstr=%finalstr:~7%
SET /A array_cell=%array_cell%+1
IF NOT "%finalstr%" == "" GOTO populate_my_array
for /l %%t in (0,1,85) do ( 
   (echo !arrayline[%%t]!)>>mysecondarray
)


setlocal disableDelayedExpansion
set "file=mysecondarray"
set "sorted=%file%.sorted"
set "deduped=%file%.deduped"
set LF=^


::The 2 blank lines above are critical, do not remove
sort "%file%" >"%sorted%"
>"%deduped%" (
  set "prev="
  for /f usebackq^ eol^=^%LF%%LF%^ delims^= %%A in ("%sorted%") DO (
    set "ln=%%A"
    setlocal enableDelayedExpansion
    if /i "!ln!" neq "!prev!" (
      endlocal
      (echo %%A)
      set "prev=%%A"
    ) else endlocal
  )
)
>nul move /y "%deduped%" "%file%"
del "%sorted%"
SET dictionary=
FOR /f "delims=" %%a IN (mysecondarray) DO (
	(echo | set /p dummyName=%%a)>>chr.tmp
)
FOR /f "delims=" %%a IN (chr.tmp) DO (
	SET dictionary=%%a
)

cls
echo MD5 Password ciphering finished: 100/100
echo [####################################################################################################]

del chr.tmp zero.tmp mysecondarray myarray




IF EXIST "mytextx.txt" (
	set set_file=mytextx.txt
) ELSE IF EXIST "mytextx.encr" (
	set set_file=mytextx.encr
)
set tags=

SetLocal DisableDelayedExpansion
If Not Exist "%set_file%" Exit /B
Copy /Y "%set_file%" "mytextx.tmp">Nul 2>&1||Exit /B
(   Set "Line="
    For /F "UseBackQ Delims=" %%A In ("mytextx.tmp") Do (
        SetLocal EnableDelayedExpansion
        If Defined Line Echo !Line!
        EndLocal
        Set "Line=%%A"))>"%set_file%"
del mytextx.tmp
EndLocal

SETLOCAL EnableDelayedExpansion
set /a cnt=0
for /f %%a in ('type "%set_file%"^|find "" /v /c') do set /a cnt=%%a
set /a full = 100
for /l %%a in (1,1,%full%) do (
 CALL:ADDSPACE)
set /a denom=%full%/%cnt%
set /a current_progress=0
set /a line_number=1

SET myalphabet=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#-/\ .,?;:=-_+()[]{}
IF EXIST "mytextx.txt" (
	ECHO Ciphering.
	(
 		FOR /f "delims=" %%a IN (mytextx.txt) DO (
  			SET line=%%a
			set /a current_progress=current_progress+%denom%
			set set_title=Ciphering
			set /a line_number=line_number+1
  			CALL:PROGRESS
  			(CALL :encipher)>>mytextx.encr
 		)
	)
	(ECHO %md5frompassword%)>>mytextx.encr
	ECHO Ciphering ended.
	DEL mytextx.txt
) ELSE IF EXIST "mytextx.encr" (
	ECHO Deciphering.
	(
		FOR /f "delims=" %%a IN (mytextx.encr) DO (
			SET line=%%a
			set /a current_progress=current_progress+%denom%
			set set_title=Deciphering
  			CALL:PROGRESS
			set /a line_number=line_number+1
			(CALL :decipher)>>mytextx.txt
		)
	)
	(ECHO %md5frompassword%)>>mytextx.txt
	ECHO Deciphering ended.
	DEL mytextx.encr
) ELSE (
	(ECHO. Enter contents for encryption here.)>>mytextx.txt
	ECHO No relative file exists. File mytextx.txt created.
	TIMEOUT 5
)
DEL _temp.bat
GOTO :EOF

:encipher
SET from=%myalphabet%
SET to=%dictionary%
SET "encrypted_line="
:encipher_transl
SET $1=%from%
SET $2=%to%
:encipher_transc
IF "%line:~0,1%"=="%$1:~0,1%" SET encrypted_line=%encrypted_line%%$2:~0,8%&GOTO encipher_transnc
SET $1=%$1:~1%
SET $2=%$2:~8%
IF DEFINED $2 GOTO encipher_transc
:: No translation - keep
SET encrypted_line=%encrypted_line%%line:~0,1%
:encipher_transnc
SET line=%line:~1%
IF DEFINED line GOTO encipher_transl
ECHO %encrypted_line%
GOTO :EOF

:decipher
SET to=%myalphabet%
SET from=%dictionary%
SET "encrypted_line="
:decipher_transl
SET $1=%from%
SET $2=%to%
:decipher_transc
IF "%line:~0,8%"=="%$1:~0,8%" SET encrypted_line=%encrypted_line%%$2:~0,1%&GOTO decipher_transnc
SET $1=%$1:~8%
SET $2=%$2:~1%
IF DEFINED $2 GOTO decipher_transc
:: No translation - keep
SET encrypted_line=%encrypted_line%%line:~0,8%
:decipher_transnc
SET line=%line:~8%
IF DEFINED line GOTO decipher_transl
ECHO %encrypted_line%
GOTO :EOF

:ADDSPACE
 set "fullBar=%fullBar%-"
 set tags=%tags%#
 exit/b
 GOTO :EOF
:PROGRESS
set /a pct=full-%current_progress%
 (TITLE %set_title%
  echo/echo/%set_title%: %current_progress%/100
  echo/echo [%%tags:~0,%current_progress%%%%%fullBar:~0,%pct%%%]
  echo/echo/Line: %line_number%
 )>_temp.bat
 cls
 call _temp.bat
 GOTO :EOF
