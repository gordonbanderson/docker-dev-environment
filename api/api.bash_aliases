#Save typing on a common command
alias artisan='php artisan'

alias reindex-test-db='DB_DEFAULT=postgresql_test PG_DB_DEFAULT=postgis_test artisan ginja:reset-index --force && DB_DEFAULT=postgresql_test PG_DB_DEFAULT=postgis_test artisan ginja:reindex --type=vendor,bot  && DB_DEFAULT=postgresql_test'
alias reset-test-db='composer dump-autoload && artisan ginja:bootstrap-test'
