CREATE DATABASE IF NOT EXISTS ecommerce;
use ecommerce;
CREATE TABLE Cliente (
    Id_Cliente INT PRIMARY KEY AUTO_INCREMENT,
    Endereço VARCHAR(200),
    telefone VARCHAR (15),
    email VARCHAR (30)
  );
  CREATE TABLE Fornecedor (
    Id_Fornecedor INT PRIMARY KEY auto_increment,
    Endereço VARCHAR(200),
    telefone VARCHAR (15),
    email VARCHAR (30)
);
CREATE TABLE Vendedor (
    Id_Vendedor INT PRIMARY KEY AUTO_INCREMENT,
    Endereço VARCHAR(200),
    telefone VARCHAR (15),
    email VARCHAR (30)
  );
create table PessoaFisica (
id_PessoaFisica int primary key auto_increment,
Id_Cliente int unique,
id_vendedor int,
Nome varchar(10)not null,
MeioNome char(3)not null,
Sobrenome varchar(20)not null,
CPF char(11) not null,
RG char(10) not null,
DataNascimento DATE not null,
constraint unique_CPF_PessoaFisica unique(CPF),
constraint unique_RG_PessoaFisica unique(RG),
constraint fk_PessoaFisica_Cliente Foreign Key (id_Cliente) REFERENCES Cliente(id_Cliente),
constraint fk_PessoaFisica_Vendedor Foreign Key (id_Vendedor) REFERENCES Vendedor(id_Vendedor)
);
create table PessoaJuridica (
id_PessoaJuridica int primary key auto_increment,
Id_Cliente int unique,
Id_Vendedor int,
Id_Fornecedor int,
RazaoSocial VARCHAR(45)not null,
NomeFantasia VARCHAR(45),
CNPJ char(14) not null,
IE char(9) not null,
constraint unique_CNPJ_Pessoa_Juridica unique(CNPJ),
constraint unique__IE_Pessoa_Juridica unique(IE),
constraint fk_PessoaJuridica_Cliente Foreign Key (id_Cliente) REFERENCES Cliente(id_Cliente),
constraint fk_PessoaJuridica_Vendedor Foreign Key (id_Vendedor) REFERENCES Vendedor(id_Vendedor),
constraint fk_PessoaJuridica_Fornecedor Foreign Key (id_Fornecedor) REFERENCES Fornecedor(id_Fornecedor)
);
    CREATE TABLE FormaPagamento (
    Id_FormaPagamento INT PRIMARY KEY AUTO_INCREMENT,
    TipoFormaPagamento ENUM('Cartão de Crédito', 'Cartão de Débito','Boleto Bancário', 'Pix', 'Dinheiro'),
    Valor float not null, 
    data_pagamento DATE NOT NULL,
    status ENUM('Pendente', 'Pago', 'Cancelado') NOT NULL
);
CREATE TABLE Cartao (
    Id_Cartão INT PRIMARY KEY AUTO_INCREMENT,
    NomeTitular VARCHAR(45) NOT NULL,
    NumeroCartao VARCHAR(45) NOT NULL,
    DataValidade DATE NOT NULL,
    CodigoSeguranca CHAR(3) NOT NULL,
    Banco VARCHAR(30),
    TipoCartao ENUM('Crédito','Débito'),
    id_FormaPagamento int,
	constraint unique_Numero_Cartao unique(Numerocartao),
    constraint FK_cartão_FormaPagamento Foreign Key (id_FormaPagamento) REFERENCES FormaPagamento(id_FormaPagamento)
);

CREATE TABLE BoletoBancario (
    ID_BoletoBancario INT PRIMARY KEY auto_increment,
    ID_FormaPagamento int,
    CodigoBarras VARCHAR(50) UNIQUE,
    DataEmissao DATE,
    DataVencimento DATE,
    constraint unique_CodigoBarras_BoletoBancario unique(CodigoBarras),
    constraint FK_BoletoBancario_FormaPagamento FOREIGN KEY (ID_FormaPagamento) REFERENCES FormaPagamento(ID_FormaPagamento)
);
CREATE TABLE Pix (
    Id_Pix INT PRIMARY KEY AUTO_INCREMENT,
    ChavePix VARCHAR(45) NOT NULL UNIQUE,
	id_FormaPagamento int,
    constraint unique_Chave_Pix unique(ChavePix),
    constraint fk_Pix_FormaPagamento FOREIGN KEY (ID_FormaPagamento) REFERENCES FormaPagamento(ID_FormaPagamento)
    );
CREATE TABLE FormaPagamentoCliente(
    id_Cliente int,
    id_FormaPagamento INT,
    PRIMARY KEY (Id_FormaPagamento,Id_Cliente),
    constraint fk_FormaPagamentoPessoa_FormaPagamento Foreign Key (id_FormaPagamento) REFERENCES FormaPagamento(id_FormaPagamento),
    constraint fk_FormaPagamentoPessoa_Cliente Foreign Key (id_Cliente) REFERENCES Cliente(id_Cliente)
);
CREATE TABLE Produto (
    id_Produto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Pnome VARCHAR(50),
    Classificacao_Kids BOOL DEFAULT false,
    Categoria ENUM('Eletrônico','Vestuário','Brinquedos','Alimentos','Móveis') NOT NULL,
    Valor FLOAT NOT NULL,
    Avaliação FLOAT DEFAULT 0,
    Tamanho VARCHAR(10)
);
CREATE TABLE LocalEstoque (
    Id_LocalEstoque INT PRIMARY KEY AUTO_INCREMENT,
    LocalEstoque VARCHAR(255) NOT NULL,
    QuantidadeEstoque INT DEFAULT 0
);
CREATE TABLE ProdutoVendedor (
    Id_Vendedor INT,
    Id_Produto INT,
    Quantidade INT DEFAULT 0,
    PRIMARY KEY (Id_Vendedor,Id_Produto),
    constraint fk_ProdutoVendedor_Vendedor FOREIGN KEY (id_Vendedor) REFERENCES Vendedor(Id_Vendedor),
    constraint fk_ProdutoVendedor_Produto FOREIGN KEY (id_Produto) REFERENCES Produto(id_Produto)
);
CREATE TABLE ProdutoEstoque (
    Id_LocalEstoque INT,
    Id_Produto INT,
    Localização VARCHAR(255) NOT NULL,
    Quantidade Float,
    PRIMARY KEY (Id_LocalEstoque,Id_Produto),
    constraint fk_ProdutoEstoque_Produto FOREIGN KEY (id_Produto) REFERENCES Produto(Id_Produto),
    constraint fk_ProdutoEstoque_LocalEstoque FOREIGN KEY (id_LocalEstoque) REFERENCES LocalEstoque(id_LocalEstoque)
);
CREATE Table Pedido (
    id_Pedido INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_Cliente INT,
    id_FormaPagamento INT,
    StatusPedido ENUM('Cancelado','Confirmado','Em Processamento') DEFAULT 'Em Processamento',
    DescriçãoPedido VARCHAR(255),
    Frete FLOAT DEFAULT 10,
    Valor Float,
    constraint fk_Pedido_FormaPagamento Foreign Key (id_FormaPagamento) REFERENCES FormaPagamento(id_FormaPagamento),
    constraint fk_Pedido_Cliente FOREIGN KEY (id_Cliente) REFERENCES Cliente(id_Cliente) 
    );
CREATE TABLE OrdemPedido (
    Id_Pedido INT,
    Id_Produto INT,
    QuantidadeProduto INT DEFAULT 1,
    STatusProduto ENUM('Disponível','Sem Estque') DEFAULT 'Disponível',
    PRIMARY KEY (Id_Pedido,Id_Produto),
    constraint fk_OrdemPedido_Produto FOREIGN KEY (id_Produto) REFERENCES Produto(Id_Produto),
    constraint fk_OrdemPedido_Pedido FOREIGN KEY (id_Pedido) REFERENCES Pedido(id_Pedido)
);
CREATE TABLE AcompanhamentoPedido (
	Id_AcompanhamentoPedido INT PRIMARY KEY AUTO_INCREMENT,
	StatusAPedido ENUM('Preparando Pedido','Enviado','Em Trânsito','Entregue'),
    CodigoRastreio Float,
    Id_Pedido INT,
    constraint fk_AcompanhamentoPedido_pedido FOREIGN KEY (id_Pedido) REFERENCES Pedido(id_Pedido)
    );
INSERT INTO Cliente (Endereço, Telefone, email) VALUES
('Rua Brasil, 124, Centro - Cidade das Flores', '44-12354-2145','mariaj@gmail.com'),
('Rua dos Passaros, 1547, Centro - Cidade das Flores', '44-11233-1125','antoniok@gmail.com'),
('Rua Valente, 545, Centro - Cidade das Flores', '44-33225-3256','marcosf@gmail.com'),
('Rua Pavão, 1985, Centro - Cidade das Flores', '44-32145-2154','joaoa@gmail.com'),
('Rua Brasil, 663, Centro - Cidade das Flores', '44-65478-6655','isabellabj@gmail.com'),
('Rua Jasmin, 894, Centro - Cidade das Flores', '44-12354-3254','lucasj@gmail.com');
INSERT INTO PessoaFisica (Id_Cliente, Id_Vendedor, nome, MeioNome, Sobrenome,CPF, RG, DataNascimento) VALUES
(1, 'Maria','J','Souza','65412398712','126547441','2001-05-15'),
(2, 'Antonio','k','Santos','12365477789','1457851114','1989-08-20'),
(3, 'Marcos','F','Ferreira','98745987887','1235487744','1998-03-24'),
(4, 'João','A','Filho','65498778992','651234886','1968-09-30'),
(5, 'Isabella','B','Silva','65488896388','657854551','2003-07-15'),
(6, 'Lucas','J','Zacarias','12366654792','651251772','1993-03-28');
INSERT INTO PessoaFisica (Id_Cliente, Id_Vendedor, nome, MeioNome, Sobrenome,CPF, RG, DataNascimento) VALUES
(null, 3, 'Clayton','J','Santos','65359826587','193268767','1998-03-21'),
(null, 4, 'Jessica','A','Gonçalves','18326922165','183264662','1997-10-09');
INSERT INTO PessoaJuridica (Id_Cliente, Id_Fornecedor, Id_Vendedor, RazaoSocial, NomeFantasia,CNPJ, IE) VALUES
(null, 1, null,  'Souza e Souza','Tecidos Souza','23125124000155','32658745'),
(null, 2, null,  'Ma Brinquedos LTDA','Mix Brinquedos','56222547000100','33558798'),
(null, null, 3, 'Tancredo Eletronicos','Top Eletrônicos','54562125000165','332548796'),
(null, null, 4, 'Silva Importados Ltda', 'Moveis Silva', '33254778888898', '336587779');
INSERT INTO Vendedor (Endereço, Telefone, email) VALUES
('Rua Brasil, 168, Centro - Cidade das Flores', '44-12368-2122','claytonj@gmail.com'),
('Jasmin, 897, Centro - Cidade das Flores', '44-12365-6658','jessicaa@gmail.com'),
('Rua Santos, 1544, Centro - São Jose-SP', '11-15477-1554','souzaesouza@gmail.com'),
('Rua das Limeiras, 3258, Centro - Blumenau-SC', '11-65877-2255','mabrinq@gmail.com');
INSERT INTO Fornecedor (Endereço, Telefone, email) VALUES
('Rua Barão, 1544, Centro - Curitiba-PR', '44-93266-12354','Topelet@gmail.com'),
('Rua America, 3547, Centro - São Paulo-SP', '44-93365-16587','simport@gmail.com');
INSERT INTO Produto (Pnome,Classificacao_kids,Categoria,Valor,Avaliação,Tamanho) VALUES
('Fone de Ouvido',False,'Eletrônico',59.90,4,NULL),
('Barbie Elsa',True,'Brinquedos',69.90,3,NULL),
('Macacão T. Tigre',True,'vestuário',129.90,5,NULL),
('Sofá Retratil',False,'Móveis',2.599,5,NULL),
('Chips Cheetos',True,'Alimentos',8.99,2,NULL);
select * From FormaPagamento;
INSERT INTO BoletoBancario (CodigoBarras, Dataemissao, DataVencimento,ID_FormaPagamento) VALUES 
('123456789012345678901234567890123456789012', '2023-12-01', '2023-12-15', 4),
('132547851256632546435415645456456845454465', '2023-11-28', '2023-12-27', 4);
INSERT INTO cartao (NomeTitular, numerocartao, DataValidade,CodigoSeguranca,Banco,TipoCartao, id_FormaPagamento) VALUES 
('Maria J. Souza', 4927325139359147,'2028-03-24',123,'Banco Z', 'Crédito', 1),
('Marcos F Ferreira', 4921465477896547,'2027-09-05',409,'Banco Z', 'Débito', 2);
INSERT INTO Pix (ChavePix,Id_FormaPagamento) VALUES
('isabellabj@gmail.com',3),
(44-33225-3256,3);
show tables;
INSERT INTO FormaPagamento (TipoFormapagamento, Valor, Data_Pagamento, Status) Values
('Cartão de Crédito', 2500.00, '2023-12-15','Pago'),
('Cartão de Débito', 89.90, '2023-12-03','Pendente'),
('Pix', 150.00, '2023-12-10','Pago'),
('Boleto Bancário',  39.90, '2023-12-01','Cancelado');
INSERT INTO FormaPagamentoCliente (Id_Cliente, Id_FormaPagamento) Values
(5, 3),
(3, 3),
(1 ,1),
(3, 2),
(2, 4),
(6, 4);
INSERT INTO LocalEstoque (LocalEstoque, QuantidadeEstoque) VALUES
('RJ', 1000),
('SP', 800), 
('DF', 100);
INSERT INTO OrdemPedido (Id_Pedido, Id_Produto, QuantidadeProduto, StatusProduto) VALUES
(1,2,1, 'Disponível'),
(2,4,1,'Disponível'),
(3,3,2,'Sem Estque'),
(4,1,2, default);
INSERT INTO ProdutoEstoque (Id_LocalEstoque, Id_produto, Localização, Quantidade) values
(1, 2,'Rio de janeiro', 100),
(1, 5,'Rio de janeiro', 750),
(2, 1,'São Paulo', 1000),
(2, 2,'São Paulo', 150),
(2, 3,'São Paulo', 620),
(3, 4,'Brasilia', 50);
INSERT INTO ProdutoVendedor (Id_Vendedor, Id_produto, Quantidade) VALUES 
(2, 4, 20),
(1, 2, 100),
(1, 3, 55);
delete from pedido where idPedido = 1;
INSERT INTO Pedido (Id_Cliente, StatusPedido, DescriçãoPedido, Frete, valor, Id_FormaPagamento) VALUES
(1, 'Confirmado', 'Compra web site', 15.90, 150.00, 3),
(5, 'Em Processamento', 'Compra Via Aplicativo', 150.00, 2.500,1),
(3, default, 'compra Via aplicativo', default, 89.90, 2),
(2, 'Cancelado', 'Compra via web site', default, 39.90,4);
INSERT INTO AcompanhamentoPedido (StatusAPedido, CodigoRastreio, Id_Pedido) VALUES
('Enviado', 23515874987, 3),
('Entregue', 23658477778, 1),
('Em Trânsito', 23554782132, 2),
('Preparando Pedido', 235132658411, 4);

SELECT count(*) from Cliente;
Select * From Cliente;
Select * From Fornecedor;
Select * From Vendedor;
SELECT Vendedor.Id_Vendedor, PessoaFisica.Nome, PessoaFisica.Sobrenome, PessoaFisica.CPF, PessoaFisica.RG, PessoaFisica.DataNascimento
FROM Vendedor
JOIN PessoaFisica ON Vendedor.Id_Vendedor = PessoaFisica.Id_Vendedor;
SELECT id_PessoaFisica, concat(nome, ' ' ,sobrenome) as Nome_Cliente from PessoaFisica inner join Cliente on PessoaFisica.id_PessoaFisica = PessoaFisica.Id_Cliente;
SELECT id_PessoaFisica, concat(nome, ' ' ,sobrenome) as Nome_Cliente, CPF, Endereço, telefone, email from PessoaFisica inner join Cliente on PessoaFisica.id_PessoaFisica = PessoaFisica.Id_Cliente;
SELECT * FROM PessoaFisica WHERE CPF = '65412398712';
SELECT nome, Sobrenome, id_Pedido, StatusPedido FROM PessoaFisica , PEDIDO  WHERE PessoaFisica.Id_PessoaFisica = Pedido. ID_Cliente;
SELECT concat(nome,' ', Sobrenome) as Nome_Pessoa, id_Pedido as pedido, StatusPedido as Status_Pedido FROM PessoaFisica , PEDIDO  WHERE PessoaFisica.Id_PessoaFisica = Pedido.ID_Cliente;
SELECT * FROM PessoaFisica WHERE Id_Cliente BETWEEN 2 AND 4;
SELECT * FROM Produto WHERE Avaliação > 3;
SELECT p.id_Pedido,
    SUM(Valor * QuantidadeProduto) AS PrecoTotal
FROM Pedido p
JOIN OrdemPedido op ON p.id_Pedido = op.id_Pedido
WHERE p.StatusPedido = 'Confirmado'
GROUP BY p.id_Pedido;
SELECT * FROM PessoaFisica ORDER BY Nome, Sobrenome;
SELECT * FROM Cliente ORDER BY Id_Cliente;
SELECT Categoria,
    AVG(Avaliação) AS AvaliacaoMedia
FROM Produto
GROUP BY Categoria
HAVING AvaliacaoMedia > 4;
SELECT id_Pedido, Valor + Frete AS ValorTotal FROM Pedido;
SELECT Pedido.id_Pedido, Cliente.Id_Cliente, PessoaFisica.Nome AS NomePessoa, Pedido.StatusPedido, Pedido.Valor
FROM Pedido
LEFT JOIN Cliente ON Pedido.id_Cliente = Cliente.Id_Cliente
LEFT JOIN PessoaFisica ON PessoaFisica.Id_Cliente = PessoaFisica.id_PessoaFisica;
SELECT Pedido.id_Pedido, Cliente.Id_Cliente, PessoaFisica.Nome AS NomePessoa, Pedido.StatusPedido, Pedido.Valor, 
AcompanhamentoPedido.StatusAPedido, AcompanhamentoPedido.CodigoRastreio
FROM Pedido
LEFT JOIN Cliente ON Pedido.id_Cliente = Cliente.Id_Cliente
LEFT JOIN PessoaFisica ON PessoaFisica.Id_Cliente = PessoaFisica.id_PessoaFisica
LEFT JOIN PessoaJuridica ON PessoaJuridica.ID_Cliente = PessoaJuridica.id_PessoaJuridica
LEFT JOIN AcompanhamentoPedido ON Pedido.id_Pedido = AcompanhamentoPedido.Id_Pedido;
select * From pedido;
show tables;
SELECT Cliente.Endereço AS EnderecoCliente, FormaPagamento.TipoFormaPagamento, FormaPagamento.Valor, FormaPagamento.Status
FROM FormaPagamentoCliente
JOIN Cliente ON FormaPagamentoCliente.id_Cliente = Cliente.Id_Cliente
JOIN FormaPagamento ON FormaPagamentoCliente.id_FormaPagamento = FormaPagamento.Id_FormaPagamento;
SELECT Pedido.id_Pedido, Cliente.Endereço AS EnderecoCliente, Produto.Pnome AS NomeProduto, OrdemPedido.QuantidadeProduto, OrdemPedido.StatusProduto
FROM Pedido
JOIN Cliente ON Pedido.id_Cliente = Cliente.Id_Cliente
JOIN OrdemPedido ON Pedido.id_Pedido = OrdemPedido.Id_Pedido
JOIN Produto ON OrdemPedido.Id_Produto = Produto.id_Produto;
SELECT LocalEstoque.LocalEstoque,
    COUNT(ProdutoEstoque.Id_Produto) AS QuantidadeDeProdutos
FROM LocalEstoque
LEFT JOIN ProdutoEstoque ON LocalEstoque.Id_LocalEstoque = ProdutoEstoque.Id_LocalEstoque
GROUP BY LocalEstoque.LocalEstoque;
SELECT * FROM Produto WHERE Valor > 100;
SELECT * FROM FormaPagamento WHERE Status = 'Pago';
SELECT * FROM Produto WHERE Categoria = 'Eletrônico';
    
   



















