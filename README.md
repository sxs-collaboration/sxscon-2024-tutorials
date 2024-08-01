# Tutorials at SXScon 2024

This repo contains workshop material like Jupyter notebooks and input files used
for the SXS workshop at ICERM.

### Connecting to Oscar

You should already have an account on the cluster. (What will their password be?)

#### SSH Keys

First we'll want to generate an SSH key (if you don't already have one)

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Then, when prompted, put in a passphrase for this key. Then we want to
add the key to our agent

```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

#### Logging in to Oscar

First, let's copy our key to Oscar

```sh
ssh-copy-id -i ~/.ssh/id_ed25519 USER@sshcampus.ccv.brown.edu
```

You should be prompted for a password. (and maybe 2FA?) After this, you
should be able to access Oscar without entering a password

```sh
ssh USER@sshcampus.ccv.brown.edu
```

### Getting SpECTRE set up for the first time

1. Download SpECTRE:

   ```sh
   git clone https://github.com/sxs-collaboration/spectre.git $HOME/spectre
   ```

2. Configure your environment on Oscar:

   ```sh
   echo 'export SPECTRE_HOME=$HOME/spectre' >> ~/.bashrc
   echo 'export SPECTRE_BUILD=$HOME/spectre/build' >> ~/.bashrc
   echo 'source $SPECTRE_HOME/support/Environments/oscar.sh' >> ~/.bashrc
   source ~/.bashrc
   ```

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

5. Now you can compile the code. Compile the command-line interface (`cli`), the
   binary black hole executables (`bbh`), and several additional executables
   that we'll use in the tutorials:

   ```sh
   cd $SPECTRE_BUILD
   make -j2 cli
   make -j2 bbh
   make -j2 EvolveBurgers EvolveNewtonionEuler1D
   ```

   Things should compile quite quickly because we've set up a cache on Oscar.

### Getting set up again after disconnecting

Just run:

```sh
spectre_load_modules
```

Then you can compile and run the code, open Jupyter notebooks, etc.

### Troubleshooting

If you run into issues, please ask a TA. Unfortunately with shared file systems
on clusters issues do arise. An easy thing to try when you run into issues is to
wipe the build directory and recompile:

1.  Delete the build directory (make sure you don't have any files in the build
    directory that you want to keep):

    ```sh
    rm -rf $SPECTRE_BUILD
    ```

2.  Go to step 4. above to reconfigure the build directory.

### Connecting Jupyter notebooks to Oscar
