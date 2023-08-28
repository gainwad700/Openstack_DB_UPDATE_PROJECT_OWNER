#!/bin/bash

# Database credentials
DB_USER="root"
DB_PASS="**************************"
DBS=("glance" "nova" "cinder" "neutron")
DB_HOST="cluster1"

# Old and new project IDs
OLD_PROJECT="313fdd5c48874c40982f0b77e7fc256d"
NEW_PROJECT="fdb57373fb084cffb095f57bac63af21"

for DB_NAME in "${DBS[@]}"; do

        if [ "$DBS" = "glance" ]; then

                # Get a list of all tables in the database
                TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -N -B -e "SHOW TABLES FROM $DB_NAME")

                # Loop through each table and generate an update query
                for TABLE in $TABLES; do
                        # Generate the update query
                        UPDATE_QUERY="UPDATE $DB_NAME.$TABLE SET owner = '$NEW_PROJECT' WHERE owner = '$OLD_PROJECT';"

                        # Execute the update query
                        mysql -u "$DB_USER" -h "$DB_HOST" -p"$DB_PASS" -e "$UPDATE_QUERY"
                done
        else

                # Get a list of all tables in the database
                TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -N -B -e "SHOW TABLES FROM $DB_NAME")

                # Loop through each table and generate an update query
                for TABLE in $TABLES; do
                        # Generate the update query
                        UPDATE_QUERY="UPDATE $DB_NAME.$TABLE SET project_id = '$NEW_PROJECT' WHERE project_id = '$OLD_PROJECT';"

                        # Execute the update query
                        mysql -u "$DB_USER" -h "$DB_HOST" -p"$DB_PASS" -e "$UPDATE_QUERY"

                done
        fi
done
