/**
 * POST /api/login
 * Autentica o usuário verificando login e senha (hash SHA-256).
 *
 * Body esperado (JSON):
 * { usuario: "login_ou_email", senha: "..." }
 *
 * Retorna:
 *   { ok: true, nome: "...", mensagem: "..." }  → 200 OK
 *   { ok: false, erro: "..." }                  → 400 / 401 / 500
 */

// Mesma função de hash usada no cadastro
async function hashSenha(senha) {
    const encoder = new TextEncoder();
    const data = encoder.encode(senha);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

export async function onRequestPost(context) {
    const { request, env } = context;

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

        const { usuario, senha } = body;

        // 2. Validações
        if (!usuario?.trim() || !senha) {
            return new Response(
                JSON.stringify({ ok: false, erro: 'Usuário e senha são obrigatórios.' }),
                { status: 400, headers }
            );
        }

        const db = env.DB;
        const loginNormalizado = usuario.trim().toLowerCase();

        // 3. Buscar usuário pelo login OU pelo e-mail
        const row = await db
            .prepare(`
                SELECT u.senha_hash, u.login, p.nome_razao_soc
                FROM usuarios u
                INNER JOIN pessoa p ON u.pessoa_id = p.pessoa_id
                WHERE u.login = ? OR p.email = ?
                LIMIT 1
            `)
            .bind(loginNormalizado, loginNormalizado)
            .first();

        // 4. Usuário não encontrado
        if (!row) {
            return new Response(
                JSON.stringify({ ok: false, erro: 'Usuário ou senha incorretos.' }),
                { status: 401, headers }
            );
        }

        // 5. Verificar senha
        const senhaDigitadaHash = await hashSenha(senha);

        if (senhaDigitadaHash !== row.senha_hash) {
            return new Response(
                JSON.stringify({ ok: false, erro: 'Usuário ou senha incorretos.' }),
                { status: 401, headers }
            );
        }

        // 6. Login bem-sucedido
        return new Response(
            JSON.stringify({
                ok: true,
                nome: row.nome_razao_soc,
                login: row.login,
                mensagem: `Bem-vindo, ${row.nome_razao_soc}!`
            }),
            { status: 200, headers }
        );

    } catch (err) {
        console.error('Erro no login:', err);
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
