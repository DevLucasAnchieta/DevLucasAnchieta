---------------------------------------
---Conexão com o DW_AdventureWorks-----
---------------------------------------

Use DW_AdventureWorks
Go

------------------------
--Criação da Procedure--
------------------------

Create PROC Carga_fVendas As 

	Declare @Final Datetime 
	Declare	@Inicial Datetime
		
	Select  @Final = Max(Data)
	From DW_AdventureWorks.DataWarehouse.DimTempo T

	Select @Inicial = Max(Data)
	From DW_AdventureWorks.DataWarehouse.fVendas FV 
	Join DW_AdventureWorks.DataWarehouse.DimTempo T on (FV.IdTempo = T.IdSK)

	If @Inicial Is Null
		Begin
			Select @Inicial = Min(Data)
			From DW_AdventureWorks.DataWarehouse.DimTempo T
		End

	Insert Into DW_AdventureWorks.DataWarehouse.fVendas(
		IdVendas,
		IdPedido,
		IdProduto,
		IdCliente,
		IdVendedor,
		IdPagamento,
		IdCambio,
		IdTempo,
		Quantidade,
		Custo_Produto_Unitário,
		Preço_Unitário,
		Desconto,
		SubTotal,
		Imposto,
		Frete,
		Valor_Total
		)
		Select
			F.IdVendas,
			P.IdSK as IdPedido,
		   PD.IdSK as IdProduto,
		   	C.IdSK as IdCliente,
		   VD.IdSK as IdVendedor,
		   PG.IdSK as IdPagamento,	
		   CM.IdSK as IdCambio,
		    T.IdSK as IdTempo,
		    F.Quantidade,
			F.Custo_Produto_Unitário,
			F.Preço_Unitário,
			F.Desconto,
			F.SubTotal,
			F.Imposto,
			F.Frete,
			F.Valor_Total
		From
			StgArea_AdventureWorks.StageArea.fVendas F

			Inner Join DW_AdventureWorks.DataWarehouse.DimPedido P
			on (F.IdPedido = P.IdPedido)	 

			Inner Join DW_AdventureWorks.DataWarehouse.DimProduto PD
			on (F.IdProduto = PD.IdProduto) And (PD.Início <= F.DtVenda And (PD.Fim >= F.DtVenda) or (PD.Fim Is Null))

			Inner Join DW_AdventureWorks.DataWarehouse.DimCliente C
			on (F.IdCliente = C.IdCliente) And (C.Início <= F.DtVenda And (C.Fim >= F.DtVenda) or (C.Fim Is Null))

			Inner Join DW_AdventureWorks.DataWarehouse.DimVendedor VD
			on (F.IdVendedor = VD.IdVendedor) And (VD.Início <= F.DtVenda And (VD.Fim >= F.DtVenda) or (VD.Fim Is Null))

			Inner Join DW_AdventureWorks.DataWarehouse.DimPagamento PG
			on (F.IdPagamento = PG.IdPagamento) And (PG.Início <= F.DtVenda And (PG.Fim >= F.DtVenda) or (PG.Fim Is Null))

			Inner Join DW_AdventureWorks.DataWarehouse.DimCambio CM
			on (F.IdCambio = CM.IdCambio)

			Inner Join DataWarehouse.DimTempo T
			On (Convert(Varchar, T.Data,102) = Convert(Varchar, F.DtVenda,102))
			--Where F.DtVenda > @Inicial And F.DtVenda < @Final--
			Where F.DtVenda Between @Inicial And @Final
Go










