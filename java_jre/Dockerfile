# escape=`
FROM microsoft/nanoserver

RUN powershell -Command `
    downloadFileWithoutIWR 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185' 'jreinstaller.exe' ; `
    Start-Process -filepath .\jreinstaller.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java\jre1.8.0_91" ; `
    del .\jreinstaller.exe

ENV JAVA_HOME c:\\Java\\jre1.8.0_91
RUN setx PATH %PATH%;%JAVA_HOME%\bin

CMD [ "java.exe" ]
