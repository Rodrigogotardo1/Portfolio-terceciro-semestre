-- ============================================================
-- FAZENTECH — fazenda_db.sql (CORRIGIDO)
-- Banco de dados da Fazenda Gotardo
-- Correções aplicadas:
--   1. PEDIDO: referência corrigida de CLIENTE → CLIENTES
--   2. PEDIDO: INSERTs com FK_fun_id corrigidos (IDs 1 e 2 existem)
--   3. SELECT final com GROUP BY adicionado
-- ============================================================

-- Criação do banco
CREATE DATABASE IF NOT EXISTS fazenda_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fazenda_db;

-- ============================================================
-- TABELA: estado
-- ============================================================
CREATE TABLE estado (
    est_id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    nome   VARCHAR(40) NOT NULL,
    UF     CHAR(2)     NOT NULL,
    pais   VARCHAR(40) NOT NULL DEFAULT 'Brasil'
);

INSERT INTO estado (nome, UF)
VALUES ('Paraná', 'PR');

-- ============================================================
-- TABELA: cidade
-- ============================================================
CREATE TABLE cidade (
    CID_ID     INT         NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    cidade     VARCHAR(50) NOT NULL,
    FK_est_id  INT         NOT NULL,
    CONSTRAINT FK_CIDADE_ESTADO_ID FOREIGN KEY (FK_est_id) REFERENCES estado (est_id)
);

INSERT INTO cidade (cidade, FK_est_id) VALUES ('Londrina', 1);
INSERT INTO cidade (cidade, FK_est_id) VALUES ('Cambé',    1);

-- ============================================================
-- TABELA: pessoa
-- ============================================================
CREATE TABLE pessoa (
    PESSOA_ID          INT         NOT NULL UNIQUE AUTO_INCREMENT,
    nome_razao_soc     VARCHAR(40),
    nome_fantasia      VARCHAR(60),
    CPF_CNPJ           VARCHAR(14),
    datanas_inauguraca DATE,
    EMAIL              VARCHAR(30),
    PRIMARY KEY (PESSOA_ID)
);

INSERT INTO pessoa (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca, EMAIL)
VALUES ('Rodrigo Gotardo',  'Rodrigo Gotardo',  '00000000000', '1983-02-11', 'rodrigo@gmail.com');  -- ID 1

INSERT INTO pessoa (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca, EMAIL)
VALUES ('Ricardo Gotardo',  'Ricardo Gotardo',  '12345678901', '1985-02-19', 'ricardo@gmail.com');  -- ID 2

INSERT INTO pessoa (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca, EMAIL)
VALUES ('Gabriel Gotardo',  'Gabriel Gotardo',  '11111111111', '1990-02-19', 'gabriel@gmail.com');  -- ID 3

INSERT INTO pessoa (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca, EMAIL)
VALUES ('Leonardo Gotardo', 'Leonardo Gotardo', '22222222222', '1995-04-20', 'leonardo@gmail.com'); -- ID 4

INSERT INTO pessoa (nome_razao_soc, nome_fantasia, CPF_CNPJ, datanas_inauguraca, EMAIL)
VALUES ('Rebecca Gotardo',  'Rebecca Gotardo',  '33333333333', '1991-02-28', 'rebecca@gmail.com'); -- ID 5

-- ============================================================
-- TABELA: endereco
-- ============================================================
CREATE TABLE endereco (
    end_id       INT          NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    tipo         CHAR(1)      NOT NULL COMMENT '[1=RESIDENCIAL, 2=COMERCIAL, 3=COBRANÇA, 4=ENTREGA]',
    endereco     VARCHAR(60)  NOT NULL,
    numero       CHAR(5),
    bairro       VARCHAR(60),
    CEP          CHAR(8)      NOT NULL,
    complemento  VARCHAR(100),
    FK_CID_ID    INT          NOT NULL,
    FK_PESSOA_ID INT          NOT NULL,
    CONSTRAINT FK_ENDERECO_CIDADE_ID  FOREIGN KEY (FK_CID_ID)    REFERENCES cidade (CID_ID),
    CONSTRAINT FK_ENDERECO_PESSOA_ID  FOREIGN KEY (FK_PESSOA_ID) REFERENCES pessoa (PESSOA_ID),
    CONSTRAINT CK_tipo_Endereco       CHECK (tipo IN ('1','2','3','4'))
);

-- Rodrigo (pessoa_id=1) — Londrina (cid_id=1)
INSERT INTO endereco (tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, FK_PESSOA_ID)
VALUES ('1', 'Rosalvo Marques', '637', 'Padovanni', '86081538', '', 1, 1);
INSERT INTO endereco (tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, FK_PESSOA_ID)
VALUES ('2', 'Rosalvo Marques', '637', 'Padovanni', '86081538', '', 1, 1);
INSERT INTO endereco (tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, FK_PESSOA_ID)
VALUES ('3', 'Av São João',     '1000','Centro',    '86081500', '', 1, 1);
INSERT INTO endereco (tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, FK_PESSOA_ID)
VALUES ('4', 'Rosalvo Marques', '637', 'Padovanni', '86081538', '', 1, 1);

-- Ricardo (pessoa_id=2)
INSERT INTO endereco (tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, FK_PESSOA_ID)
VALUES ('1', 'Humaitá', '100', 'Centro', '86015100', '', 1, 2);

-- Gabriel (pessoa_id=3)
INSERT INTO endereco (tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, FK_PESSOA_ID)
VALUES ('1', 'JK', '100', 'Centro', '86015100', '', 1, 3);

-- Leonardo (pessoa_id=4)
INSERT INTO endereco (tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, FK_PESSOA_ID)
VALUES ('1', 'Pernambuco', '100', 'Centro', '86084100', '', 1, 4);

-- Rebecca (pessoa_id=5) — Cambé (cid_id=2)
INSERT INTO endereco (tipo, endereco, numero, bairro, CEP, complemento, FK_CID_ID, FK_PESSOA_ID)
VALUES ('1', 'Mauricio', '200', 'Centro', '81415100', '', 2, 5);

-- ============================================================
-- TABELA: funcionario
-- ============================================================
CREATE TABLE funcionario (
    fun_id       INT         NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    setor        VARCHAR(20),
    CTPS         CHAR(20),
    funcao       VARCHAR(40),
    salario      DECIMAL(12,2),
    FK_pessoa_id INT,
    CONSTRAINT FK_FUNCIONARIO_PESSOA_ID FOREIGN KEY (FK_pessoa_id) REFERENCES pessoa (PESSOA_ID)
);

-- Rodrigo (pessoa_id=1) => fun_id=1
INSERT INTO funcionario (setor, CTPS, funcao, salario, FK_pessoa_id)
VALUES ('RH', '0000000', 'Recrutador', 1000.00, 1);

-- Leonardo (pessoa_id=4) => fun_id=2
INSERT INTO funcionario (setor, CTPS, funcao, salario, FK_pessoa_id)
VALUES ('TI', '11111111', 'DBA', 2000.00, 4);

-- ============================================================
-- TABELA: clientes
-- ============================================================
CREATE TABLE clientes (
    CLIENTE_ID    INT         NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    DATA_CADASTRO DATE,
    LIMITE        DECIMAL(15,2),
    FK_PESSOA_ID  INT,
    CONSTRAINT FK_CLIENTE_PESSOA_ID FOREIGN KEY (FK_PESSOA_ID) REFERENCES pessoa (PESSOA_ID)
);

-- Rodrigo (pessoa_id=1) => cliente_id=1
INSERT INTO clientes (DATA_CADASTRO, LIMITE, FK_PESSOA_ID)
VALUES ('2020-10-05', 10000.00, 1);
-- Ricardo (pessoa_id=2) => cliente_id=2
INSERT INTO clientes (DATA_CADASTRO, LIMITE, FK_PESSOA_ID)
VALUES ('2020-10-10', 9000.00, 2);
-- Gabriel (pessoa_id=3) => cliente_id=3
INSERT INTO clientes (DATA_CADASTRO, LIMITE, FK_PESSOA_ID)
VALUES ('2020-10-20', 5000.00, 3);
-- Rebecca (pessoa_id=5) => cliente_id=4
INSERT INTO clientes (DATA_CADASTRO, LIMITE, FK_PESSOA_ID)
VALUES ('2020-10-20', 1000.00, 5);

-- ============================================================
-- TABELA: producao
-- ============================================================
CREATE TABLE producao (
    producao_id  INT           NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    especie      VARCHAR(40)   NOT NULL,
    data_ordenha DATE          NOT NULL,
    produtividade DECIMAL(4,2) NOT NULL,
    inseminacao  CHAR(1)       NOT NULL COMMENT '[1=sim, 2=nao]',
    CONSTRAINT ck_inseminacao_producao CHECK (inseminacao IN ('1','2'))
);

INSERT INTO producao (especie, data_ordenha, produtividade, inseminacao)
VALUES ('Simenta', '2020-10-22', 10.00, '2');  -- producao_id=1
INSERT INTO producao (especie, data_ordenha, produtividade, inseminacao)
VALUES ('Guemsey', '2020-10-23', 13.00, '1');  -- producao_id=2

-- ============================================================
-- TABELA: produto
-- ============================================================
CREATE TABLE produto (
    PROD_ID       INT           NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    nome_prod     VARCHAR(50)   NOT NULL,
    tipo_prod     VARCHAR(50)   NOT NULL,
    custo         DECIMAL(9,2),
    QTDO_ESTOQUE  DECIMAL(10,2),
    VALOR_VENDA   DECIMAL(8,2),
    FK_PRODUCAO_ID INT,
    CONSTRAINT FK_PROD_PRODUCAO_ID FOREIGN KEY (FK_PRODUCAO_ID) REFERENCES producao (producao_id)
);

INSERT INTO produto (nome_prod, tipo_prod, custo, QTDO_ESTOQUE, VALOR_VENDA, FK_PRODUCAO_ID)
VALUES ('Queijo',       'Integral',  5.00, 120.00, 9.00, 1);  -- prod_id=1
INSERT INTO produto (nome_prod, tipo_prod, custo, QTDO_ESTOQUE, VALOR_VENDA, FK_PRODUCAO_ID)
VALUES ('Leite',        'Desnatado', 1.00,  30.00, 3.00, 1);  -- prod_id=2
INSERT INTO produto (nome_prod, tipo_prod, custo, QTDO_ESTOQUE, VALOR_VENDA, FK_PRODUCAO_ID)
VALUES ('Doce de Leite','Light',     2.00,  20.00, 7.00, 2);  -- prod_id=3

-- ============================================================
-- TABELA: pedido
-- (CORRIGIDO: FK referencia 'clientes' e não 'cliente')
-- (CORRIGIDO: FK_fun_id usa IDs que existem: 1 e 2)
-- ============================================================
CREATE TABLE pedido (
    PEDIDO_ID      INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_pedido    DATE,
    QTDO_VENDA_PROD DECIMAL(10,2),
    VALOR_VENDA    DECIMAL(10,2),
    FK_CLIENTE_ID  INT,
    FK_PROD_ID     INT,
    FK_fun_id      INT,
    CONSTRAINT FK_PEDIDO_CLIENTE_ID    FOREIGN KEY (FK_CLIENTE_ID) REFERENCES clientes (CLIENTE_ID),
    CONSTRAINT FK_PEDIDO_PRODUTO_ID    FOREIGN KEY (FK_PROD_ID)    REFERENCES produto  (PROD_ID),
    CONSTRAINT FK_PEDIDO_FUNCIONARIO_ID FOREIGN KEY (FK_fun_id)    REFERENCES funcionario (fun_id)
);

-- Rodrigo compra Queijo, atendido por Rodrigo (fun_id=1)
INSERT INTO pedido (data_pedido, QTDO_VENDA_PROD, VALOR_VENDA, FK_CLIENTE_ID, FK_PROD_ID, FK_fun_id)
VALUES ('2020-10-24', 2, 18.00, 1, 1, 1);

-- Gabriel compra Queijo, atendido por Leonardo (fun_id=2)
INSERT INTO pedido (data_pedido, QTDO_VENDA_PROD, VALOR_VENDA, FK_CLIENTE_ID, FK_PROD_ID, FK_fun_id)
VALUES ('2020-10-25', 5, 45.00, 3, 1, 2);

-- Gabriel compra Leite, atendido por Leonardo (fun_id=2)
INSERT INTO pedido (data_pedido, QTDO_VENDA_PROD, VALOR_VENDA, FK_CLIENTE_ID, FK_PROD_ID, FK_fun_id)
VALUES ('2020-10-24', 10, 30.00, 3, 2, 2);

-- ============================================================
-- CONSULTAS
-- ============================================================

-- Quantidade de clientes por cidade
SELECT COUNT(*) AS Quantidade, c.cidade
FROM cidade c
INNER JOIN (
    SELECT MAX(end_id) AS END_ID, FK_CID_ID, FK_PESSOA_ID
    FROM endereco
    GROUP BY FK_CID_ID, FK_PESSOA_ID
) AS e ON e.FK_CID_ID = c.CID_ID
INNER JOIN pessoa p       ON p.PESSOA_ID   = e.FK_PESSOA_ID
INNER JOIN clientes cl    ON cl.FK_PESSOA_ID = p.PESSOA_ID
GROUP BY c.cidade;

-- Saídas de produtos (total vendido por produto)
SELECT pr.nome_prod AS PRODUTO, SUM(pe.QTDO_VENDA_PROD) AS QUANTIDADE_VENDIDA
FROM pedido pe
INNER JOIN produto pr ON pe.FK_PROD_ID = pr.PROD_ID
GROUP BY pr.nome_prod;

-- Saldo em estoque dos produtos
SELECT pr.nome_prod AS PRODUTO,
       pr.QTDO_ESTOQUE - COALESCE(SUM(pe.QTDO_VENDA_PROD), 0) AS QUANTIDADE_ESTOQUE
FROM produto pr
LEFT JOIN pedido pe ON pe.FK_PROD_ID = pr.PROD_ID
GROUP BY pr.nome_prod, pr.QTDO_ESTOQUE;

-- Funcionário com maior salário (CORRIGIDO: adicionado GROUP BY)
SELECT p.nome_razao_soc AS FUNCIONARIO, SUM(f.salario) AS SALARIO_TOTAL
FROM funcionario f
INNER JOIN pessoa p ON f.FK_pessoa_id = p.PESSOA_ID
GROUP BY p.nome_razao_soc
ORDER BY SALARIO_TOTAL DESC;
