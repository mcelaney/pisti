alias Points.Accounts
alias Points.Accounts.User
alias Points.Repo


# Primary user for QA of most functionality
(fn ->
   params = %{email: "primary@example.com", password: "howdyhowdyhowdy"}

   with {:ok, user} <- Accounts.register_user(params),
        {:ok, confirmed} <- user |> User.confirm_changeset() |> Repo.update(),
        {:ok, admin} <- confirmed |> Accounts.set_member() |> Accounts.set_admin() do
     admin
   else
     _ -> raise "primary user seed failed"
   end
 end).()

# Archived users are former users which can no longer log in
(fn ->
   params = %{email: "archived@example.com", password: "howdyhowdyhowdy"}

   with {:ok, user} <- Accounts.register_user(params),
        {:ok, confirmed} <- user |> User.confirm_changeset() |> Repo.update(),
        {:ok, archived} <- Accounts.set_member(confirmed) |> Accounts.set_archived() do
     archived
   else
     _ -> raise "archived user seed failed"
   end
 end).()

# A user in the initial creation state before the email is confirmed or the
#   admin promotes to a member
(fn ->
   params = %{email: "unconfirmed@example.com", password: "howdyhowdyhowdy"}
   {:ok, user} = Accounts.register_user(params)

   user
 end).()

# A user that has been promoted to member before they confirmed their email
(fn ->
   params = %{email: "pre+accepted@example.com", password: "howdyhowdyhowdy"}

   with {:ok, user} <- Accounts.register_user(params),
        {:ok, member} <- Accounts.set_member(user) do
     member
   else
     _ -> raise "Pre accepted user seed failed"
   end
 end).()

# A user that has confirmed their email before they were promoted to member
(fn ->
   params = %{email: "confirmed@example.com", password: "howdyhowdyhowdy"}

   with {:ok, user} <- Accounts.register_user(params),
        {:ok, confirmed} <- user |> User.confirm_changeset() |> Repo.update() do
     confirmed
   else
     _ -> raise "confirmed user seed failed"
   end
 end).()

# A user who has been promoted to member and has confirmed their email
(fn ->
   params = %{email: "member@example.com", password: "howdyhowdyhowdy"}

   with {:ok, user} <- Accounts.register_user(params),
        {:ok, confirmed} <- user |> User.confirm_changeset() |> Repo.update(),
        {:ok, member} <- Accounts.set_member(confirmed) do
     member
   else
     _ -> raise "member user seed failed"
   end
 end).()

# A second admin user to allow for QA of admin demotion funcationality
(fn ->
   params = %{email: "admin@example.com", password: "howdyhowdyhowdy"}
   with {:ok, user} <- Accounts.register_user(params),
        {:ok, confirmed} <- user |> User.confirm_changeset() |> Repo.update(),
        {:ok, admin} <- confirmed |> Accounts.set_member() |> Accounts.set_admin() do
     admin
   else
     _ -> raise "member user seed failed"
   end
 end).()
