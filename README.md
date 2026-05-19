# Pulse

Monitoramento de serviços para desktop — design Glass/Aurora, atalhos de teclado, command palette, métricas (uptime% e p95), incidentes, webhooks (Slack/Discord/genérico) e workspace exportável.

## Instalar (usuário final)

O Pulse foi feito para que ninguém precise abrir um terminal. Cada plataforma tem o seu instalador na página de **Releases**: https://github.com/Pauloricardorc/pulse/releases/latest

### Windows
- **`pulse-setup-X.Y.Z.exe`** — instalador padrão. Duplo clique → próximo → instalar. Cria atalho no Menu Iniciar (opcional: na Área de Trabalho e na Inicialização).
- **`pulse-windows-portable.zip`** — versão zip sem instalar. Descompacte e rode `Pulse.exe`.

### Linux
- **`Pulse-X.Y.Z-x86_64.AppImage`** — 1 arquivo, sem instalar. `chmod +x Pulse-*.AppImage` e duplo clique.
- **`pulse_X.Y.Z_amd64.deb`** — Ubuntu/Debian: `sudo apt install ./pulse_*.deb`. Vira um ícone no menu.

### macOS
- **`pulse-macos.zip`** — descompacte e arraste o `Pulse.app` para a pasta Aplicativos.

> Versões Windows e macOS recebem auto-update via Sparkle/WinSparkle. Linux usa um banner na app com link para a release mais recente.

> **macOS — primeira vez:** se aparecer "A Apple não pôde verificar…", abra Ajustes do Sistema → Privacidade e Segurança → "Abrir Mesmo Assim" para o Pulse. Só na primeira vez.

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

## Recursos

- **Glass/Aurora UI** — fundo com mesh-gradient sutil, surfaces translúcidas, accent lime + violet.
- **Check avançado** — método HTTP (GET/POST/PUT/PATCH/DELETE/HEAD), headers, body, timeout configurável.
- **Critérios de saúde** — status exato, range, body contém, regex, JSON path.
- **Métricas** — uptime%, p95, avg de latência em janelas 1h/24h/7d/30d.
- **Incidentes** — toda queda vira um incidente com início/fim/duração/nota.
- **Tags** — etiquetas livres por ambiente para organização.
- **Webhooks** — Slack, Discord ou JSON genérico em mudança de status.
- **Workspace** — exportar/importar serviços, ambientes, tags e webhooks (.pulse.json).
- **Auto-update** — Sparkle (macOS) e WinSparkle (Windows) baixam e instalam automaticamente; Linux mostra banner.

## Desenvolvimento

```bash
flutter pub get
dart run build_runner build
flutter run -d macos    # ou windows / linux
```

Schema fica em `lib/core/database/app_database.dart` — rode o build_runner depois de alterá-lo.

### Lançar uma versão

```bash
# 1) bump em pubspec.yaml: version: 2.0.4+5
# 2) git commit e tag
git tag v2.0.4
git push origin --tags
```

O workflow `.github/workflows/release.yml` constrói:
- **Windows**: `.zip` portable + `.exe` (Inno Setup)
- **Linux**: `.AppImage` + `.deb`
- **macOS**: `.zip` do `.app`

… e publica tudo em uma GitHub Release. O Pulse rodando nos usuários Win/Mac detecta a nova tag via appcast e mostra popup nativo de atualização.
