# Aliases
alias alert="terminal-notifier -message 'Job finished!' -title 'Terminal'"
alias avn="aws-vault exec nonprod --"
alias avp="aws-vault exec prod --"
alias dps="docker ps"
alias dcup="docker compose up"
alias dcdown="docker compose down"
alias dockeri="docker images"
alias hb="hub browse"
alias ls="ls --color -l"
alias reload="source ~/.zshrc"
alias tree="tree -C --filelimit 20"

# Custom functions

# Codecademy startup commands
function how() {
  CURRENT_DIR=$(pwd)
  case $CURRENT_DIR in
    **/[Cc]odecademy)
      echo "Startup commands for Codecademy:"
      echo "  bundle exec rails s"
      echo "  yarn run start"
      ;;
    **/[Aa]uthor)
      echo "Startup commands for Author:"
      echo "  yarn start:postgres"
      echo "  yarn start:rails"
      echo "  cd client && yarn start"
      ;;
    **/[Cc]ontent_[Ss]ervice)
      echo "codecademy"
      echo "Startup commands for content_service:"
      echo "  docker compose up -d"
      echo "  bundle exec rackup"
      ;;
    **/[Cc]ontent_[Ss]ervice_v4)
      echo "Startup commands for content_service_v4:"
      echo "  make dev-up"
      ;;
    **/[Bb]usiness-account-management)
      echo "Startup commands for business_account_management"
      echo "  yarn start"
      ;;
    **/[Pp]ortal-app)
      echo "Startup commands for portal-app"
      echo "  yarn start"
      ;;
    **/[Cc]ontainer-api)
      echo "Startup commands for container-api"
      echo "  aws-vault exec propeller -- aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 408604917997.dkr.ecr.us-east-1.amazonaws.com"
      echo "  aws-vault exec propeller -- aws ecr list-images --repository-name container-api/ein"
      echo "  docker compose up"
      ;;
    *)
      echo "Current directory not recognized: no startup commands known"
      ;;
  esac
}

# Access Codecademy content service in Kubernetes
function sshcontent() {
  if [ "$1" = "production" -o "$1" = "prod" ]
  then
    ENVIRONMENT=prod
    KUBERNETES_CONTEXT=production-eks
  else
    ENVIRONMENT=nonprod
    KUBERNETES_CONTEXT=staging-eks
  fi
    aws-vault exec $ENVIRONMENT -- kubectx $KUBERNETES_CONTEXT
    aws-vault exec $ENVIRONMENT -- kubens contentv4
    POD_NAME=$(aws-vault exec $ENVIRONMENT -- kubectl get pods -o json | jq -r '.items[0].metadata.name')
    echo "Found pod: $POD_NAME"
    echo "Attempting to open rails console in pod..."
    aws-vault exec $ENVIRONMENT -- kubectl exec -it $POD_NAME -- bundle exec rails console
}
