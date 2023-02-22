![TigerData logo](app/assets/images/logo-300-200.png)

# tiger-data-app

TigerData is a comprehensive set of data storage and management tools and services that provides storage capacity, reliability, functionality, and performance to meet the needs of a rapidly changing research landscape and to enable new opportunities for leveraging the power of institutional data. 

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

#### MediaFlux Server

Docker is currently used to manage and run deployments of the MediaFlux server used for development environments.

In order to retrieve or update the Docker Image, please invoke the following. Note that one will need to retrieve the credentials for the Docker Registry from [LastPass](https://lastpass.com):

```bash
$ bin/docker/bin/pull
```

Then, in order to start a deployment of the MediaFlux server, please then invoke:

```bash
$ bin/docker/bin/start
```

If this is successful, one should then be able to view the logs for the server within the terminal session:

```bash
Starting the mediaflux server...
Wed Feb 22 22:09:33 UTC 2023 : service start -Dapplication.home=/usr/local/mediaflux
Wed Feb 22 22:09:34 UTC 2023 : Mediaflux (3) launcher starting server using command: '/usr/local/openjdk-8/jre/bin/java -server -Xmx2048m -XX:ErrorFile=/usr/local/mediaflux/volatile/logs/jvm/jvm_crash_20230222_2209_pid%p.log -cp /usr/local/mediaflux/bin/aserver.jar:/usr/local/mediaflux/bin/lib/servlet-api-2.5.jar:/usr/local/mediaflux/bin/lib/jai_imageio.jar:/usr/local/mediaflux/bin/lib/activation.jar:/usr/local/mediaflux/bin/lib/PYCC.pf:/usr/local/mediaflux/bin/lib/jai_core.jar:/usr/local/mediaflux/bin/lib/bsh.jar:/usr/local/mediaflux/bin/lib/tcl.jar:/usr/local/mediaflux/bin/lib/native:/usr/local/mediaflux/bin/lib/jai_codec.jar:/usr/local/mediaflux/ext/packages:/usr/local/mediaflux/plugin/bin -Dapplication.home=/usr/local/mediaflux -Djava.library.path=/usr/local/mediaflux/bin/lib/native:/usr/local/mediaflux/plugin/lib/native -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Djava.awt.headless=true arc.mf.server.ServerGUI nogui'
```

One may then confirm that this is successfully running by accessing either [http://0.0.0.0:8888/aterm] or [http://0.0.0.0:8888/desktop] within a web browser. One may also create a terminal session within the container with the following:

```bash
$ docker/bin/shell
```

##### Stopping the MediaFlux Server

In order to stop the MediaFlux server, one may invoke the following:

```bash
$ docker/bin/stop
```

### Running tests

- Fast: `bundle exec rspec spec`
- Run in browser: `RUN_IN_BROWSER=true bundle exec rspec spec`

### Starting the development server

1. `bundle exec rails s -p 3000`
2. Access application at [http://localhost:3000/](http://localhost:3000/)
