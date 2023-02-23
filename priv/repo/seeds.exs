IO.puts("Setting up user seeds")
Code.require_file("seeds/users.exs", __DIR__)

IO.puts("Setting up project seeds")
Code.require_file("seeds/projects.exs", __DIR__)

IO.puts("Database seeding complete")
