#!/bin/bash
if [ "$READ_ONLY" = true ] ; then

echo "Create SQL script for read-only-user"

user_name="$POSTGRES_USER"
user_name+="_read"
cat >./99-read-only-user.sql <<EOL
CREATE ROLE readaccess;
GRANT CONNECT ON DATABASE $POSTGRES_DB TO readaccess;
GRANT USAGE ON SCHEMA public TO readaccess;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess;
CREATE USER $user_name WITH PASSWORD '$POSTGRES_PASSWORD';
GRANT readaccess TO $user_name;
EOL

mv ./99-read-only-user.sql /docker-entrypoint-initdb.d/

fi
