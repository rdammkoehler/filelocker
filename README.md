A super simple example file server with OAuth2 and some sekrits.
 
* Run filelocker_local.rb
* Visit http://localhost:4567 to see an unsecured status
* Visit http://localhost:4567/sekrit to see a secured message (by OAuth2)
* Visit http://localhost:4567/file/{some file in the project} to see a secured file (by OAuth2)

### Examples

Request
```
    http://localhost:4567/
```

responds with 

```
    {"status":"active"}
```

Request 

```
    http://localhost:4567/sekrit
```

responds with 

```
    "hello moto"
```

Request

```
    http://localhost:4567/file/Gemfile
```

responds with

```
    source 'https://rubygems.org'
    
    gem 'yconfig'
    gem 'sinatra'
    gem 'jwt'
```