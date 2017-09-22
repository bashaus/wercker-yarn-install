#!/bin/bash

# Property: clear-cache-on-failed
# Must be a valid boolean (true, false, 1 or 0)
case "$WERCKER_YARN_INSTALL_CLEAR_CACHE_ON_FAILED" in
  "true" | "1" ) WERCKER_YARN_INSTALL_CLEAR_CACHE_ON_FAILED=1 ;;
  "false" | "0" ) WERCKER_YARN_INSTALL_CLEAR_CACHE_ON_FAILED=0 ;;
  * ) fail "Property clear-cache-on-failed must be either true or false"
esac

# Property: production
# Must be a valid boolean (true, false, 1 or 0)
case "$WERCKER_YARN_INSTALL_PRODUCTION" in
  "true" | "1" ) WERCKER_YARN_INSTALL_PRODUCTION=1 ;;
  "false" | "0" ) WERCKER_YARN_INSTALL_PRODUCTION=0 ;;
  * ) fail "Property production must be either true or false"
esac

main() {
  download_yarn
  setup_cache
  yarn_install
  success "Finished yarn install"
}

download_yarn() {
  if hash yarn 2>/dev/null; then
    info "Yarn already installed"
  else
    info "Yarn not found, installing"
    (curl -o- -L https://yarnpkg.com/install.sh | bash) && return
    fail "Yarn failed to install"
  fi
}

setup_cache() {
  info "Setting up yarn cache directory"
  export YARN_CACHE_FOLDER="$WERCKER_CACHE_DIR/$WERCKER_STEP_OWNER/$WERCKER_STEP_NAME"
  debug "$YARN_CACHE_FOLDER"
  mkdir -p "$YARN_CACHE_FOLDER"
  yarn config set cache-folder "$YARN_CACHE_FOLDER"
}

clear_cache() {
  warn "Clearing yarn cache"
  yarn cache clear
}

yarn_install() {
  if [ "$WERCKER_YARN_INSTALL_PRODUCTION" == "1" ]; then
    info "Production enabled, skipping devDependencies"
  else
    info "Production disabled, including devDependencies"
  fi

  local attempts=3;
  for attempt in $(seq "$attempts"); do
    info "Starting yarn install, attempt: $attempt"

    yarn install $WERCKER_YARN_INSTALL_OPTS \
      $( [[ "$WERCKER_YARN_INSTALL_PRODUCTION" == "1" ]] && echo "--production" ) \
      && return;

    if [ "$WERCKER_YARN_INSTALL_CLEAR_CACHE_ON_FAILED" == "1" ]; then
      clear_cache
    fi
  done

  fail "Failed to successfully execute yarn install, attempts: $attempts"
}

main;
