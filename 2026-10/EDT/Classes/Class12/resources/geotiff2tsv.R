# Install terra if you don't have it: install.packages("terra")
library(terra)

# 1. Configuration - Set your file paths here
input_file <- "input.tif"
output_file <- "output.tsv"

# 2. Load the GeoTIFF
# 'rast' reads the file as a SpatRaster object
r <- rast(input_file)

message("Converting raster to data frame...")

# 3. Convert to a Data Frame
# xy = TRUE: Includes the x and y coordinates (longitude/latitude or projected)
# na.rm = TRUE: Automatically drops "NoData" pixels to save space
df <- as.data.frame(r, xy = TRUE, na.rm = TRUE)

# 4. Rename columns for clarity (Optional)
# Usually, terra uses the layer name for the value column.
colnames(df) <- c("x", "y", "value")

# 5. Write to TSV
# sep = "\t" creates the tab-separated format
# row.names = FALSE prevents R from adding an extra column of indices
write.table(df, 
            file = output_file, 
            sep = "\t", 
            row.names = FALSE, 
            quote = FALSE)

message(paste("Success! File saved to:", output_file))