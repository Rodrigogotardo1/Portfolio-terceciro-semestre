-- craição do banco
 create database fazenda_db;
-- utilizando o banco
use fazenda_db;

CREATE TABLE  pessoa ( 
PESSOA_ID INT NOT NULL UNIQUE auto_increment,
nome_razao_soc varchar (40),
nome_fantasia varchar (60),
CPF_CNPJ VARCHAR (14),
datanas_inauguraca date,
EMAIL VARCHAR (30), 
primary key (pessoa_id)
);

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

-- criando a tabela estado

CREATE TABLE estado(
est_id int not null unique auto_increment primary key,
nome varchar (40) NOT NULL,
UF char (2) NOT NULL,
pais varchar (40) NOT NULL DEFAULT 'Brasil'
);

-- criando a tabela cidade

CREATE TABLE cidade (
CID_ID int not null unique auto_increment primary key,
cidade  varchar(50) NOT NULL,
FK_est_id int NOT NULL,
CONSTRAINT FK_CIDADE_ESTADO_ID FOREIGN KEY (FK_EST_ID) REFERENCES ESTADO (EST_ID)
);

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
constraint CK_tipo_Endereco check (tipo in (1,2,3,4)),
CONSTRAINT FK_ENDERECO_PESSO_ID foreign key (FK_PESSOA_ID) REFERENCES PESSOA (PESSOA_ID)
);

-- PRODUTO

CREATE TABLE produto(
PROD_ID INT NOT NULL UNIQUE auto_increment PRIMARY KEY,
nome_prod varchar (50) not null,
tipo_prod varchar(50) not null,
estoque decimal(9,2),
custo decimal(9,2),
QTDO_ESTOQUE VARCHAR(10),
VALOR_VENDA VARCHAR(10),
CONSTRAINT FK_PROD_ID_PRODUCAO_ID FOREIGN KEY (FK_PRODUCAO_ID) REFERENCES PRODUCAO (PRODUCAO_ID)
)DEFAULT CHARSET=utf8;

-- PRODUCAO

CREATE table producao(
producao_id int not null unique auto_increment primary key,
especie varchar (40) NOT NULL,
data_ordenha date not null,
produtividade decimal (4,2)not null,
inseminacao char(1) comment '[1=sim, 2=nao]',
constraint CK_PRODUTIVIDADE CHECK (TIPO IN (1,2)),
CONSTRAINT FK_PRODUCAO_ID_PROD_ID FOREIGN KEY (FK_PROD_ID) REFERENCES PRODUTO (PROD_ID)
)DEFAULT CHARSET=utf8;

-- CLIENTE 

CREATE TABLE CLIENTES(
CLIENTE_ID INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
NOME_RAZAO_SOCIAL VARCHAR(80),
DATA_CADASTRO date,
LIMITE DECIMAL(15,2),
CONSTRAINT FK_CLIENTE_ID_PESSOA_ID FOREIGN KEY (FK_PESSOA_ID) REFERENCES PESSOA(FK_PESSOA_ID)
);

-- PEDIDO

CREATE TABLE PEDIDO(
PEDIDO_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
NUM_PEDIDO varchar(10) not null,
data_pedido date,
QTDO_VENDA_PROD VARCHAR(20),
VALOR_VENDA VARCHAR (20),
CONSTRAINT FK_PEDIDO_ID_CLIENTE_ID FOREIGN KEY (FK_CLIENTE_ID) REFERENCES CLIENTE(FK_CLIENTE_ID),
CONSTRAINT FK_PEDIDO_ID_PROD_ID FOREIGN KEY (FK_PROD_ID) REFERENCES PRODUTO(FK_PROD_ID)
);


INSERT INTO estado (nome, UF)
value ('Paraná', 'PR');
INSERT INTO cidade (CIDADE, FK_EST_ID)
VALUE ('lONDRINA', '1');

INSERT INTO PESSOA (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca,EMAIL) VALUES ('ROGRIGO Gotardo', 'RODRIGO Gotardo', '00000000000', '1983-02-11', 'RODRIGO@GMAIL.COM');
SELECT LAST_INSERT_ID() INTO @idPessoa;
insert into funcionario(setor,CTPS,funcao,salario,FK_pessoa_id) value ('RH', '0000000', 'RECRUTADOR', '1000.00', @idPessoa);
select CID_ID into @IdCidade from cidade where cidade = 'LONDRINA'; 
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('1', 'rosalvo marques', '637','padovanni','86081538', '',@IdCidade,@idPessoa);

INSERT INTO PESSOA (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca,EMAIL) VALUES ('RICARDO Gotardo', 'RICARDO Gotardo', '11111111111', '1985-02-19', 'RICARDO@GMAIL.COM');
SELECT LAST_INSERT_ID() INTO @idPessoa;
insert into funcionario(setor,CTPS,funcao,salario,FK_pessoa_id) value ('TI', '11111111', 'DBA', '2000.00', @idPessoa);
select CID_ID into @IdCidade from cidade where cidade = 'LONDRINA'; 
insert into endereco ( tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, fk_pessoa_id)
VALUE ('1', 'HUMAITA', '255','CENTRO','86015100', '',@IdCidade,@idPessoa);


SELECT  * -- CASE ENDERECO.TIPO WHEN '1' THEN 'RESIDENCIAL' WHEN 2 THEN 'COMERCIAL' WHEN 3 THEN 'COBRANÇA' ELSE 'ENTREGA' AS TIPOENDERECO
FROM PESSOA PESSOA
INNER JOIN ENDERECO ENDERECO ON PESSOA.PESSOA_ID = ENDERECO.FK_PESSOA_ID
INNER JOIN CIDADE CIDADE ON ENDERECO.FK_CID_ID = CIDADE.CID_ID
INNER JOIN ESTADO ESTADO ON CIDADE.FK_est_id = ESTADO.est_id
WHERE ENDERECO.TIPO = 1

