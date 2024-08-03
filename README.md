# Tutorials at SXScon 2024

This repo contains workshop material like Jupyter notebooks and input files used
for the SXS workshop at ICERM. It should be cloned on Oscar, the cluster at
Brown which we will be using. To access Oscar, see
[the instructions below](#connecting-to-oscar).

The documentation for Oscar can be found
[here](https://docs.ccv.brown.edu/oscar). These docs are quite good, so if
there's anything missing from this README about how to do something on Oscar,
you can refer here. Or you can also ask any organizer/TA for help.

### 1. Connecting to Oscar

You should already have an account on the cluster. At the beginning of the
workshop you should have received an email from Brown/ICERM with details about a
Brown account. This should have your username and password. These will be the
username and password you use for everything below.

#### Duo 2FA

Brown requires 2FA for all its accounts. To setup 2FA, go to your
[brown account](https://myaccount.brown.edu/twostep/settings), log in with your
credentials, and follow the instructions there.

#### Wifi

There are two networks you can use. The guest wifi requires no authentication.
To use the Brown network, you'll have to log in with your Brown username and
password. Access to the Brown network will be required if you want to use
[ssh keys](#ssh-keys-optional) to access Oscar, or if you want to use
[VSCode](#logging-in-to-oscar-with-vscode-optional) to access Oscar.

#### Logging in to Oscar with a terminal

To access oscar, simply do

```sh
ssh USER@ssh.ccv.brown.edu
```

You'll be prompted for you password, and then for 2FA.

#### SSH Keys (Optional)

Using ssh keys is *not* required for the workshop. Though it can make accessing
Oscar easier so you don't have to type your password in every time.

> :warning: You can only use ssh keys to access the `sshcampus.ccv.brown.edu`
> domain. And you can only access the `sshcampus.ccv.brown.edu` domain from the
> Brown network. Ssh keys *will not work* for the `ssh.ccv.brown.edu` domain or
> on the guest [wifi](#wifi).

If you don't already have an ssh key, the
[GitHub docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
are very easy to follow.

We need to copy our key to Oscar

```sh
ssh-copy-id -i ~/.ssh/id_ed25519 USER@sshcampus.ccv.brown.edu
```

You should be prompted for a password and 2FA. After this, you
should be able to access Oscar without entering a password

```sh
ssh USER@sshcampus.ccv.brown.edu
```

#### Logging in to Oscar with VSCode (Optional)

You cannot log in to Oscar with VSCode through either of the above domains
(`sshcampus.ccv.brown.edu` or `ssh.ccv.brown.edu`). You also cannot use VSCode
to access Oscar on the guest [wifi](#wifi). You have to be on the Brown network.

You will need to add the following to your `~/.ssh/config` file

```conf
Host oscar-vscode
  HostName vscode1
  User USERNAME
  ProxyJump oscar-jump

Host oscar-jump
  HostName poodcit4.services.brown.edu
  User USERNAME
```

replacing the username with your own. Then with the
[remote ssh
extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
, find the `oscar-vscode` host, and connect with that. If you set up
[ssh keys](#ssh-keys-optional), then you won't be prompted for a password. If you didn't
set them up, you'll have to enter your password and 2FA.

### 2. Clone this repo

Once you have access to Oscar, clone this repo

```sh
git clone https://github.com/sxs-collaboration/sxscon-2024-tutorials.git $HOME/sxscon-2024-tutorials
```

### 3. Getting an interactive compute node

Oscar offers a convenient command for getting an interactive compute node

```sh
interact -f cascade -n 2 -t 01:00:00
```

The `-n` means number of cores, `-t` time limit. You can optionally also
specify the amount of memory with `-m 10G`. This will give you 10GB of
memory.

### 4. Getting SpECTRE set up for the first time

1. Download SpECTRE:

   ```sh
   git clone https://github.com/sxs-collaboration/spectre.git $HOME/spectre
   ```

2. Configure your environment on Oscar:

   ```sh
   echo 'export SPECTRE_HOME=$HOME/spectre' >> ~/.bashrc
   echo 'export SPECTRE_BUILD=$HOME/spectre/build' >> ~/.bashrc
   echo 'export PATH=$SPECTRE_BUILD/bin:$PATH' >> ~/.bashrc
   echo 'source $SPECTRE_HOME/support/Environments/oscar.sh' >> ~/.bashrc
   source ~/.bashrc
   ```

   (You'll want to do the next steps on a
   [compute node](#4-getting-an-interactive-compute-node)).

3. Load the SpECTRE modules:

   ```sh
   spectre_load_modules
   ```

   To make sure things loaded correctly run `module list`. You should see
   modules like `spectre-deps/oscar-2024-07` and `spec-exporter/spec-2024-07`
   loaded.

4. Configure the SpECTRE build directory:

   ```sh
   mkdir -p $SPECTRE_BUILD
   cd $SPECTRE_BUILD
   spectre_run_cmake
   ```

5. Now you can compile the code (on a
   [compute node](#4-getting-an-interactive-compute-node)). Compile the
   command-line interface (`cli`), the
   binary black hole executables (`bbh`), and several additional executables
   that we'll use in the tutorials:

   ```sh
   cd $SPECTRE_BUILD
   make -j2 cli
   make -j2 bbh
   make -j2 EvolveBurgers EvolveNewtonionEuler1D
   ```

   Things should compile quite quickly because we've set up a cache on Oscar.
   You can check the cache hit rate with `ccache -s`.

#### Getting set up again after disconnecting

Just run:

```sh
spectre_load_modules
```

Then you can compile and run the code, open Jupyter notebooks, etc.

#### Troubleshooting

If you run into issues, please ask a TA. Unfortunately with shared file systems
on clusters issues do arise. An easy thing to try when you run into issues is to
wipe the build directory and recompile:

1.  Delete the build directory (make sure you don't have any files in the build
    directory that you want to keep):

    ```sh
    rm -rf $SPECTRE_BUILD
    ```

2.  Go to step 4. above to reconfigure the build directory.

### 5. Connecting Jupyter Lab to Oscar

You have to run Jupyter notebooks/lab on a
[compute node](#3-getting-an-interactive-compute-node) since they can sometimes
have a lot of computation.

We offer a convenience bash script to help setup the Jupyter server. On the
compute node

```sh
cd $HOME/sxscon-2024-tutorials
./jupyter_setup.sh $SPECTRE_BUILD
```

After this, you'll need to open a new ssh connection in a separate terminal.
This script prints instructions on how to do this, and then how to open the
server in a local browser. You can also open the URL in VSCode if it is
connected to Oscar.

### 6. Connecting Paraview to Oscar

Unfortunately paraview is very strict when trying to do remote rendering
about the local and remote versions of the code being identical. This means
you'll need to download a specific version of paraview for this workshop,
even if you already have a different version installed.

You specifically need version 5.11.2 (https://www.paraview.org/download/).

If you are on linux, you can download it with

```sh
wget https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.11&type=binary&os=Linux&downloadFile=ParaView-5.11.2-MPI-Linux-Python3.9-x86_64.tar.gz
tar -xzf Paraview-5.11.2*
```

On macOS, choose the correct arch for your laptop (arm vs x86). The new
M(1/2/3) macs need arm. Older macs use x86.

Similar to running a [jupyter server](#5-connecting-jupyter-lab-to-oscar),
paraview needs to be run on a
[compute node](#3-getting-an-interactive-compute-node) as well.

We also offer a convenience bash script to help set this up

```sh
./paraview_setup.sh
```

If the port you were assigned is busy, you can rerun the script or pass
a specific port to the script. The output of the script will also tell
you what to run on your local machine to connect your local paraview to
the server (it'll also be a new ssh connection).
