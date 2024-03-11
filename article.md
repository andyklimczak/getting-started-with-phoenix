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
<h1 class="text-lg text-brand">
    Hello Phoenix
</h1>
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

### 6.1 Generating a model

```shell
$ mix phx.gen.schema MyBlog.Article articles title:string body:text
* creating lib/blog/my_blog/article.ex
* creating priv/repo/migrations/20240311211707_create_articles.exs

Remember to update your repository by running migrations:

    $ mix ecto.migrate
```

### 6.2 Database Migrations

```elixir
defmodule Blog.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :body, :text

      timestamps(type: :utc_datetime)
    end
  end
end
```

Let's run our migration with the following command:
```shell
$ mix ecto.migrate
```

The command will display output indicating that the table was created:
```shell
Compiling 2 files (.ex)
Generated blog app

17:19:38.008 [info] == Running 20240311211707 Blog.Repo.Migrations.CreateArticles.change/0 forward

17:19:38.010 [info] create table articles

17:19:38.102 [info] == Migrated 20240311211707 in 0.0s
```

### 6.3 Using the Model to Interact with the Database

Let's launch the console with this command:
```shell
$ iex -S mix
```

You should see an iex prompt like:

```shell
Erlang/OTP 26 [erts-14.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [dtrace]

Interactive Elixir (1.16.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

At this prompt, we can initialize a new Article object:
```shell
iex(1)> alias Blog.MyBlog.Article
Blog.MyBlog.Article
iex(2)> alias Blog.Repo
Blog.Repo
iex(3)> article = Repo.insert(%Article{title: "Hello Phoenix", body: "I am on Phoenix!"})
[debug] QUERY OK source="articles" db=1.6ms idle=1638.2ms
INSERT INTO "articles" ("title","body","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Hello Phoenix", "I am on Phoenix!", ~U[2024-03-11 21:34:35Z], ~U[2024-03-11 21:34:35Z]]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:405
{:ok,
 %Blog.MyBlog.Article{
   __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
   id: 1,
   title: "Hello Phoenix",
   body: "I am on Phoenix!",
   inserted_at: ~U[2024-03-11 21:34:35Z],
   updated_at: ~U[2024-03-11 21:34:35Z]
 }}
```

The above output shows an INSERT INTO "articles" ... database query. This indicates that the article has been inserted into our table. And if we take a look at the article object again, we see something interesting has happened:
```shell
iex(4)> article
{:ok,
 %Blog.MyBlog.Article{
   __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
   id: 1,
   title: "Hello Phoenix",
   body: "I am on Phoenix!",
   inserted_at: ~U[2024-03-11 21:34:35Z],
   updated_at: ~U[2024-03-11 21:34:35Z]
 }}
```
The id, created_at, and updated_at attributes of the object are now set. Phoenix did this for us when we saved the object.

When we want to fetch this article from the database, we can call find on the model and pass the id as an argument:
```shell
iex(5)> Repo.get!(Article, 1)
[debug] QUERY OK source="articles" db=1.3ms queue=1.3ms idle=533.9ms
SELECT a0."id", a0."title", a0."body", a0."inserted_at", a0."updated_at" FROM "articles" AS a0 WHERE (a0."id" = $1) [1]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:405
%Blog.MyBlog.Article{
  __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
  id: 1,
  title: "Hello Phoenix",
  body: "I am on Phoenix!",
  inserted_at: ~U[2024-03-11 21:34:35Z],
  updated_at: ~U[2024-03-11 21:34:35Z]
}
```

And when we want to fetch all articles from the database, we can call all using the repo:
```shell
iex(7)> Repo.all(Article)
[debug] QUERY OK source="articles" db=2.0ms queue=2.6ms idle=1101.3ms
SELECT a0."id", a0."title", a0."body", a0."inserted_at", a0."updated_at" FROM "articles" AS a0 []
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:405
[
    %Blog.MyBlog.Article{
        __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
        id: 1,
        title: "Hello Phoenix",
        body: "I am on Phoenix!",
        inserted_at: ~U[2024-03-11 21:34:35Z],
        updated_at: ~U[2024-03-11 21:34:35Z]
    }
]
```

Exit the shell by doing `Ctrl-C` twice.

### Showing a List of Articles

Update controller:
```elixir
# lib/blog_web/article_controller.ex

defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller
  
  alias Blog.Repo
  alias Blog.MyBlog.Article

  def index(conn, _params) do
    articles = Repo.all(Article)
    render(conn, :index, articles: articles)
  end
end
```

Update HTML:
```html
<h1 class="text-lg text-brand">
    Hello Phoenix
</h1>

<ul>
    <%= for article <- @articles do %>
    <li>
        <%= article.title %>
    </li>
    <% end %>
</ul>
```
## 7 CRUDit Where CRUDit Is Due 

### 7.1 Showing a Single Article
