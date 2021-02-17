-- craição do banco
 create database fazenda_db;
-- utilizando o banco
use fazenda_db;

-- criando a tabela estado
CREATE TABLE estado(
est_id int not null unique auto_increment primary key,
nome varchar (40) NOT NULL,
UF char (2) NOT NULL,
pais varchar (40) NOT NULL DEFAULT 'Brasil'
);

-- Populando tabela Estado
INSERT INTO estado (nome, UF)
value ('Paraná', 'PR');

-- criando a tabela cidade
CREATE TABLE cidade (
CID_ID int not null unique auto_increment primary key,
cidade  varchar(50) NOT NULL,
FK_est_id int NOT NULL,
CONSTRAINT FK_CIDADE_ESTADO_ID FOREIGN KEY (FK_EST_ID) REFERENCES ESTADO (EST_ID)
);

-- Populando Tabela Cidade
INSERT INTO cidade (CIDADE, FK_EST_ID)
VALUE ('lONDRINA', '1');
INSERT INTO cidade (CIDADE, FK_EST_ID)
VALUE ('cambé', '1');

-- criando tabela pessoa
CREATE TABLE  pessoa ( 
PESSOA_ID INT NOT NULL UNIQUE auto_increment,
nome_razao_soc varchar (40),
nome_fantasia varchar (60),
CPF_CNPJ VARCHAR (14),
datanas_inauguraca date,
EMAIL VARCHAR (30), 
primary key (pessoa_id)
);

-- Populando tabela Pessoa
INSERT INTO PESSOA (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca,EMAIL) 
VALUES ('ROGRIGO Gotardo', 'RODRIGO Gotardo', '00000000000', '1983-02-11', 'RODRIGO@GMAIL.COM'); -- Cliente / Funcionário

INSERT INTO PESSOA (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca,EMAIL) 
VALUES ('RICARDO Gotardo', 'RICARDO Gotardo', '12345678901', '1985-02-19', 'RICARDO@GMAIL.COM'); -- Cliente

INSERT INTO PESSOA (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca,EMAIL) 
VALUES ('GABRIEL Gotardo', 'GABRIEL Gotardo', '11111111111', '1990-02-19', 'GABRIEL@GMAIL.COM'); -- Cliente

INSERT INTO PESSOA (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca,EMAIL) 
VALUES ('LEONARDO Gotardo', 'LEONARDO Gotardo', '22222222222', '1995-04-20', 'LEONARDO@GMAIL.COM'); -- Funcionário

INSERT INTO PESSOA (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca,EMAIL) 
VALUES ('REBECCA Gotardo', 'REBECCA Gotardo', '3333333333', '1991-02-28', 'REBECCA@GMAIL.COM'); -- Cliente

-- criando a tabela endereço
CREATE TABLE  endereco (
end_id int not null unique auto_increment primary key,
tipo char(1) not null comment '[1=RESIDENCIAL, 2=COMERCIAL, 3=COBRANÇA, 4=ENTREGA]',
endereco varchar(60) not null,
numero char(5),
bairro varchar (60),
CEP char(8) not null,
complemento varchar(100),
FK_CID_ID int not null,
FK_PESSOA_ID INT NOT NULL,
CONSTRAINT FK_ENDERECO_CIDADE_ID FOREIGN KEY (FK_CID_ID) REFERENCES CIDADE (CID_ID),
constraint CK_tipo_Endereco check (tipo in (1,2,3,4))
);

-- Populando Tabela Endereco
-- Cidade FK_CID_ID = 1 - Londrina
-- Endereços Rodrigo => Pessoa fk_pessoa_id = 1
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('1', 'rosalvo marques', '637','padovanni','86081538', '', 1, 1); -- tipo = 1 - Residencial
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('2', 'rosalvo marques', '637','padovanni','86081538', '', 1, 1); -- tipo = 2 - Comercial
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('3', 'Av Sao Joao', '1000','Centro','86081500', '', 1, 1); -- tipo = 3 - Cobrança
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('4', 'rosalvo marques', '637','padovanni','86081538', '', 1, 1); -- tipo = 4 - Entrega

-- Endereços Ricardo => Pessoa fk_pessoa_id = 2
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('1', 'Humaitá', '100','centro','86015100', '', 1, 2); -- tipo = 1 - Residencial
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('2', 'Humaitá', '100','centro','86015100', '', 1, 2); -- tipo = 2 - Comercial
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('3', 'Humaitá', '100','centro','86015100', '', 1, 2); -- tipo = 3 - Cobrança
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('4', 'Humaitá', '100','centro','86015100', '', 1, 2); -- tipo = 4 - Entrega

-- Endereços Gabriel => Pessoa fk_pessoa_id = 3
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('1', 'JK', '100','centro','86015100', '', 1, 3); -- tipo = 1 - Residencial

-- Endereços Leonardo => Pessoa fk_pessoa_id = 4
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('1', 'pernanbuco', '100','centro','86084100', '', 1, 4); -- tipo = 1 - Residencial
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('2', 'Piaui', '1000','centro','8684700', '', 1, 4); -- tipo = 2 - Comercial

-- Endereços REbecca => Pessoa fk_pessoa_id = 5
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('1', 'MAURICIO', '200','centro','81415100', '', 2, 5); -- tipo = 1 - Residencial


-- criando a tabela funcionario
CREATE TABLE funcionario(
fun_id int not null unique auto_increment primary KEY,
setor varchar(20),
CTPS char(20),
funcao varchar (40),
salario decimal (12,2),
FK_pessoa_id int,
CONSTRAINT FK_FUNCIONARIO_PESSOA_ID FOREIGN KEY (FK_PESSOA_ID) references PESSOA (PESSOA_ID)
);

-- Populando Tabela Funcionário
-- Rodrigo => Pessoa fk_pessoa_id = 1
insert into funcionario(setor,CTPS,funcao,salario,FK_pessoa_id) 
value ('RH', '0000000', 'RECRUTADOR', '1000.00', 1);
-- Leonardo => Pessoa fk_pessoa_id = 4
insert into funcionario(setor,CTPS,funcao,salario,FK_pessoa_id) 
value ('Vendedor', '11111111', 'DBA', '2000.00', 4);

-- CLIENTE 
CREATE TABLE CLIENTES(
CLIENTE_ID INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
DATA_CADASTRO date,
LIMITE DECIMAL(15,2),
FK_PESSOA_ID INT,
CONSTRAINT FK_CLIENTE_ID_PESSOA_ID FOREIGN KEY (FK_PESSOA_ID) REFERENCES PESSOA(FK_PESSOA_ID)
);
-- Populando tabela Clientes
-- Rodrigo => Pessoa fk_pessoa_id = 1
INSERT INTO CLIENTES (DATA_CADASTRO, LIMITE, FK_PESSOA_ID)
VALUES ('2020/10/05', '10000.00', 1);
-- Ricardo => Pessoa fk_pessoa_id = 2
INSERT INTO CLIENTES (DATA_CADASTRO, LIMITE, FK_PESSOA_ID)
VALUES ('2020/10/10', '9000.00', 2);
-- Gabriel => Pessoa fk_pessoa_id = 3
INSERT INTO CLIENTES (DATA_CADASTRO, LIMITE, FK_PESSOA_ID)
VALUES ('2020/10/20', '5000.00', 3);
-- rEBECCA => Pessoa fk_pessoa_id = 5
INSERT INTO CLIENTES (DATA_CADASTRO, LIMITE, FK_PESSOA_ID)
VALUES ('2020/10/20', '1000.00', 5);

-- PRODUCAO
CREATE table producao(
producao_id int not null unique auto_increment primary key,
especie varchar (40) NOT NULL,
data_ordenha date not null,
produtividade decimal (4,2)not null,
inseminacao char(1) NOT NULL comment '[1=sim, 2=nao]',
constraint ck_inseminacao_producao CHECK (inseminacao IN ('1','2'))
);

-- Populando Tabela de Producao
INSERT INTO producao (especie, data_ordenha, produtividade, inseminacao)
VALUES ('simenta','2020/10/22','10','2');
INSERT INTO producao (especie, data_ordenha, produtividade, inseminacao)
VALUES ('guemsey','2020/10/23','13','1');

-- PRODUTO
CREATE TABLE produto(
PROD_ID INT NOT NULL UNIQUE auto_increment PRIMARY KEY,
nome_prod varchar (50) not null,
tipo_prod varchar(50) not null,
custo decimal(9,2),
QTDO_ESTOQUE decimal(10,2),
VALOR_VENDA decimal(8,2),
FK_PRODUCAO_ID INT,
CONSTRAINT FK_PROD_ID_PRODUCAO_ID FOREIGN KEY (FK_PRODUCAO_ID) REFERENCES PRODUCAO (PRODUCAO_ID)
);

-- Populando tabela Produto
-- FK_PRODUCAO_ID = 1 - simenta
INSERT INTO produto ( nome_prod, tipo_prod, custo, QTDO_ESTOQUE, VALOR_VENDA, FK_PRODUCAO_ID )
VALUES ('queijo', 'integral','5.00','120','9.00', 1);
INSERT INTO produto ( nome_prod, tipo_prod, custo, QTDO_ESTOQUE, VALOR_VENDA, FK_PRODUCAO_ID )
-- FK_PRODUCAO_ID = 1 - simenta
VALUES ('leite', 'desnatado','1.00','30','3.00', 1);
-- FK_PRODUCAO_ID = 2 - guemsey
INSERT INTO produto ( nome_prod, tipo_prod, custo, QTDO_ESTOQUE, VALOR_VENDA, FK_PRODUCAO_ID )
VALUES ('docedeleite', 'ligth','2.00','20','7.00', 2);

-- PEDIDO
CREATE TABLE PEDIDO(
PEDIDO_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
data_pedido date,
QTDO_VENDA_PROD DECIMAL(20),
VALOR_VENDA decimal (20),
FK_CLIENTE_ID INT,
FK_PROD_ID INT,
FK_fun_id INT,
CONSTRAINT FK_PEDIDO_CLIENTE_ID FOREIGN KEY (FK_CLIENTE_ID) REFERENCES CLIENTE(FK_CLIENTE_ID),
CONSTRAINT FK_PEDIDO_PRODUTO_ID FOREIGN KEY (FK_PROD_ID) REFERENCES PRODUTO(FK_PROD_ID),
CONSTRAINT FK_PEDIDO_FUNCIONARIO_ID FOREIGN KEY (FK_fun_id) REFERENCES funcionario(fun_id)
);

-- Populando tabela de Pedido
-- FK_CLIENTE_ID 1- Rodrigo
-- FK_PROD_ID 1-Queijo
-- FK_fun_id - 5-Rodrigo
INSERT INTO PEDIDO (data_pedido, QTDO_VENDA_PROD, VALOR_VENDA, FK_CLIENTE_ID, FK_PROD_ID, FK_fun_id)
VALUES ('2020/10/24', '2', '9.00','1','1','4');
-- FK_CLIENTE_ID 3- Gabriel
-- FK_PROD_ID 1-Queijo
-- FK_fun_id - 5-Leonardo
INSERT INTO PEDIDO (data_pedido, QTDO_VENDA_PROD, VALOR_VENDA, FK_CLIENTE_ID, FK_PROD_ID, FK_fun_id)
VALUES ('2020/10/25', '5', '9.00','3','1','5');
-- FK_CLIENTE_ID 3- Gabriel
-- FK_PROD_ID 2-leite
-- FK_fun_id - 5-Leonardo
INSERT INTO PEDIDO (data_pedido, QTDO_VENDA_PROD, VALOR_VENDA, FK_CLIENTE_ID, FK_PROD_ID, FK_fun_id)
VALUES ('2020/10/24', '10', '3.00','3','2','5');

-- Quantidade de clientes por cidade
SELECT count(*) AS Quantidade, cidade
FROM CIDADE 
INNER JOIN ( SELECT MAX(end_id) AS END_ID, FK_CID_ID, FK_PESSOA_ID 
			 FROM ENDERECO 
             GROUP BY FK_CID_ID, FK_PESSOA_ID ) AS ENDERECO ON ENDERECO.FK_CID_ID = CIDADE.CID_ID 
INNER JOIN PESSOA ON PESSOA.PESSOA_ID = ENDERECO.FK_PESSOA_ID
INNER JOIN CLIENTES ON CLIENTES.FK_PESSOA_ID = PESSOA.PESSOA_ID
GROUP BY cidade;

-- Saídas de produtos
SELECT NOME_PROD AS PRODUTO, SUM(QTDO_VENDA_PROD) AS QUANTIDADE
FROM PEDIDO
INNER JOIN produto ON PEDIDO.FK_PROD_ID = produto.PROD_ID
GROUP BY NOME_PROD;

-- SALDO EM ESTOQUE DOS PRODUTOS
SELECT NOME_PROD AS PRODUTO, QTDO_ESTOQUE - SUM(COALESCE(QTDO_VENDA_PROD,0)) AS QUANTIDADE_ESTOQUE
FROM PRODUTO
LEFT JOIN PEDIDO ON PEDIDO.FK_PROD_ID = produto.PROD_ID
GROUP BY NOME_PROD, QTDO_ESTOQUE;

-- Funcionário com maior salario
SELECT nome_razao_soc, SUM(salario) AS Salario
FROM funcionario
INNER JOIN PESSOA ON funcionario.FK_PESSOA_ID = PESSOA.PESSOA_ID;
