 #!/usr/bin/env bash

#variables
HOMEDIR='/home'
USER_DATA=$sc/data/users/$user

# Return codes
OK=0
E_ARGS=1
E_NOTEXIST=2
E_EXISTS=3
E_PASSWORD=4
E_FORBIDEN=5
E_UPDATE=20
E_RESTART=21

generate_password() {
    matrix=$1
    lenght=$2
    if [ -z "$matrix" ]; then
        matrix=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
    fi
    if [ -z "$lenght" ]; then
        lenght=10
    fi
    i=1
    while [ $i -le $lenght ]; do
        pass="$pass${matrix:$(($RANDOM%${#matrix})):1}"
       ((i++))
    done
    echo "$pass"
}

check_result() {
    if [ $1 -ne 0 ]; then
        echo "Error: $2"
        if [ ! -z "$3" ]; then
            exit $3
        else
            exit $1
        fi
    fi
}

# Argument list checker
check_args() {
    if [ "$1" -gt "$2" ]; then
        echo "Usage: $(basename $0) $3"
        check_result $E_ARGS "not enought arguments" >/dev/null
    fi
}

is_user_free() {
    check_sysuser=$(cut -f 1 -d : /etc/passwd | grep "^$user$" )
    if [ ! -z "$check_sysuser" ] || [ -e "$USER_DATA" ]; then
        check_result $E_EXISTS "user $user exists"
    fi
}

is_user_exist() {
    check_sysuser=$(cut -f 1 -d : /etc/passwd | grep "^$user$" )
    if [  -z "$check_sysuser" ]; then
        check_result $E_NOTEXIST "user $user not exists"
    fi
}

increase_user_value() {
    key="${2//$}"
    factor="${3-1}"
    conf="$sc/data/users/$1/user.conf"
    old=$(grep "$key=" $conf | cut -f 2 -d \')
    if [ -z "$old" ]; then
        old=0
    fi
    new=$((old + factor))
    sed -i "s/$key='$old'/$key='$new'/g" $conf
}


decrease_user_value() {
    key="${2//$}"
    factor="${3-1}"
    conf="$sc/data/users/$1/user.conf"
    old=$(grep "$key=" $conf | cut -f 2 -d \')
    if [ -z "$old" ]; then
        old=0
    fi
    if [ "$old" -le 1 ]; then
        new=0
    else
        new=$((old - factor))
    fi
    if [ "$new" -lt 0 ]; then
        new=0
    fi
    sed -i "s/$key='$old'/$key='$new'/g" $conf
}

# Check if object is valid
is_object_valid() {
    if [ $2 = 'USER' ]; then
        user_dir=$(basename $3)
        if [ ! -d "$sc/data/users/$user_dir" ]; then
            check_result $E_NOTEXIST "$1 $3 doesn't exist"
        fi
    else
        object=$(grep "$2='$3'" $sc/data/users/$user/$1.conf)
        if [ -z "$object" ]; then
            arg1=$(basename $1)
            arg2=$(echo $2 |tr '[:upper:]' '[:lower:]')
            check_result $E_NOTEXIST "$arg1 $arg2 $3 doesn't exist"
        fi
    fi
}


# Get object value
get_object_value() {
    object=$(grep "$2='$3'" $USER_DATA/$1.conf)
    eval "$object"
    eval echo $4
}

# Update object value
update_object_value() {
    row=$(grep -nF "$2='$3'" $USER_DATA/$1.conf)
    lnr=$(echo $row | cut -f 1 -d ':')
    object=$(echo $row | sed "s/^$lnr://")
    eval "$object"
    eval old="$4"
    old=$(echo "$old" | sed -e 's/\\/\\\\/g' -e 's/&/\\&/g' -e 's/\//\\\//g')
    new=$(echo "$5" | sed -e 's/\\/\\\\/g' -e 's/&/\\&/g' -e 's/\//\\\//g')
    sed -i "$lnr s/${4//$/}='${old//\*/\\*}'/${4//$/}='${new//\*/\\*}'/g" \
        $USER_DATA/$1.conf
}

# Add object key
add_object_key() {
    row=$(grep -n "$2='$3'" $USER_DATA/$1.conf)
    lnr=$(echo $row | cut -f 1 -d ':')
    object=$(echo $row | sed "s/^$lnr://")
    if [ -z "$(echo $object |grep $4=)" ]; then
        eval old="$4"
        sed -i "$lnr s/$5='/$4='' $5='/" $USER_DATA/$1.conf
    fi
}

is_object_new() {
    if [ $2 = 'USER' ]; then
        if [ -d "$USER_DATA" ]; then
            object="OK"
        fi
    else
        object=$(grep "$2='$3'" $USER_DATA/$1.conf)
    fi
    if [ ! -z "$object" ]; then
        check_result $E_EXISTS "$2=$3 is already exists"
    fi
}

search_objects() {
    OLD_IFS="$IFS"
    IFS=$'\n'
    for line in $(grep $2=\'$3\' $USER_DATA/$1.conf); do
        eval $line
        eval echo \$$4
    done
    IFS="$OLD_IFS"
}


list_objects() {
    OLD_IFS="$IFS"
    IFS=$'\n'
    for line in $(cat $USER_DATA/$1.conf); do
        eval $line
        eval echo \$$2
    done
    IFS="$OLD_IFS"
}
