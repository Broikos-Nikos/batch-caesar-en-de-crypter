@ECHO OFF
IF EXIST "mytextx.txt" (
	set set_file=mytextx.txt
) ELSE IF EXIST "mytextx.encr" (
	set set_file=mytextx.encr
)
set tags=

SETLOCAL EnableDelayedExpansion
for /f "Tokens=* Delims=" %%x in (%set_file%) do set Build=!Build!%%x
ECHO %Build%>x&FOR %%? IN (x) DO SET /A strlength=%%~z? - 2&del x
set /a cnt=0
for /f %%a in ('type "%set_file%"^|find "" /v /c') do set /a cnt=%%a
set /a full = 100
for /l %%a in (1,1,%full%) do (
 CALL:ADDSPACE)
set /a denom=%full%/%cnt%
set /a current_progress=0

SET    abet=abcdefghijklmnopqrstuvwxyz@#-/\ .0123456789
SET cipher1=0123456789abcdefghijklmnopqrstuvwxyz@#-/\ .
IF EXIST "mytextx.txt" (
	ECHO Cyphering.
	(
 		FOR /f "delims=" %%a IN (mytextx.txt) DO (
  			SET line=%%a
			set /a current_progress=current_progress+%denom%
			set set_title=Cyphering
  			CALL:PROGRESS
  			(CALL :encipher)>>mytextx.encr
 		)
	)
	ECHO Cyphering ended.
	DEL mytextx.txt
) ELSE IF EXIST "mytextx.encr" (
	ECHO Decyphering.
	(
		FOR /f "delims=" %%a IN (mytextx.encr) DO (
			SET line=%%a
			set /a current_progress=current_progress+%denom%
			set set_title=Decyphering
  			CALL:PROGRESS
			(CALL :decipher)>>mytextx.txt
		)
	)
	ECHO Decyphering ended.
	DEL mytextx.encr
) ELSE (
	ECHO No relative file exists.
	TIMEOUT 5
)
DEL _temp.bat
GOTO :EOF
:decipher
SET morf=%abet%
SET from=%cipher1%
GOTO trans
:encipher
SET from=%abet%
SET morf=%cipher1%
:trans
SET "enil="
:transl
SET $1=%from%
SET $2=%morf%
:transc
IF /i "%line:~0,1%"=="%$1:~0,1%" SET enil=%enil%%$2:~0,1%&GOTO transnc
SET $1=%$1:~1%
SET $2=%$2:~1%
IF DEFINED $2 GOTO transc
:: No translation - keep
SET enil=%enil%%line:~0,1%
:transnc
SET line=%line:~1%
IF DEFINED line GOTO transl
ECHO %enil%
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
 )>_temp.bat
 cls
 call _temp.bat
 GOTO :EOF
:forceexit