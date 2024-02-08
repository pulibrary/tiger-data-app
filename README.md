![TigerData logo](app/assets/images/logo-300-200.png)

# tiger-data-app

TigerData is a comprehensive set of data storage and management tools and services that provides storage capacity, reliability, functionality, and performance to meet the needs of a rapidly changing research landscape and to enable new opportunities for leveraging the power of institutional data.

This application provides a front end for users to create and manage projects that live in the TidgerData infrastructure.

[![CircleCI](https://circleci.com/gh/pulibrary/tiger-data-app/tree/main.svg?style=svg)](https://circleci.com/gh/pulibrary/tiger-data-app/tree/main)
[![Coverage Status](https://coveralls.io/repos/github/pulibrary/tiger-data-app/badge.svg?branch=main)](https://coveralls.io/github/pulibrary/tiger-data-app?branch=main)

## Documentation

- Design documents and meeting notes are in [Google Drive](https://drive.google.com/drive/u/1/folders/0AJ7rJ2akICY2Uk9PVA)
- RDSS internal notes are in a [separate directory](https://drive.google.com/drive/u/1/folders/1kG6oJBnGqOUdM2cHKPxCOC9fBmAJ7iDo)
- A set of requirements derived from early sketches is [here](https://docs.google.com/document/d/1U06FBX0qR9iMNiWes5YhP0schcPiLTmFwjHurduSb3A/edit).
- We're writing a ["Missing Manual"](docs/) for the subset of Mediaflux that is used by TigerData.

## Structure

These are our initial plans: In the eventual implementation different systems
(Mediaflux, Postgres, LDAP) may have responsibility for different bits of data.
Cardinality constraints (projects must have sponsors, etc.) will be enforced in software.

```mermaid
erDiagram
  Project }|--|{ User : "via metadata_json"
  User ||--o{ UsersRoles : ""
  Role ||--o{ UsersRoles :  ""

  Project {
    integer created_by_user_id
    integer mediaflux_id
    jsonb metadata_json "hash with metadata"
    datetime created_at
    datetime updated_at
  }

  Role {
    string name
    string resource "default nil role applies to all Objects"
  }

  UsersRoles {
    int user FK
    int role FK
  }

  User {
    string uid "Princeton netid"
    string provider "should always be cas"
    string email
    string given_name
    string family_name
    string display_name

  }
```
### Roles
The system will eventually have many roles.  Please refer to the [docs for a description](https://github.com/pulibrary/tiger-data-app/blob/main/docs/roles.md) of the system roles

## Local development

### Setup

1. Check out code and `cd`
1. Install tool dependencies; If you've worked on other PUL projects they will already be installed.
    1. [Lando](https://docs.lando.dev/getting-started/installation.html)
    1. [asdf](https://asdf-vm.com/guide/getting-started.html#_2-download-asdf)
    1. postgres (`brew install postgresql`: Postgres runs inside a Docker container, managed by Lando, but the `pg` gem still needs a local Postgres library to install successfully.)
1. Install asdf dependencies with asdf
    1. `asdf plugin add ruby`
    1. `asdf plugin add node`
    1. `asdf plugin add yarn`
    1. `asdf plugin add java`
    1. `asdf install`
    1. ... but because asdf is not a dependency manager, if there are errors, you may need to install other dependencies. For example: `brew install gpg`
1. OR - Install dependencies with brew and chruby
   1. `ruby-install 3.2.3 -- --with-openssl-dir=$(brew --prefix openssl@1.1)`
   2. If you get "error: use of undeclared identifier 'RUBY_FUNCTION_NAME_STRING'" while updating, make sure your Xcode toolks are up to date.
   3. close the terminal window and open a new terminal
   4. `chruby 3.2.3`
   5. `ruby --version`
2. Install language-specific dependencies
    1. `bundle install`
    2. `yarn install`

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

#### MediaFlux Server

Documentation for starting the mediaflux server can be found at [doc/local_development](https://github.com/pulibrary/tiger-data-app/blob/main/docs/local_development.md)

1. Once mediaflux is running locally
  1. `bundle exec rake schema:create`

##### Authentication

By default, there exists for the MediaFlux deployment a user account with the following credentials:

- domain: `system`
- user: `manager`
- password: `change_me`

Alternatively, one may please use `docker/bin/shell` to create a terminal session within the container and find individual accounts within the file `/setup/config/users.json`.

##### aterm Client

The MediaFlux `aterm` may be accessed using http://0.0.0.0:8888/aterm/

##### Desktop Client

The MediaFlux desktop client may be accessed using http://0.0.0.0:8888/desktop/

##### Thick Client

One may start and access the Thick Client using the Java Virtual Machine with the following steps:

```bash
$ docker/bin/start
# Within another terminal session, please invoke:
$ docker cp mediaflux:/usr/local/mediaflux/bin/aterm.jar ~/aterm.jar
$ java -Xmx4g -Djava.net.preferIPv4Stack=true -jar ~/aterm.jar
```

###### Configuration Commands

```bash
> server.identity.set :name carolyn
> display font-size 18
> display prompt   "carolyn > "
> display save
```

##### Service Documentation

The MediaFlux service documentation may be accessed using http://0.0.0.0.:8888/mflux/service-docs/


### Running tests

- Fast: `bundle exec rspec spec`
- Run in browser: `RUN_IN_BROWSER=true bundle exec rspec spec`

### Add Yourself as a Project Sponsor

1. Edit config/default_sponsors.yml
   1. Add your netid in each section
2. Edit config/default_mediaflux_admins.yml
   1. Add your netid in each section
3. Run the rake task to update the config file
   1. `bundle exec rake roles:default_sponsors`
   2. `bundle exec rake roles:default_mediaflux_admins`

### Starting the development server

1. `bundle exec rails s -p 3000`
2. Access application at [http://localhost:3000/](http://localhost:3000/)

## Production and Staging Deployment
Deploy with Capistrano (we are intending to have a deployment mechanism with Ansible Tower, but that is not yet implemented)
```bundle exec cap production deploy```
or
```bundle exec cap staging deploy```

## Mail

### Mail on Development
Mailcatcher is a gem that can also be installed locally.  See the [mailcatcher documentation](https://mailcatcher.me/) for how to run it on your machine.

### Mail on Staging and QA
To See mail that has been sent on the Staging and QA servers you can utilize capistrano to open up both mailcatcher consoles in your browser (see below).  Look in your default browser for the consoles

#### staging command
```
cap staging  mailcatcher:console
```

#### qa command
```
cap qa  mailcatcher:console
```

### Mail on Production
Emails on production are sent via [Pony Express](https://github.com/pulibrary/pul-it-handbook/blob/f54dfdc7ada1ff993a721f6edb4aa1707bb3a3a5/services/smtp-mail-server.md).

## User Registration List

### Updating User Registration List
To save updates and make changes to appointed users for early testing of the TigerData site:

1. Make the requested changes to the [Google spreadsheet](https://docs.google.com/spreadsheets/d/169lfRTOSe6H66Iu2DK5g-QzqiVsfz5lHFHMaGmwNT7Y/edit#gid=0)
2. Save those updated changes
3. Download the file as a .CSV file
4. Copy the downloaded .CSV file to `data` > `user_registration_list.csv`
5. Open a PR to check the updated file into version control
6. Once that PR is merged, release and deploy the code. This will automatically run the `load_users.rake` rake task.
