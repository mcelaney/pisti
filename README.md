# Points

[Points](https://github.com/fastruby/points) is a Ruby app by [FastRuby.io](https://www.fastruby.io/) -- this is not Points.  This is an Elixir rebuild of points with some features I kinda wished Points had.

A year ago I did a [one-day skunk](https://github.com/mcelaney/elixir-points-skunk/edit/main/README.md) of this project as a time-boxed kata to see what I thought of [PETAL](https://changelog.com/posts/petal-the-end-to-end-web-stack). This version will be a more complete project written with code I probably feel better about.  I'm leaving the old repo up as I think they could both make for useful examples in their own way.

This is not a "specification by reference" rebuild - there will be some fundamental differences in how this app works.

Why is the repo named Pisti? It's latin for Points.

# Installing

## Setup Phoenix

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`


## Run the app

Run tests with `mix test`

Run credo with `mix test` (this will fail because I was mid-effort when the timer went off)

Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Contributing

Please lint your code with `mix credo --strict`
