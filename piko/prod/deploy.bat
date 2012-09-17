echo Removing all working directories - PLS TURN OFF TOMCAT!!!!
rmdir /s /q home
rmdir /s /q daps
rmdir /s /q paws
rmdir /s /q asmts
rmdir /s /q orgs
echo creating new working directories
mkdir home
mkdir daps
mkdir paws
rem   this long working directory is to take care of caps "Asmt" directory which is crashing viewAsmt
mkdir asmts/src/main/resources/org/ideademo/asmts/pages/asmt
mkdir orgs
echo Copying from Github all working directories - TURN OFF TOMCAT BY NOW !!!!! - 
xcopy c:\users\administrator\documents\github\piko-home home /e /y
xcopy c:\users\administrator\documents\github\piko-home c:\websites\piko /e /y /d
xcopy c:\users\administrator\documents\github\piko-home c:\websites\pacis\piko /e /y /d
xcopy c:\users\administrator\documents\github\piko-daps daps /e /y
xcopy c:\users\administrator\documents\github\piko-paws paws /e /y
xcopy c:\users\administrator\documents\github\piko-asmts c:\installs\piko\asmts /e /y /i
xcopy c:\users\administrator\documents\github\piko-orgs orgs /e /y
rem so to run in test mode you would do deploy.bat anything.  For prod, just deploy.bat with no arguments
IF (%1)==() GOTO SKIP_TEST_FIX
start "!!! Replace index.php with piko for test !!!" /wait cmd /c ant -f test.xml
:SKIP_TEST_FIX
start "daps build" /D daps /wait cmd /c mvn clean install
start "paws build" /D paws /wait cmd /c mvn clean install
start "asmts build" /D asmts /wait cmd /c mvn clean install
start "orgs build" /D orgs /wait cmd /c mvn clean install
rmdir /s /q c:\tomcat5.5.35\logs
mkdir c:\tomcat5.5.35\logs
echo off
echo y | erase c:\webapps\daps.war >:NULL
echo y | erase c:\webapps\pawz.war >:NULL
echo y | erase c:\webapps\asmts.war >:NULL
echo y | erase c:\webapps\orgs.war >:NULL
echo on
rmdir /s /q c:\webapps\daps
rmdir /s /q c:\webapps\pawz
rmdir /s /q c:\webapps\asmts
rmdir /s /q c:\webapps\orgs
echo Cleaned up Tomcat - build new wars 
xcopy daps\target\*.war c:\webapps /y /d
xcopy paws\target\*.war c:\webapps /y /d
xcopy asmts\target\*.war c:\webapps /y /d
xcopy orgs\target\*.war c:\webapps /y /d
xcopy c:\users\administrator\documents\github\piko\target\piko.db.txt /d /y
xcopy c:\users\administrator\documents\github\piko-orgs\target\*.sql /d /y
echo Done copying wars - start Tomact as soon as this script is done - running change logo filenames patch 
C:\PostgreSQL9.1\bin\dropdb --username postgres --no-password --host localhost --port 5432 piko
C:\PostgreSQL9.1\bin\createdb --username postgres --no-password --host localhost --port 5432 -T template0 piko
C:\PostgreSQL9.1\bin\psql --username postgres --no-password --host localhost --port 5432 piko < piko.db.txt
C:\PostgreSQL9.1\bin\psql --username postgres --no-password --host localhost --port 5432 --file=updatelogo.sql piko 
echo ######### DONE Deployment ###### PLS START TOMCAT 






