# ☁️ ContainerEmNuvem

Este repositório contém o código para construir e executar um serviço de gerenciamento de brinquedos usando Docker e Azure Container Instances (ACI). Aqui você encontrará instruções para criar a imagem Docker, fazer push para o Azure Container Registry (ACR), e implantar no ACI.

## 📜 Pré-requisitos

Antes de começar, certifique-se de ter o seguinte:

- [Docker](https://www.docker.com/get-started) instalado e configurado.
- [Azure CLI](https://learn.microsoft.com/pt-br/cli/azure/install-azure-cli) instalado e autenticado na sua conta Azure.

## 📟 EndPoints acessiveis

### 1. Página Home
```bash
brinquedos-repositorio.eastus.azurecontainer.io:8080
```

### 2. Página Brinquedos
```bash
brinquedos-repositorio.eastus.azurecontainer.io:8080/listar
```

### 3. Página Fornecedores
```bash
brinquedos-repositorio.eastus.azurecontainer.io:8080/fornecedores
```

## 🔧 Passos para configuração

### 1. Build da Imagem Docker
Primeiro, você precisa construir a imagem Docker do projeto. Para isso, executamos o seguinte comando:

```bash
docker build -t brinquedos_repositorio:v1 .
```

### 2. Executar a Imagem Docker Localmente
Para testar a imagem Docker localmente antes de enviá-la para o ACR, você pode executar o container com o seguinte comando:

```bash
docker run -p 8080:8080 brinquedos_repositorio:v1
```

Agora, a aplicação estará disponível localmente na porta 8080.

### 3. Criar um Grupo de Recursos no Azure
Agora, crie um grupo de recursos no Azure onde todos os recursos serão organizados:

```bash
az group create --name rg-aci-brinquedosrm551261 --location eastus
```

### 4. Criar o Azure Container Registry (ACR)
Em seguida, crie um ACR para armazenar a imagem Docker:

```bash
az acr create --resource-group rg-aci-brinquedosrm551261 --name rm551261acrbrinquedos --sku Basic --location eastus
```

### 5. Autenticar no ACR
Faça login no seu registro de contêiner:

```bash
az acr login --name rm551261acrbrinquedos
```

### 6. Taggear e Fazer Push da Imagem Docker para o ACR
Agora, você deve taggear a imagem Docker local para enviá-la ao ACR:

```bash
docker tag brinquedos_repositorio:v1 rm551261acrbrinquedos.azurecr.io/brinquedos_repositorio:v1
```

Depois, faça o push da imagem para o ACR:

```bash
docker push rm551261acrbrinquedos.azurecr.io/brinquedos_repositorio:v1
```

### 7. Habilitar Credenciais de Admin no ACR
Habilite as credenciais de admin no ACR para permitir a autenticação durante a criação do container:

```bash
az acr update -n rm551261acrbrinquedos --admin-enabled true
```

### 8. Recuperar Credenciais do ACR
Recupere as credenciais do ACR para utilizá-las na criação do container:

```bash
az acr credential show --name rm551261acrbrinquedos
```

### 9. Criar e Executar a Instância de Contêiner no Azure
Agora que a imagem Docker está no ACR, você pode criar uma instância de contêiner no Azure para executar a aplicação:

```bash
az container create --resource-group rg-aci-brinquedosrm551261 --name rm551261-aci-brinquedos --image rm551261acrbrinquedos.azurecr.io/brinquedos_repositorio:v1 --cpu 1 --memory 1.5 --registry-login-server rm551261acrbrinquedos.azurecr.io --registry-username rm551261acrbrinquedos --registry-password <SUA_SENHA_ACR> --dns-name-label brinquedos-repositorio --ports 8080
```

Substitua *<SUA_SENHA_ACR>* pela senha obtida no comando anterior.

### 10. Acessar o Serviço
Após criar a instância, sua aplicação estará disponível publicamente através do endereço DNS gerado. Acesse-a através da URL:

```bash
http://brinquedos-repositorio.eastus.azurecontainer.io:8080
```
