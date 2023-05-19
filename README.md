<h1 align="center"> Atividade_PB_Compass </h1>
<h3 align="center"> Prática AWS/Linux </h3>


<p align="center">
  <a href="#-Objetivo">Objetivo</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Requisitos AWS">Requisitos AWS</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Requisitos no linux">Requisitos no linux</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-Instruções de Execução">Instruções de Execução</a>
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

Subir instância EC2 com par de chaves
- Acessar a AWS na pagina do serviço EC2, e clicar em "instancias" no menu lateral esquerdo.
- Clicar em "executar instâncias" na parte superior esquerda da tela.
- Inserir um nome para a sua máquina e clicar em "adicionar mais tags".

<br>

## 📎 Referências
[MEditor.md](https://pandao.github.io/editor.md/index.html)