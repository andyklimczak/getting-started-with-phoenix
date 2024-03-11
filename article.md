# Elixir Pheonix Getting Started

## 3 Creating a new Phoenix Project


### 3.1 Installing Phoenix 

[Official Phoenix Install Guide](https://hexdocs.pm/phoenix/installation.html)

Prerequisites:
- elixir
- postgres

#### 3.1.1 Installing Ruby

```shell
$ elixir -v
Erlang/OTP 26 [erts-14.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [dtrace]

Elixir 1.16.1 (compiled with Erlang/OTP 26)
```

#### 3.1.2 Installing Postgres

```shell
$ postgres --version
```

#### 3.1.3 Installing Phoenix

```shell
$ mix archive.install hex phx_new
```

### 3.2 Creating the Blog Application

```shell
$ mix phx.new blog
```

```shell
$ cd blog
```

## 4 Hello Phoenix

### 4.1 Starting Up the Web Server

Need to create db and migrate before running the server
```shell
$ mix ecto.create
$ mix ecto.migrate
```

Start server with
```shell
$ mix phx.server
```

navigate to [http://localhost:4000](http://localhost:4000)

### 4.2 Say "Hello", Phoenix

```elixir
# router.ex

scope "/", BlogWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/articles", ArticleController, :index
end
```

Create `lib/blog_web/controllers/article_controller.ex`
```elixir
defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
```

Create `lib/blog_web/controllers/article_html.ex`
```elixir
defmodule BlogWeb.ArticleHTML do
  use BlogWeb, :html

  embed_templates "article_html/*"
end
```

Create `lib/blog_web/controllers/article_html/index.html`
```html
<h1>Hello Phoenix</h1>
```

Visit [http://localhost:4000/articles](http://localhost:4000)

### 4.3 Setting the Application to Home Page

```elixir
# router.ex

get "/", ArticleController, :index
get "/articles", ArticleController, :index
```

## 5 Autoloading

## 6 MVC and You
