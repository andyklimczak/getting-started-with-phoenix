defmodule Blog.MyBlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blog.MyBlog` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body",
        commenter: "some commenter"
      })
      |> Blog.MyBlog.create_comment()

    comment
  end
end
