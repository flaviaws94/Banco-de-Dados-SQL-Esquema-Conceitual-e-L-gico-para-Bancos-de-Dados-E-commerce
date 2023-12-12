CREATE DATABASE IF NOT EXISTS ecommerce;
use ecommerce;
create table PessoaFisica (
idPFisica int primary key auto_increment,
Nome varchar(10),
MeioNome char(3),
Sobrenome varchar(20),
CPF char(11) not null,
RG char(10) not null,
Endereço VARCHAR(200),
telefone VARCHAR (15),
email VARCHAR (30),
DataNascimento DATE not null,
constraint unique_CPF_Pessoa_Fisica unique(CPF),
constraint unique_RG_Pessoa_Fisica unique(RG)
);
create table PessoaJuridica (
idPJuridica int primary key auto_increment,
RazaoSocial VARCHAR(45),
NomeFantasia VARCHAR(45),
CNPJ char(14) not null,
IE char(9) not null,
Endereço VARCHAR(200),
telefone VARCHAR (15),
email VARCHAR (30),
constraint unique_CNPJ_Pessoa_Juridica unique(CNPJ),
constraint unique__IE_Pessoa_Juridica unique(IE)
);
CREATE TABLE Cliente (
    IdCliente INT PRIMARY KEY AUTO_INCREMENT,
    IdPFisica INT,
    IdPJuridica INT,
    Foreign Key (idPFisica) REFERENCES PessoaFisica(idPFisica),
    Foreign Key (idPJuridica) REFERENCES PessoaJuridica(idPJuridica)
);
CREATE TABLE Produto (
    idProduto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Pnome VARCHAR(50),
    Classificacao_Kids BOOL DEFAULT false,
    Categoria ENUM('Eletrônico','Vestuário','Brinquedos','Alimentos','Móveis') NOT NULL,
    Valor FLOAT NOT NULL,
    Avaliação FLOAT DEFAULT 0,
    Tamanho VARCHAR(10)
);
CREATE Table Pedido (
    idPedido INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    idPedido_Cliente INT,
    idFPagamento INT,
    StatusPedido ENUM('Cancelado','Confirmado','Em Processamento') DEFAULT 'Em Processamento',
    Descrição VARCHAR(255),
    Frete FLOAT DEFAULT 10,
    Valor Float,
    constraint fk_Forma_Pagamento_Cliente Foreign Key (idFPagamento) REFERENCES FormaPagamentoCliente(idFPagamento),
    constraint fk_Pedido_Cliente FOREIGN KEY (idPedido_Cliente) REFERENCES cliente(idCliente) 
    );
CREATE TABLE FormaPagamentoCliente(
    idCliente INT,
    idFPagamentoCliente INT,
    PRIMARY KEY (IdFPagamento,IdCliente),
    constraint fk_FormaPagamento_Cliente Foreign Key (idFPagamento) REFERENCES FormaPagamento(idFPagamento),
    constraint fk_Cliente_Cliente Foreign Key (idCliente) REFERENCES Cliente(idCliente)
);
CREATE TABLE FormaPagamento (
    IdFPagamento INT PRIMARY KEY AUTO_INCREMENT,
    IdCartão INT,
    IdContaBancaria INT,
    IdPix INT,
	Foreign Key (idCartão) REFERENCES Cartão(idCartão),
    Foreign Key (idContaBancaria) REFERENCES Boleto_ContaBancaria(idContaBancaria),
    Foreign Key (idPix) REFERENCES Pix(idPix)
);
CREATE TABLE Cartão (
    IdCartão INT PRIMARY KEY AUTO_INCREMENT,
    NomeCartao VARCHAR(45) NOT NULL,
    CNumero VARCHAR(45) NOT NULL,
    DataValidade DATE NOT NULL,
    CVV CHAR(3) NOT NULL,
    Banco VARCHAR(30),
    TipoCartão ENUM('Crédito','Débito'),
	constraint unique_Numero_Cartao unique(CNumero)
);
CREATE TABLE Boleto_ContaBancaria (
    IdContaBancaria INT PRIMARY KEY AUTO_INCREMENT,
    NomeCompleto VARCHAR(100) NOT NULL,
    CPFConta char(11),
	Agencia varchar(5) not null,
    NumeroConta varchar(20) not null,
    Banco VARCHAR(30),
    TipoConta Enum('Conta Corrente','Conta Popança') not null,
    constraint unique_Conta_Bancaria unique(idContaBancaria)
);
CREATE TABLE Pix (
    IdPix INT PRIMARY KEY AUTO_INCREMENT,
    ChavePix VARCHAR(45) NOT NULL UNIQUE,
    constraint unique_Chave_Pix unique(ChavePix)
);
CREATE TABLE LocalizaçãoEstoque (
    IdLocalEstoque INT PRIMARY KEY AUTO_INCREMENT,
    Local VARCHAR(255) NOT NULL,
    QuantidadeEstoque INT DEFAULT 0
);
CREATE TABLE Fornecedor (
    IdPJuridica INT,
    PRIMARY KEY (IdPJuridica),
    constraint fk_CNPJ_Fornecedor Foreign Key (idPJuridica) REFERENCES PessoaJuridica(idPJuridica)
);
CREATE TABLE Vendedor (
    IdVendedor INT PRIMARY KEY AUTO_INCREMENT,
    IdPJuridica INT,
    IdPFisica INT,
    constraint fk_CNPJ_Vendedor Foreign Key (idPJuridica) REFERENCES PessoaJuridica(idPJuridica),
    constraint fk__CPF_Vendedor Foreign Key (idPFisica) REFERENCES PessoaFisica(idPFisica)
);
CREATE TABLE ProdutoVendedor (
    IdVendedor INT,
    IdProduto INT,
    Quantidade INT DEFAULT 0,
    PRIMARY KEY (IdVendedor,IdProduto),
    constraint fk_Produto_Vendedor FOREIGN KEY (idVendedor) REFERENCES Vendedor(IdVendedor),
    constraint fk_Produto_Produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
);
CREATE TABLE ProdutoEstoque (
    IdLocalEstoque INT,
    IdProduto INT,
    Localização VARCHAR(255) NOT NULL,
    Quantidade Float,
    PRIMARY KEY (IdLocalEstoque,IdProduto),
    constraint fk_Estoque_Localização_Produto FOREIGN KEY (idProduto) REFERENCES Produto(IdProduto),
    constraint fk_Estoque_Localização_Estoque FOREIGN KEY (idLocalEstoque) REFERENCES LocalizaçãoEstoque(idLocalEstoque)
);
CREATE TABLE OrdemPedido (
    IdPedido INT,
    IdProduto INT,
    QunatidadeProduto INT DEFAULT 1,
    STatusProduto ENUM('Disponível','Sem Estque') DEFAULT 'Disponível',
    PRIMARY KEY (IdPedido,IdProduto),
    constraint fk_OrdemPedido_Vendedor FOREIGN KEY (idProduto) REFERENCES Produto(IdProduto),
    constraint fk_OrdemPedido_Produto FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);
CREATE TABLE AcompanhamentoPedido (
	IdAcompanhamentoPedido INT PRIMARY KEY AUTO_INCREMENT,
	StatusAPedido ENUM('Preparando Pedido','Enviado','Entregue'),
    CodigoRastreio Float,
    IdPedido INT,
    constraint fk_Acompanhamento_Pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
    );
    
INSERT INTO PessoaFisica (nome, MeioNome, Sobrenome,CPF, RG, DataNascimento, Endereço, Telefone, email) VALUES
('Maria','J','Souza','65412398712','126547441','2001-05-15','Rua Brasil, 124, Centro - Cidade das Flores', '44-12354-2145','mariaj@gmail.com'),
('Antonio','k','Santos','12365477789','1457851114','1989-08-20','Rua dos Passaros, 1547, Centro - Cidade das Flores', '44-11233-1125','antoniok@gmail.com'),
('Marcos','F','Ferreira','98745987887','1235487744','1998-03-24','Rua Valente, 545, Centro - Cidade das Flores', '44-33225-3256','marcosf@gmail.com'),
('João','A','Filho','65498778992','651234886','1968-09-30','Rua Pavão, 1985, Centro - Cidade das Flores', '44-32145-2154','joaoa@gmail.com'),
('Isabella','B','Silva','65488896388','657854551','2003-07-15','Rua Brasil, 663, Centro - Cidade das Flores', '44-65478-6655','isabellabj@gmail.com'),
('Lucas','J','Zacarias','12366654792','651251772','1993-03-28','Rua Jasmin, 894, Centro - Cidade das Flores', '44-12354-3254','lucasj@gmail.com');
INSERT INTO PessoaJuridica (RazaoSocial, NomeFantasia,CNPJ, IE, Endereço, Telefone, email) VALUES
('Souza e Souza','Tecidos Souza','23125124000155','32658745','Rua Santos, 1544, Centro - São Jose-SP', '11-15477-1554','souzaesouza@gmail.com'),
('Ma Brinquedos LTDA','Mix Brinquedos','56222547000100','33558798','Rua das Limeiras, 3258, Centro - Blumenau -SC', '11-65877-2255','mabrinq@gmail.com'),
('Tancredo Eletronicos','Top Eletrônicos','54562125000165','332548796','Rua Barão, 1544, Centro - Curitiba-PR', '44-93266-12354','Topelet@gmail.com');
INSERT INTO Produto (Pnome,Classificacao_kids,Categoria,Valor,Avaliação,Tamanho) VALUES
('Fone de Ouvido',False,'Eletrônico',59.90,4,NULL),
('Barbie Elsa',True,'Brinquedos',69.90,3,NULL),
('Macacão T. Tigre',True,'vestuário',129.90,5,NULL),
('Sofá Retratil',False,'Móveis',2.599,5,NULL),
('Chips Cheetos',True,'Alimentos',8.99,2,NULL);
INSERT INTO Cliente (idPFisica) VALUES
(1),
(2),
(3),
(5),
(6),
(4);
INSERT INTO Fornecedor VALUES 
(1),
(2),
(3);
INSERT INTO Boleto_ContaBancaria (NomeCompleto, CPFConta, Agencia, NumeroConta, Banco, TipoConta) VALUES 
('Marcos F Ferreira', 98745987887 ,3544 , 354833-2, 'Banco Azul', 'Conta Corrente'),
('Antonio k Santos', 12365477789, 3544, 386877-5, 'Banco Azul', 'Conta Corrente'),
('João A Filho', 65498778992, 1369, 35648899-7, 'Banco Safra','Conta Popança');
select * from Fornecedor;
INSERT INTO cartão (NomeCartao, Cnumero, DataValidade,CVV,Banco,TipoCartão) VALUES 
('Maria J. Souza', 4927325139359147,'2028-03-24',123,'Banco Z', 'Crédito'),
('Marcos F Ferreira', 4921465477896547,'2027-09-05',409,'Banco Z', 'Débito'),
('Lucas J Zacarias', 6547996522354789,'2025-01-30',369,'Banco Z', 'Débito');
INSERT INTO Pix (ChavePix) VALUES
('MariaJ@gmail.com'),
(12366654792), 
(44654786655); 
show tables;
INSERT INTO FormaPagamento (IdCartão, IdContaBancaria, IdPix) Values
(1, null, 1),
(2, 1, null),
(3, null, 2),
(null, null, 3),
(null, 2, null),
(null, 3, null);
INSERT INTO FormaPagamentoCliente (IdCliente, IdFPagamento) Values
(1, 13),
(3, 14),
(6 ,15),
(5, 16),
(2, 17),
(4, 18);
INSERT INTO LocalizaçãoEstoque (Local, QuantidadeEstoque) VALUES
('RJ', 1000),
('SP', 800), 
('DF', 100);
INSERT INTO OrdemPedido (IdPedido, IdProduto, QunatidadeProduto, StatusProduto) VALUES
(1,2,1, 'Disponível'),
(2,4,1,'Disponível'),
(3,3,2,'Sem Estque'),
(4,1,2, default);
INSERT INTO ProdutoEstoque (IdLocalEstoque, IdProduto, Localização, Quantidade) values
(1, 2,'Rio de janeiro', 100),
(1, 5,'Rio de janeiro', 750),
(2, 1,'São Paulo', 1000),
(2, 2,'São Paulo', 150),
(2, 3,'São Paulo', 620),
(3, 4,'Brasilia', 50);

INSERT INTO Vendedor (IdPFisica, IdPJuridica) VALUES 
(1,2),
(5,1);
INSERT INTO ProdutoVendedor (IdVendedor, Idproduto, Quantidade) VALUES 
(2, 4, 20),
(1, 2, 100),
(1, 3, 55);
delete from pedido where idPedido = 1;
INSERT INTO Pedido (IdPedido_cliente, StatusPedido, Descrição, Frete, IdFPagamento, Valor) VALUES
(1, 'Confirmado', 'Compra web site', 15.90, 13, 59.90),
(4, 'Em Processamento', 'Compra Via Aplicativo', 150.00, 18, 2.500),
(2, default, 'compra Via aplicativo', default, 17, 89.90),
(6, 'Cancelado', 'Compra via web site', default, 15, 39.90);

INSERT INTO AcompanhamentoPedido (StatusAPedido, CodigoRastreio, IdPedido) VALUES
('Enviado', 23515874987, 3),
('Entregue', 23658477778, 1),
('Enviado', 23554782132, 2),
('Preparando Pedido', 235132658411, 4);

SELECT count(*) from cliente;
SELECT idCliente, concat(nome, ' ' ,sobrenome) as Nome_Cliente from PessoaFisica inner join Cliente on PessoaFisica.idPFisica = Cliente.IdPFisica;
SELECT * FROM CLIENTE;
SELECT * FROM PessoaFisica WHERE CPF = '65412398712';
SELECT nome, Sobrenome, idPedido, StatusPedido FROM PessoaFisica , PEDIDO  WHERE PessoaFisica.IdPFisica = Pedido. IDPEDIDO_CLIENTE;
SELECT concat(nome,' ', Sobrenome) as Cliente, idPedido as pedido, StatusPedido as Status_Pedido FROM PessoaFisica , PEDIDO  WHERE PessoaFisica.IdPFisica = Pedido. IDPEDIDO_CLIENTE;
SELECT * FROM Cliente WHERE IdCliente BETWEEN 2 AND 4;
SELECT * FROM Produto WHERE Avaliação > 3;
SELECT p.idPedido,
    SUM(Valor * QunatidadeProduto) AS PrecoTotal
FROM Pedido p
JOIN OrdemPedido op ON p.idPedido = op.idPedido
WHERE p.StatusPedido = 'Confirmado'
GROUP BY p.idPedido;
SELECT * FROM PessoaFisica ORDER BY Nome, Sobrenome;
SELECT * FROM Cliente ORDER BY IdCliente;
SELECT Categoria,
    AVG(Avaliação) AS AvaliacaoMedia
FROM Produto
GROUP BY Categoria
HAVING AvaliacaoMedia > 4;
SELECT idPedido, Valor + Frete AS ValorTotal FROM Pedido;
SELECT Pedido.idPedido, Cliente.IdCliente, PessoaFisica.Nome AS NomeCliente, Pedido.StatusPedido, Pedido.Valor
FROM Pedido
    LEFT JOIN Cliente ON Pedido.idPedido_Cliente = Cliente.IdCliente
    LEFT JOIN PessoaFisica ON Cliente.IdPFisica = PessoaFisica.idPFisica;
    SELECT Pedido.idPedido, Cliente.IdCliente, PessoaFisica.Nome AS NomeCliente, Pedido.StatusPedido, Pedido.Valor, 
    AcompanhamentoPedido.StatusAPedido, AcompanhamentoPedido.CodigoRastreio
FROM Pedido
    LEFT JOIN Cliente ON Pedido.idPedido_Cliente = Cliente.IdCliente
    LEFT JOIN PessoaFisica ON Cliente.IdPFisica = PessoaFisica.idPFisica
    LEFT JOIN PessoaJuridica ON Cliente.IdPJuridica = PessoaJuridica.idPJuridica
    LEFT JOIN AcompanhamentoPedido ON Pedido.idPedido = AcompanhamentoPedido.IdPedido;



















