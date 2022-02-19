#!/bin/bash
function main {
  echo " "
  echo "Choose operation:
    1.  Initialize 
    2.  List .env
    3.  Add .env
    4.  Remove .env
    5.  Encrypt and upload changes
    6.  Exit"

    while true; do
      echo " "
      read -p "Your choice: " SELECT
      case "$SELECT" in
        1) SELECT=init;;
        2) SELECT=list_env;;
        3) SELECT=add_env;;
        4) SELECT=remove_env;;
        5) SELECT=encrypt_and_upload;;
        6) SELECT=exit;;
        *) echo Invalid selection.; continue
      esac
      break
    done
}
################################### 1) SELECT=init #############################################
function init {
  cd /home/ivan/variabler
  echo "Initializing..."
  echo "Pulling latest from git"
  git switch master
  git pull
  echo "Decrypting .env files"
  ansible-vault decrypt /home/ivan/variabler/env_test --vault-password-file=/home/ivan/variabler/ansible_test_key
  ansible-vault decrypt /home/ivan/variabler/env_staging --vault-password-file=/home/ivan/variabler/ansible_stage_key
  sleep 1
  main
}

################################### 2) SELECT=list_env #############################################
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
  echo "-------------------------------------------"
  cat ./env_test
  echo "-------------------------------------------"
  sleep 1
  main
}
function list_env_staging {
  echo "-------------------------------------------"
  cat ./env_staging
  echo "-------------------------------------------"
  sleep 1
  main
}
################################### 3) SELECT=add_env #############################################
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
  DATETIME=`date +"%d_%m_%y-%H:%M:%S"`
  new_test_git_branch=test_env_updated_${DATETIME}
  echo "Making new git branch"
  git switch -c $new_test_git_branch
  echo $new_test_var >> ./env_test
  echo "New variable added on test!"
  echo "Don't forget to Encrypt and upload changes"
  sleep 1
  main
}
function add_env_staging {
  read -p "Enter the new variable: " new_staging_var
  echo $new_staging_var >> ./env_staging
  echo "New variable added on staging!"
  sleep 1
  main
}
################################### 4) SELECT=remove_env #############################################
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
################################### 5) SELECT=encrypt_and_upload #############################################
function encrypt_and_upload {
  cd /home/ivan/variabler
  echo "Encrypting .env files"
  ansible-vault encrypt /home/ivan/variabler/env_test --vault-password-file=/home/ivan/variabler/ansible_test_key
  ansible-vault encrypt /home/ivan/variabler/env_staging --vault-password-file=/home/ivan/variabler/ansible_stage_key
  echo "Pushing to git"
  read -p "Commit comment: " NEW_GIT_BRANCH_COMMENT
  git commit -am "$NEW_GIT_BRANCH_COMMENT"
  git push --set-upstream origin $new_test_git_branch
  git switch master
  main
}




# ... write a function for each possible value of $SELECT...

main

while test $? -eq 0; do
  $SELECT
done
