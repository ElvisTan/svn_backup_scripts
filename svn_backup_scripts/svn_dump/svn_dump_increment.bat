@echo off
rem ���ø�ʽ��dump ��Ŀ����
if "%1"=="" goto no_args
set PROJECT=%1
if not exist %RAR_STORE%\%PROJECT% mkdir %RAR_STORE%\%PROJECT%
cd %RAR_STORE%\%PROJECT%
SET LOWER=0
SET UPPER=0
if not exist %Log_PATH%\%PROJECT% mkdir %Log_PATH%\%PROJECT%
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] ��ʼ����.>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
%SVN_LOOK% youngest %SVN_REPOROOT%\%PROJECT%> %Log_PATH%\read_new_revision.tmp
@FOR /f %%D IN (%Log_PATH%\read_new_revision.tmp) DO set UPPER=%%D
if %UPPER%==0 GOTO :N_EXIT
if not exist %DUMP_PATH%\svn_dump_%PROJECT%_last_revision.dat GOTO :BAKUP
rem ȡ���ϴα��ݺ�İ汾�ţ�������1����(ע����㷨δ��98ϵͳ��֤)
@FOR /f %%C IN (%DUMP_PATH%\svn_dump_%PROJECT%_last_revision.dat) DO @set LOWER=%%C
@set /A LOWER=%LOWER%+1
rem ����Ҫ���ݣ�����ת����
IF %LOWER% gtr %UPPER% GOTO :N_EXIT

:BAKUP
SET FILENAME=svn_%PROJECT%_dump_FROM_%LOWER%_TO_%UPPER%.DMP
@ECHO ��ʼ����[%PROJECT%]�����ļ�[%FILENAME%]
@ECHO %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] �����ļ�[%FILENAME%]>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
%SVN_ADMIN% dump %SVN_REPOROOT%\%PROJECT% -r %LOWER%:head --incremental >%FILENAME%
%RAR_CMD% a -ag -df svn_%PROJECT%_dump_FROM_%LOWER%_TO_%UPPER%_AT_.rar %FILENAME%
rem ׼��д������־��Ϣ
IF %LOWER% gtr 0 GOTO :WRITENOTE
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] ����[%LOWER%]��[%UPPER%]���.>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
GOTO :COMPLETE

:WRITENOTE
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] ��������[%LOWER%]��[%UPPER%]���.>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt

:COMPLETE
rem ����һ�����ڿ��������ļ���Ŀ���ַ
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] �����ļ�ѹ�����.>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
del %Log_PATH%\read_new_revision.tmp
@echo %UPPER% > %DUMP_PATH%\svn_dump_%PROJECT%_last_revision.dat

:N_EXIT
@ECHO ��Ŀ��[%PROJECT%]�������
@echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% [%PROJECT%] ���ݽ���!>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
@CD..
@exit /B

:no_args
@ECHO ON
@echo "����ȷʹ��svnadmin dump���dump ��Ŀ����"