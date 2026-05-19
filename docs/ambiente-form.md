# Form de Ambiente

Cada ambiente é uma URL que o Pulse vai bater de tempos em tempos e classificar como **online** ou **offline** segundo regras que você define aqui.

O form fica em **Serviços → (botão) Ambiente** ou navegando direto para `/services/{id}/environments/new`.

---

## 1. Identificação

### Nome
Curto, MAIÚSCULAS no card (ex.: `PROD`, `STAGING`, `DEV`, `HOMOLOG`). Aceita qualquer texto, mas o Pulse colore automaticamente alguns nomes:

| Nome contém       | Cor             |
| ----------------- | --------------- |
| `prod`            | Coral (vermelho)|
| `staging`/`homolog` | Amarelo       |
| `dev`/`local`     | Violet          |
| outros            | Cinza neutro    |

### Papel (opcional)
Etiqueta semântica do ambiente: `frontend`, `backend`, `api`, `health`. Só decora — útil quando o mesmo serviço tem duas URLs (uma do front, outra da API). Deixe vazio se não fizer sentido.

### URL
URL completa que será chamada. Aceita `http://` e `https://`. Pode conter path, query string, porta:

```
https://api.acme.io/health
https://checkout-staging.acme.io:8443/_ping
http://localhost:3000/health
```

---

## 2. Requisição

### Método
HTTP verb da requisição. Default `GET`. Outras opções: `POST`, `PUT`, `PATCH`, `DELETE`, `HEAD`.

Use `HEAD` se só te interessa o status (mais rápido, não baixa corpo). Use `POST` quando o health check exige payload (raro, mas alguns gateways pedem).

### Timeout (ms)
Quanto tempo o Pulse espera antes de considerar a requisição falha. Default `10000` (10s).

- Endpoint local rápido: `2000` (2s) é suficiente.
- Endpoint público com TLS pesado: `5000`–`10000`.
- Pra serviços sabidamente lentos: `30000`. Acima disso, repense o teste.

### Headers
Pares `key`/`valor` enviados na requisição. Use o botão **Adicionar header** para criar linhas. Exemplos:

| Header              | Valor                                |
| ------------------- | ------------------------------------ |
| `Authorization`     | `Bearer ${token}`                    |
| `X-Api-Key`         | `prod_abc123`                        |
| `User-Agent`        | `Pulse/2.0`                          |
| `Accept`            | `application/json`                   |

**Não há expansão de variável** — cole o token literal. Em ambientes compartilhados, isso fica gravado em texto plano no banco local.

### Body
Conteúdo enviado quando o método é `POST`/`PUT`/`PATCH`. Aceita qualquer texto (JSON, XML, form-encoded). Em `GET`/`HEAD`/`DELETE` é ignorado.

Exemplo (JSON):
```json
{ "probe": "pulse", "v": 1 }
```

---

## 3. Critério de saúde

Aqui você diz **o que torna a resposta "UP"**. Cinco modos:

### `Status exato`
A resposta precisa ter exatamente o código informado.

| Campo  | Valor  |
| ------ | ------ |
| Código | `200`  |

Use quando seu endpoint sempre retorna o mesmo status no caminho feliz.

### `Range de status`
A resposta passa se o status estiver entre **De** e **Até** (inclusivos).

| Campo | Valor |
| ----- | ----- |
| De    | `200` |
| Até   | `299` |

Útil para healthchecks que podem responder 200, 201 ou 204 indistintamente. Range mais permissivo: `200`–`399` (aceita redirects).

### `Body contém`
O corpo da resposta precisa **conter** o texto informado (sensível a maiúsculas).

| Campo | Valor              |
| ----- | ------------------ |
| Texto | `"status":"ok"`    |

Bom para detectar "200 OK com conteúdo errado" (servidor responde 200 mas com mensagem de erro no corpo).

### `Regex no body`
O corpo precisa **bater** com a expressão regular Dart. Use isso quando a string esperada tem variação (ex.: timestamp, versão).

| Campo | Valor                                  |
| ----- | -------------------------------------- |
| Regex | `"status"\s*:\s*"(ok\|healthy)"`       |

Se a regex for inválida, o check é marcado como falho com a mensagem "Regex inválida: ...".

### `JSON path`
Espera que o corpo seja JSON e que o caminho informado exista (qualquer valor não-`null`).

| Campo   | Valor              |
| ------- | ------------------ |
| Caminho | `data.user.id`     |
| Caminho | `result[0].status` |

Sintaxe suportada: chaves separadas por ponto, índices entre colchetes. **Não** suporta `$.`, filtros, wildcards — é um path dotado simples. Se a resposta não for JSON válido, marca falha.

---

## 4. Verificação

### Intervalo (segundos)
Frequência da checagem. Default `60` (1 min). Não pode ser menor que 1.

| Cenário             | Sugestão       |
| ------------------- | -------------- |
| Produção crítica    | `30`–`60`      |
| Staging/Homolog     | `120`–`300`    |
| Dev/local           | `300`+ ou pausado |
| Endpoint caro/com cota | `300`–`600` |

Cada ambiente roda no seu próprio timer; intervalos curtos são OK desde que a URL aguente.

### Estado
**Ativo** roda o timer. **Pausado** mantém o ambiente cadastrado mas não verifica nada — útil quando você sabe que vai dar manutenção e não quer poluir o histórico com falhas previstas.

---

## 5. Tags

Etiquetas livres de organização. Digite o nome e pressione **Enter** ou **Add**. Cada tag ganha uma cor consistente (hash do nome).

Exemplos: `prod`, `infra`, `billing`, `pci`, `external`, `cron`.

Tags servem pra filtrar no dashboard quando você passa de ~20 ambientes. Não afetam o monitoring.

---

## Salvando

Ao clicar em **Criar ambiente** / **Salvar alterações**:

1. O Pulse persiste o registro no banco local.
2. Recria/reagenda o timer (com o intervalo novo).
3. Dispara um check imediato — você vê o primeiro resultado em segundos no dashboard.

Se o estado for **Pausado**, o passo 2/3 não acontecem.

---

## Erros comuns

| Sintoma                                         | Causa provável                                  |
| ----------------------------------------------- | ----------------------------------------------- |
| Marca DOWN imediatamente com "Timeout de conexão" | URL errada, firewall, ou VPN exigida            |
| "Esperado status 200, recebido 401"             | Falta `Authorization` no header                 |
| "Body não contém X"                             | Endpoint não responde JSON ou string mudou      |
| "Regex inválida"                                | Escape errado — em Dart, `\d` precisa ser `\\d` se em string literal, mas no input do form vai direto |
| "Resposta não é JSON válido" (em jsonpath)      | Endpoint responde HTML/erro de servidor         |
| Check fica "aguardando" pra sempre              | Ambiente está **Pausado** — alterne em Editar   |
