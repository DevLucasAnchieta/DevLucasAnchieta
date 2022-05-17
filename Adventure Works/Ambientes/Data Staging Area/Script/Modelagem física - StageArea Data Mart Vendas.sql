/*Conectando no banco de dados AdventureWorks2012*/

Use AdvetureWorks2012
Go

/*Criando tabela auxiliar para a dimensão de pagamentos*/
Create Table StageArea.AuxPagamento(
	IdAuxPagamento int Identity,
	FormaPagamento nvarchar(50)
)
Go


/*Script do ambiente de Stage Area*/


/*Criando o banco de dados que irá armazenar o ambiente de Stage Area*/
Create Database StgArea_AdventureWorks
Go 



/*Criação do Schema StageArea para as tabelas da StagingArea*/
Create Schema StageArea
Go 


/*Conectando no Banco de dados StgArea.AdventureWorks*/
Use StgArea_AdventureWorks
Go 


/*Criando a tabela fato Vendas*/
Create Table StageArea.fVendas(
		IdVendas 				int,
		IdPedido 				int,
		IdProduto 				int,
		IdCliente 				int,
		IdVendedor				int,
		IdPagamento 			int,
		IdCambio				int,
		DtVenda					datetime,
		Quantidade 				smallint,
		Custo_Produto_Unitário	money,
		Preço_Unitário			money,
		Desconto				money,
		Subtotal				money,
		Imposto           		money,
		Frete 					money,
		Valor_Total				money
)
Go

/*Criando a tabela da dimensão Pedido*/

Create Table StageArea.DimPedido(
		IdPedido 	int,
		Status 		tinyint
)
Go

/*Criando a tabela da dimensão Produto*/

Create Table StageArea.DimProduto(
		IdProduto 		int,
		IdSubcategoria 	int,
		Produto 		nvarchar(50),
		Modelo	 		nvarchar(50),
		Linha_Produto	nchar(2),
		Publico_Alvo	nchar(2)
)
Go

/*Criando a tabela tbSubcategoria*/

Create Table StageArea.tbSubcategoria(
		IdSubcategoria 	int,
		Subcategoria 	nvarchar(50),
		Categoria 		nvarchar(50)
)
Go


/*Criando a tabela da dimensão Cliente*/

Create table StageArea.DimCliente(
		IdCliente 	int,
		Cliente 	nvarchar(160),
		Regiao 		nvarchar(50),
		País 		nvarchar(50),
		País_Sigla 	nvarchar(3),
		Continente 	nvarchar(50)
)
Go


/*Criando a tabela da dimensão Vendedor*/

Create Table StageArea.DimVendedor(
		IdVendedor 	int,
		Vendedor   	nvarchar(110),
		Comissão 	smallmoney
)
Go

/*Criando a tabela da dimensão Pagamento*/

Create Table StageArea.DimPagamento(
		IdPagamento int,
		Pagamento 	nvarchar(50)
)
Go

/*Criando a tabela da dimensão Pagamento*/

Create Table StageArea.DimCambio(
		IdCambio		int,
		Moeda_Origem	nvarchar(3),
		Moeda_Destino	nvarchar(3),
		Cambio_Médio	money,
		Cambio_Final	money
)
Go 

/*Criando a tabela tbMoeda*/

Create Table StageArea.tbMoeda(
		IdMoeda nchar(3),
		Moeda 	nvarchar(50)	
)
Go



