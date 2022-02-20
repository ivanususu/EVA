#!/bin/bash
################################### VARIABLES ##################################
ansible_test_key="/home/ivan/ansible_test_key"
ansible_stage_key="/home/ivan/ansible_stage_key"
git_work_dir="/home/ivan/variabler"
env_path_test="/home/ivan/variabler/env_test"
env_path_stage="/home/ivan/variabler/env_staging"

################################### CLEANUP FOR EXITS AND INTERUPT #############################################
function cleanup() {
  echo "Cleaning up and exiting..."
  cd $git_work_dir
  git switch master
  git restore .
  git branch | grep -v "master" | xargs git branch -D &> /dev/null
  exit
}

trap cleanup SIGINT SIGTERM ERR EXIT
################################### MAIN MENU #############################################
function main {
  echo "-----------------------------------------------------------------"
  echo "Welcome to the Variabler!"
  echo "You must Initialize (1) to pull the latest changes from git"
  echo "To change the .env files you must first make a new git branch (2)"
  echo "-----------------------------------------------------------------"
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
################################### INITIALIZATION #############################################
function init {
  cd $git_work_dir
  echo "Initializing..."
  echo "Pulling latest from git"
  git switch master
  git pull
  git restore .
  echo "Decrypting .env files"
  ansible-vault decrypt $env_path_test --vault-password-file=$ansible_test_key
  ansible-vault decrypt $env_path_stage --vault-password-file=$ansible_stage_key
  sleep 1
  main
}
################################### CREATING NEW GIT BRANCH #############################################
function create_git_branch {  
  DATETIME=`date +"%d%m%y_%H%M%S"`
  new_test_git_branch=env_updated_${DATETIME}
  echo "Making new git branch"
  git switch -c $new_test_git_branch
  sleep 1
  main
}

################################### LISTING .ENV #############################################
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
  cat $env_path_test
  echo "-------------------------------------------"
  sleep 1
  main
}
function list_env_staging {
  echo "-------------------------------------------"
  cat $env_path_stage
  echo "-------------------------------------------"
  sleep 1
  main
}
################################### ADDING .ENV #############################################
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
  echo $new_test_var >> $env_path_test
  echo "New variable added on test!"
  echo "Don't forget to Encrypt and upload changes"
  sleep 1
  main
}
function add_env_staging {
  read -p "Enter the new variable: " new_staging_var
  echo $new_staging_var >> $env_path_stage
  echo "New variable added on staging!"
  sleep 1
  main
}
################################### REMOVE .ENV #############################################
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
################################### ENCRYPT AND UPLOAD #############################################
function encrypt_and_upload {
  cd $git_work_dir
  echo "Encrypting .env files"
  ansible-vault encrypt $env_path_test --vault-password-file=$ansible_test_key
  ansible-vault encrypt $env_path_stage --vault-password-file=$ansible_stage_key
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

