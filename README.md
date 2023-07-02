<h1 align="center"> 1_Atividade_PB_Compass </h1>
<h3 align="center"> Prática AWS/Linux </h3>


<p align="center">
  <a href="#-Objetivo">Objetivo</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Requisitos-AWS">Requisitos AWS</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Requisitos-no-linux">Requisitos no linux</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Instruções-de-Execução">Instruções de Execução</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Referências">Referências</a>
</p>


## 🚀 Objetivo

Documentar detalhadamente o processo de criação de um ambiente AWS com instância EC2 configurado com NFS para armazenamento de dados e do Apache com script de validação automatizado para execução.
<br>

## ☁ Requisitos AWS

<li> Gerar uma chave pública para acesso ao ambiente;
<li> Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD);
<li> Gerar 1 elastic IP e anexar à instância EC2;
<li> Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e UDP,
2049/TCP/UDP, 80/TCP, 443/TCP).
<br>

## 💻 Requisitos no linux

<li> Configurar o NFS entregue;
<li> Criar um diretorio dentro do filesystem do NFS com seu nome;
<li> Subir um apache no servidor - o apache deve estar online e rodando;
<li> Criar um script que valide se o serviço esta online e envie o resultado da validação
para o seu diretorio no nfs;
<li> O script deve conter - Data HORA + nome do serviço + Status + mensagem
personalizada de ONLINE ou offline;
<li> O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço
OFFLINE;
<li> Preparar a execução automatizada do script a cada 5 minutos.
<li> Fazer o versionamento da atividade;
<li> Fazer a documentação explicando o processo de instalação do Linux.
<br>

## 📝 Instruções de Execução
### >> AWS
### Subir instância EC2 com par de chaves pública
- Acessar a AWS na pagina do serviço EC2, e clicar em "instancias" no menu lateral esquerdo.
- Clicar em "executar instâncias" na parte superior esquerda da tela.
- Abaixo do campo de inserir nome clicar em "adicionar mais tags".
- Crie e insira o valor para as chaves: Name, Project e CostCenter, selecionando "intancias", "volume" e "interface de rede" como tipos de recurso.
- Abaixo selecione também a AMI Amazon Linux 2(HVM) SSD Volume Type.
- Selecionar como tipo de intância a família t3.small.
- Em Par de chaves login clique em "criar novo par de chaves".
- Insira o nome do par de chaves, tipo RSA, formato .ppk e clique em "criar par de chaves".
- Em configurações de rede, selecione criar grupo de segurança e permitir todos tráfegos(SSH).
- Configure o armazenamento com 16GiB, volume raiz gp2.
- Clique em executar instância.

### Gerar Elastic IP e anexar à instância EC2
- Acessar a pagina do serviço EC2, no menu lateral esquerdo em "Rede e Segurança" e clicar em "IPs elásticos".
- Clicar em "Alocar endereço IP elástico".
- Automaticamente a região padrão vai vir como "Grupo de borda de Rede" e selecionado Conjunto de endereços IPv4 públicos da Amazon.
- Clicar em "Alocar".
- Depois de criado selecionar o IP alocado e clicar em "Ações", "Associar endereço IP elástico".
- Selecionar a instância EC2 criada anteriormente.
- Selecionar o endereço IP privado já sugerido.
- Marcar a opção "Permitir que o endereço IP elástico seja reassociado" e clicar em "Associar".

### Editar grupo de segurança liberando as portas de comunicação para acesso público
- Na pagina do serviço EC2, no menu lateral esquerdo em "Rede e Segurança" e clicar em "Security groups".
- Selecionar o grupo criado anteriormente junto com a instancia.
- Clicar em "Regras de entrada" e do lado esquerdo da tela em "Editar regras de entrada".
- Automáticamente virá uma regra de entrada definidas(SSH/22), adicione as demais: 111/TCP e UDP,
2049/TCP/UDP, HTTPS/443, HTTP/80.
- Deverá ficar como na tabela abaixo:

    Tipo | Protocolo | Intervalo de portas | Origem | Descrição
    ---|---|---|---|---
    SSH | TCP | 22 | 0.0.0.0/0 | SSH
    TCP personalizado | TCP | 80 | 0.0.0.0/0 | HTTP
    TCP personalizado | TCP | 443 | 0.0.0.0/0 | HTTPS
    TCP personalizado | TCP | 111 | 0.0.0.0/0 | RPC
    UDP personalizado | UDP | 111 | 0.0.0.0/0 | RPC
    TCP personalizado | TCP | 2049 | 0.0.0.0/0 | NFS
    UDP personalizado | UDP | 2049 | 0.0.0.0/0 | NFS

- Clicar em "Salvar regras".

### >> LINUX
### Servidor NFS utilizando Elastic File System
Antes de começarmos as configurações via SSH para EFS, navegue no serviço EC2 da AWS em Security groups.
- Clique em criar grupo de segurança, este será utilizado para segurança de rede do EFS.
- Depois de atribuir um nome(EFS-acess), adicione como regra de entrada para NFS com origem para o grupo de segurança criado e anexado juntamente da instancia.
Deverá ficar assim:
    Tipo | Protocolo | Intervalo de portas | Origem | Descrição
    ---|---|---|---|---
    NFS | TCP | 2049 | sg-0e0fe595c74f876a6 | NFS

- Clique em criar grupo de segurança para finalizar.

### Criando Elastic File System
- Ainda no ambiente da AWS, navegue até o serviço de EFS.
- No menu lateral esquerdo clique em Sistemas de arquivos e logo após em "Criar sistema de arquivos" a direita.
- Adicione um nome para o mesmo(sistemaArquivosEFS) e selecione a opção "personalizar".
- Marque a opção "One zone" e selecione a zona de disponibilidade em que suas EC2 está criada e avance.
- Mantenha as opções pré-definidas, só altere o grupo de segurança para o "EFS-acess" criado anteriormente.
- Revise e clique em criar para finalizar.
- Abra o sistema de arquivos criado e clique no botão "anexar" a esquerda para visualizar as opções de montagem(IP ou DNS). 
- A AWS já te dá os comandos definidos de acordo com as opções escolhidas, nesse caso vamos utilizar a montagem via DNS usando o cliente do NFS, copie o mesmo. Como no exemplo abaixo:
```
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-07d84686cb6d691f7.efs.us-east-1.amazonaws.com:/ efs
```
### Montando sistema de arquivos do EFS
- Configure o NFS acessando sua maquina via SSH e instalando o pacote necessário através do comando:
```
sudo yum install nfs-utils
```
Ao instalar o "nfs-utils", você estará habilitando seu sistema para usar o NFS, é um protocolo que permite compartilhar diretórios e arquivos entre sistemas operacionais em uma rede.
- Depois disso é necessário criar um diretório de arquivos para o EFS no diretótio de montagem, através do comando:
```
sudo mkdir /mnt/efs
```
Podemos montar o sistema de arquivos de forma manual e de forma automática.
#### --> Manual 
Nessa forma será necessário montar sempre que a maquina for iniciada, utilizando o comando abaixo(o mesmo copiado do sistemas de arquivos):
```
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs- fs-07d84686cb6d691f7.efs.us-east-1.amazonaws.com:/ /mnt/efs
```
Certifique-se de substituir "/mnt/efs" pelo caminho real do seu diretório e "fs-07d84686cb6d691f7.efs.us-east-1.amazonaws.com" pelo ID e região do seu sistema de arquivos.

- Para verificar se o sistema de arquivos do EFS está montado no diretório /mnt/efs, você pode usar o seguinte comando:
```
df -hT | grep /mnt/efs
```
Este comando lista todos os sistemas de arquivos montados no sistema e filtra apenas as linhas que contêm o diretório /mnt/efs. Se o EFS estiver montado corretamente, você verá uma linha de saída que mostra o sistema de arquivos do EFS e seus detalhes.

#### --> Forma Automática


- Para configurar a montagem do sistema de arquivos de forma automática é necessário editar o arquivo "etc/fstab", edite o mesmo através do comando:
```
sudo nano /etc/fstab
```
- Adicione a seguinte linha no final do arquivo:
```
fs-07d84686cb6d691f7.efs.us-east-1.amazonaws.com:/ /mnt/efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0
```
Novamente, substitua "fs-07d84686cb6d691f7.efs.us-east-1.amazonaws.com" pelo ID do sistema de arquivos do seu EFS.
- Salve e feche o arquivo.
- Execute o seguinte comando para reiniciar a instância:
```
sudo reboot
```
Após a reinicialização, o sistema de arquivos do EFS estará montado no diretório /mnt/efs e estará disponível para uso na instância.
Para verificar se o sistema de arquivos do EFS está realmente montado, execute o comando:
```
df -hT | grep /mnt/efs
```
Este comando lista todos os sistemas de arquivos montados no sistema e filtra apenas as linhas que contêm o diretório /mnt/efs. Se o EFS estiver montado corretamente, você verá uma linha de saída que mostra o sistema de arquivos do EFS e seus detalhes.

### Configurando Apache no Servidor
- Atualizar os pacotes do sistema com o comando:
```
sudo yum update
```
- Instale o Apache executando o comando:
```
sudo yum install httpd
```
- Após a conclusão da instalação, inicie o serviço do Apache com o comando:
```
sudo /bin/systemctl start httpd.service
```
- Utilize também o seguinte comando para habilitar o serviço do Apache para inicialização automática:
```
sudo systemctl enable httpd.service
```
- Verifique se o Apache está em execução executando o comando:
```
sudo service httpd status
```
- Ir até o diretório padrão dos arquivos do Apache com o comando:
```
cd var/www/html
```
- Verificar se tem um arquivo html no diretório com o comando:
```
ls
```
Abra o arquivo com o comando abaixo e caso não tenha você pode cria-lo da mesma forma.
```
sudo nano index.html
```
O conteudo HTML desse arquivo que aparecerá na página do navegador ao acessar o IP publico na sua maquina. Desta forma certifica-se de que o Apache está rodando. Abaixo um exemplo de conteúdo HTML para teste(colar no arquivo criado).
```
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Apache</title>
</head>
<body>
  <h1>Apache rodando com sucesso!!!</h1>
</body>
</html>
```

### Criando um script que valide se o serviço do Apache está online
- Para criar um script é necessário utilizar um editor de texto e ao final do nome do arquivo atribuir a extensão "sh". O comando abaixo criará e abrirá o arquivo vazio.
```
nano validacao_apache.sh
```
- Colar o código abaixo no arquivo.
```
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
diretorio_nfs="/mnt/efs/keren"

# Cria o arquivo de resultado no diretório do NFS com as informações
echo "$mensagem_final" > "$diretorio_nfs/$arquivo_de_saida"

echo "Resultado da validação foi salvo em $diretorio_nfs/$arquivo_de_saida."

```
- Certifique-se de substituir "/mnt/efs/keren" pelo caminho real do diretório no NFS em que você deseja salvar o arquivo de resultado.
- Depois de criar o arquivo "validacao_apache.sh" é preciso dar permissão de execução ao mesmo usando o comando:
```
sudo chmod +x validacao_apache.sh
```
- Depois para executar o script estando no diretório em que ele pertence utilize o comando:
```
./validacao_apache.sh
```
- Para executá-lo fora do diretório em que ele pertence é necessário utilizar o caminho completo como no exemplo de comando abaixo:
```
/home/validacao_apache.sh

```
### Automatizando o script para execução a cada 5 minutos

Para automatizar a execução do script a cada 5 minutos, você pode usar a ferramenta cron no Linux. O cron é um utilitário que permite agendar tarefas para serem executadas em momentos específicos.
- No seu  terminal e digite o seguinte comando para editar as tarefas cron:
```
crontab -e
```
- Ao abrir o arquivo é preciso adicioar a seguinte linha para agendar a execução do script a cada 5 minutos:
```
*/5 * * * * /caminho/para/o/script/validacao_apache.sh
```
Substitua "/caminho/para/o/script" pelo caminho real para o diretório onde o seu script "validacao_apache.sh" está localizado.

Para entender cada parte dessa configuração:

*/5: O asterisco (*) significa "qualquer valor".
No contexto dos minutos, */5 significa "a cada 5 minutos". Ou seja, a tarefa será executada quando o valor dos minutos for divisível por 5.

O asterisco (*) é usado para representar "qualquer valor" nas outras partes da configuração. Na terceira posição representa "qualquer valor" para o dia do mês, na quarta posição representa "qualquer valor" para o mês e na quinta posição representa "qualquer valor" para o dia da semana.

OBS: O cron irá executar o script no contexto do usuário atual. Portanto, certifique-se de que o usuário tenha permissão adequada para executar o script e acessar os recursos necessários.

- Verificar se o script está realmente está automatizado. Vá até o diretório de compartilhamento criado e abra o arquivo de saida gerado("servico_offline.txt" ou "servico_online.txt" como no exemplo dado anteriormente), nele constará a hora e data em que o arquivo foi gerado. Dê 5 minutos e repita o processo para verificar se foi gerado um novo arquivo com horário de 5 minutos mais recente.
<br>

## 📎 Referências
[MEditor.md](https://pandao.github.io/editor.md/index.html)<br>
[Servidor de Arquivos NFS](https://debian-handbook.info/browse/pt-BR/stable/sect.nfs-file-server.html)<br>
[Documentação Apache](https://httpd.apache.org/docs/2.4/pt-br/)
[AWS Elastic File System](https://aws.amazon.com/pt/efs/)
