#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  # If Returned to main menu, print the return message
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # Start main menu
  echo "How may I help you?" 
  #F001 echo -e "\n1) Cut\n2) Color\n3) Trim\n4) Straighten\n5) Exit"
  echo -e "\n1) Cut\n2) Color\n3) Trim\n4) Straighten"
  read SERVICE_ID_SELECTED

  # Check that service exists (only 1-4 in this case)
  case $SERVICE_ID_SELECTED in
    1) SERVICE 1 ;;
    2) SERVICE 2 ;;
    3) SERVICE 3 ;;
    4) SERVICE 4 ;;
    #F001 5) EXIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

SERVICE() {
  # Set the name of the service
  case $1 in
    1) SERVICE_NAME="cut" ;;
    2) SERVICE_NAME="color" ;;
    3) SERVICE_NAME="trim" ;;
    4) SERVICE_NAME="straighten" ;;
  esac

  # Check the customer exists
  CHECK_CUSTOMER_EXISTS

  # Prompt for a service time
  # echo -e "\n$SERVICE_NAME Requested for $CUSTOMER_NAME"
  echo -e "\nEnter the time you would like service:"
  read SERVICE_TIME

  CREATE_SERVICE
}

### --- SERVICE --- ###
CREATE_SERVICE(){
  # insert new service request
  INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');") 
  
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

### --- CHECK CUSTOMER EXISTS --- ###
CHECK_CUSTOMER_EXISTS() {
  echo "Please enter your phone number"
  read CUSTOMER_PHONE

  # Check for Customer in database
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo "$CUSTOMER_NAME"

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
  EXIT 0
}

MAIN_MENU