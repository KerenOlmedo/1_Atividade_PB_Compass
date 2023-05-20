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
<br>

#### Gerar Elastic IP e anexar à instância EC2
- Acessar a pagina do serviço EC2, no menu lateral esquerdo em "Rede e Segurança" e clicar em "IPs elásticos".
- Clicar em "Alocar endereço IP elástico".
- Automaticamente a região padrão vai vir como "Grupo de borda de Rede" e selecionado Conjunto de endereços IPv4 públicos da Amazon.
- Clicar em "Alocar".
- Depois de criado selecionar o IP alocado e clicar em "Ações", "Associar endereço IP elástico".
- Selecionar a instância EC2 criada anteriormente.
- Selecionar o endereço IP privado já sugerido.
- Marcar a opção "Permitir que o endereço IP elástico seja reassociado" e clicar em "Associar".
<br>

#### Editar grupo de segurança liberando as portas de comunicação para acesso público
- Na pagina do serviço EC2, no menu lateral esquerdo em "Rede e Segurança" e clicar em "Security groups".
- Selecionar o grupo criado anteriormente junto com a instancia.
- Clicar em "Regras de entrada" e do lado esquerdo da tela em "Editar regras de entrada".
- Automáticamente virão já três regras de entrada definidas(HTTPS/443, HTTP/80, SSH/22), adicione as demais: 111/TCP e UDP,
2049/TCP/UDP. 
Deverá ficar como na tabela abaixo:

    Tipo | Protocolo | Intervalo de portas | Origem | Descrição
    ---|---|---|---|---
    SSH | TCP | 22 | 0.0.0.0/0 | SSH
    TCP personalizado | TCP | 80 | 0.0.0.0/0 | HTTP
    TCP personalizado | TCP | 443 | 0.0.0.0/0 | HTTPS
    TCP personalizado | TCP | 111 | 0.0.0.0/0 | RPC
    UDP personalizado | UDP | 111 | 0.0.0.0/0 | RPC
    TCP personalizado | TCP | 2049 | 0.0.0.0/0 | NFS
    UDP personalizado | UDP | 2049 | 0.0.0.0/0 | NFS

### >> LINUX


<br>

## 📎 Referências
[MEditor.md](https://pandao.github.io/editor.md/index.html)