defmodule Post do
  use Meseeks

  defstruct([:id, :user_id, :title, :text])

  can do
    %User{role: :admin}, %Post{} -> [:show, :update, :delete]
    %User{id: user_id}, %Post{user_id: user_id} -> [:show, :update, :delete]
    %User{}, %Post{user_id: nil} -> [:index, :create]
  end
end
