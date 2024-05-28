# Elixir Pheonix Getting Started

## 3 Creating a new Phoenix Project


### 3.1 Installing Phoenix 

[Official Phoenix Install Guide](https://hexdocs.pm/phoenix/installation.html)

Prerequisites:
- elixir
- SQLite3

#### 3.1.1 Installing Ruby

```shell
$ elixir -v
Erlang/OTP 26 [erts-14.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [dtrace]

Elixir 1.16.1 (compiled with Erlang/OTP 26)
```

#### 3.1.2 Installing SQLite3

```shell
$ sqlite3 --version
```

#### 3.1.3 Installing Phoenix

```shell
$ mix archive.install hex phx_new
```

### 3.2 Creating the Blog Application

```shell
$ mix phx.new blog --database sqlite3
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

We've covered the "CR" of CRUD. Now let's move on to the "U" (Update). Updating a resource is very similar to creating a resource. They are both multi-step processes. First, the user requests a form to edit the data. Then, the user submits the form. If there are no errors, then the resource is updated. Else, the form is redisplayed with error messages, and the process is repeated.

These steps are conventionally handled by a controller's edit and update actions. Let's add a typical implementation of these actions to `lib/blog_web/article_controller.ex`, below the create action::

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

  def edit(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    changeset = MyBlog.change_article(article)
    render(conn, :edit, article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = MyBlog.get_article!(id)

    case MyBlog.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: ~p"/articles/#{article}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, article: article, changeset: changeset)
    end
  end
end
```

Notice how the edit and update actions resemble the new and create actions.
The edit action fetches the article from the database, and passes it to the view  so that it can be used when building the form.
The edit action fetches the article from the database, creates a changeset using that article, and passes the article and the changeset to the view.
By using the argument `:edit` in the `render` function, the edit action will render `lib/blog_web/controllers/article_html/edit.html.heex`.


The update action (re-)fetches the article from the database, and attempts to update it with the submitted form data filtered by article_params. If no validations fail and the update is successful, the action redirects the browser to the article's page. Else, the action redisplays the form — with error messages — by rendering `lib/blog_web/controllers/article_html/edit.html.heex`.


The `edit` method uses the methods `MyBlog.get_article!` and `MyBlog.change_article` we already have in the `MyBlog` context.
But the `update` action uses a method we still need to add: `MyBlog.update_article`. Add `update_article` to the `MyBlog` context.

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

  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end
end
```

### 7.4.1 Using Partials to Share View Code

Our `edit` form will look the same as our `new` form.

Because the code will be the same, we're going to factor it out into a shared view called a partial. Let's create `lib/blog_web/controllers/article_html/article_form.html.heex` with the following contents:

```html
<.simple_form :let={f} for={@changeset} action={@action}>
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

The above code is the same as our form in `lib/blog_web/controllers/article_html/new.html.heex`, except that `action` now uses `@action`.


Let's update `lib/blog_web/controllers/article_html/new.html.heex` to use the partial:

```html
<.header>
    New Article
</.header>

<.article_form changeset={@changeset} action={~p"/articles"} />
```


And now, let's create a very similar app/views/articles/edit.html.erb:

```html
<.header>
    Edit Article
</.header>

<.article_form changeset={@changeset} action={~p"/articles/#{@article}"} />
```

### 7.4.2 Finishing Up

We can now update an article by visiting its edit page, e.g. http://localhost:4000/articles/1/edit. To finish up, let's link to the edit page from the bottom of `lib/blog_web/controllers/article_html/show.html.heex`:

```html
<h1 class="text-lg text-brand">
    <%= @article.title %>
</h1>

<p><%= @article.body %></p>

<ul>
    <li>
        <.link navigate={~p"/articles/#{@article}/edit"}>Edit</.link>
    </li>
</ul>
```

## 7.5 Deleting an Article

Finally, we arrive at the "D" (Delete) of CRUD.
Deleting a resource is a simpler process than creating or updating.
It only requires a route and a controller action.
And our resourceful routing (resources :articles) already provides the route, which maps DELETE /articles/:id requests to the destroy action of `ArticlesController`.

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

  def edit(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    changeset = MyBlog.change_article(article)
    render(conn, :edit, article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = MyBlog.get_article!(id)

    case MyBlog.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: ~p"/articles/#{article}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, article: article, changeset: changeset)
    end
  end
  
  def delete(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    {:ok, _article} = MyBlog.delete_article(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: ~p"/articles")
  end
end
```

The newly added `delete` method in the controller uses a new method in the `MyBlog` context: `MyBlog.delete_article`. Let's add that now:

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

  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end
end
```

The destroy action fetches the article from the database, and calls destroy on it. Then, it redirects the browser to the root path with status code 303 See Other.

We have chosen to redirect to the root path because that is our main access point for articles. But, in other circumstances, you might choose to redirect to e.g. `|> redirect(to: ~p"/articles")`.

Now let's add a link at the bottom of `lib/blog_web/controllers/article_html/show.html.heex` so that we can delete an article from its own page:
```html
<h1 class="text-lg text-brand">
    <%= @article.title %>
</h1>

<p><%= @article.body %></p>

<ul>
    <li>
        <.link navigate={~p"/articles/#{@article}/edit"}>Edit</.link>
    </li>
    <li>
        <.link href={~p"/articles/#{@article}"} method="delete" data-confirm="Are you sure?">
          Delete
        </.link>
    </li>
</ul>
```

And that's it! We can now list, show, create, update, and delete articles! InCRUDable!

## 8 Adding a Second Model

It's time to add a second model to the application. The second model will handle comments on articles.

### 8.1 Generating a Model

We're going to see the same generator that we used before when creating the Article model. This time we'll create a Comment model to hold a reference to an article. Run this command in your terminal:

```shell
$ mix phx.gen.context MyBlog Comment comments commenter:string body:text article_id:references:articles
```

It will ask you if you want to add functions to the existing context:
```shell
You are generating into an existing context.

The Blog.MyBlog context currently has 6 functions and 1 file in its directory.

  * It's OK to have multiple resources in the same context as long as they are closely related. But if a context grows too large, consider breaking it apart

  * If they are not closely related, another context probably works better

The fact two entities are related in the database does not mean they belong to the same context.

If you are not sure, prefer creating a new context over adding to the existing one.

Would you like to proceed? [Yn] 
```

We want to put the new `Comments` model in the same context as the existing `Article` model. Press enter.

It will create new files and add to existing files:
```shell
* creating lib/blog/my_blog/comment.ex
* creating priv/repo/migrations/20240423232742_create_comments.exs
* injecting lib/blog/my_blog.ex
* creating test/blog/my_blog_test.exs
* injecting test/blog/my_blog_test.exs
* creating test/support/fixtures/my_blog_fixtures.ex
* injecting test/support/fixtures/my_blog_fixtures.ex

Remember to update your repository by running migrations:

    $ mix ecto.migrate
```

> :warning: See what files are generated for each of the `mix phx.gen` commands [in the docs here](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.html).

First, take a look at the `Comment` model, located at `lib/blog/my_blog/comment.ex`:

```elixir
defmodule Blog.MyBlog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :commenter, :string
    field :article_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:commenter, :body])
    |> validate_required([:commenter, :body])
  end
end
```

In addition to the model, Pheonix has also made a migration to create the corresponding database table:
```elixir
defmodule Blog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :commenter, :string
      add :body, :text
      add :article_id, references(:articles, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:article_id])
  end
end
```

The `article_id` field is used to reference the `id` field on the `articles` table.

Let's make one small change to the `on_delete` option for the `article_id` field to keep data consistent.

```elixir
defmodule Blog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :commenter, :string
      add :body, :text
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:article_id])
  end
end
```

This will help keep out database clean, so when an article gets deleted, the associated comments for that article also gets deleted.
The `delete_all` option will prevent comments from existing in the database without an article existing.

Go ahead and run the migration:
```shell
mix ecto.migrate
```

Phoenix is smart enough to only execute the migrations that have not already been run against the current database, so in this case you will just see:

```shell
Generated blog app

19:41:18.734 [info] == Running 20240329022229 Blog.Repo.Migrations.CreateArticles.change/0 forward

19:41:18.738 [info] create table articles

19:41:18.738 [info] == Migrated 20240329022229 in 0.0s

19:41:18.747 [info] == Running 20240423232324 Blog.Repo.Migrations.CreateComments.change/0 forward

19:41:18.747 [info] create table comments

19:41:18.747 [info] create index comments_article_id_index

19:41:18.747 [info] == Migrated 20240423232324 in 0.0s
```


## 8.2 Associating Models

Ecto associations let you easily declare the relationship between two models.
In the case of comments and articles, you could write out the relationships this way:

- Each comment belongs to one article.
- One article can have many comments.

In fact, this is very close to the syntax that Ecto uses to declare this association.
Let's modify the `Comment` model to make each comment belong_to an `Article`:

Update the `Comment` model located at `lib/blog/my_blog/comment.ex` with this:
```elixir
defmodule Blog.MyBlog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blog.MyBlog.Article

  schema "comments" do
    field :body, :string
    field :commenter, :string
    belongs_to :article, Article

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:commenter, :body, :article_id])
    |> validate_required([:commenter, :body])
    |> assoc_constraint(:article)
  end
end
```

You'll need to edit `lib/blog/my_blog/article.ex` to add the other side of the association:
```elixir
defmodule Blog.MyBlog.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blog.MyBlog.Comment

  schema "articles" do
    field :title, :string
    field :body, :string
    has_many :comments, Comment

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

> :warning: For more information on Ecto associations, see the [Ecto Assocations](https://hexdocs.pm/ecto/2.2.11/associations.html#one-to-many) guide.

Let's test the relationship in `iex`:
```shell
$ iex -S mix
[info] Migrations already up
Interactive Elixir (1.14.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> 

```
First create a new article:
```shell
iex(1)> alias Blog.MyBlog.Article
Blog.MyBlog.Article
iex(2)> article = %Article{title: "My test article", body: "Has many comments"}
%Blog.MyBlog.Article{
  __meta__: #Ecto.Schema.Metadata<:built, "articles">,
  id: nil,
  body: "Has many comments",
  title: "My test article",
  inserted_at: nil,
  updated_at: nil
}
iex(3)> alias Blog.Repo
Blog.Repo
iex(4)> article = Repo.insert!(article)
[debug] QUERY OK source="articles" db=9.6ms idle=1008.4ms
INSERT INTO "articles" ("body","title","inserted_at","updated_at") VALUES (?,?,?,?) RETURNING "id" ["Has many comments", "My test article", ~U[2024-04-23 23:53:05Z], ~U[2024-04-23 23:53:05Z]]
↳ anonymous fn/4 in :elixir.eval_external_handler/1, at: src/elixir.erl:309
%Blog.MyBlog.Article{
  __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
  id: 4,
  title: "My test article",
  body: "Has many comments",
  comments: #Ecto.Association.NotLoaded<association :comments is not loaded>,
  inserted_at: ~U[2024-04-24 00:09:21Z],
  updated_at: ~U[2024-04-24 00:09:21Z]
}
```

Then let's create a comment for the article we just created:
```shell
iex(11)> comment = Ecto.build_assoc(article, :comments, %{commenter: "First commenter", body: "Sweet article"})
%Blog.MyBlog.Comment{
  __meta__: #Ecto.Schema.Metadata<:built, "comments">,
  id: nil,
  body: "Sweet article",
  commenter: "First commenter",
  article_id: 5,
  article: #Ecto.Association.NotLoaded<association :article is not loaded>,
  inserted_at: nil,
  updated_at: nil
}
iex(12)> Repo.insert!(comment)
[debug] QUERY OK source="comments" db=0.4ms idle=1273.9ms
INSERT INTO "comments" ("article_id","body","commenter","inserted_at","updated_at") VALUES (?,?,?,?,?) RETURNING "id" [5, "Sweet article", "First commenter", ~U[2024-04-24 00:12:35Z], ~U[2024-04-24 00:12:35Z]]
↳ anonymous fn/4 in :elixir.eval_external_handler/1, at: src/elixir.erl:309
%Blog.MyBlog.Comment{
  __meta__: #Ecto.Schema.Metadata<:loaded, "comments">,
  id: 1,
  body: "Sweet article",
  commenter: "First commenter",
  article_id: 5,
  article: #Ecto.Association.NotLoaded<association :article is not loaded>,
  inserted_at: ~U[2024-04-24 00:12:35Z],
  updated_at: ~U[2024-04-24 00:12:35Z]
}
```

Let's see if it worked:
```shell
iex(14)> Repo.get(Article, article.id) |> Repo.preload(:comments)
[debug] QUERY OK source="articles" db=0.0ms queue=0.2ms idle=1774.5ms
SELECT a0."id", a0."title", a0."body", a0."inserted_at", a0."updated_at" FROM "articles" AS a0 WHERE (a0."id" = ?) [5]
↳ anonymous fn/4 in :elixir.eval_external_handler/1, at: src/elixir.erl:309
[debug] QUERY OK source="comments" db=0.0ms queue=0.1ms idle=1781.4ms
SELECT c0."id", c0."body", c0."commenter", c0."article_id", c0."inserted_at", c0."updated_at", c0."article_id" FROM "comments" AS c0 WHERE (c0."article_id" = ?) ORDER BY c0."article_id" [5]
↳ anonymous fn/4 in :elixir.eval_external_handler/1, at: src/elixir.erl:309
%Blog.MyBlog.Article{
  __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
  id: 5,
  title: "My test article",
  body: "Has many comments",
  comments: [
    %Blog.MyBlog.Comment{
      __meta__: #Ecto.Schema.Metadata<:loaded, "comments">,
      id: 1,
      body: "Sweet article",
      commenter: "First commenter",
      article_id: 5,
      article: #Ecto.Association.NotLoaded<association :article is not loaded>,
      inserted_at: ~U[2024-04-24 00:12:35Z],
      updated_at: ~U[2024-04-24 00:12:35Z]
    }
  ],
  inserted_at: ~U[2024-04-24 00:12:10Z],
  updated_at: ~U[2024-04-24 00:12:10Z]
}
```

In the example above, Ecto.build_assoc received an existing article struct, that was already persisted to the database, and built a Comment struct, based on its :comments association, with the article_id foreign key field properly set to the ID in the article struct.

## 8.3 Adding a Route for Comments

As with the articles controller, we will need to add a route so that Phoenix knows where we would like to navigate to see comments.
Open up the `lib/blog/router.ex` file again, and edit it as follows:
```elixir
  scope "/", BlogWeb do
    pipe_through :browser

    get "/", ArticleController, :index
    resources "/articles", ArticleController do
        resources "/comments", CommentController
    end
  end
```

This creates comments as a nested resource within articles. This is another part of capturing the hierarchical relationship that exists between articles and comments.

## 8.4 Generating a Controller

With the model in hand, you can turn your attention to creating a matching controller.
Again, we'll create it by hand by creating a new, empty file at `lib/blog_web/controllers/comment_controller.ex`.

Let's first wire up the Article show template (`lib/blog_web/controllers/article_html/show.html.heex`) to let us create a new comment:
```html
<h1 class="text-lg text-brand">
    <%= @article.title %>
</h1>

<p><%= @article.body %></p>

<ul>
    <li>
        <.link navigate={~p"/articles/#{@article}/edit"}>Edit</.link>
    </li>
    <li>
        <.link href={~p"/articles/#{@article}"} method="delete" data-confirm="Are you sure?">
          Delete
        </.link>
    </li>
</ul>

<p>
<.simple_form :let={f} for={@comment_changeset} action={~p"/articles/#{@article}/comments"}>
  <.error :if={@comment_changeset.action}>
    Oops, something went wrong! Please check the errors below.
  </.error>
  <.input field={f[:commenter]} type="text" label="Commenter" />
  <.input field={f[:body]} type="text" label="Body" />
  <:actions>
    <.button>Create Comment</.button>
  </:actions>
</.simple_form>
</p>
```

This adds a form on the `Article` show page that creates a new comment by calling the `CommentsController` create action. 

Let's wire up the `create` in `lib/blog/blog_web/controllers/comment_controller.ex`:
```elixir
defmodule BlogWeb.CommentController do
  use BlogWeb, :controller

  alias Blog.MyBlog
  alias Blog.MyBlog.Comment

  def create(conn, %{"comment" => comment_params, "article_id" => article_id} = params) do

    case MyBlog.create_comment(Map.merge(comment_params, %{"article_id" => article_id})) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/articles/#{comment.article_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
```

You'll see a bit more complexity here than you did in the controller for articles.
That's a side-effect of the nesting that you've set up.
Each request for a comment has to keep track of the article to which the comment is attached, thus the `article_id` must be merged to the `comment_params` map to make the association betwen the comment and the article.

Once we have made the new comment, we send the user back to the original article using the `redirect(to: ~p"/articles/#{comment.article_id}")` helper.
As we have already seen, this calls the show action of the `ArticlesController` which in turn renders the show.html.heex template.
This is where we want the comment to show, so let's add that to the `lib/blog_web/controllers/article_html/show.html.heex`:

```html
<h1 class="text-lg text-brand">
    <%= @article.title %>
</h1>

<p><%= @article.body %></p>

<ul class="py-2">
    <li>
        <.link navigate={~p"/articles/#{@article}/edit"}>Edit</.link>
    </li>
    <li>
        <.link href={~p"/articles/#{@article}"} method="delete" data-confirm="Are you sure?">
          Delete
        </.link>
    </li>
</ul>

<h2 class="text-md text-brand">
    Comments
</h2>
<%= for comment <- @article.comments do %>
<div class="py-2">
    <p>
        <strong>Commenter:</strong>
        <%= comment.commenter %>
    </p>
    <p>
        <strong>Comment:</strong>
        <%= comment.body %>
    </p>
</div>
<% end %>

<p>
<.simple_form :let={f} for={@comment_changeset} action={~p"/articles/#{@article}/comments"}>
  <.error :if={@comment_changeset.action}>
    Oops, something went wrong! Please check the errors below.
  </.error>
  <.input field={f[:commenter]} type="text" label="Commenter" />
  <.input field={f[:body]} type="text" label="Body" />
  <:actions>
    <.button>Create Comment</.button>
  </:actions>
</.simple_form>
</p>
```

Lastly to do is to `preload` the `comments` for the `@article`.
Unlike other ORMs, Ecto does not allow lazy loading, meaning that all requests to the database must be explicit.
Add `Repo.preload(:comments)` to the `get_article!` method in the `MyBlog` context in `lib/blog/my_blog/my_blog.ex`:
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
    |> Repo.preload(:comments)
  end

  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  alias Blog.MyBlog.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
```

Now try creating a new comment.
You should be redirected back to the article show page, and see the newly created comment.
