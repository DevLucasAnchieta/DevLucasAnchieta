-------------------------------
--Carregando a dimens�o Tempo--
-------------------------------
	
--Conectando no banco de dados DW_AdventureWorks

	Use DW_AdventureWorks
	Go
--Truncando a tabela antes de inserir os dados--

	Truncate Table DataWarehouse.DimTempo
	Go
	
--Exibindo a data atual
	Print Convert(varchar,Getdate(),113)
	Go


--Alterando o inclemento para o in�cio 5000
--Para a possibilidade de datas anteriores

	DBCC Checkident([DataWarehouse.DimTempo], RESEED, 50000) 
	Go

--Inser��o de dados na dimens�o

	Declare @Datainicio datetime,
			@Data datetime,
			@Datafim datetime
	 		  
	Print Getdate() 
		
	Select @Datainicio = '1/1/2008'
	Select @Datafim = '1/1/2050'
	Select @Data = @Datainicio

	While @Data < @Datafim 
	Begin
	
	Insert Into DataWarehouse.DimTempo
	( 
		[Data], 
		Dia,
		Dia_Semana, 
		M�s,
		Nome_M�s, 
		Quarto,
		NomeQuarto, 
		Ano 
		) 
	
	Select @Data As Data, 
	
	Datepart(Day,@Data) As Dia, 

	Case Datepart(DW, @Data) 
		When 1 Then 'Domingo'
		When 2 Then 'Segunda' 
		When 3 Then 'Ter�a' 
		When 4 Then 'Quarta' 
		When 5 Then 'Quinta' 
		When 6 Then 'Sexta' 
		When 7 Then 'S�bado' 
	End As Dia_Semana,

	Datepart(Month,@Data) As M�s, 

	Case Datename(Month,@Data) 
		When 'January' Then 'Janeiro'
		When 'February' Then 'Fevereiro'
		When 'March' Then 'Mar�o'
		When 'April' Then 'Abril'
		When 'May' Then 'Maio'
		When 'June' Then 'Junho'
		When 'July' Then 'Julho'
		When 'August' Then 'Agosto'
		When 'September' Then 'Setembro'
		When 'October' Then 'Outubro'
		When 'November' Then 'Novembro'
		When 'December' Then 'Dezembro'
	End As Nome_M�s,
		 
	DatePart(qq,@Data) Quarto, 

	Case Datepart(qq,@DATA) 
		When 1 Then 'Primeiro' 
		When 2 Then 'Segundo' 
		When 3 Then 'Terceiro' 
		When 4 Then 'Quarto' 
	End As NomeQuarto 

	,Datepart(Year,@Data) Ano
	Select @Data = Dateadd(dd,1,@Data)
	End
	Go


	Update DataWarehouse.DimTempo 
	Set Dia = '0' + Dia 
	Where Len(Dia) = 1 

	Update DataWarehouse.DimTempo 
	Set M�s = '0' + M�s 
	Where Len(M�s) = 1 

	Update DataWarehouse.DimTempo 
	Set Data_Completa = Ano + M�s + Dia 
	Go

	Select * From DataWarehouse.DimTempo
	Go

----------------------------------------------
----------FINS DE SEMANA E ESTA��ES-----------
----------------------------------------------

	Declare C_Tempo Cursor For	
		Select IdSK, Data_Completa, Dia_Semana, Ano From DataWarehouse.DimTempo
	
	Declare			
			@Id int,
			@Data varchar(10),
			@DiaSemana varchar(20),
			@Ano char(4),
			@FimSemana char(3),
			@Esta��o varchar(15)
					
	Open C_Tempo
		Fetch Next From C_Tempo
		Into @Id, @Data, @DiaSemana, @Ano
	While @@Fetch_Status = 0
	Begin
		If @DiaSemana in ('Domingo','S�bado') 
		Set @FimSemana = 'Sim'
		
		Else 
		Set @FimSemana = 'N�o'

--Atualizando esta��es

	If @Data Between Convert(char(4),@ano)+'0923' 
	And Convert(char(4),@Ano)+'1220'
	Set @Esta��o = 'Primavera'

	Else If @Data Between Convert(char(4),@ano)+'0321' 
	And Convert(char(4),@Ano)+'0620'
	Set @Esta��o = 'Outono'

	Else If @Data Between Convert(char(4),@ano)+'0621' 
	And Convert(char(4),@Ano)+'0922'
	Set @Esta��o = 'Inverno'

	Else -- @data between 21/12 e 20/03
	Set @Esta��o = 'Ver�o'

--Atualizando fim de semana
	
	Update DataWarehouse.DimTempo Set Fim_Semana = @FimSemana
	Where IdSK = @Id

--Atualizando

	Update DataWarehouse.DimTempo Set Esta��o_Ano = @Esta��o
	Where IdSK = @Id
		
	Fetch Next From C_Tempo
	Into @Id, @Data, @DiaSemana, @Ano	
	End
	Close C_Tempo
	DealLocate C_Tempo
	Go
