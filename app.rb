# app.rb — PetShopFácil (Ruby + Sinatra)
# PetShopFácil — E-commerce para produtos de pet. Contém vulnerabilidades propositais.

require 'sinatra'

set :bind, '0.0.0.0'
set :port, 8080

PAGE = lambda do |content|
  <<~HTML
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
      <meta charset="UTF-8">
      <title>PetShopFácil</title>
      <style>
        body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
        h1 { color: #d35400; }
        input, button { padding: 10px; margin: 5px; width: 90%; }
        button { background: #d35400; color: #fff; border: none; cursor: pointer; }
        nav a { margin-right: 15px; color: #d35400; }
        .err { color: red; }
      </style>
    </head>
    <body>
      <h1>🐶 PetShopFácil</h1>
      <nav>
        <a href="/">Home</a>
        <a href="/login">Login</a>
        <a href="/buscar">Buscar Produtos</a>
      </nav>
      #{content}
    </body>
    </html>
  HTML
end

get '/' do
  PAGE.call(<<~HTML)
    <p>E-commerce de produtos para pets — ração, brinquedos, acessórios.</p>
    <h3>Produtos em destaque:</h3>
    <ul>
      <li>🦴 Ração Premium 15kg</li>
      <li>🎾 Bolinha Interativa</li>
      <li>🛏️ Caminha Confort</li>
    </ul>
  HTML
end

# ❌ VULNERABILIDADE PROPOSITAL: XSS Refletido + credencial hardcoded
get '/login' do
  PAGE.call(<<~HTML)
    <h2>🔒 Login</h2>
    <form method="POST" action="/login">
      <input name="usuario" placeholder="Usuário"><br>
      <input name="senha" type="password" placeholder="Senha"><br>
      <button type="submit">Entrar</button>
    </form>
  HTML
end

post '/login' do
  usuario = params['usuario'] || ''
  senha = params['senha'] || ''

  # ❌ VULNERABILIDADE: credencial hardcoded
  if usuario == 'admin' && senha == 'admin123'
    redirect '/'
  else
    # ❌ VULNERABILIDADE: input refletido sem sanitização (XSS)
    PAGE.call(<<~HTML)
      <h2>🔒 Login</h2>
      <p class="err">Usuário '#{usuario}' inválido!</p>
      <form method="POST" action="/login">
        <input name="usuario" placeholder="Usuário"><br>
        <input name="senha" type="password" placeholder="Senha"><br>
        <button type="submit">Entrar</button>
      </form>
    HTML
  end
end

# ❌ VULNERABILIDADE PROPOSITAL: XSS Refletido na busca
get '/buscar' do
  query = params['q'] || ''
  # XSS: query exibida sem escape
  PAGE.call(<<~HTML)
    <h2>🔍 Buscar Produtos</h2>
    <form method="GET" action="/buscar">
      <input name="q" value="#{query}" placeholder="Ex: ração">
      <button type="submit">Buscar</button>
    </form>
    #{query.empty? ? '' : "<p>Você buscou: <strong>#{query}</strong></p><p>Nenhum produto encontrado.</p>"}
  HTML
end

# ❌ VULNERABILIDADE: sem headers de segurança (CSP, X-Frame-Options, etc.)
# O OWASP ZAP detecta automaticamente
