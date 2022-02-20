#!/bin/bash
function main {
  echo " "
  echo "Welcome to the Variabler!"
  echo "You must Initialize (1) to pull the latest changes from git"
  echo "To change the .env files you must first make a new git branch (2)"
  echo "Choose operation:
    1.  Initialize
    2.  Create new git branch 
    3.  List .env
    4.  Add .env
    5.  Remove .env
    6.  Encrypt and upload changes
    7.  Exit"

    while true; do
      echo " "
      read -p "Your choice: " SELECT
      case "$SELECT" in
        1) SELECT=init;;
        2) SELECT=create_git_branch;;
        3) SELECT=list_env;;
        4) SELECT=add_env;;
        5) SELECT=remove_env;;
        6) SELECT=encrypt_and_upload;;
        7) SELECT=exit;;
        *) echo Invalid selection.; continue
      esac
      break
    done
}
################################### 1) SELECT=init #############################################
function init {
  cd /home/ivan/variabler ### MAKE VAR
  echo "Initializing..."
  echo "Pulling latest from git"
  git switch master
  git pull
  echo "Decrypting .env files"
  ansible-vault decrypt /home/ivan/variabler/env_test --vault-password-file=/home/ivan/variabler/ansible_test_key ### MAKE VAR
  ansible-vault decrypt /home/ivan/variabler/env_staging --vault-password-file=/home/ivan/variabler/ansible_stage_key ### MAKE VAR
  sleep 1
  main
}
################################### 2) SELECT=create_git_branch;; #############################################
function create_git_branch {  
  DATETIME=`date +"%d%m%y_%H%M%S"`
  new_test_git_branch=test_env_updated_${DATETIME}
  echo "Making new git branch"
  git switch -c $new_test_git_branch
}

################################### 3) SELECT=list_env;; #############################################
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
  cat ./env_test ### MAKE VAR
  echo "-------------------------------------------"
  sleep 1
  main
}
function list_env_staging {
  echo "-------------------------------------------"
  cat ./env_staging ### MAKE VAR
  echo "-------------------------------------------"
  sleep 1
  main
}
################################### 4) SELECT=add_env;; #############################################
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
  echo $new_test_var >> ./env_test ### MAKE VAR
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
################################### 5) SELECT=remove_env;; #############################################
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
################################### 6) SELECT=encrypt_and_upload;; #############################################
function encrypt_and_upload {
  cd /home/ivan/variabler ### MAKE VAR
  echo "Encrypting .env files"
  ansible-vault encrypt /home/ivan/variabler/env_test --vault-password-file=/home/ivan/variabler/ansible_test_key ### MAKE VAR
  ansible-vault encrypt /home/ivan/variabler/env_staging --vault-password-file=/home/ivan/variabler/ansible_stage_key ### MAKE VAR
  echo "Pushing to git"
  read -p "Commit comment: " NEW_GIT_BRANCH_COMMENT
  git commit -am "$NEW_GIT_BRANCH_COMMENT"
  git push --set-upstream origin $new_test_git_branch
  git switch master
  git branch -D $new_test_git_branch
  main
}




# ... write a function for each possible value of $SELECT...

main

while test $? -eq 0; do
  $SELECT
done

