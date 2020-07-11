defprotocol Meseeks.Policy do
  @moduledoc """
  An small, simple protocol used to determine the authorization of a user on a given resource.

  Implementing this module directly is done at the users' own risk; it is meant to be invoked only
  by the parent module, `Meseeks`.
  """

  @doc """
  Returns whether the given `user` is allowed to perform `action` on `resource`.
  """
  @spec can?(struct(), atom(), struct()) :: boolean()
  def can?(resource, action, user)
end
