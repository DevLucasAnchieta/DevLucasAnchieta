/*Conectando no banco de dados AdventureWorks2012*/
Use AdventureWorks2012
Go 


/*Script para filtrar os valores distintos da tabela Sales.CrediCard e inserir este valores na tabela StageArea.AuxPagamento*/
Insert Into StageArea.AuxPagamento (FormaPagamento) Select Distinct CardType From Sales.CreditCard
Go


/*Criação da View Auxiliar de Registro de linhas por IdPedido */
Create View StageArea.vAuxRegistros_Pedido AS
		Select
			SalesOrderID As IdPedido,
			Count(OrderQty) As Registros
		From Sales.SalesOrderDetail
		Group By SalesOrderID
Go

/*Criação da View Auxiliar do rateio do imposto e do frete*/
Create View StageArea.vAuxImposto_Frete As
		Select
			ARP.IdPedido,
			ARP.Registros,
			VC.TaxAmt As Imposto_Total,
			Imposto = VC.TaxAmt/Registros,
			VC.Freight As Frete_Total,
			Frete = Vc.Freight/Registros
		From StageArea.vAuxRegistros_Pedido ARP
		Inner Join Sales.SalesOrderHeader VC
		On ARP.IdPedido = VC.SalesOrderID
Go


/*Criação da View de transição da chave primária IdPagamento*/

Create View StageArea.vTempAuxPagamento As
	Select
		CC.CreditCardID As IdPagamento,
		AuxP.IdAuxPagamento,
		CC.CardType As Pagamento
		From AdventureWorks2012.Sales.CreditCard CC 
		Inner Join StageArea.AuxPagamento AuxP 
		On CC.CardType = AuxP.FormaPagamento
Go


/*Criação da View da tabela fVendas*/
Create View StageArea.vfVendas As 
	Select 
		VD.SalesOrderDetailID As IdVendas,
		VD.SalesOrderID As IdPedido,
		VD.ProductID As IdProduto,
		VC.CustomerID AS IdCliente,
		VC.SalesPersonID As IdVendedor,
		TAP.IdAuxPagamento As IdPagamento,
		VC.CurrencyRateID As IdCambio,
		VC.OrderDate As DtVenda,
		VD.OrderQty As Quantidade,
		P.StandardCost As Custo_Produto_Unitário, 
		VD.UnitPrice As Preço_Unitário,
		VD.UnitPriceDiscount AS Desconto,
		VD.LineTotal As Subtotal,
		VC.TaxAmt As Imposto_Total,
		AIF.Imposto,
		VC.Freight As Frete_Total,
		AIF.Frete,
		Total_Venda = LineTotal+Imposto+Frete
	From Sales.SalesOrderDetail VD
	Inner Join Sales.SalesOrderHeader VC
	on VD.SalesOrderID = VC.SalesOrderID
	Inner Join StageArea.vAuxImposto_Frete AIF
	on VD.SalesOrderID = AIF.IdPedido
	Inner Join StageArea.vTempAuxPagamento TAP
	On VC.CreditCardID = TAP.IdPagamento
	Inner Join Production.Product P
	on VD.ProductID = P.ProductID
	Where Status = 5
Go

/*Ponteiros  VD = Venda Detalhada
			 VC = Venda Cabeçalho
			 AI = vAuxImposto
			 P = Produto
			 TAP = vTempAuxPagamento
*/


/*Scripts para realizar a carga de dados no Data Tools - Integration Services*/


/*Script para inserção das informações na tabela fVendas*/
Select *From StageArea.vfVendas
Go

/*Script para inserção das informações na tabela DimPedido*/

Select 
		SalesOrderID AS IdPedido,
		Status
		From Sales.SalesOrderHeader
		Where Status = 5
Go 

/*Script para inserção das informações na tabela DimProduto*/

Select
		P.ProductID As IdProduto,
		P.ProductSubcategoryID As IdSubcategoria,
		P.Name AS Produto,
		M.Name As Modelo,
		P.ProductLine As Linha_Produto,
		P.Style AS Publico_Alvo
	From Production.Product P
	Inner join Production.ProductModel M
	On P.ProductModelID = M.ProductModelID
Go 

/*Ponteiramento P = Produto
				M = Modelo
*/

/*Script para inserção das informações na tabela tbSubcategoria*/

Select 
		SC.ProductSubcategoryID As IdSubcategoria,
		SC.Name As Subcategoria,
		C.Name As Categoria
	From Production.ProductSubcategory SC
	Inner join Production.ProductCategory C
	on SC.ProductCategoryID = C.ProductCategoryID
Go 

/*Ponteiramento SC = Subcategoria
				C= Categoria
*/


/*Script para inserção das informações na tabela DimCliente*/

Select 
		Cl.CustomerID AS IdCliente,
		Pe.FirstName + ' ' + Pe.LastName As Cliente,
		T.Name AS Regiao,
		CR.Name As País,
		T.CountryRegionCode AS País_Sigla,
		T.[Group] As Continente
	From Sales.Customer Cl
	Inner Join Person.Person Pe 
	On Cl.PersonID = Pe.BusinessEntityID
	Inner Join Sales.SalesTerritory T
	On Cl.TerritoryID = T.TerritoryID
	Inner Join Person.CountryRegion CR 
	On T.CountryRegionCode = CR.CountryRegionCode
Go

/*Ponteiramento Cl = Cliente
				Pe = Pessoas
				T = Território
				CR = Regiões e páises
*/


/*Script para inserção das informações na tabela DimVendedor*/

Select
		SP.BusinessEntityID As IdVendedor,
		Pe.FirstName + ' ' + Pe.LastName As Vendedor,
		SP.CommissionPct AS Comissão
	From Sales.SalesPerson SP
	Inner Join Person.Person Pe 
	On SP.BusinessEntityID = Pe.BusinessEntityID
Go

/*Ponteiramento SP = Vendedor
				Pe = Pessoas
*/


/*Script para inserção das informações na tabela DimPagamento*/

Select 	
		IdAuxPagamento As IdPagamento, 
		FormaPagamento As Pagamento
	From StageArea.AuxPagamento
Go


/*Script para inserção das informações na tabela DimCambio*/

Select
		CurrencyRateID AS IdCambio,
		FromCurrencyCode As Moeda_Origem,
		ToCurrencyCode As Moeda_Destino,
		AverageRate AS Cambio_Médio,
		EndOfDayRate AS Cambio_Final
	From Sales.CurrencyRate
Go

/*Script para inserção das informações na tabela tbMoeda*/

Select 
		CurrencyCode As IdMoeda,
		Name As Moeda
	From Sales.Currency
Go 