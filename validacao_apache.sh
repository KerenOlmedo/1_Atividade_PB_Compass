#!/bin/bash

# Obter data e hora atual
data_hora=$(date +"%Y-%m-%d %H:%M:%S")

# Verificar o status do serviço do Apache
apache_status=$(systemctl is-active httpd)

# Verificar se o serviço está ativo
if [ "$apache_status" == "active" ]; then
    echo "O serviço do Apache está ONLINE."
    resultado_validacao="ONLINE"

    # Define o nome do arquivo de saída para o serviço online
    arquivo_de_saida="servico_online.txt"
else
    echo "O serviço do Apache está OFFLINE."
    resultado_validacao="OFFLINE"

    # Define o nome do arquivo de saída para o serviço offline
    arquivo_de_saida="servico_offline.txt"
fi

# Mensagem personalizada
mensagem_personalizada="Serviço do Apache verificado."

# Combinação de todas as informações
mensagem_final="$data_hora - Serviço do Apache - Status: $resultado_validacao - $mensagem_personalizada"

# Diretório no NFS
diretorio_nfs="/home/nfs/keren"

# Cria o arquivo de resultado no diretório do NFS com as informações
echo "$mensagem_final" > "$diretorio_nfs/$resultado_validacao"

echo "Resultado da validação foi salvo em $diretorio_nfs/$arquivo_de_saida."
