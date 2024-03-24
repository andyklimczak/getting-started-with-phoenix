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

Create context `lib/blog/myblog.ex`:
```elixir
defmodule Blog.MyBlog do
  import Ecto.Query, warn: false

  alias Blog.Repo
  alias Blog.MyBlog.Article

  def list_articles() do
    Repo.all(Article)
  end
end
```

Update controller:
```elixir
# lib/blog_web/article_controller.ex

defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  alias Blog.MyBlog

  def index(conn, _params) do
    articles = MyBlog.list_articles()
    render(conn, :index, articles: articles)
  end
end
```

Update HTML:
```html
<h1 class="text-lg text-brand">
    Hello Phoenix
</h1>

<ul class="pt-5">
    <%= for article <- @articles do %>
    <li>
        <%= article.title %>
    </li>
    <% end %>
</ul>
```
## 7 CRUDit Where CRUDit Is Due 

### 7.1 Showing a Single Article

```elixir
# router.ex
get "/", ArticleController, :index
get "/articles", ArticleController, :index
get "/articles/:id", ArticleController, :show
```

Update context `lib/blog/my_blog.ex`:
```elixir
defmodule Blog.MyBlog do
  import Ecto.Query

  alias Blog.Repo
  alias Blog.MyBlog.Article

  def list_articles() do
    Repo.all(Article)
  end

  def get_article!(id) do
    Repo.get!(Article, id)
  end
end
```

Update controller `lib/blog_web/controllers/article_controller.ex`:
```elixir
defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  alias Blog.MyBlog

  def index(conn, _params) do
    articles = MyBlog.list_articles()
    render(conn, :index, articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    render(conn, :show, article: article)
  end
end
```

Update view `lib/blog_web/controllers/article_html/show.html.heex`:
```html
<h1>
    <%= @article.title %>
</h1>

<p><%= @article.body %></p>
```

Now we can see the article when we visit http://localhost:4000/articles/1!

To finish up, let's add a convenient way to get to an article's page. We'll link each article's title in app/views/articles/index.html.erb to its page:
```html
<h1 class="text-lg text-brand">
    Hello Phoenix
</h1>

<ul class="pt-5">
    <%= for article <- @articles do %>
        <li>
            <a href={~p"/articles/#{article}"}>
                <%= article.title %>
            </a>
        </li>
    <% end %>
</ul>
```

## 7.2 Resource Routing

So far, we've covered the "R" (Read) of CRUD. We will eventually cover the "C" (Create), "U" (Update), and "D" (Delete). As you might have guessed, we will do so by adding new routes, controller actions, and views. Whenever we have such a combination of routes, controller actions, and views that work together to perform CRUD operations on an entity, we call that entity a resource. For example, in our application, we would say an article is a resource.

Pheonix provides a routes method named resources that maps all of the conventional routes for a collection of resources, such as articles. So before we proceed to the "C", "U", and "D" sections, let's replace the two get routes in `lib/blog_web/router.ex` with resources:

```elixir
  scope "/", BlogWeb do
    pipe_through :browser

    get "/", ArticleController, :index
    resources "/articles", ArticleController
  end
```

We can inspect what routes are mapped by running the `mix phx.routes` routes command:

```shell
  ...
  GET     /                                      BlogWeb.ArticleController :index
  GET     /articles                              BlogWeb.ArticleController :index
  GET     /articles/:id/edit                     BlogWeb.ArticleController :edit
  GET     /articles/new                          BlogWeb.ArticleController :new
  GET     /articles/:id                          BlogWeb.ArticleController :show
  POST    /articles                              BlogWeb.ArticleController :create
  PATCH   /articles/:id                          BlogWeb.ArticleController :update
  PUT     /articles/:id                          BlogWeb.ArticleController :update
  DELETE  /articles/:id                          BlogWeb.ArticleController :delete
  ...
```

Nice!

## 7.3 Creating a New Article

Now we move on to the "C" (Create) of CRUD. Typically, in web applications, creating a new resource is a multi-step process. First, the user requests a form to fill out. Then, the user submits the form. If there are no errors, then the resource is created and some kind of confirmation is displayed. Else, the form is redisplayed with error messages, and the process is repeated.

In a Phoenix application, these steps are conventionally handled by a controller's new and create actions. 

First let's add two new functions `change_article` and `create_article` to the context `lib/blog/my_blog.ex`:
```elixir
defmodule Blog.MyBlog do
  import Ecto.Query, warn: false

  alias Blog.Repo
  alias Blog.MyBlog.Article

  def list_articles() do
    Repo.all(Article)
  end

  def get_article!(id) do
    Repo.get!(Article, id)
  end

  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end
end
```

Then let's add a typical implementation of the `new` and `create` actions to `lib/blog_web/article_controller.ex` using the methods just added to the context, below the show action:
```elixir
defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  alias Blog.MyBlog
  alias Blog.MyBlog.Article

  def index(conn, _params) do
    articles = MyBlog.list_articles()
    render(conn, :index, articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    render(conn, :show, article: article)
  end

  def new(conn, _params) do
    changeset = MyBlog.change_article(%Article{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, _params) do
    case MyBlog.create_article(%{title: "...", body: "..."}) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: ~p"/articles/#{article}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
```

The `new` create a changeset for an article, but does not save it.
By default, the new action will render `lib/blog_web/controllers/article_web/new.html.heex`, which we will create next.

The `create` action instantiates a new article with values for the title and body, and attempts to save it.
If the article is saved successfully, the action redirects the browser to the article's page at "http://localhost:4000/articles/#{article.id}".
Else, the action redisplays the form by rendering `lib/blog_web/article_html/new.html.heex` with status code 422 Unprocessable Entity.
The title and body here are dummy values. After we create the form, we will come back and change these.

### 7.3.1 Using a Form Builder

We will use a feature of Phoenix called a form builder to create our form.
Using a form builder, we can write a minimal amount of code to output a form that is fully configured and follows Phoenix conventions.

Let's create `lib/blog_web/article_html/new.html.heex` with the following contents:
```html
<h1>
    New Article
</h1>

// replace with normal html?
<.simple_form :let={f} for={@changeset} action={~p"/articles"}>
    <.error :if={@changeset.action}>
        Oops, something went wrong! Please check the errors below.
    </.error>
    <.input field={f[:title]} type="text" label="Title" />
    <.input field={f[:body]} type="text" label="Body" />
    <:actions>
        <.button>Save Article</.button>
    </:actions>
</.simple_form>
```

The `simple_form` helper...

The resulting output of our `simple_form` will look like:
```html

<form action="/articles" method="post">
    <input name="_csrf_token" type="hidden" hidden="" value="...">
    <div class="mt-10 space-y-8 bg-white">
        <!-- @caller lib/blog_web/controllers/article_html/new.html.heex:9 () -->
        <!-- <BlogWeb.CoreComponents.input> lib/blog_web/components/core_components.ex:371 (blog) -->
        <div phx-feedback-for="article[title]">
            <!-- @caller lib/blog_web/components/core_components.ex:373 (blog) -->
            <!-- <BlogWeb.CoreComponents.label> lib/blog_web/components/core_components.ex:399 (blog) -->
            <label for="article_title" class="block text-sm font-semibold leading-6 text-zinc-800">
                Title
            </label><!-- </BlogWeb.CoreComponents.label> -->
            <input type="text" name="article[title]" id="article_title"
                   class="mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 border-zinc-300 focus:border-zinc-400">
        </div><!-- </BlogWeb.CoreComponents.input> -->
        <!-- @caller lib/blog_web/controllers/article_html/new.html.heex:10 () -->
        <!-- <BlogWeb.CoreComponents.input> lib/blog_web/components/core_components.ex:371 (blog) -->
        <div phx-feedback-for="article[body]">
            <!-- @caller lib/blog_web/components/core_components.ex:373 (blog) -->
            <!-- <BlogWeb.CoreComponents.label> lib/blog_web/components/core_components.ex:399 (blog) -->
            <label for="article_body" class="block text-sm font-semibold leading-6 text-zinc-800">
                Body
            </label><!-- </BlogWeb.CoreComponents.label> -->
            <input type="text" name="article[body]" id="article_body"
                   class="mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 border-zinc-300 focus:border-zinc-400">
        </div><!-- </BlogWeb.CoreComponents.input> -->
        <div class="mt-2 flex items-center justify-between gap-6">
            <!-- @caller lib/blog_web/controllers/article_html/new.html.heex:12 () -->
            <!-- <BlogWeb.CoreComponents.button> lib/blog_web/components/core_components.ex:230 (blog) -->
            <button class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 ">
                Save Article
            </button><!-- </BlogWeb.CoreComponents.button> -->
        </div>
    </div>
</form>
```

### 7.3.2 Using Parameters

...Explanation

Let's update the create action in the controller `lib/blog_web/article_controller.ex` to use the values in the `params` param:
```elixir
defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  alias Blog.MyBlog
  alias Blog.MyBlog.Article

  def index(conn, _params) do
    articles = MyBlog.list_articles()
    render(conn, :index, articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    render(conn, :show, article: article)
  end

  def new(conn, _params) do
    changeset = MyBlog.change_article(%Article{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case MyBlog.create_article(article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: ~p"/articles/#{article}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
```

Try creating by visiting [http://localhost:4000/articles/new](http://localhost:4000/articles/new) now.
After creating a new article, you should be redirected to that article's show page.

### 7.3.3 Validations and Displaying Error Messages

Try creating a new article without a title or body.
You should see `can't be blank` error messages under the title input and body input.
These validations for the article `title` and `body` field were created for us in the schema that was generated when we ran `mix phx.gen.schema`.
Open `lib/blog/my_blog/article.ex` and notice the usage of `validate_required` in the `changeset` function:
```elixir
defmodule Blog.MyBlog.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :title, :string
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
```

Let's add an additional length check validation to the `body` field in `lib/blog/my_blog/article.ex`:
```elixir
defmodule Blog.MyBlog.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :title, :string
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> validate_length(:body, min: 10)
  end
end
```

Test the new validation by visiting http://localhost:4000/articles/new and try submitting the form with a body with less than 10 characters.

To understand how all of this works together, let's take another look at the new and create controller actions:
```elixir
  def new(conn, _params) do
    changeset = MyBlog.change_article(%Article{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case MyBlog.create_article(article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: ~p"/articles/#{article}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
```

When we visit http://localhost:4000/articles/new, the GET /articles/new request is mapped to the `new` action. The `new` action does not attempt to save `article`. Therefore, validations are not checked, and there will be no error messages.

When we submit the form, the POST /articles request is mapped to the `create` action. The `create` action does attempt to save `article`. Therefore, validations are checked. If any validation fails, `article` will not be saved, and `lib/blog_web/article_html/new.html.heex` will be rendered with error messages.

### 7.3.4 Finishing Up

We can now create an article by visiting http://localhost:4000/articles/new.
To finish up, let's link to that page from the top of `lib/blog_web/article_html/index.html.heex:

```html
<h1 class="text-lg text-brand">
    Hello Phoenix
</h1>
<a href={~p"/articles/new"}>
    New Article
</a>

<ul class="pt-5">
    <%= for article <- @articles do %>
    <li>
        <a href={~p"/articles/#{article}"}>
            <%= article.title %>
        </a>
    </li>
    <% end %>
</ul>
```

## 7.4 Updating an Article
