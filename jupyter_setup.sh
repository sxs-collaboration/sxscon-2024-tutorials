first=$(hostname)      # get the 1st name
if [[ $first == "login"* ]]; then
  echo "ERROR: You should not run the jupyter server on the login node."
  echo "Use a compute node instead. Request an interactive node with:"
  echo ""
  echo "interact -f cascade -n4 -t 1:00:00"
  exit 1
fi

unset XDG_RUNTIME_DIR

if [[ -z $1 ]]; then
  echo "You must supply a SpECTRE build directory"
  exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Starts a Juptyer server in the background for you to connect to."
  echo "You must supply a SpECTRE build directory to this script so the"
  echo "Jupyter server is launched with SpECTRE python"
  exit 0
fi

spectre_python="$1/bin/python-spectre"

if ! test -f $spectre_python; then
  echo "Could not find $spectre_python which is needed to launch the"
  echo "Jupyter server. Make sure you have built the python bindings with"
  echo ""
  echo "make cli"
  exit 1
fi

echo "############## Setup Output ##############"

source $SPECTRE_HOME/support/Environments/oscar.sh
spectre_load_modules > /dev/null 2>&1

ipnport=$(comm -23 <(seq 8000 9000 | sort) <(ss -Htan | awk '{print $4}' | cut -d':' -f2 | sort -u) | shuf | head -n 1)
echo ipnport "$ipnport"
ipnip=$(hostname -i)
echo ipnip "  $ipnip"

echo ""
echo "Once the server starts, establish a new ssh connection in a different"
echo "terminal using"
echo ""
echo "ssh -L $ipnport:$ipnip:$ipnport $USER@sshcampus.ccv.brown.edu"
echo ""
echo "*Note* If you are not on the Brown network, replace 'sshcampus' with 'ssh'"
echo "*Note* If the Jupyter output below has a message similar to"
echo "       'The port XXXX is already in use, trying another port'"
echo "       use the new port from the URL in your ssh connection."
echo ""
echo "Once connected, copy one of the URLs from below into a browser (likely"
echo "the last URL)"
echo ""

echo "############# Jupyter Output ############"

$spectre_python -m jupyterlab --no-browser --port=$ipnport --ip=$ipnip
