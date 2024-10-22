first=$(hostname)      # get the 1st name
# if [[ $first == "login"* ]]; then
#   echo "ERROR: You should not run the paraview server on the login node."
#   echo "Use a compute node instead. Request an interactive node with:"
#   echo ""
#   echo "interact -n4 -m45G -t 1:30:00"
#   exit 1
# fi

unset XDG_RUNTIME_DIR

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Starts a paraview server in the background for you to connect to."
  echo "Can optionally specify a port number to use that specific port"
  exit 0
fi

echo "############## Setup Output ##############"

module purge
source $SPECTRE_HOME/support/Environments/oscar.sh
spectre_load_modules
module use /users/nvu8/modules
module load paraview/5.11.2-osmesa

pvport=$(comm -23 <(seq 11111 33333 | sort) <(ss -Htan | awk '{print $4}' | cut -d':' -f2 | sort -u) | shuf | head -n 1)
if [[ ! -z "$1" ]]; then
  pvport=$1
fi
node="$(echo $first | cut -d'.' -f1)"
echo port "$pvport"
echo node "$node"

echo ""
echo "Once the server starts, establish a new ssh connection in a different"
echo "terminal using"
echo ""
echo "ssh -L $pvport:$node:$pvport $USER@sshcampus.ccv.brown.edu"
echo ""
echo "*Note* If you are not on the Brown network, replace 'sshcampus' with 'ssh'"
echo "*Note* If this fails, then likely the port chosen isn't available. In that"
echo "       case, just run this script again, or supply a port to this script in"
echo "       the range 11111-33333."
echo ""
echo "Once connected, on your local machine if you are on linux run"
echo ""
echo "/path/to/paraview5.11.2/bin/paraview --url cs://localhost:$pvport"
echo ""
echo "If you are on MacOS run"
echo ""
echo "open ParaView-5.11.2.app --args --url cs://localhost:$pvport"
echo ""
echo "*Note* Once you run the above command, it may take a minute or two for"
echo "       ParaView to connect."
echo ""

echo "############# Paraview Output ############"

mpirun -np 1 pvserver --server-port $pvport
