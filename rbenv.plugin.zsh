found_rbenv=''
rbenvdirs=("$HOME/.rbenv" "$HOME/.local/rbenv" "/usr/local/opt/rbenv" "/usr/local/rbenv" "/opt/rbenv")

for rbenvdir in "${rbenvdirs[@]}" ; do
  if [ -z "$found_rbenv" ] && [ -d "$rbenvdir/versions" ]; then
    found_rbenv=true
    if [ -z "$RBENV_ROOT" ]; then
      RBENV_ROOT=$rbenvdir
      export RBENV_ROOT
    fi
    export PATH=${rbenvdir}/bin:$PATH
    eval "$(rbenv init --no-rehash - zsh)"

    function current_ruby() {
      echo "$(rbenv version-name)"
    }

    function current_gemset() {
      echo "$(rbenv gemset active 2&>/dev/null | sed -e ":a" -e '$ s/\n/+/gp;N;b a' | head -n1)"
    }

    function rbenv_prompt_info() {
      if [[ -n "$(current_gemset)" ]] ; then
        echo "$(current_ruby)@$(current_gemset)"
      else
        echo "$(current_ruby)"
      fi
    }
  fi
done
unset rbenvdir

if [ -z "$found_rbenv" ] ; then
  function rbenv_prompt_info() {
    echo "system: $(ruby -v | cut -f2 -d ' ')"
  }
fi
