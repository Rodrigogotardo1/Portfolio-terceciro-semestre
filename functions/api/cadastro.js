/**
 * POST /api/cadastro
 * Recebe os dados do formulário de cadastro, valida e salva no D1.
 *
 * Body esperado (JSON):
 * {
 *   tipo_pessoa, nome_razao, cpf, cnpj, dtNas, email, telefone,
 *   login, senha, confirma_senha,
 *   estado, cidade, logradouro, numero, complemento, cep,
 *   end_entrega, end_cobranca
 * }
 *
 * Retorna:
 *   { ok: true, mensagem: "..." }  → 201 Created
 *   { ok: false, erro: "..." }     → 400 / 409 / 500
 */

// Gera hash SHA-256 de uma string usando a Web Crypto API nativa
async function hashSenha(senha) {
    const encoder = new TextEncoder();
    const data = encoder.encode(senha);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

export async function onRequestPost(context) {
    const { request, env } = context;

    // Cabeçalhos CORS para permitir requisição do frontend
    const headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
    };

    try {
        // 1. Ler body JSON
        let body;
        try {
            body = await request.json();
        } catch {
            return new Response(
                JSON.stringify({ ok: false, erro: 'Dados inválidos. Envie JSON.' }),
                { status: 400, headers }
            );
        }

        const {
            tipo_pessoa, nome_razao, cpf, cnpj, dtNas,
            email, telefone, login, senha, confirma_senha,
            estado, cidade, logradouro, numero,
            complemento, cep, end_entrega, end_cobranca
        } = body;

        // 2. Validações básicas
        const erros = [];

        if (!nome_razao?.trim())   erros.push('Nome/Razão Social é obrigatório.');
        if (!email?.trim())        erros.push('E-mail é obrigatório.');
        if (!login?.trim())        erros.push('Login é obrigatório.');
        if (!senha)                erros.push('Senha é obrigatória.');
        if (!confirma_senha)       erros.push('Confirmação de senha é obrigatória.');
        if (!estado?.trim())       erros.push('Estado é obrigatório.');
        if (!cidade?.trim())       erros.push('Cidade é obrigatória.');
        if (!logradouro?.trim())   erros.push('Logradouro é obrigatório.');
        if (!numero?.trim())       erros.push('Número é obrigatório.');
        if (!cep?.trim())          erros.push('CEP é obrigatório.');

        // Validar e-mail com regex simples
        if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())) {
            erros.push('E-mail inválido.');
        }

        // Validar correspondência das senhas
        if (senha && confirma_senha && senha !== confirma_senha) {
            erros.push('As senhas não coincidem.');
        }

        // Validar comprimento mínimo da senha
        if (senha && senha.length < 6) {
            erros.push('A senha deve ter pelo menos 6 caracteres.');
        }

        if (erros.length > 0) {
            return new Response(
                JSON.stringify({ ok: false, erro: erros.join(' ') }),
                { status: 400, headers }
            );
        }

        const db = env.DB;

        // 3. Verificar e-mail duplicado
        const emailExiste = await db
            .prepare('SELECT pessoa_id FROM pessoa WHERE email = ?')
            .bind(email.trim().toLowerCase())
            .first();

        if (emailExiste) {
            return new Response(
                JSON.stringify({ ok: false, erro: 'Este e-mail já está cadastrado.' }),
                { status: 409, headers }
            );
        }

        // 4. Verificar login duplicado
        const loginExiste = await db
            .prepare('SELECT usuario_id FROM usuarios WHERE login = ?')
            .bind(login.trim().toLowerCase())
            .first();

        if (loginExiste) {
            return new Response(
                JSON.stringify({ ok: false, erro: 'Este login já está em uso. Escolha outro.' }),
                { status: 409, headers }
            );
        }

        // 5. Determinar cpf_cnpj conforme tipo
        const cpfCnpj = tipo_pessoa === 'juridica'
            ? (cnpj?.replace(/\D/g, '') || null)
            : (cpf?.replace(/\D/g, '') || null);

        // 6. Inserir em pessoa
        const pessoaResult = await db
            .prepare(`
                INSERT INTO pessoa (nome_razao_soc, tipo_pessoa, cpf_cnpj, datanas_inauguraca, email, telefone)
                VALUES (?, ?, ?, ?, ?, ?)
            `)
            .bind(
                nome_razao.trim(),
                tipo_pessoa === 'juridica' ? 'juridica' : 'fisica',
                cpfCnpj,
                dtNas || null,
                email.trim().toLowerCase(),
                telefone?.trim() || null
            )
            .run();

        const pessoaId = pessoaResult.meta.last_row_id;

        // 7. Inserir endereço
        await db
            .prepare(`
                INSERT INTO endereco (pessoa_id, estado, cidade, logradouro, numero, complemento, cep, end_entrega, end_cobranca)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            `)
            .bind(
                pessoaId,
                estado.trim(),
                cidade.trim(),
                logradouro.trim(),
                numero.trim(),
                complemento?.trim() || null,
                cep.replace(/\D/g, ''),
                end_entrega?.trim() || null,
                end_cobranca?.trim() || null
            )
            .run();

        // 8. Inserir na tabela clientes
        await db
            .prepare('INSERT INTO clientes (pessoa_id) VALUES (?)')
            .bind(pessoaId)
            .run();

        // 9. Fazer hash da senha e inserir usuário
        const senhaHash = await hashSenha(senha);
        await db
            .prepare('INSERT INTO usuarios (pessoa_id, login, senha_hash) VALUES (?, ?, ?)')
            .bind(pessoaId, login.trim().toLowerCase(), senhaHash)
            .run();

        return new Response(
            JSON.stringify({ ok: true, mensagem: 'Cadastro realizado com sucesso! Faça login para continuar.' }),
            { status: 201, headers }
        );

    } catch (err) {
        console.error('Erro no cadastro:', err);
        return new Response(
            JSON.stringify({ ok: false, erro: 'Erro interno do servidor. Tente novamente.' }),
            { status: 500, headers }
        );
    }
}

// Handler OPTIONS para preflight CORS
export async function onRequestOptions() {
    return new Response(null, {
        status: 204,
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type',
        },
    });
}
