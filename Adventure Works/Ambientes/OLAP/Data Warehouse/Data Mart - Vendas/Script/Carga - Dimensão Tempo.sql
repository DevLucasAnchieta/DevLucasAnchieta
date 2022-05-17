-------------------------------
--Carregando a dimensão Tempo--
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


--Alterando o inclemento para o início 5000
--Para a possibilidade de datas anteriores

	DBCC Checkident([DataWarehouse.DimTempo], RESEED, 50000) 
	Go

--Inserção de dados na dimensão

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
		Mês,
		Nome_Mês, 
		Quarto,
		NomeQuarto, 
		Ano 
		) 
	
	Select @Data As Data, 
	
	Datepart(Day,@Data) As Dia, 

	Case Datepart(DW, @Data) 
		When 1 Then 'Domingo'
		When 2 Then 'Segunda' 
		When 3 Then 'Terça' 
		When 4 Then 'Quarta' 
		When 5 Then 'Quinta' 
		When 6 Then 'Sexta' 
		When 7 Then 'Sábado' 
	End As Dia_Semana,

	Datepart(Month,@Data) As Mês, 

	Case Datename(Month,@Data) 
		When 'January' Then 'Janeiro'
		When 'February' Then 'Fevereiro'
		When 'March' Then 'Março'
		When 'April' Then 'Abril'
		When 'May' Then 'Maio'
		When 'June' Then 'Junho'
		When 'July' Then 'Julho'
		When 'August' Then 'Agosto'
		When 'September' Then 'Setembro'
		When 'October' Then 'Outubro'
		When 'November' Then 'Novembro'
		When 'December' Then 'Dezembro'
	End As Nome_Mês,
		 
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
	Set Mês = '0' + Mês 
	Where Len(Mês) = 1 

	Update DataWarehouse.DimTempo 
	Set Data_Completa = Ano + Mês + Dia 
	Go

	Select * From DataWarehouse.DimTempo
	Go

----------------------------------------------
----------FINS DE SEMANA E ESTAÇÕES-----------
----------------------------------------------

	Declare C_Tempo Cursor For	
		Select IdSK, Data_Completa, Dia_Semana, Ano From DataWarehouse.DimTempo
	
	Declare			
			@Id int,
			@Data varchar(10),
			@DiaSemana varchar(20),
			@Ano char(4),
			@FimSemana char(3),
			@Estação varchar(15)
					
	Open C_Tempo
		Fetch Next From C_Tempo
		Into @Id, @Data, @DiaSemana, @Ano
	While @@Fetch_Status = 0
	Begin
		If @DiaSemana in ('Domingo','Sábado') 
		Set @FimSemana = 'Sim'
		
		Else 
		Set @FimSemana = 'Não'

--Atualizando estações

	If @Data Between Convert(char(4),@ano)+'0923' 
	And Convert(char(4),@Ano)+'1220'
	Set @Estação = 'Primavera'

	Else If @Data Between Convert(char(4),@ano)+'0321' 
	And Convert(char(4),@Ano)+'0620'
	Set @Estação = 'Outono'

	Else If @Data Between Convert(char(4),@ano)+'0621' 
	And Convert(char(4),@Ano)+'0922'
	Set @Estação = 'Inverno'

	Else -- @data between 21/12 e 20/03
	Set @Estação = 'Verão'

--Atualizando fim de semana
	
	Update DataWarehouse.DimTempo Set Fim_Semana = @FimSemana
	Where IdSK = @Id

--Atualizando

	Update DataWarehouse.DimTempo Set Estação_Ano = @Estação
	Where IdSK = @Id
		
	Fetch Next From C_Tempo
	Into @Id, @Data, @DiaSemana, @Ano	
	End
	Close C_Tempo
	DealLocate C_Tempo
	Go
