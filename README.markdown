# Mgr
cl-mgr is a migration system like Ruby on Rails.　It is easy to alter your database.

Bases on [cl-dbi](https://github.com/fukamachi/cl-dbi)
## Usage
```
;; connect your database
(mgr:connect-db "mysql" "database-name" "username" "password")
;; create migration file. 
(mgr:create "create_users")
;; execute migration file
(mgr:migrate! "full migration-file path")
;; if you want to rollback
(mgr:rollback! "full migration-file path")
```
## Installation
```
 (asdf:load-system :mgr)
```
## Author

* Masayuki Suzuki (szkmsyk041792@gmail.com)

## Copyright

Copyright (c) 2019 Masayuki Suzuki (szkmsyk041792@gmail.com)

## License

Licensed under the MIT License.
