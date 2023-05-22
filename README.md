<h1 align="center"> Atividade_PB_Compass </h1>
<h3 align="center"> Prática AWS/Linux </h3>


<p align="center">
  <a href="#-Objetivo">Objetivo</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Requisitos-AWS">Requisitos AWS</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Requisitos-no-linux">Requisitos no linux</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Instruções-de-Execução">Instruções de Execução</a>
</p>


## 🚀 Objetivo

Documentar detalhadamente o processo de criação de um ambiente AWS com instância EC2 configurado com NFS para armazenamento de dados.
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
#### Subir instância EC2 com par de chaves pública
- Acessar a AWS na pagina do serviço EC2, e clicar em "instancias" no menu lateral esquerdo.
- Clicar em "executar instâncias" na parte superior esquerda da tela.
- Abaixo do campo de inserir nome clicar em "adicionar mais tags".
- Crie e insira o valor para as chaves: Name, Project e CostCenter, selecionando "intancias", "volume" e "interface de rede" como tipos de recurso.
- Abaixo selecione também a AMI Amazon Linux 2(HVM) SSD Volume Type.
- Selecionar como tipo de intância a família t3.small.
- Em Par de chaves login clique em "criar novo par de chaves".
- Insira o nome do par de chaves, tipo RSA, formato .ppk e clique em "criar par de chaves".
- Em configurações de rede, selecione criar grupo de segurança e permitir todos tráfegos(SSH, HTTPS, HTTP).
- Configure o armazenamento com 16GiB, volume raiz gp2.
- Clique em executar instância.

#### Gerar Elastic IP e anexar à instância EC2
- Acessar a pagina do serviço EC2, no menu lateral esquerdo em "Rede e Segurança" e clicar em "IPs elásticos".
- Clicar em "Alocar endereço IP elástico".
- Automaticamente a região padrão vai vir como "Grupo de borda de Rede" e selecionado Conjunto de endereços IPv4 públicos da Amazon.
- Clicar em "Alocar".
- Depois de criado selecionar o IP alocado e clicar em "Ações", "Associar endereço IP elástico".
- Selecionar a instância EC2 criada anteriormente.
- Selecionar o endereço IP privado já sugerido.
- Marcar a opção "Permitir que o endereço IP elástico seja reassociado" e clicar em "Associar".

#### Editar grupo de segurança liberando as portas de comunicação para acesso público
- Na pagina do serviço EC2, no menu lateral esquerdo em "Rede e Segurança" e clicar em "Security groups".
- Selecionar o grupo criado anteriormente junto com a instancia.
- Clicar em "Regras de entrada" e do lado esquerdo da tela em "Editar regras de entrada".
- Automáticamente virão já três regras de entrada definidas(HTTPS/443, HTTP/80, SSH/22), adicione as demais: 111/TCP e UDP,
2049/TCP/UDP. 
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
### Maquina servidor NFS
- Pra configurar o NFS instale o pacote necessário utilizando o comando:
```
sudo yum install nfs-utils
```
- É necessário criar um diretório para compartilhamento via NFS que pode ser criado através do comando:

```
sudo mkdir nome/do/diretorio
```
- Para realizar as configurações de acesso do NFS será necessário acessar e editar o arquivo “/etc/exports” com um editor de arquivos (neste exemplo foi utilizado o Nano), através do comando:
```
sudo nano /etc/exports
```
- Adicionar uma linha com o caminho do diretório + o intervalo de endereços IP que deseja dar permissão de acesso (neste caso * para qualquer endereço IP) + as devidas permissões entre parênteses como no comando abaixo:
```
/home/nfs *(rw,sync,no_root_squash,no_all_squash)
```
"rw" dará permissões de leitura e gravação, a opção "sync" garante que as alterações sejam gravadas no disco imediatamente, a opção no_root_squash permite acesso de root e "no_all_squash" mantem as permissoes de acesso originais dos usuários das maquinas clientes.
- Depois disso salve o arquivo e reinicie o serviço para atualizar as novas permissões através do comando:
```
sudo systemctl restart nfs-server
```
- Antes de testar verifique se o serviço está ativo com o comando:
```
sudo systemctl status nfs-server
```
- Para verificar se o diretório foi realmente compartilhado execute o comando:
```
sudo exportfs -v
```
O mesmo deverá retornar o diretório criado anteriormente.

### Maquina cliente
- Certificar-se de que a maquina está com o NFS instalado com o comando:
```
nfsstat
``` 
Esse comando exibe estatísticas e informações relacionadas ao NFS. Se o comando for reconhecido e retornar informações, significa que o NFS está instalado, caso não estiver disponível ou não for reconhecido indica que o NFS não está instalado.
- Será necessário montar um diretório de compartilhamento na máquina cliente através do comando:
```
Sudo mount -t nfs 192.168.4.10:/home/nfs /mnt/nfs
```
192.168.4.10 – IP do servidor(substitua pelo da sua maquina servidor)
/home/nfs – caminho absoluto do servidor
/mnt/nfs – caminho local do cliente
- Para verificar se o diretório foi mesmo criado execute o comando:
```
df  -h
```
O mesmo listará as partições montadas em disco e o espaço disponível, nela deve contar o diretório criado e informações do mesmo.

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
Abra o arquivo com o comando abaixo e caso não tenha você pode cria-lo da mesma forma. O conteudo HTML desse arquivo que aparecerá na página do navegador ao acessar o IP publico na sua maquina.
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


<br>

## 📎 Referências
[MEditor.md](https://pandao.github.io/editor.md/index.html)<br>
[Servidor de Arquivos NFS](https://debian-handbook.info/browse/pt-BR/stable/sect.nfs-file-server.html)