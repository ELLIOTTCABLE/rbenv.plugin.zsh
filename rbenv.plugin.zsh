FOUND_RBENV=0
rbenvdirs=("$HOME/.rbenv"  "/usr/local/opt/rbenv" "/usr/local/rbenv" "/opt/rbenv")

for rbenvdir in "${rbenvdirs[@]}" ; do
  if [ -d $rbenvdir/bin -a $FOUND_RBENV -eq 0 ] ; then
    FOUND_RBENV=1
    if [[ $RBENV_ROOT = '' ]]; then
      RBENV_ROOT=$rbenvdir
    fi
    export RBENV_ROOT
    export PATH=${rbenvdir}/bin:$PATH
    eval "$(rbenv init --no-rehash -)"

    function current_node() {
      echo "$(rbenv version-name)"
    }

    function rbenv_prompt_info() {
      echo "$(current_node)"
    }
  fi
done
unset rbenvdir

if [ $FOUND_RBENV -eq 0 ] ; then
  function rbenv_prompt_info() { echo "system: $(node --version)" }
fi
