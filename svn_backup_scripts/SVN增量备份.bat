@echo off
rem Subversion的安装目录及执行文件
set SVN_HOME="C:\Program Files (x86)\VisualSVN Server\bin"
set SVN_ADMIN=%SVN_HOME%\svnadmin.exe
set SVN_LOOK=%SVN_HOME%\svnlook.exe
rem 配置库仓库根目录
set SVN_REPOROOT=D:\Repositories
rem 压缩命令
set RAR_CMD="C:\Program Files (x86)\WinRAR\WinRAR.exe"
rem 增量备份文件存放路径
set RAR_STORE=D:\svn_backup
rem 日志及最后一次备份修订号存放文件目录，以下是跟增量备份脚本目录同一目录
set DUMP_PATH=%~dp0\svn_dump
set Log_PATH=%~dp0\svn_dump_log
rem 读取项目库列表文件，并忽略其中;开头的行
FOR /f "eol=;" %%C IN (svn_dump\svn_dump_project.conf) DO call svn_dump\svn_dump_increment.bat %%C