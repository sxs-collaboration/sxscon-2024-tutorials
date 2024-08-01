# Tutorials at SXScon 2024

This repo contains files like Jupyter notebooks and input files used for the SXS workshop at ICERM.



### Getting SpECTRE set up for the first time
1. Connect to Oscar, `ssh USER@ssh.ccv.brown.edu`
2. Run `echo 'export SPECTRE_HOME=$HOME/spectre' >> ~/.bashrc` and `echo 'export SPECTRE_BUILD=$HOME/spectre/build' >> ~/.bashrc`
3. Run `git clone https://github.com/sxs-collaboration/spectre.git $SPECTRE_HOME`
4. Run `mkdir -p $SPECTRE_BUILD`
5. Go to the build directory by running `cd $SPECTRE_BUILD`
6. Source the environement by running `source $SPECTRE_HOME/support/Environments/oscar.sh` and run `spectre_load_modules`. To make sure things loaded correctly run `module list`. You should see modules like `spectre-deps/oscar-2024-07` and `spec-exporter/spec-2024-07` loaded.
7. First, we need to get CMake to configure the build directory. Run `cd $SPECTRE_BUILD && spectre_run_cmake`
8. First build the Python bindings by running `cd $SPECTRE_BUILD && make -j2 cli`. Things should compile without issue and quite quickly because we've set up a cache on Oscar.
9. Now compile the binary black hole executable by running `cd $SPECTRE_BUILD && make -j2 EvolveGhBinaryBlackHole`. Things should compile without issue and quite quickly because we've set up a cache on Oscar.
10. The tutorials need several additional targets built. Run `cd $SPECTRE_BUILD && make -j2 EvolveBurgers EvolveNewtonionEuler1D` to compile them.

### Getting set up again after disconnecting
1. Run `source $SPECTRE_HOME/support/Environments/oscar.sh && spectre_load_modules && cd $SPECTRE_BUILD`
2. In general everything should remain in a working state. If you run into issues, please ask a TA. Unfortunately with shared file systems on clusters issues do arise. An easy thing to test is to run `rm -rf $SPECTRE_BUILD/* && spectre_run_cmake` and then recompile the code.

### Connecting Jupyter notebooks to Oscar
