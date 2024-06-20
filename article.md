# Elixir Phoenix Getting Started

## 1 Guide Assumptions

This guide is designed for beginners who want to get started with creating a Phoenix application from scratch.
It does not assume that you have any prior experience with Phoenix.

Phoenix is a web application framework running on the Elixir programming language.
If you have no prior experience with Elixir, you will find a very steep learning curve diving straight into Phoenix.
There are several curated lists of online resources for learning Phoenix:

- [Elixir Introduction](https://hexdocs.pm/elixir/introduction.html)
- [Community Resources](https://elixir-lang.org/learning.html)

## 2 What is Phoenix?

> Phoenix is a web development framework written in Elixir which implements the server-side Model View Controller (MVC) pattern. Many of its components and concepts will seem familiar to those of us with experience in other web frameworks like Ruby on Rails or Python's Django.
>
> Phoenix provides the best of both worlds - high developer productivity and high application performance. It also has some interesting new twists like channels for implementing realtime features and pre-compiled templates for blazing speed.

[source](https://hexdocs.pm/phoenix/overview.html)


## 3 Creating a new Phoenix Project

The best way to read this guide is to follow it step by step.
All steps are essential to run this example application and no additional code or steps are needed.

By following along with this guide, you'll create a Phoenix project called `blog`, a (very) simple weblog.
Before you can start building the application, you need to make sure that you have Phoenix itself installed.

### 3.1 Installing Phoenix 

[Official Phoenix Install Guide](https://hexdocs.pm/phoenix/installation.html)

Prerequisites:
- elixir
- SQLite3

#### 3.1.1 Installing Ruby

Verify that you have a current version of Elixir installed:
```shell
$ elixir -v
Erlang/OTP 26 [erts-14.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [dtrace]

Elixir 1.16.1 (compiled with Erlang/OTP 26)
```

Phoenix requires a Elixir version 1.14.1/Erlang 24 or later.

For installation methods, check out [the official docs](https://elixir-lang.org/install.html).

#### 3.1.2 Installing SQLite3

You will also need an installation of SQLite3.

Verify that is correctly installed and in your load `PATH`:
```shell
$ sqlite3 --version
```

#### 3.1.3 Installing Phoenix

To install Phoenix, use the `mix` command:

```shell
$ mix archive.install hex phx_new
```

To verify Phoenix was installed correctly, run the command:
```shell
mix phx.new
```

### 3.2 Creating the Blog Application

Phoenix comes with a number of scripts called generators that are designed to make development easier and quicker by creating files with boilerplate code.
One of these is the new applicatoin generator, which will provide you with a foundation of a fresh Phoenix application so that you don't have to write it yourself.

Too  use this generator, open a terminal, navigate to a directory, and run:

```shell
$ mix phx.new blog --database sqlite3
```

This will create a Phoenix application called Blog in a `blog` directory and install all dependencies that are already in the `mix.exs` file using `mix deps.get`.

> :warning: You can see all the command line options the Phoenix application generator accepts by running `mix phx.new`

After you create the blog application, switch to its directory:

```shell
$ cd blog
```

The `blog` directory will have a number of generated files and folder that make up a structure of a Phoenix application.
Most of the work of this tutorial will happen in the `lib` folder, but here's a basic rundown of each of the files and folders that Phoenix creates by default:

| File/Folder | Purpose                                                                                                                                  |
| --- |------------------------------------------------------------------------------------------------------------------------------------------|
| assets/ | Contains your css and javascript assets for your application.                                                                            |
| config/ | General and environment specific configuration for your application.                                                                     |
| lib/ | Contains your contexts, schemas, controllers, views of your application. You'll focus on this directory for the remainder of this guide. |
| priv/ | Contains your I18n translations, database migrations, and static assets.                                                                 |
| test/ | Unit tests, fixtures, and other test files |
| .formatter.exs | Config file for Elixir code formatting. See more [here](https://hexdocs.pm/mix/main/Mix.Tasks.Format.html). |
| .gitignore | Default `.gitignore` file for Phoenix applications to not commit generated files to git repositories. |
| mix.exs | Used to specify the main configuration for the project, application, and dependencies. |
| README.md | Standard README that details how to run a Phoenix application. |

## 4 Hello Phoenix

To begin with, let's get some text on the screen quickly.
TO do this, you'll need your Phoenix application server running.

### 4.1 Starting Up the Web Server

You actually have a functional Phoenix application already.
To see it, you need to start a web server on your development machine.
But first we need to create and migrate the database.
You can do this by running the following commands in the `blog` directory:

```shell
$ mix ecto.create
$ mix ecto.migrate
```

Then start the server with:
```shell
$ mix phx.server
```

To see your application in action, open the browser window and navigate to [http://localhost:4000](http://localhost:4000).
You should see the default Phoenix information page.

To stop the server, hit Ctrl-C in the terminal window.
In the development environment, Phoenix does not generally require you to restart the server; changes you make in files will be automatically picked up by the server.

### 4.2 Say "Hello", Phoenix

To get Phoenix saying "Hello", you need to create at minimum a route, a controller with an action, and a view.
A route maps a request to a controller action.
A controller action performs the necessary work to handle the request, and prepares any data for the view.
A view displays data in a desired format.

Let's start by adding a route to our routes file, `lib/blog_web/router.ex` at the bottom of the `scope "/", BlogWeb do` block:
```elixir
scope "/", BlogWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/articles", ArticleController, :index
end
```

The route above declares that GET /articles requests are mapped to the index action of ArticleController.

Let's create the `ArticleController` at `lib/blog_web/controllers/article_controller.ex` with our `index` action next:
```elixir
defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
```

Next let's create an HTML view, which gets collocated with the controller in `lib/blog_web/controllers/article_html.ex`:
```elixir
defmodule BlogWeb.ArticleHTML do
  use BlogWeb, :html

  embed_templates "article_html/*"
end
```

Then finally create the HTML template in `lib/blog_web/controllers/article_html/index.html.heex`:
```html
<h1 class="text-lg text-brand">
    Hello Phoenix
</h1>
```

Visit [http://localhost:4000/articles](http://localhost:4000) to see Phoenix display "Hello Phoenix"!

### 4.3 Setting the Application to Home Page

At the moment, http://localhost:4000 still displays the default Phoenix page. 
Let's display our "Hello, Phoenix!" text at http://localhost:4000 as well. To do so, we will add a route that maps the root path of our application to the appropriate controller and action.

Let's open `lib/blog_web/router.ex` and add the `get "/"` path to map to the `ArticleController` `index` action:
```elixir
scope "/", BlogWeb do
    pipe_through :browser

    get "/", ArticleController, :index
    get "/articles", ArticleController, :index
end
```

## 5 Autoloading

TODO?

## 6 MVC and You

So far, we've discussed routes, controllers, actions, and views.
All of these are typical pieces of a web application that follows the [MVC (Model-View-Controller)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) pattern. 
MVC is a design pattern that divides the responsibilities of an application to make it easier to reason about. 
Phoenix follows this design pattern by convention.

Since we have a controller and a view to work with, let's generate the next piece: a model.

### 6.1 Generating a model

The _model_ in Phoenix is actually an [Ecto Schema](https://hexdocs.pm/ecto/Ecto.Schema.html).
Schemas behave similarly to models from other frameworks, such as mapping external data into Elixir structs.
But the difference to other frameworks is that schemas area much more solely focused on that mapping of external data.

To generate a schema, we'll use the [schema generator](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Schema.html) to generate an `article` schema which contains `title` and `body` database fields.
```shell
$ mix phx.gen.schema MyBlog.Article articles title:string body:text
* creating lib/blog/my_blog/article.ex
* creating priv/repo/migrations/20240311211707_create_articles.exs

Remember to update your repository by running migrations:

    $ mix ecto.migrate
```

This command will create two new files:
1. Schema file at `lib/blog_my_blog/article.ex` in the `my_blog` context.
2. Migration file at `priv/repo/migrations/<timestamp>_create_articles.exs`.

### 6.2 Database Migrations

Migrations are used to alter the structure of an application's database. 
In Phoenix applications, migrations are written in Elixir so that they can be database-agnostic.

Let's take a look at the contents of our new migration file:
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

The `create table(:articles) do` block specifies how the new `articles` table should be constructed.
By default, the table is automatically created with an auto-incrementing primary key `id` field.

Inside the block for `create table(:articles), two columns are defined: `title` and `body`.
These were added by the generator because we included them in our generate command.

On the last line of the block is `timestamps(type: :utc_datetime)`.
This method defines two additional columns named `inserted_at` and `updated_at`.
Phoenix will manage these for us, setting the values when we create or update a schema.

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

Phoenix has a notion of organizing code into a domain-driven-design (DDD) style structure with the use of Contexts.
Contexts are used as an abstraction layer between schemas and the rest of the application, by encapsulating data access and data validation.

Let's create our `MyBlog` context at `lib/blog/my_blog.ex`:
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

Here we're using `alias` in order to more easily reference different modules.
We've created a `list_articles` function that takes no params, and will return all the articles in the database by using the `Repo`.
We will use this `list_articles` function in the controller, rather than using `Repo` directly.

Let's update the `index` action of the `ArticleController` at `lib/blog_web/article_controller.ex`:
```elixir
defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  alias Blog.MyBlog

  def index(conn, _params) do
    articles = MyBlog.list_articles()
    render(conn, :index, articles: articles)
  end
end
```

We are getting the `articles` in the database by using our `MyBlog` context's `list_articles` function, then assigning the articles in our HTML template the key `articles`.
This will allow us to access the articles by using `@articles` in our template.

Let's update the HTML to use the passed in `@articles` in `lib/blog_web/controllers/article_html/index.html.heex`:
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

We are looping over all of the `@articles` with a `for` loop.
For each `article` in `@articles`, we will display the article's title.

Navigate to localhost:4000 and see the article's we've created so far.

## 7 CRUDit Where CRUDit Is Due 

Almost all web applications involve CRUD (Create, Read, Update, and Delete) operations. 
You may even find that the majority of the work your application does is CRUD. 
Phoenix acknowledges this, and provides many features to help simplify code doing CRUD.

Let's begin exploring these features by adding more functionality to our application.

### 7.1 Showing a Single Article

We currently have an `index` view that list all of our articles in our database.
Let's add a new view that shows the title and body of a single article.

We start by adding a new route that maps to our new controller action (which we will add next).
Open `lib/blog/router.ex` and insert the last route shown here:

```elixir
scope "/", BlogWeb do
    pipe_through :browser

    get "/", ArticleController, :index
    get "/articles", ArticleController, :index
    get "/articles/:id", ArticleController, :show
end
```

The new route is another `get` route, but it has something extra in its path: `:id`.
This designates a route _parameter_.
A route parameter captures a segment of the request's path, and puts that value in the params map.
For example, when handling a request like `GET http://localhost:4000/articles/1`, `1` would be captured as the value for `:id`.

Let's first update our `MyBlog` context with a function that retrieves an `Article` based on its primary key `id` in `lib/blog/my_blog/my_blog.ex`:
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

Then let's add the `show` method which uses the new context method to the controller at `lib/blog_web/controllers/article_controller.ex`:
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

The `show` action method pulls the `id` from the incoming params, and passes the `id` to the `MyBlog` context's `get_article!(id)` function.
The `get_article!` method in the context will return the article with the matching `id`.
Lastly the `show` action assigns the `article` to the template variable named `article`, which will be accessible in the template using the `@article` variable.

Then let's create a new HTML template at `lib/blog_web/controllers/article_html/show.html.heex` at access the article using `@article` to display its title and body:
```html
<h1>
    <%= @article.title %>
</h1>

<p><%= @article.body %></p>
```

Now we can see the article when we visit http://localhost:4000/articles/1!

To finish up, let's add a convenient way to get to an article's page. We'll link each article's title in `lib/blog_web/controllers/article_html/index.html.heex` to its page:
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

So far, we've covered the "R" (Read) of CRUD. We will eventually cover the "C" (Create), "U" (Update), and "D" (Delete). 
As you might have guessed, we will do so by adding new routes, controller actions, and views. 
Whenever we have such a combination of routes, controller actions, and views that work together to perform CRUD operations on an entity, we call that entity a resource. 
For example, in our application, we would say an article is a resource.

Pheonix provides a routes method named resources that maps all of the conventional routes for a collection of resources, such as articles. 
So before we proceed to the "C", "U", and "D" sections, let's replace the two get routes in `lib/blog_web/router.ex` with resources:

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

Submitted form data is put into the `article_params` map.
We could pass or pluck these values individually to `MyBlog.create_article`, but that would be verbose and possibly error-prone.
And it would become worse as we add more fields.

Instead, we will pass a single map that contains values from the form.
In order to prevent anything malicious from happening if extra params are submitted, we will `cast` the fields we want in the article schema's `changeset` function.

Let's update the `create` action in the controller `lib/blog_web/article_controller.ex` to use the values in the `article_params` param:
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

# 9 Refactoring

Now that we have articles and comments working, take a look at the `lib/blog_web/controllers/article_html/show.html.heex` template. It is getting long and awkward.
We can use partials to clean it up.

## 9.1 Rendering Partial Collections

First, we will make a comment partial to extract showing all the comments for the article.
Create the file `lib/blog_web/controllers/article_html/_comment.html.heex` and put the following into it:

```html
<div class="py-2">
    <p>
        <strong>Commenter:</strong>
        <%= @comment.commenter %>
    </p>
    <p>
        <strong>Comment:</strong>
        <%= @comment.body %>
    </p>
</div>
```

Then you can change `lib/blog_web/controllers/article_html/show.html.heex` to look like the following:
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
    <._comment comment={comment} />
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

This will now render the partial in `lib/blog_web/controllers/article_html/_comment.html.heex` once for each comment that is in the `@article.comments` collection. 

## 9.2 Rendering a Partial Form

Let us also move that new comment section out to its own partial.
Again, you create a file `lib/blog_web/controllers/comment_html/_form.html.heex` containing:

```html
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
```

Then you make the `lib/blog_web/controllers/article_html/show.html.heex` look like the following:
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
    <._comment comment={comment} />
<% end %>

<p>
    <._form comment_changeset={@comment_changeset} article={@article} />
</p>
```

Lastly, we need to update `lib/blog_web/article_html.ex` to include the form template in the new `comment` directory:
```html
defmodule BlogWeb.ArticleHTML do
  use BlogWeb, :html

  embed_templates "article_html/*"
  embed_templates "comment_html/*"
end
```

Refresh and the form should still work.

## 9.3 Sharing code between schemas

Not sure of what the best way to implement this in Phoenix is actually.

# 10 Deleting Comments

Another important feature of a blog is being able to delete spam comments.
To do this, we need to implement a link of some sort in the view and a destroy action in the CommentsController.

So first, let's add the delete link in the `lib/blog_web/controllers/comment_html/_comment.html.heex` partial:

```html
<div class="py-2">
    <p>
        <strong>Commenter:</strong>
        <%= @comment.commenter %>
    </p>
    <p>
        <strong>Comment:</strong>
        <%= @comment.body %>
    </p>
</div>

<.link href={~p"/articles/#{@comment.article_id}/comments/#{@comment.id}"} method="delete" data-confirm="Are you sure?">
Delete Comment
</.link>
```

Clicking this new "Delete Comment" link will fire off a `DELETE /articles/:article_id/comments/:id` to our CommentsController, which can then use this to find the comment we want to delete, so let's add a `delete` action to our controller (`lib/blog_web/controllers/comment_controller.ex`):
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

  def delete(conn, %{"article_id" => article_id, "id" => id}) do
    comment = MyBlog.get_comment_for_article!(article_id, id)
    {:ok, comment} = MyBlog.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/articles/#{comment.article_id")
  end
end
```

The destroy action will find the comment we are looking at in the article's comments, and then remove it from the database and send us back to the show action for the article.

Let's add the new context method `MyBlog.get_comment_for_article!` to the `MyBlog` context at `lib/blog/my_blog/my_blog.ex`:
```elixir
def get_comment_for_article!(article_id, comment_id) do
  Repo.one(from c in Comment, where: c.article_id == ^article_id and c.id == ^comment_id)
end
```

Try deleting a comment now.
