-- ============================================================
-- FAZENTECH — schema.sql
-- Banco de dados Cloudflare D1 (SQLite)
-- Execute com: npx wrangler d1 execute fazentech-db --file=./schema.sql
-- ============================================================

-- Dados pessoais (pessoa física ou jurídica)
CREATE TABLE IF NOT EXISTS pessoa (
    pessoa_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_razao_soc     TEXT    NOT NULL,
    tipo_pessoa        TEXT    NOT NULL CHECK(tipo_pessoa IN ('fisica','juridica')),
    cpf_cnpj           TEXT    UNIQUE,
    datanas_inauguraca TEXT,
    email              TEXT    NOT NULL UNIQUE,
    telefone           TEXT,
    criado_em          TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- Endereço do cliente
CREATE TABLE IF NOT EXISTS endereco (
    end_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    pessoa_id    INTEGER NOT NULL REFERENCES pessoa(pessoa_id) ON DELETE CASCADE,
    estado       TEXT    NOT NULL,
    cidade       TEXT    NOT NULL,
    logradouro   TEXT    NOT NULL,
    numero       TEXT    NOT NULL,
    complemento  TEXT,
    cep          TEXT    NOT NULL,
    end_entrega  TEXT,
    end_cobranca TEXT
);

-- Dados específicos de clientes (limite de crédito, data de cadastro)
CREATE TABLE IF NOT EXISTS clientes (
    cliente_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    pessoa_id     INTEGER NOT NULL UNIQUE REFERENCES pessoa(pessoa_id) ON DELETE CASCADE,
    data_cadastro TEXT    NOT NULL DEFAULT (date('now')),
    limite        REAL    NOT NULL DEFAULT 5000.00
);

-- Credenciais de acesso (senha armazenada como hash SHA-256)
CREATE TABLE IF NOT EXISTS usuarios (
    usuario_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pessoa_id  INTEGER NOT NULL UNIQUE REFERENCES pessoa(pessoa_id) ON DELETE CASCADE,
    login      TEXT    NOT NULL UNIQUE,
    senha_hash TEXT    NOT NULL,
    criado_em  TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_pessoa_email  ON pessoa(email);
CREATE INDEX IF NOT EXISTS idx_usuario_login ON usuarios(login);
