<#
Extra server setup steps


7. Change Dockerfile in master and agent to use: nano-java:jre1.8.0_91 
#>

cd c:\
mkdir jenkins
cd jenkins

# Installs: 
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

cinst -y git
cinst -y notepadplusplus
cinst -y jdk8nn

& 'C:\Program Files\Git\bin\git' clone https://github.com/wallism/windowscontainers-jenkinsci.git

cd .\windowscontainers-jenkinsci\java_jre

docker build -t nano-java:jre1.8.0_91 .


