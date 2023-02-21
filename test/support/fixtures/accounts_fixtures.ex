defmodule Points.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Points.Accounts` context.
  """

  alias Points.Accounts

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()
      |> elem(1)
      |> Accounts.set_member()

    user
  end

  def archived_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()
      |> elem(1)
      |> Accounts.set_member()
      |> elem(1)
      |> Accounts.set_archived()

    user
  end

  def joined_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()

    user
  end

  def member_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()
      |> elem(1)
      |> Accounts.set_member()

    user
  end

  def admin_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()
      |> elem(1)
      |> Accounts.set_member()
      |> elem(1)
      |> Accounts.set_admin()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
