# Desafio Adventureworks

## Objetivo

Neste repositório visa-se desenvolver um projeto completo de uma pipeline de dados. 

Você verá:

* Extração de dados da fonte utilizando a ferramenta Airbyte.
* Modelagem de data-warehouse utilizando dbt.
* Construção de dashboards para a visualização dos dados com Metabase.

Este trabalho faz parte de um desafio da trilha de [analytics engineers](https://blog.indicium.tech/primeira-formacao-em-analytics-engineering-do-brasil/) do projeto [Lighthouse](https://blog.indicium.tech/lighthouse-formacao-na-area-de-dados-da-indicium/) da Indicium.

## Repositório

* desafio_analytics é o repositório para o desafio que contém o código referente ao dbt do DW.

## Dados:

* Utilizamos o banco de dados exemplo da [AdventureWorks](https://docs.microsoft.com/pt-br/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms) disponibilizado publicamente pela Microsoft. E apenas os dados referentes a área __production__.

## Procedimento operacional:

###  1) Modelagem conceitual e entendimento do problema

Iniciamos nosso projeto buscando entender os principais processos de negócios, métricas e KPI’s da área de produção. Assim como, estudar o banco de dados e entender quais desses processos seriam possíveis mapear com os dados disponibilizados.

Após esse processo, mapeamos 4 processos de negócios:

* __Ordem de serviço:__

Refere-se a um pedido para a manufatura de um produto da empresa. Cada novo pedido de manufatura é um dado novo no banco de dados.

* __Detalhamentos da ordem de serviço:__

Refere-se a descrição da sequência do processo de manufatura que a ordem de serviço percorre desde a matéria prima até o produto final. Quando o pedido passa para a fase seguinte é gerado um dado novo do banco.

* __Estoque:__

Quando um pedido de serviços não é vendido logo ao final do processo, vai para o estoque. O banco de dados guarda quantos produtos tem em cada localização/armazém.

* __Transações:__

Refere-se às transações de compra e venda de materiais/produtos e ordem de serviços. Cada nova transação gera um dado novo no banco de dados.

Utilizando a abordagem de modelagem dimensional, mapeamos esses processos em 4 fatos, descritos no modelo como __fact_ordens_servicos, fact_ordem_servicos_detalhes, fact_inventario e fact_transacoes__.

e 4 dimensões:

* __Produtos:__ 

Descreve todas as propriedades dos produtos e materiais da empresa.

* __Materiais:__

Descreve as hierarquias entre os materiais, qual material é utilizado para a manufatura de outro material ou produto.

* __Localização:__ 

Descreve onde são os locais de estoque e de manufatura dos produtos.

* __Razão do sucateamento:__

Descreve o motivo pelo qual os produtos que não passaram na inspeção de qualidade são descartados após o término de uma ordem de serviço.

###  2) Extração no airbyte

A partir do entendimento do problema e do mapeamento das tabelas do cliente, seguimos para a etapa de extração de dados do processo de ELT. Nesta etapa, a ferramenta Airbyte foi utilizada. 
	
#### Instalando o airbyte:

Para facilitar a criação do ambiente, um arquivo docker-compose está disponível na pasta do projeto.
Se você não tem o docker instalado na sua máquina siga essas [instruções](https://www.docker.com/products/docker-desktop).
docker-compose up


#### Configurando o airbyte:
Agora o airbyte está rodando localmente, então visite: http://localhost:8000

Configure suas preferências. Primeiramente, você deve ver uma página de integração, digite seu e-mail se quiser atualizações sobre o Airbyte e continue.

Configure sua primeira conexão e crie uma fonte (source). conforme mostra a imagem abaixo:


Então, crie uma destination, no nosso caso, estamos utilizando um banco de dados BigQuery, como a imagem abaixo:

 
 
Agora que já tem uma source e uma destination, falta criar uma conexão (connection) entre os dois. No projeto a frequência de sincronização, fora manual e a extração de tabelas estratégicas (billofmaterials, location, product, productcategory, productcosthistory, productinventory, productsubcategory, scrapreason, transactionhistory, transactionhistoryarchive, workorder, workorderrouting) com o prefixo “raw_” para melhor controle. Como mostra o print abaixo

 

### 3) Modelagem DW no dbt

#### Criando um Ambiente Virtual

A primeira tarefa em um projeto é configurar um ambiente virtual. Desse modo, para criar um ambiente virtual basta rodar o comando abaixo na pasta do projeto (os comandos a seguir são para o sistema operacional Linux):
```
python3 -m venv venv
```
Em seguida, deve-se ativar a venv criada no passo anterior e, para isso, basta rodar o comando:
```
source venv/bin/activate
```
Iniciando o projeto, a instalação do dbt é necessária. Então, o comando abaixo é executado:
```
pip install dbt-bigquery
```
Certifique-se de que o dbt instalado esteja executando o comando abaixo: 
```
dbt --version 
```
Crie um arquivo requirements.txt e adicione a linha
```
dbt-bigquery == 1.0.0		
```
Na sequência, execute para iniciar o dbt:
```
dbt init desafio_analytics
```

#### Profile

Agora é preciso dar um refresh na pasta do projeto e, com isso, deve aparecer as pastas padrão do dbt. 

Com o dbt instalado na pasta do projeto, é preciso fazer a configuração dos arquivos profiles.yml e dbt_project.yml. A configuração do arquivo profiles.yml é feita no diretório /.dbt/profiles.yml (1 arquivo para todos os projetos) e não deve ir para a página do projeto.
```
desafio_analytics_bigquery: 		#isso precisa corresponder ao perfil: em seu arquivo dbt_project.yml
  outputs:   
    dev:
      type: bigquery
      method: service-account
      project: desafioanalytics		#nome do projeto no gcp
      dataset: dbt_seunome	 	#nome do seu dbt dataset, ex. dbt_jessica
      threads: 1				
      timeout_seconds: 300
      location: US 			#localização que o seu server está alocado
      priority: interactive
      retries: 1
      keyfile: /path/to/bigquery.json 	#adicionar o caminho do arquivo .json referente a chave extraído no gcp
  target: dev
 
```
A configuração do arquivo dbt_project.yml é feita a partir da alteração do mesmo arquivo padrão instalado anteriormente. Esse item é muito importante pois ele contém informações que informam ao dbt como operar em seu projeto. 

Logo, deve-se prestar atenção à mudança do nome do projeto e o nome do profile. Obs.: o nome que colocar no profile deve ser o mesmo que você colocou no arquivo profile.yml. 
``` 
name: 'desafio_analytics'
profile: 'desafio_analytics_bigquery'
```

Com ambas as configurações feitas, execute o comando debug para confirmar que você pode se conectar com sucesso. 
``` 
dbt debug
```
Confirme se a última linha da saída é "Connection test: OK connection ok."

Agora é hora de construir os primeiros modelos. 

#### Git

É importante, nesta etapa, a utilização de um repositório Git ou similar. Logo, crie um novo repositório [aqui](https://github.com/new) chamado 'desafio_analytics'. Vincule o projeto dbt com o repositório git criado executando os seguintes comandos. Certifique-se de usar a URL git correta para o seu repositório.
```
$ git init
$ git branch -m main
$ git add .
$ git commit -m "adicione_um_comentario_aqui"
$ git remote add origin https://github.com/USERNAME/desafio_analytics.git
$ git push -u origin main

```
Agora que seu projeto está conectado a um repositório git, execute o comando abaixo para criar uma nova ramificação (branch).
``` 
git checkout -b nome_da_branch	#nome_da_branch, ex: feature/staging
```

#### Construção do modelo

Com tudo configurado, você está pronto para construir seu primeiro modelo. Vamos dividir os modelos em duas pastas: staging e marts. 

Os modelos staging pegam dados brutos, limpam e os preparam para análise posterior. Ou seja, mudança de nomes das tabelas ou transformar uma tabela binário (0 ou 1) em (sim ou não) acontecem nesse modelo. 

Já, os modelos marts descrevem entidades e processos do negócio que queremos mapear. Nele faremos as transformações com joins e unions. Vale destacar que os modelos usam CTEs e a função "ref". 

Os modelos stagings devem ter um prefixo "stg_" e devem ser configurados apenas para visualização na parte do arquivo dbt_project.yml como "materialized: ephemeral". 
Após a elaboração dos modelos, execute o comando abaixo:
``` 
dbt run
```
Adicione testes a seu projeto para validar os seus modelos. Há dois tipos de testes, os testes de schema e os testes de dados. 

Os testes de schema são chamados de “testes genéricos” e são criados junto com os modelos na pasta marts com o mesmo nome do modelo, porém salvos em formato .yml (Ex: modelo = dim_produto.sql; teste_schema = dim_produto.yml). 

Os testes de dados são testes de singularidade que trazem consigo informações únicas usadas para um único propósito. Criados na pasta tests, usam CTEs e a função "ref". Execute o comando abaixo para confirmar se todos os seus testes foram aprovados.
``` 
dbt test
```

Além disso, adicione documentação ao seu projeto através da descrição com riqueza de detalhes e compartilhe essas informações com seu time.

Lembre que após as alterações realizadas no projeto, deve-se enviar para o repositório. Logo, deve-se seguir os seguintes passos:

  1. Adicione todas as suas alterações ao git 
```
git add -a
```
  2. Confirme suas alterações
 ```
git commit -m "comentário"
```
  3. Envie suas alterações para o seu repositório
```
git push --set-upstream origin nome_da_branch
```
  4. Navegue até seu repositório e abra um Pull Request para mesclar o código em seu branch master.


#### Referência
Esse README foi baseado nas instruções disponíveis no site do [dbt](https://docs.getdbt.com/tutorial/setting-up).


### 4) Visualização no Metabase

Após algumas conversas e analisar qual dessas KPI 's agregaram mais valor de primeira instância, concluímos que as métricas mais interessantes podem ser divididas em dois painéis: ordem de serviço e  inventário.

* __Painel Ordem de Serviço__

Por este painel é possível analisar a prospecção dos negócios da ordem de serviço de manufatura. 

Os principais indicadores são:
  * Quantidade de Produtos Produzidos;
  * Quantidade de produtos sucateados;
  * Média de Horas dos Processos de Manufatura;
  * Custo Real;
  * Custo Planejado.

E com esses critérios foram feitos algumas análises mais gerais:
  * Quantidade de produtos produzidos por mês;
  * Quantidade de produtos produzido nos últimos 7 dias;
  * Os 10 Produtos mais produzidos;
  * Quantidade de produtos sucateados por mês;
  * Quantidade de produtos sucateados por dia;
  * Os principais motivos de sucateio.

E algumas observações mais detalhadas, como:
* Gastos em compra de matéria prima;
* Custo médio de cada processo de manufatura;
* Média de horas de cada produção.

  * __Painel de Inventário__

Por este painel é possível analisar as prospecções dos negócios do inventário. E o seu indicador é:
* Número de produtos no inventário

Em relação a análise do inventário temos:
* Quais são os locais onde há maior quantidade de produto estocado;
* Qual é a quantidade de produto no inventário por categoria;
* Quais são os tipos produtos por categoria presente no estoque.

E fizemos outra análise em relação ao estoque mínimo crítico da empresa que é um valor estipulado pela própria instituição.
* Quais produtos estão abaixo do nível mínimo de estoque;
* Os 15 produtos com mais variação de estoque em relação ao estoque mínimo crítico.

Além desses dois diagnósticos, trouxemos também uma observação relacionada à visão detalhada dos produtos no inventário:
* Qual é a quantidade de cada produto no inventário e seu estoque mínimo seguro?



