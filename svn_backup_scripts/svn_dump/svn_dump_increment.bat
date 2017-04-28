@echo off
rem 调用格式：dump 项目库名
if "%1"=="" goto no_args
set PROJECT=%1
if not exist %RAR_STORE%\%PROJECT% mkdir %RAR_STORE%\%PROJECT%
cd %RAR_STORE%\%PROJECT%
SET LOWER=0
SET UPPER=0
if not exist %Log_PATH%\%PROJECT% mkdir %Log_PATH%\%PROJECT%
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] 开始备份.>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
%SVN_LOOK% youngest %SVN_REPOROOT%\%PROJECT%> %Log_PATH%\read_new_revision.tmp
@FOR /f %%D IN (%Log_PATH%\read_new_revision.tmp) DO set UPPER=%%D
if %UPPER%==0 GOTO :N_EXIT
if not exist %DUMP_PATH%\svn_dump_%PROJECT%_last_revision.dat GOTO :BAKUP
rem 取出上次备份后的版本号，并做＋1处理(注意此算法未在98系统验证)
@FOR /f %%C IN (%DUMP_PATH%\svn_dump_%PROJECT%_last_revision.dat) DO @set LOWER=%%C
@set /A LOWER=%LOWER%+1
rem 不需要备份，则跳转结束
IF %LOWER% gtr %UPPER% GOTO :N_EXIT

:BAKUP
SET FILENAME=svn_%PROJECT%_dump_FROM_%LOWER%_TO_%UPPER%.DMP
@ECHO 开始导出[%PROJECT%]备份文件[%FILENAME%]
@ECHO %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] 导出文件[%FILENAME%]>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
%SVN_ADMIN% dump %SVN_REPOROOT%\%PROJECT% -r %LOWER%:head --incremental >%FILENAME%
%RAR_CMD% a -ag -df svn_%PROJECT%_dump_FROM_%LOWER%_TO_%UPPER%_AT_.rar %FILENAME%
rem 准备写备份日志信息
IF %LOWER% gtr 0 GOTO :WRITENOTE
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] 备份[%LOWER%]到[%UPPER%]完成.>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
GOTO :COMPLETE

:WRITENOTE
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] 增量备份[%LOWER%]到[%UPPER%]完成.>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt

:COMPLETE
rem 下面一行用于拷贝备份文件到目标地址
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] 备份文件压缩完成.>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
del %Log_PATH%\read_new_revision.tmp
@echo %UPPER% > %DUMP_PATH%\svn_dump_%PROJECT%_last_revision.dat

:N_EXIT
@ECHO 项目库[%PROJECT%]备份完成
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] 备份结束!>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
@CD..
@exit /B

:no_args
@ECHO ON
@echo "请正确使用svnadmin dump命令：dump 项目库名"