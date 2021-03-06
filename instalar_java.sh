#!/bin/bash

JDK_FILE=$1;

PREFIX_PATH="PATH="
FILE=~/.bashrc


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
  if [ -z $JDK_FILE ]; then
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
  
  JDK_DIR=$(tar -zxvf $JDK_FILE)

  JDK_DIR_NAME=$(echo $JDK_DIR | head -n 1 | cut -d "/" -f 1)
  
  echo "Movendo para o diretorio /opt !"
  mv $JDK_DIR_NAME /opt

  Add_Variable "JAVA_HOME" "/opt/$JDK_DIR_NAME"

  source ~/.bashrc

  echo "Finalizado !" 
}



Add_Variable() 
{
  SUFIX_EXPORT="="
  VARIABLE_KEY=$1
  VARIABLE_VALUE=$2
  VARIABLE_KEY_SUFIX=$1$SUFIX_EXPORT  

  #echo $VARIABLE_KEY

  NUMBER_LINE_PATH=$(grep -n $VARIABLE_KEY_SUFIX $FILE | cut -d ":" -f 1)

  if [ -z $NUMBER_LINE_PATH ]; then
    #echo "nao tem variavel"
    Add_Path $VARIABLE_KEY $VARIABLE_VALUE false
  else 
    #echo "tem variavel"  
    Add_Path $VARIABLE_KEY $VARIABLE_VALUE true
  fi
}


Add_Path() 
{

  VARIABLE_KEY=$1  
  VARIABLE_VALUE=$2
  VARIABLE_EXISTS=$3
  NEW_VALUE="export $VARIABLE_KEY=$VARIABLE_VALUE"

  #echo $VARIABLE_KEY
  #echo $VARIABLE_VALUE
  #echo $NEW_VALUE

  NUMBER_LINE_PATH=$(grep -n $PREFIX_PATH $FILE | cut -d ":" -f 1)

  #echo $NUMBER_LINE_PATH

  if [ -z $NUMBER_LINE_PATH ]; then
    #echo "não tem path"
    echo "" >> $FILE
    #adicionando a nova variavel
    echo $NEW_VALUE >> $FILE
    #adicionando ao path
    echo "export PATH=$PATH:\$$VARIABLE_KEY/bin" >> $FILE
  else
    #echo "tem path"
    OLD_PATH_VALUE=$(grep PATH= $FILE)

    if [ "$VARIABLE_EXISTS" = "false" ]; then
      #echo "nao tem variavel"
      sed -i "$NUMBER_LINE_PATH""i$NEW_VALUE" $FILE   
    fi

    EXISTS_IN_PATH=$(grep -n $VARIABLE_KEY <<< $OLD_PATH_VALUE | cut -d ":" -f 1)
    
    if [ -z $EXISTS_IN_PATH ]; then
          sed -i 's,'"$OLD_PATH_VALUE,""$OLD_PATH_VALUE:\$$VARIABLE_KEY/bin"',g' $FILE
    fi

  fi
}

Main