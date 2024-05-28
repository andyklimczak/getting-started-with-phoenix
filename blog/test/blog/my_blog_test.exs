defmodule Blog.MyBlogTest do
  use Blog.DataCase

  alias Blog.MyBlog

  describe "comments" do
    alias Blog.MyBlog.Comment

    import Blog.MyBlogFixtures

    @invalid_attrs %{body: nil, commenter: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert MyBlog.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert MyBlog.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{body: "some body", commenter: "some commenter"}

      assert {:ok, %Comment{} = comment} = MyBlog.create_comment(valid_attrs)
      assert comment.body == "some body"
      assert comment.commenter == "some commenter"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MyBlog.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{body: "some updated body", commenter: "some updated commenter"}

      assert {:ok, %Comment{} = comment} = MyBlog.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
      assert comment.commenter == "some updated commenter"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = MyBlog.update_comment(comment, @invalid_attrs)
      assert comment == MyBlog.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = MyBlog.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> MyBlog.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = MyBlog.change_comment(comment)
    end
  end
end
