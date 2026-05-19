# Pulse v2

Monitoramento de serviços para desktop — design Glass/Aurora, atalhos de teclado, command palette, métricas (uptime% e p95), incidentes, webhooks (Slack/Discord/genérico) e workspace exportável.

## Instalar (usuário final)

A v2 foi feita para que ninguém precise abrir um terminal. Cada plataforma tem o seu instalador na página de **Releases**: https://github.com/Pauloricardorc/pulse/releases/latest

### Windows
- **`pulse-setup-X.Y.Z.exe`** — instalador padrão. Duplo clique → próximo → instalar. Cria atalho no Menu Iniciar (opcional: na Área de Trabalho e na Inicialização).
- **`pulse-windows-portable.zip`** — versão zip sem instalar. Descompacte e rode `pulse_v2.exe`.

### Linux
- **`Pulse-X.Y.Z-x86_64.AppImage`** — 1 arquivo, sem instalar. `chmod +x Pulse-*.AppImage` e duplo clique.
- **`pulse_X.Y.Z_amd64.deb`** — Ubuntu/Debian: `sudo apt install ./pulse_*.deb`. Vira um ícone no menu.

### macOS
- **`pulse-macos.zip`** — descompacte e arraste o `pulse_v2.app` para a pasta Aplicativos.

> Não há cobrança de auto-update. Quando uma versão nova é publicada, o Pulse mostra um banner que abre direto a página de releases.

## Atalhos

| Atalho | Ação |
|--------|------|
| `⌘K` / `Ctrl+K` | Command palette |
| `/` | Focar busca |
| `?` | Cheatsheet de atalhos |
| `Esc` | Fechar / voltar |
| `G D` | Dashboard |
| `G S` | Serviços |
| `G I` | Incidentes |
| `G W` | Webhooks |
| `G P` | Preferências |
| `N` | Novo serviço |
| `R` | Recheck em todos |

## Recursos v2

- **Glass/Aurora UI** — fundo com mesh-gradient animado, surfaces translúcidas, neon-cyan + magenta.
- **Check avançado** — método HTTP (GET/POST/PUT/PATCH/DELETE/HEAD), headers, body, timeout configurável.
- **Critérios de saúde** — status exato, range, body contém, regex, JSON path.
- **Métricas** — uptime%, p95, avg de latência em janelas 1h/24h/7d/30d.
- **Incidentes** — toda queda vira um incidente com início/fim/duração/nota.
- **Tags** — etiquetas livres por ambiente para organização.
- **Webhooks** — Slack, Discord ou JSON genérico em mudança de status.
- **Workspace** — exportar/importar serviços, ambientes, tags e webhooks (.pulse.json).
- **Banner de update** — checa a API do GitHub Releases ao iniciar e mostra um banner se há versão nova.

## Desenvolvimento

```bash
flutter pub get
dart run build_runner build
flutter run -d macos    # ou windows / linux
```

Schema fica em `lib/core/database/app_database.dart` — rode o build_runner depois de alterá-lo.

### Lançar uma versão

```bash
# 1) bump em pubspec.yaml: version: 2.0.1+2
# 2) git commit e tag
git tag v2.0.1
git push origin v2.0.1
```

O workflow `.github/workflows/release.yml` constrói:
- **Windows**: `.zip` portable + `.exe` (Inno Setup)
- **Linux**: `.AppImage` + `.deb`
- **macOS**: `.zip` do `.app`

… e publica tudo em uma GitHub Release. O Pulse rodando nos usuários detecta a nova tag pela GitHub API e mostra o banner.
