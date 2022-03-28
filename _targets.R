# _targets.R file
library(targets)

library(future)
library(future.callr)
plan(callr)

# Source functions in R folder
lapply(grep("R$", list.files("R", recursive = TRUE), value = TRUE), function(x) source(file.path("R", x)))

# Set options (i.e. clustermq.scheduler for multiprocess computing)
options(tidyverse.quiet = TRUE, clustermq.scheduler = "multiprocess")

tar_option_set(packages = c("dplyr", "data.table", "terra", 
                            "rgdal", "purrr"))


# List of targets
list(
  
  ### Get all coordinates
  tar_target(coords_fp, "data/data_coord_plots_test.csv"),
  tar_target(coords, fread(coords_fp)),

  ##############################################################################
  ############################## SOIL DATA #####################################
  ##############################################################################

    # Dynamic branching through variables, depths and values
  tar_target(sg_var, c("nitrogen", "phh2o", "soc", "cec")),
  tar_target(sg_depth, c("0-5cm", "5-15cm", "15-30cm")),
  tar_target(sg_value, c("mean", "uncertainty")),

    # Convert coords from WGS84 to Goode homolosine
  tar_target(coords_igh, Convert_Coords_WGS_to_IGH(coords)),
  
    # Extract variables for each var, each depth and each group of coords (within the same tile, cf previous target)
  tar_target(sg_raw, Extract_SoilGrids_from_Serv_var_depth_value(coords_igh, sg_var, sg_depth, sg_value, 
                                                                 "/vsicurl/https://files.isric.org/soilgrids/latest/data"), pattern = cross(sg_var, sg_depth, sg_value), iteration = "list"),

    # Merge list of datasets for each var and depth into a single dataframe
  tar_target(sg_merged, Merge_SoilGrids(sg_raw)),

    # Rescale SoilGrids datasets
  tar_target(sg_rescaled, Rescale_SoilGrids(sg_merged)),

    # Compute weighted mean for all variables
  tar_target(data_soil, Compute_SoilGrids_WeightedMean(sg_rescaled, sg_var)),

    # Save soil dataset
  tar_target(data_soil_filepath, Save_Soil_Dataset(data_soil, "output/data_soil.csv"))
)

