# tiger-data-app

TigerData is a comprehensive set of data storage and management tools and services that provides storage capacity, reliability, functionality, and performance to meet the needs of a rapidly changing research landscape and to enable new opportunities for leveraging the power of institutional data. 

[![CircleCI](https://circleci.com/gh/pulibrary/tiger-data-app/tree/main.svg?style=svg)](https://circleci.com/gh/pulibrary/tiger-data-app/tree/main)
[![Coverage Status](https://coveralls.io/repos/github/pulibrary/tiger-data-app/badge.svg?branch=main)](https://coveralls.io/github/pulibrary/tiger-data-app?branch=main)

## Documentation

We're writing a ["Missing Manual"](docs/) for the subset of Mediaflux that is used by TigerData.

## Structure

These are our initial plans: In the eventual implementation different systems
(Mediaflux, Postgres, LDAP) may have responsibility for different bits of data.
Cardinality constraints (projects must have sponsors, etc.) will be enforced in software.

```mermaid
erDiagram
  Project ||--o{ File : ""
  Project ||--o{ ProjectUserRole : ""
  ProjectUserRole }o--|| User : ""
  ProjectUserRole }o--|| Role : ""
  Project }o--o{ Funder : ""
  User ||--o{ AllowedRole : ""
  Role ||--o{ AllowedRole :  ""

  Project {
    string title
    string memo
    date start_date
    date end_date
  }

  Role {
    string name
    string description_md
  }
```

Controllers may rely either on ActiveRecord models, or the `MediafluxWrapper` class.

```mermaid
flowchart TD
  guiv --> guic --> ar & mf
  apic --> ar & mf

  subgraph View
  guiv[ERB Templates]
  end

  subgraph Controller
  guic[UI Controllers]
  apic[API Controllers]
  end

  subgraph Model
  ar[ActiveRecord Classes]
  mf[MediafluxWrapper]
  end

  ar --> Postgres
  mf --> Mediaflux
```

## Local development

### Setup

1. Check out code and `cd`
1. Install tool dependencies; If you've worked on other PUL projects they will already be installed.
    1. [Lando](https://docs.lando.dev/getting-started/installation.html)
    1. [asdf](https://asdf-vm.com/guide/getting-started.html#_2-download-asdf)
    1. postgres (`brew install postgresql`: Postgres runs inside a Docker container, managed by Lando, but the `pg` gem still needs a local Postgres library to install successfully.)
1. Install asdf dependencies
    1. `asdf plugin add ruby`
    1. `asdf plugin add node`
    1. `asdf plugin add yarn`
    1. `asdf install`
    1. ... but because asdf is not a dependency manager, if there are errors, you may need to install other dependencies. For example: `brew install gpg`
1. Install language-specific dependencies
    1. `bundle install`
    1. `yarn install`

On a Mac with an M1 chip, `bundle install` may fail. [This suggestion](https://stackoverflow.com/questions/74196882/cannot-install-jekyll-eventmachine-on-m1-mac) helped:
```
gem install eventmachine -v '1.2.7' -- --with-openssl-dir=$(brew --prefix libressl)
brew install pkg-config
bundle install
```

### Starting / stopping services

We use lando to run services required for both test and development environments.

Start and initialize database services with:

`bundle exec rake servers:start`

To stop database services:

`bundle exec rake servers:stop` or `lando stop`

You will also want to run the vite development server:

`bin/vite dev`

### Running tests

- Fast: `bundle exec rspec spec`
- Run in browser: `RUN_IN_BROWSER=true bundle exec rspec spec`

### Starting the development server

1. `bundle exec rails s -p 3000`
2. Access application at [http://localhost:3000/](http://localhost:3000/)
