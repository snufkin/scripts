#!/bin/sh
# Universal mysql admin helper.
# Commands:
#   sql create <databasename>
#   sql dump <databasename> <output> (default: databasename.sql)
#   sql import <databasename> <importfile>

COMMAND=$1
DB=$2
MYSQL=$(which mysql5)
MYSQLADMIN=$(which mysqladmin5)
MYSQLDUMP=$(which mysqldump5)
USER="root"

# Different parameters if password is not present.
if [ -z $PASS ] ; then
  MYSQLCMD="$MYSQL -u $USER"
  MYSQLDMP="$MYSQLDUMP -u $USER"
else
  MYSQLCMD="$MYSQL -u $USER -p$PASS"
  MYSQLDMP="$MYSQLDUMP -u $USER -p$PASS"
fi

die() {
  echo "ERROR: $1, quitting..."
  exit 1
}

error() {
  echo "ERROR: $1"
}

message() {
  echo "SUCCESS: $1"
}

if [ ! -x $MYSQL ] ; then
  die "No mysql binary found."
fi

if [ -e $COMMAND ]; then
  die "Missing command."
fi

case $COMMAND in
  dump)
  if [ -z $2 ] ; then
    OUTPUT=${3:-"${DB}.sql"}
    $MYSQLDMP $DB > $OUTPUT
    message "Database dumped to $OUTPUT."
  fi
  ;;
  import)
  if [ ! -r $3 ] ; then
    die "Import database does not exist or is not readable."
  else
    $MYSQLCMD $DB < $3
    message "Database imported."
  fi
  ;;
  create)
  $MYSQLCMD -e "create database $DB"
  ;;
  drop)
  # TODO ask for confirmation
  $MYSQLCMD -e "drop database $DB" 
  ;;
  show)
  # -t forces the output to tabular format instead of list.
  $MYSQLCMD -e "show databases" -t
  ;;
  use)
  $MYSQLCMD $DB
  ;;
esac

if [ $? ] ; then
  message "Command successful."
else
  error "Command failed."
fi
