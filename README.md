# Extract_SoilGrids_Server
Extract soilgrids variables directly from the server there are stored and compute an incertainty-weighted mean over considered horizons

# Inputs
Coord file with columns longitude and latitude

# What it does :
* Convert lat/long into Goode homolosine (soilgrids proj system)
* Extract sg data from the soilgrids server for each var, depth and value
* Rescale soilgrids variables
* Compute an incertainty-weighted mean over considered horizons 

# How to :
* Set the correct filepath for you coords file
* Set the interest variable, depth and values (mean, quantiles etc...) you want to extract
* Run in a single process using tar_make() or in multiprocess using tar_make_future(workers = N) (N is the nb of process to use)

natheo.beauchamp@inrae.fr
beauchamp.natheo@gmail.com
