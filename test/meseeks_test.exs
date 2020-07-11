defmodule MeseeksTest do
  @moduledoc """
  Since Elixir's Protocols are consolidated at compile-time, it's difficult to build dynamic
  scenarios to test different aspects of a Protocol-based library. Thus, I have taken a somewhat
  unusual step in building a micro-application in "test/support" be the vehicle by which to test.
  """

  use ExUnit.Case
  doctest Meseeks

  import Meseeks, only: [can?: 3]

  describe "can?/3" do
    test "normal users may only show their own posts" do
      user = %User{id: 1}
      user_post = %Post{user_id: 1}
      other_post = %Post{user_id: 2}

      assert user |> can?(:show, user_post)
      refute user |> can?(:show, other_post)
    end

    test "admins can see everyones' posts" do
      admin = %User{role: :admin, id: 1}
      admin_post = %Post{user_id: 1}
      other_post = %Post{user_id: 2}

      assert admin |> can?(:show, admin_post)
      assert admin |> can?(:show, other_post)
    end
  end
end
