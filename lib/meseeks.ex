defmodule Meseeks do
  @moduledoc """
  Can do! A simple Elixir authorization system!

  ## Specifying Permissions

  The most basic usage consists of invoking the `can do` macro inside a struct module
  definition. The `can do` macro receives a list of expressions in the form `user, resource ->
  permissions`, where the permissions returned are granted for matching user-resource combinations.

      # MyApp.Blog.Post
      use Meseeks

      can do
        %User{id: user_id}, %Post{user_id: user_id} -> [:show, :update, :delete]
      end

  While it is common to use CRUD (create, read, update, delete) or controller actions (index, show,
  create, update, delete), there is not set list of permissions. You can invent any you want!

  Typically, an "empty" resource struct will be used to check "list"/"index" and "create"
  permissions since there is no single real resource that can be used otherwise.

      # MyApp.Blog.Post
      use Meseeks

      can do
        %User{id: user_id}, %Post{user_id: user_id} -> [:show, :update, :delete]
        %User{}, %Post{user_id: nil} -> [:index, :create]
      end

  If your users have roles associated with them, Meseeks can be used to implement RBAC!

      # MyApp.Blog.Post
      use Meseeks

      can do
        %User{role: :admin}, %Post{} -> [:show, :update, :delete]
        %User{id: user_id}, %Post{user_id: user_id} -> [:show, :update, :delete]
        %User{}, %Post{user_id: nil} -> [:index, :create]
      end

  In this example, admins can show, update, and delete _all_ posts. "Normal" users (users without
  the `:admin` role) can only show, update, and delete posts that belong to them. Everyone can index
  and create new posts.

  Note that filtering the list/index action is left to the user to implement.

  ## Checking Permissions

  To check if a user is authorized to perform an action on a given resource, invoke `Meseeks.can?/3`.

      user |> Meseeks.can?(:update, post)
      # => true

  This is especially useful for doing authorization checks inside of Phoenix controllers.

      # MyAppWeb.PostController
      import Meseeks, only: :functions

      def update(conn, %{"post" => post_params}) do
        with %Post{} = post <- MyApp.Blog.get_post(post_params["id"]),
             true <- conn.assigns.current_user |> can?(:update, post) do
          # Perform update
        else
          _ -> conn |> put_flash(:error, "Not found!") |> redirect(to: Routes.page_path(conn, :index))
        end
      end

  A plug to simplify usage inside of Phoenix controllers is under development.
  """

  # Quoted version of `_, _ -> []`, indicating that user-resource combinations that don't match any
  # previous clause result in no permissions being granted.
  @catch_all_clause {:->, [], [[{:_, [], Elixir}, {:_, [], Elixir}], []]}

  @doc """
  Define permissions for what a user may do with structs of the containing module.

  The permissions should be listed in the form of `user, resource -> permissions`, where
  `permissions` is a list of permissible actions.

      can do
        %User{id: user_id}, %Thing{user_id: user_id} -> [:show, :update, :delete]
        %User{role: :admin}, _ -> [:show, :update, :delete]
      end
  """
  defmacro can([do: block] = _permissions) do
    # The user-specified permissions block with our "catch all clause" appended.
    safe_block = block ++ [@catch_all_clause]

    # Two-argument quoted anonymous function containing the "safe block."
    perm_function = {:fn, [], safe_block}

    quote do
      defimpl Meseeks.Policy, for: __MODULE__ do
        def can?(resource, action, user) do
          perm_function = unquote(perm_function)

          user
          |> perm_function.(resource)
          |> Enum.member?(action)
        end
      end
    end
  end

  @doc """
  Check if `user` can perform `action` on `resource`.

      import Meseeks, only: :functions

      user |> can?(:show, post)
      # => true

      user |> can?(:delete, post)
      # => false
  """
  @spec can?(user :: term(), action :: atom(), resource :: term()) :: boolean()
  def can?(user, action, resource) do
    # The user and resource arguments are swapped from the invocation of this function to the call
    # to `Meseeks.Policy` for two reasons:
    # 1. Elixir Protocols dispatch based on the first argument
    # 2. The ergonomics of "user |> can?(:read, post)" are wonderful
    Meseeks.Policy.can?(resource, action, user)
  end

  defmacro __using__(_opts) do
    quote do
      import Meseeks, only: :macros
    end
  end
end
