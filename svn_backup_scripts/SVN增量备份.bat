@echo off
rem Subversion�İ�װĿ¼��ִ���ļ�
set SVN_HOME="C:\Program Files (x86)\VisualSVN Server\bin"
set SVN_ADMIN=%SVN_HOME%\svnadmin.exe
set SVN_LOOK=%SVN_HOME%\svnlook.exe
rem ���ÿ�ֿ��Ŀ¼
set SVN_REPOROOT=D:\Repositories
rem ѹ������
set RAR_CMD="C:\Program Files (x86)\WinRAR\WinRAR.exe"
rem ���������ļ����·��
set RAR_STORE=D:\svn_backup
rem ��־�����һ�α����޶��Ŵ���ļ�Ŀ¼�������Ǹ��������ݽű�Ŀ¼ͬһĿ¼
set DUMP_PATH=%~dp0\svn_dump
set Log_PATH=%~dp0\svn_dump_log
rem ��ȡ��Ŀ���б��ļ�������������;��ͷ����
FOR /f "eol=;" %%C IN (svn_dump\svn_dump_project.conf) DO call svn_dump\svn_dump_increment.bat %%C