# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Points.Repo.insert!(%Points.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

(fn ->
   params = %{email: "mac@patterntoaster.com", password: "howdyhowdyhowdy"}
   {:ok, user} = Accounts.register_user(params)
   {encoded_token, _user_token} = UserToken.build_email_token(user, "confirm")
   Accounts.confirm_user(encoded_token)
   Repo.get!(Taglockr.Accounts.User, user.id)
   Accounts.User |> Repo.get!(user.id) |> Accounts.set_admin()
 end).()

(fn ->
   params = %{email: "mac+archived@patterntoaster.com", password: "howdyhowdyhowdy"}
   {:ok, user} = Accounts.register_user(params)
   {encoded_token, _user_token} = UserToken.build_email_token(user, "confirm")
   Accounts.confirm_user(encoded_token)
   Accounts.User |> Repo.get!(user.id)
 end).()

(fn ->
   params = %{email: "mac+joined@patterntoaster.com", password: "howdyhowdyhowdy"}
   {:ok, user} = Accounts.register_user(params)
   {encoded_token, _user_token} = UserToken.build_email_token(user, "confirm")
   Accounts.confirm_user(encoded_token)
   Accounts.User |> Repo.get!(user.id)
 end).()

(fn ->
   params = %{email: "mac+member@patterntoaster.com", password: "howdyhowdyhowdy"}
   {:ok, user} = Accounts.register_user(params)
   {encoded_token, _user_token} = UserToken.build_email_token(user, "confirm")
   Accounts.confirm_user(encoded_token)
   Accounts.User |> Repo.get!(user.id) |> Accounts.set_member()
 end).()

(fn ->
   params = %{email: "mac+admin@patterntoaster.com", password: "howdyhowdyhowdy"}
   {:ok, user} = Accounts.register_user(params)
   {encoded_token, _user_token} = UserToken.build_email_token(user, "confirm")
   Accounts.confirm_user(encoded_token)
   Accounts.User |> Repo.get!(user.id) |> Accounts.set_admin()
 end).()
