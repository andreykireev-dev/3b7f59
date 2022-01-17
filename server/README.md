# Overview

This is a Ruby on Rails application.

# Getting Started

## Requirements

- You need to have a specific version of Ruby installed on your system.
  See `.ruby-version` file to check which version is needed.
  It is recommended to use [RVM](https://rvm.io/) for Ruby installation.
- You need `rails` and `bundler` gems installed locally.
  ```
  $ gem install rails bundler
  ```

## Initial Setup

- Clone this repository.
- `cd` into the `server` directory of the cloned repository and install dependencies.
  ```
  $ bundler
  ```
- Start a postgres database.
- Add `.env` file with required environment variables. See `.env.sample` file for reference.
- Run migration.
  ```
  $ rails db:migrate
  ```
- Seed the database.
  ```
  $ rails db:seed
  ```
- Start the server. By default, the server will listen to http://localhost:3001/
  ```
  $ rails server
  ```
- Test the server by sending a login request.
  ```
  $ curl -X POST http://localhost:3001/api/login \
  -H 'Content-Type: application/json' \
  -d '{"email": "test@test.com", "password": "sample"}'
  ```
  It should return a json document with `user` and `token`.

## Common Troubleshooting

- I Can't Install RVM

  Please make sure you have all dependencies listed [here](https://rvm.io/rvm/install).
  If you are on Mac, `xcode-select --install` might be needed for building specific Ruby versions.

- An error occurred while installing pg

  Please install `libpq-dev` package if you are on Linux. It is a native dependency required for `pg` gem.
