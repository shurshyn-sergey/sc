 #!/usr/bin/env bash
get_database_values() {
    eval $(grep "DB='$database'" $USER_DATA/db.conf)
}
