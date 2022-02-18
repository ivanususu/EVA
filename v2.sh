#!/bin/bash
function main {
  echo "Choose operation:
    1.  List .env
    2.  Add .env
    3.  Remove .env
    4.  Exit"

    while true; do
      echo " "
      read -p "Your choice: " SELECT
      case "$SELECT" in
        1) SELECT=list_env;;
        2) SELECT=add_env;;
        3) SELECT=remove_env;;
        4) SELECT=exit;;
        *) echo Invalid selection.; continue
      esac
      break
    done
}
################################### 1) SELECT=list_env #############################################
function list_env {
  echo "Choose environment:
    1.  Test
    2.  Staging
    3.  Exit"

  while true; do
    echo " "
    read -p "Your choice: " SELECT
    case "$SELECT" in
      1) SELECT=list_env_test;;
      2) SELECT=list_env_staging;;
      3) SELECT=exit;;
      *) echo Invalid selection.; continue
    esac
    break
  done
}
function list_env_test {
  cat ./env_test
  main
}
function list_env_staging {
  cat ./env_staging
  main
}
################################### 2) SELECT=add_env #############################################
function add_env {
  echo "Choose environment:
    1.  Test
    2.  Staging
    3.  Exit"

  while true; do
    echo " "
    read -p "Your choice: " SELECT
    case "$SELECT" in
      1) SELECT=add_env_test;;
      2) SELECT=add_env_staging;;
      3) SELECT=exit;;
      *) echo Invalid selection.; continue
    esac
    break
  done
}

function add_env_test {
  read -p "Enter the new variable: " new_test_var
  echo $new_test_var >> ./env_test
  echo "New variable added on test!"
  main
}
function add_env_staging {
  read -p "Enter the new variable: " new_staging_var
  echo $new_staging_var >> ./env_staging
  echo "New variable added on staging!"
  main
}
################################### 3) SELECT=remove_env #############################################
function remove_env {
  echo "Choose environment:
    1.  Test
    2.  Staging
    3.  Exit"

  while true; do
    echo " "
    read -p "Your choice: " SELECT
    case "$SELECT" in
      1) SELECT=remove_env_test;;
      2) SELECT=remove_env_staging;;
      3) SELECT=exit;;
      *) echo Invalid selection.; continue
    esac
    break
  done
}

function remove_env_test {
  read -p "Variable to be removed: " remove_test_var

}
function remove_env_staging {
  read -p "Variable to be removed: " remove_staging_var

}






# ... write a function for each possible value of $SELECT...

main

while test $? -eq 0; do
  $SELECT
done
