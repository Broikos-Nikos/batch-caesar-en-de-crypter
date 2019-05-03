@ECHO OFF
mode con cols=102 lines=13
title Encrypted file reader
SETLOCAL EnableDelayedExpansion

set tags=
set /a cnt=0
for /f %%a in ('type "mytextx.encr"^|find "" /v /c') do set /a cnt=%%a
set /a full = 100
for /l %%a in (1,1,%full%) do (CALL:ADDSPACE)
set /a denom=%full%/%cnt%
set /a current_progress=0

if exist "mytextx.encr" (
SET myalphabet=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@#-/\ .0123456789
SET dictionary=A 23456 B 23456 C 23456 D 23456 E 23456 F 23456 G 23456 H 23456 I 23456 J 23456 K 23456 L 23456 M 23456 N 23456 O 23456 P 23456 Q 23456 R 23456 S 23456 T 23456 U 23456 V 23456 W 23456 X 23456 Y 23456 Z 23456 a 23456 b 23456 c 23456 d 23456 e 23456 f 23456 g 23456 h 23456 i 23456 j 23456 k 23456 l 23456 m 23456 n 23456 o 23456 p 23456 q 23456 r 23456 s 23456 t 23456 u 23456 v 23456 w 23456 x 23456 y 23456 z 23456 @ 23456 # 23456 - 23456 / 23456 \ 23456   23456 . 23456 0 23456 1 23456 2 23456 3 23456 4 23456 5 23456 6 23456 7 23456 8 23456 9 23456 
(
 FOR /f "delims=" %%a IN (mytextx.encr) DO (
  SET line=%%a
  set /a current_progress=current_progress+%denom%
  set set_title=Decyphering
  CALL:PROGRESS
  (CALL :decipher)>>mytextx.txt
 )
)
DEL _temp.bat
ECHO.
ECHO DO NOT CLOSE THIS CONSOLE.
ECHO.
ECHO Waiting a few seconds to open mytextx.txt file.
ECHO Then mytextx.txt will be deleted.
ECHO.
ECHO To close it faster press any key.
ECHO.
ECHO DO NOT CLOSE THIS CONSOLE.
TIMEOUT 10
del mytextx.txt
) else (
	ECHO File "mytextx.encr" does not exist.
	timeout 5
)
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
 )>_temp.bat
 cls
 call _temp.bat
 GOTO :EOF
