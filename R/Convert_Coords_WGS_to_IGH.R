Convert_Coords_WGS_to_IGH <- function(coords, long_lat.names = c("longitude", "latitude")) {
    # Set wgs84 proj to long/lat coords
  coords_wgs <- terra::vect(coords, geom = long_lat.names, crs = "epsg:4326")
  
    # Convert long/lat coords into igh (homolosine goode) projection
  coords_igh <- terra::project(coords_wgs, "+proj=igh +datum=WGS84 +no_defs +towgs84=0,0,0")

    # Convert SpatVector into a coords dataframe and rename columns
  coords_igh_df <- terra::crds(coords_igh, df = TRUE)
  names(coords_igh_df) <- paste(names(coords_igh_df), "igh", sep="_")
  
    # Bind coords in both system
  coords <- cbind(coords, coords_igh_df)
  return(coords)
}


Convert_Coords_IGH_to_WGS <- function(coords, x_y.names = c("x", "y")) {
  # Set igh proj to coords
  coords_igh <- terra::vect(coords, geom = x_y.names, crs = "+proj=igh +datum=WGS84 +no_defs +towgs84=0,0,0")
  
  # Convert ign coordqs into long/lat coords
  coords_wgs <- terra::project(coords_igh, "epsg:4326")
  
  # Convert SpatVector into a coords dataframe and rename columns
  coords_wgs_df <- terra::crds(coords_wgs, df = TRUE)
  names(coords_wgs_df) <- paste(names(coords_wgs_df), "wgs", sep="_")
  
  # Bind coords in both system
  coords <- cbind(coords, coords_wgs_df)
  return(coords)
}
