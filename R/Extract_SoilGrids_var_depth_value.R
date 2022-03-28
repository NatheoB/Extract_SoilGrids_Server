Extract_SoilGrids_from_Serv_var_depth_value <- function(coords, var, depth, value, rast_folderpath)
{
    # Load the raster
  rast_filepath <- file.path(rast_folderpath, var, paste0(var, "_", depth, "_", value, ".vrt"))
  rast <- terra::rast(rast_filepath)
  
    # Get value in the raster
  data_sg <- terra::extract(rast, coords[,c("x_igh", "y_igh")])[-1] # First column is ID : we don't mind
  names(data_sg) <- paste(var, depth, value, sep="_")

    # Bind with the coord dataset
  data_sg <- cbind(plotcode = coords$plotcode, data_sg)
  
  return(list(var = var, depth = depth, value = value, data = data_sg))
}