@echo off
REM GDAL terrain analysis of Nigeria (SRTM 90 m)
REM Run from the project folder in a GDAL-enabled prompt

if not exist nigeria_terrain mkdir nigeria_terrain

echo Reprojecting DEM to UTM Zone 32N...
gdalwarp -overwrite -t_srs EPSG:32632 -tr 90 90 -r bilinear -dstnodata -9999 -ot Float32 -multi -wo NUM_THREADS=ALL_CPUS -co COMPRESS=DEFLATE -co TILED=YES -co BIGTIFF=IF_SAFER nigeria_srtm.vrt nigeria_dem_utm.tif

echo Creating terrain derivatives...
gdaldem hillshade nigeria_dem_utm.tif nigeria_terrain\hillshade.tif -compute_edges -co COMPRESS=DEFLATE -co TILED=YES
gdaldem slope nigeria_dem_utm.tif nigeria_terrain\slope.tif -compute_edges -co COMPRESS=DEFLATE -co TILED=YES
gdaldem aspect nigeria_dem_utm.tif nigeria_terrain\aspect.tif -compute_edges -zero_for_flat -co COMPRESS=DEFLATE -co TILED=YES
gdaldem TRI nigeria_dem_utm.tif nigeria_terrain\tri.tif -compute_edges -co COMPRESS=DEFLATE -co TILED=YES
gdaldem TPI nigeria_dem_utm.tif nigeria_terrain\tpi.tif -compute_edges -co COMPRESS=DEFLATE -co TILED=YES
gdaldem roughness nigeria_dem_utm.tif nigeria_terrain\roughness.tif -compute_edges -co COMPRESS=DEFLATE -co TILED=YES

echo Generating 100 m contours...
if exist nigeria_terrain\contours_100m.gpkg del nigeria_terrain\contours_100m.gpkg
gdal_contour -a elev_m -i 100 -f GPKG nigeria_dem_utm.tif nigeria_terrain\contours_100m.gpkg

echo Done. Outputs are in nigeria_terrain\