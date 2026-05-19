# Deploy de uma nova versão

**Mudar a tag é o gatilho único.** Tudo o que vem depois é automático — incluindo o auto-update nos clientes Windows e macOS.

## Fluxo TL;DR

```bash
# 1) bump no pubspec.yaml
#    version: 2.0.1+2     <- antes era 2.0.0+1

git add pubspec.yaml
git commit -m "chore: bump 2.0.1"

git tag v2.0.1
git push origin main --tags
```

Pronto. Em 6-10 min existe a Release em `github.com/Pauloricardorc/pulse/releases/v2.0.1` com os instaladores **e** o `appcast.xml` no `main` foi atualizado. Usuários Windows/macOS que abrirem o Pulse a partir desse momento veem o popup de atualização.

## O que acontece automaticamente

Push da tag → `.github/workflows/release.yml` roda 5 jobs:

| Job | Roda em | Saída |
|-----|---------|-------|
| `build-windows` | windows-latest | `pulse-setup-2.0.1.exe` + `pulse-windows-portable.zip` |
| `build-linux` | ubuntu-22.04 | `Pulse-2.0.1-x86_64.AppImage` + `pulse_2.0.1_amd64.deb` |
| `build-macos` | macos-latest | `pulse-macos.zip` |
| `release` | ubuntu-latest | Cria a Release no GitHub e anexa todos os arquivos |
| `appcast` | ubuntu-latest | Regenera `appcast.xml` apontando para os novos enclosures e dá push em `main` |

Se algum dos 3 builds falhar, a Release **e** o appcast não são tocados. Apps já instalados continuam acreditando que a versão atual ainda é a mais recente.

## O que o usuário vê

Diferente por plataforma:

### Windows e macOS — popup nativo

Ao abrir o Pulse:

1. O `auto_updater` (WinSparkle no Win, Sparkle no Mac) lê `https://raw.githubusercontent.com/Pauloricardorc/pulse/main/appcast.xml`.
2. Compara `sparkle:version` com a versão local.
3. Se for maior, aparece um popup nativo:

   ```
   Uma nova versão do Pulse está disponível!
   Pulse 2.0.1 está disponível — você tem a 2.0.0.

   [Instalar atualização]   [Lembrar mais tarde]   [Ignorar esta versão]
   ```

4. **Instalar atualização** → baixa em background → fecha o Pulse → roda o instalador (silencioso no Mac, Inno Setup com clique-em-Continue no Win) → reabre o Pulse na versão nova.

A checagem só acontece **uma vez por abertura**. Quem deixa o Pulse aberto 3 dias não recebe popup até reiniciar (ou clicar em **Preferências → Buscar atualizações → Verificar**).

### Linux — banner manual

Sparkle/WinSparkle não suportam Linux. Mantemos o banner que já existia:

> **Versão 2.0.1 disponível · Nome da release**  `[Abrir release]`  `×`

O usuário clica em "Abrir release", baixa `.deb` ou AppImage e instala manual. Auto-update real no Linux fica pra uma próxima iteração — exige implementação custom (`sudo apt install` ou substituição de AppImage).

## Aviso sobre macOS sem assinatura

A app **não é code-signed** com Apple Developer ID. Consequências:

- **Primeira instalação**: usuário precisa fazer `clique-direito → Abrir` (uma vez) para o Gatekeeper liberar.
- **Auto-update**: o `.zip` baixado pelo Sparkle herda a flag de quarentena. Ao trocar o `.app`, o macOS pode pedir confirmação adicional na próxima abertura (a mensagem "App baixado da internet, deseja abrir?").

Não bloqueia — é fricção pequena, igual à instalação inicial. Pra eliminar isso, precisaria comprar Apple Developer ($99/ano) e configurar notarização no workflow. Em outra iteração.

## Como o usuário aplica a atualização

Para quem **não** está em Win/Mac (ou que recusou o popup):

| Plataforma | Como atualizar |
|------------|---------------|
| **Windows** (instalador) | Baixa o novo `.exe` e roda. Inno Setup detecta a instalação anterior (mesmo `AppId`) e atualiza por cima. |
| **Windows** (portable zip) | Baixa o zip, fecha o Pulse, substitui a pasta. |
| **Linux** (`.deb`) | `sudo apt install ./pulse_2.0.1_amd64.deb` |
| **Linux** (AppImage) | Sobrescreve o arquivo antigo (`chmod +x` se necessário). |
| **macOS** (`.zip`) | Arrasta o novo `.app` para Aplicativos, substitui. |

## Dados do usuário são preservados?

**Sim.** O banco local e as preferências ficam em:

| Plataforma | Localização |
|------------|-------------|
| Windows | `%APPDATA%\com.pauloricardo\pulse_v2\` |
| Linux   | `~/.local/share/com.pauloricardo/pulse_v2/` |
| macOS   | `~/Library/Application Support/com.pauloricardo/pulse_v2/` |

Atualizar o binário **não toca** nesses arquivos. Schema do Drift evolui via `MigrationStrategy` (`onUpgrade`); hoje só tem `onCreate`. Se você adicionar coluna, escreva a migration antes de taggear.

## Onde mora o appcast

`appcast.xml` na raiz do repo, branch `main`. URL pública usada pelo `auto_updater`:

```
https://raw.githubusercontent.com/Pauloricardorc/pulse/main/appcast.xml
```

**Não edite à mão** — o job `appcast` reescreve toda vez que sai uma release. Se quiser inspecionar, abra o arquivo após uma tag rodar; ele só tem um `<item>` (a versão mais recente). Sparkle só precisa do último.

## Checklist antes de taggear

- [ ] `pubspec.yaml` versão bumpada (`semver+build`).
- [ ] `flutter analyze` limpo localmente.
- [ ] Testou abrindo a app e fazendo um check?
- [ ] Se mexeu no schema do Drift, rodou `dart run build_runner build` **e** escreveu a migration.
- [ ] Commit feito e pushado para `main`.

Aí sim, `git tag vX.Y.Z && git push origin --tags`.

## Hotfix / rollback

### Republicar
Bump pra `vX.Y.(Z+1)`, novo push de tag. Apps existentes recebem popup de novo no próximo abrir.

### Desfazer release errada
1. Na aba *Releases* do GitHub, edite a release e marque como **Draft** (some pra todo mundo, incluindo a API).
2. Reverta o commit que mexeu no `appcast.xml` (apontava pra v errada):
   ```bash
   git revert <hash-do-commit-do-appcast>
   git push origin main
   ```
3. Se for reusar o número da versão, apague também a tag:
   ```bash
   git tag -d v2.0.1
   git push origin :refs/tags/v2.0.1
   ```

### Pre-release (testar sem distribuir)
Marque a release como **Pre-release** no GitHub. **Atenção**: o workflow ainda assim regenera o `appcast.xml`. Se você quer testar sem afetar todo mundo, edite manualmente o `appcast.xml` de volta para a versão estável **antes** que algum usuário abra o app, ou desabilite o job `appcast` temporariamente.

Um caminho mais limpo: criar uma branch `next` com `appcast.xml` apontando para versões beta, e o `auto_updater` configurado pra ler dela em builds de desenvolvimento. Não está implementado hoje.

## Resumo do contrato

| Você faz | O Pulse faz | O usuário faz |
|----------|-------------|---------------|
| Bump + tag + push | Builda, empacota, publica Release, regenera appcast | Win/Mac: clica em "Instalar atualização" no popup. Linux: clica em "Abrir release" e instala. |

Uma operação sua, atualização visível em segundos do próximo abrir, opt-in pelo usuário (ele sempre pode adiar ou ignorar a versão).
