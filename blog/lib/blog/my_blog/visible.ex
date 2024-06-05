defmodule Blog.MyBlog.Visible do
    defmacro __using__(opts) do
        quote do
            def archived?(obj) do
                obj.status == "archived"
            end
        end
    end
end
