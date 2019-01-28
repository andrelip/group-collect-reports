# GroupCollect

To start your server:

  * Install dependencies with `mix deps.get`
  * Create a `config/dev.exs` and `config/test.exs` based on their examples in the same folder
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deployment with Docker

Build a docker image:

  * Install Docker and Docker Compose
  * Create a `docker-compose.yml` from the `docker-compose.yml.example`
  * Run `./make_release.sh`

To run set the env variales and execute the image with your preferred Docker flow.

You can use locally with Docker by executing `docker-compose up release`

## Deployment using a Distillery release

Build a docker image:

  * Set the `prod.exs` and `prod.secret.exs`
  * Run `chmod +x docker/scripts/prepare-build`
  * Run `docker/scripts/prepare-build`