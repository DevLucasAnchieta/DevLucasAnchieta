/*Script para criação do ambiente físico do Data Mart de Vendas*/

/*Criando o banco de dados do Data Warehouse*/
Create Database DW_AdventureWorks
Go

/*Conectando no banco de dados DW_AdventureWorks*/
Use DW_AdventureWorks
Go

/*Criando o schema DataWarehouse para fins de organização e padronização*/
Create Schema DataWarehouse
Go

/*Criando a tabela fato do Data Mart de Vendas*/
Create Table DataWarehouse.fVendas(
	IdVendas 				int,
	IdPedido 				int,
	IdProduto 				int,
	IdCliente 				int,
	IdVendedor				int,
	IdPagamento 			int,
	IdCambio 				int,
	IdTempo					int,
	Quantidade 				smallint,
	Custo_Produto_Unitário	money,
	Preço_Unitário 			money,
	Desconto 				money,
	SubTotal 				money,
	Imposto 				money,
	Frete 					money,
	Valor_Total 			money
)
Go

/*Criando a tabela para a dimensão Pedido*/

Create Table DataWarehouse.DimPedido(
	IdSK 				int identity Primary Key,
	IdPedido 			int,
	Status 				tinyint
)
Go

/*Crinado a tabela para a dimensão Tempo*/

Create Table DataWarehouse.DimTempo(
	IdSK 				int identity Primary Key,
	Data 				date,
	Dia 				varchar(2),
	Dia_Semana 			varchar(30),
	Mês 				varchar(2),
	Nome_Mês 			varchar(15),
	Quarto 				smallint,
	NomeQuarto 			varchar(10),
	Ano 				varchar(4),
	Estação_Ano 		varchar(30),
	Fim_Semana 			varchar(3),
	Data_Completa		varchar(10)
)
Go

/*Criando a tabela para a dimensão Cambio*/

Create Table DataWarehouse.DimCambio(
	IdSK 				int identity Primary Key,
	IdCambio 			int,
	Moeda_Origem 		nchar(3),
	Moeda_Destino 		nchar(3),
	Cambio_Médio 		money,
	Cambio_Final 		money
)
Go


/*Criando a tabela para a tabela Moeda*/

Create Table DataWarehouse.tbMoeda(
	IdMoeda 		nchar(3) Primary Key,
	Moeda 			nvarchar(50)
)
Go

/*Criando a constraint de chave estrangeira Moeda_Origem e Moeda_Destino*/

Alter Table DataWarehouse.DimCambio Add Constraint FK_DimCambio_tbMoeda_Moeda_Origem
Foreign Key(Moeda_Origem) References DataWarehouse.tbMoeda(IdMoeda)
Go

Alter Table DataWarehouse.DimCambio Add Constraint FK_DimCambio_tbMoeda_Moeda_Destino
Foreign Key(Moeda_Destino) References DataWarehouse.tbMoeda(IdMoeda)
Go

/*Criando a tabela para a dimensão Pagamento*/

Create Table DataWarehouse.DimPagamento(
	IdSK 			int identity Primary Key,
	IdPagamento 	int,
	Pagamento 		nvarchar(50),
	Início 			datetime,
	Fim				datetime
)
Go

/*Criando a tabela para dimensão Vendedor*/

Create Table DataWarehouse.DimVendedor(
	IdSK 			int identity Primary Key,
	IdVendedor 		int,
	Vendedor 		nvarchar(110),
	Comissão 		smallmoney,
	Início 			datetime,
	Fim 			datetime
)
Go

/*Criando a tabela para dimensão Cliente*/

Create Table DataWarehouse.DimCliente(
	IdSK 		int identity Primary Key,
	IdCliente 	int,
	Cliente 	nvarchar(200),
	Região		nvarchar(50),
	País		nvarchar(50),
	País_Sigla	nvarchar(3),
	Continente 	nvarchar(50),
	Início		datetime,
	Fim 		datetime
)
Go

/*Criando a tabela para a dimensão Produto*/

Create Table DataWarehouse.DimProduto(
	IdSK 			int identity Primary Key,
	IdProduto 		int,
	IdSubCategoria 	int,
	Produto 		nvarchar(50),
	Modelo 			nvarchar(50),
	Linha_Produto 	nchar(2),
	Publico_Alvo	nchar(2),
	Início 			datetime,
	Fim 			datetime
)
Go

/*Criando a tabela para a tabela Subcategoria*/

Create Table DataWarehouse.tbSubcategoria(
	IdSubCategoria int Primary Key,
	Subcategoria nvarchar(50),
	Categoria nvarchar(50)
)
Go

/*Criando a constraint de chave estrangeira IdSubcategoria*/

Alter Table DataWarehouse.DimProduto Add Constraint FK_DimProduto_tbSubcategoria
Foreign Key(IdSubCategoria) References DataWarehouse.tbSubcategoria(IdSubCategoria)
Go


/*Criando a constraint de chave estrangeira das dimensões com a tabela fato de Vendas*/


/*Criando a constraint de chave estrangeira da dimensão Pedido*/

Alter Table DataWarehouse.fVendas Add Constraint FK_fVendas_DimPedido
Foreign Key(IdPedido) References DataWarehouse.DimPedido(IdSK)
Go

/*Crinado a constraint de chave estrangeira da dimensão Tempo*/

Alter Table DataWarehouse.fVendas Add Constraint FK_fVendas_DimTempo
Foreign Key(IdTempo) References DataWarehouse.DimTempo(IdSK)
Go

/*Criando a constraint de chave estrangeira da dimensão Cambio*/

Alter Table DataWarehouse.fVendas Add Constraint FK_fVendas_DimCambio
Foreign Key(IdCambio) References DataWarehouse.DimCambio(IdSK)
Go

/*Crinado a constraint de chave estrangeira da dimensão Pagamento*/

Alter Table DataWarehouse.fVendas Add Constraint FK_fVendas_DimPagamento
Foreign Key(IdPagamento) References DataWarehouse.DimPagamento(IdSK)
Go

/*Criando a constraint de chave estrangeria da dimensão Vendedor*/

Alter Table DataWarehouse.fVendas Add Constraint FK_fVendas_DimVendedor
Foreign Key(IdVendedor) References DataWarehouse.DimVendedor(IdSK)
Go

/*Criando a constraint de chave estrangeira da dimensão Cliente*/

Alter Table DataWarehouse.fVendas Add Constraint FK_fVendas_DimCliente
Foreign Key(IdCliente) References DataWarehouse.DimCliente(IdSK)
Go

/*Criando a constraint de chave estrangeira da dimensão Produto*/
Alter Table DataWarehouse.fVendas Add Constraint FK_fVendas_DimProduto
Foreign Key(IdProduto) References DataWarehouse.DimProduto(IdSK)
Go