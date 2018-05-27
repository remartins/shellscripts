#!/bin/bash

jdk_file=$1;


Main()
{
  if [ "$(id -u)" != "0" ]; then
    echo "Voce deve executar este script como root! "
  else
    Read_file
  fi
}


Read_file() 
{
  if [ -z $jdk_file ]; then
    echo "Informe o arquivo jdk*.tar.gz !"
    echo "Exemplo:"
    echo "sudo ./instalar_java jdk-8u172-linux-x64.tar.gz"
  else
    echo "Desinstalando o OpenJDK !"
    apt-get remove --purge openjdk-*
    Install_jdk
  fi
}

Install_jdk()
{
  echo "Extraindo o tar.gz !"
  
  jdk_dir=$(tar -zxvf $jdk_file)

  jdk_dirname=$(echo $jdk_dir | head -n 1 | cut -d "/" -f 1)
  
  echo "Movendo para o diretorio /opt !"
  mv $jdk_dirname /opt
  
  echo "Atribuindo variaveis de ambiente !"

  echo "" >> ~/.bashrc
  echo "export JAVA_HOME=/opt/$jdk_dirname" >> ~/.bashrc
  echo "export PATH=$PATH:\$JAVA_HOME/bin" >> ~/.bashrc
  source ~/.bashrc
  echo "Finalizado !" 
}

Main




