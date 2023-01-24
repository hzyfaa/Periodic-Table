#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z "$1" ]] 
then
  echo "Please provide an element as an argument."
else
  #if argument is number
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    ELEMENT="$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")"
  else 
    #if argument is string
    ELEMENT="$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")"
  fi 

  #if element does not exist in database 
  if [[ -z $ELEMENT ]] 
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while IFS=" | " read NUM NAME SYMBOL TYPE MASS MELT_POINT BOIL_POINT; 
    do
    echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
    done
  fi
fi 