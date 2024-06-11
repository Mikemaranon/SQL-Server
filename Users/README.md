# EXECUTE AS ADMIN!
- Bat to start MSSQL instance
```bat
@ECHO OFF
echo "starting sql server"
net user "<administrator>" /active:yes
pause
net start mssqlserver
pause
```
- Bat to start Custom instance
```bat
@ECHO OFF
echo "starting sql server"
net user "<administrator>" /active:yes
pause
net start mssql$<customName>
pause
```
