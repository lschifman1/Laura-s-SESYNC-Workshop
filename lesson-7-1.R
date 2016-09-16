# Reading shapefiles into R

library(rgdal)
## first argument is the file path, the second is the layer file
counties_md <- readOGR("data/cb_500k_maryland", 
                       "cb_500k_maryland")


# Basic spatial plots

plot(counties_md)

howard <- counties_md[counties_md[["NAME"]]=="Howard", ]
plot(howard, col="red", add=T)
text(coordinates(ranked),labels = ranked[["NAME"]], cex = 0.7)

# Exercise

# Starting from a fresh map, print numbers on each county in order of
#  the smallest (1) to largest (24) in land area ("ALAND" attribute). 
# Hint: Use `rank(x)` to get ranks from a numeric vector x.

rank(counties_md$ALAND) -> ranks
plot(counties_md)
text(coordinates(counties_md),labels = ranks,cex=0.7)
# Reading rasters into R

library(raster)

nlcd <- raster("data/nlcd_agg.grd")

plot(nlcd)

attr_table <- nlcd@data@attributes[[1]]


# Change projections

proj4string(counties_md)
proj4string(nlcd)

counties_proj <- spTransform(counties_md, proj4string(nlcd))

plot(nlcd)
plot(counties_proj, add=T)


# Masking a raster

pasture <- mask(nlcd, nlcd==81, maskvalue = F)
plot(pasture)

# Exercise

# Create a mask for a different land cover class. 
#  Look up the numeric ID for a specific class in attr_table.

water <- mask(nlcd, nlcd==11, maskvalue = F)
plot(water)


# Adding data to maps with tmap

library(tmap)

qtm(counties_proj)

qtm(counties_proj, fill = "AWATER", text = "NAME")

map1 <- tm_shape(counties_proj) +
            tm_borders() +
            tm_fill("AWATER", title = "Water Area (sq. m)") +
            tm_text("NAME", size = 0.7)
map1

map1 +
    tm_style_classic(legend.frame = TRUE) +
    tm_scale_bar(position =c("left", "top"))

# Exercise

# The color scales in tmap are divided into bins by default. 
# Look at the help file for tm_fill: help("tm_fill") to find which argument
#  controls the binning scale. How can you change it to a continuous gradient?

map1 <- tm_shape(counties_proj) +
  tm_borders() +
  tm_fill("AWATER", style="cont",title = "Water Area (sq. m)") +
  tm_text("NAME", size = 0.7)
map1

map1 +
  tm_style_classic(legend.frame = TRUE) +
  tm_scale_bar(position =c("left", "top"))


# Interactive maps with leaflet

library(leaflet)

imap <- leaflet() %>%
            addTiles() %>%
            setView(lng = -76.505206, lat = 38.9767231, zoom = 7)
imap
##YOU CAN CHECK THE WEATHER WITH THIS! 
imap %>%
    addWMSTiles(
        "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
        layers = "nexrad-n0r-900913", group = "base_reflect",
        options = WMSTileOptions(format = "image/png", transparent = TRUE),
        attribution = "Weather data © 2012 IEM Nexrad"
    )
