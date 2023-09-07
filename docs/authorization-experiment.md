# Authorization Experiments
## Authorization Options
   * Create a session utilizing the princeton domain & have the user supply their username and password
     * Advantages
       * Requires one call to mediaflux to instatiate the session
       * mediaflux would control user access to the data and commands
     * Disadvantages
       * would either require two logins or for the tigedata app to utilize the mediaflux login instead of single signon
       * less separation from mediaflux and the tigerdata app
   * Create a Identity token to represent the user
     * Advantages
       * Could continue to utilize princeton single signon for tigerdata app
       * keep the tigerdata application and mediaflux more separate
     * Disadvantages
       * Need to control Identity Tokens via the application
       * Could take up to two calls to mediaflux to create a session for a user depending on how long we keep the token active

## Timing experiments on Docker
  First off it should be noted that the docker instance gets in a weird state if we try to run two of the rake tasks in a row (any two).  In Between each rake take I deleted the docker instance `docker rm mediaflux` and then created and started it utilizing the commands in [local development.md](https://github.com/pulibrary/tiger-data-app/blob/main/docs/local_development.md)

  you must create the test user with `user.create :domain princeton.edu :password change_me :user test` each time you destroy the docker container for the experiment to be valid.  This command can be run in any aterm

  Login with an existing token seems to be comparable of slightly faster than login vias user name and password.  Creating a new token every time is much slower, becuase you make twice as many calls.

### By Session
 This test mimics option 1 above.  Basically the user signs in and we create a session.
 ```
> rake authorization:by_session       
1 Session 84.28621292114258 miliseconds 0.08428621292114258 seconds
1000 Sessions 8345.745086669922 miliseconds 8.345745086669922 seconds
 ```

### By New Token
 This test mimics option 2 above, creating a new token for the user with every login.
 ```
> rake authorization:by_new_token     
1 New Token 121.18387222290039 mili seconds 0.12118387222290039 seconds
1000 New Tokens 21111.900806427002 mili seconds 21.111900806427002 seconds
```

### By Existing Token
 This test mimics option 2 above, storing token for the user and just logging in.
 ```
rake authorization:by_existing_token
1 Existing Token 20.946979522705078 mili seconds 0.020946979522705078 seconds
1000 Existing Tokens 7462.0959758758545 mili seconds 7.4620959758758545 seconds
```