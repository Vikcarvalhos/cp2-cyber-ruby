# PetShopFácil — Testes de Segurança Automatizados

> **FIAP — Engenharia de Software | Cibersegurança DevSecOps**
> **Checkpoint 2 — OWASP ZAP CLI no GitHub Actions**
> **Stack:** Ruby 3.3 + Sinatra

---

## Sobre

**PetShopFácil** é uma aplicação web de e-commerce de produtos para pets,
desenvolvida em **Ruby com Sinatra** (framework minimalista para web).
Contém **vulnerabilidades propositais** para demonstrar testes de segurança
automatizados com **OWASP ZAP CLI** integrado ao pipeline de **GitHub Actions**.

## Tarefas Atendidas

| # | Tarefa | Status |
|---|--------|--------|
| 1 | OWASP ZAP CLI no GitHub Actions — relatório HTML | ✅ |
| 2 | Pipeline falha em vulnerabilidades High/Critical | ✅ |
| 3 | Análise de alertas: total, severidade, tipos | ✅ |
| 4 | Vulnerabilidade proposital (XSS no login) | ✅ |
| 5 | Relatório salvo como artefato do GitHub Actions | ✅ |

## Vulnerabilidades Inseridas

1. **XSS Refletido** no login e busca (input do usuário sem sanitização)
2. **Credencial hardcoded** `admin/admin123`
3. **Sem proteção CSRF** nos formulários
4. **Sem headers de segurança** (CSP, X-Frame-Options, etc.) — detectado pelo ZAP

## Como Rodar Localmente

```bash
# Instalar Ruby 3.3+ (se ainda não tiver)
# macOS: brew install ruby
# Ubuntu: sudo apt install ruby-full

# Instalar dependências
bundle install

# Rodar a aplicação
bundle exec ruby app.rb

# Acessar
# http://localhost:8080
```

## Rodar ZAP Localmente (com Docker)

```bash
mkdir -p zap-reports
docker run --rm --network host \
  -v $(pwd)/zap-reports:/zap/wrk/:rw \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py -t http://localhost:8080 \
    -r zap-report.html -J zap-report.json

# Abrir: zap-reports/zap-report.html
```

## Resultado Esperado no Pipeline

```
TOTAL DE ALERTAS: ~10

POR SEVERIDADE:
   High:          2
   Medium:        4
   Low:           3
   Informational: 1

 TIPOS MAIS COMUNS:
  • Cross Site Scripting (Reflected)
  • Content Security Policy (CSP) Header Not Set
  • Missing Anti-clickjacking Header
  • Absence of Anti-CSRF Tokens

 FALHA: 2 vulnerabilidade(s) ALTA detectada(s)!
```

##  Onde Ver os Resultados

1. Repo no GitHub → aba **Actions**
2. Click no último workflow run
3. Role até **Artifacts** → baixe `zap-security-report`
4. Abra `zap-report.html` no browser

---

*Projeto educacional — FIAP 2026*
