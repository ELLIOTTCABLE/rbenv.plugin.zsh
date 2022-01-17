FOUND_RBENV=0
rbenvdirs=("$HOME/.rbenv" "/opt/homebrew/bin/rbenv" "/usr/local/opt/rbenv" "/usr/local/rbenv" "/opt/homebrew/opt/rbenv" "/opt/rbenv")

for rbenvdir in "${rbenvdirs[@]}" ; do
  if [ -d $rbenvdir/bin -a $FOUND_RBENV -eq 0 ] ; then
    FOUND_RBENV=1
    if [[ $RBENV_ROOT = '' ]]; then
      RBENV_ROOT=$rbenvdir
    fi
    export RBENV_ROOT
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

if [ $FOUND_RBENV -eq 0 ] ; then
  function rbenv_prompt_info() { echo "system: $(ruby -v | cut -f2 -d ' ')" }
fi
