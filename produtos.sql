
create database atividade_produtos
go

use atividade_produtos

go 

create table produto(

codigo int not null,
nome varchar(100) not null,
valor decimal(7,2) not null

primary key(codigo)

)

go 

-- cada produto que a empresa compra 
create table entrada(
codigo_transacao int not null,
codigo_produto int not null, 
quantidade int not null, 
valor_total decimal(7,2) not null

primary key(codigo_transacao)
foreign key(codigo_produto) references produto(codigo)

)

go

--cada produto que a empresa vende 
create table saida(
codigo_transacao int not null,
codigo_produto int not null, 
quantidade int not null, 
valor_total decimal(7,2) not null

primary key(codigo_transacao)
foreign key(codigo_produto) references produto(codigo)

)

insert into produto values
(1, 'Lapis', 2.00),
(2, 'Caderno do Batman',20.00),
(3, 'Mochila hotwells', 300.00),
(4, 'Borracha', 1.50)

create procedure sp_entrada_e_saida (@codigo char(1),
	@produto int, @qtd int, @saida varchar(150) output)
as
	declare @tabela varchar(30),
			@val_total decimal(7,2),
			@query	varchar(max),
			@tipo char(1),
			@valor decimal (7,2),
			@erro varchar(max),
			@transacao int 

			if (@codigo = 'e')
			begin 
				set @tabela = 'entrada'
				select @transacao = max(@transacao) +1 from entrada
				if (@transacao is null)
				begin 
					set @transacao = 1
				end
			end
			else 
			begin
				if (@codigo = 's')
				begin 
				set @tabela = 'saida'
				select @transacao = max(@transacao) +1 from entrada
				if (@transacao is null)
				begin 
					set @transacao = 1
				end
				else
				begin 
					raiserror('Tipo não existe',16,1)
				end
			end
			end 

			if (@codigo = 'e' or @codigo = 's')
			begin
				set @valor =(select valor from produto 
				where codigo =@produto)

				set @val_total = @qtd *@valor

				set @query = 'insert into '+@tabela+' values('''+
					cast(@transacao as varchar(10))+''','''+
					cast(@produto as varchar(5))+''','''+
					cast(@qtd as varchar(5))+''','''+
					cast(@val_total as varchar(20))+''')'

				print @query

				begin try
					exec(@query)
					set @saida ='dados cadastrados na tabela'+@tabela
				end try 
				begin catch
					set @erro = ERROR_MESSAGE()
					raiserror (@erro,16,1)
				end catch
			end

declare @saida1 varchar(150)
exec sp_entrada_e_saida 'e', 1,3, @saida1 output
print @saida1

select*from entrada

declare @saida2 varchar(150)
exec sp_entrada_e_saida 's', 2,5, @saida2 output
print @saida2

select*from saida
