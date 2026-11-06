# Terrain Analysis of Nigeria with GDAL

A reproducible terrain analysis of Nigeria built entirely with the GDAL command line, using SRTM elevation data. Developed as a GDAL capstone project.

## Outputs

| Product | GDAL tool | Description |
| --- | --- | --- |
| Reprojected DEM | gdalwarp | SRTM reprojected to UTM Zone 32N at 90 m |
| Hillshade | gdaldem hillshade | Shaded relief, sun from the northwest (315°, 45°) |
| Slope | gdaldem slope | Steepness in degrees |
| Aspect | gdaldem aspect | Direction each slope faces (0–360°) |
| TRI | gdaldem TRI | Terrain Ruggedness Index |
| TPI | gdaldem TPI | Topographic Position Index (ridges +, valleys −) |
| Roughness | gdaldem roughness | Max elevation difference in a 3×3 window |
| Contours | gdal_contour | 100 m contour lines (GeoPackage) |

## Data

- **DEM:** SRTM 3 arc-second (~90 m), masked to Nigeria's boundary in ArcGIS Pro
- **Input:** nigeria_srtm.vrt (virtual raster pointing to the masked SRTM)
- **Output CRS:** WGS 84 / UTM Zone 32N (EPSG:32632), 90 m resolution
- Raster data is not stored in this repository because of file size. SRTM is freely available from NASA Earthdata (search.earthdata.nasa.gov).

## Requirements

GDAL installed through conda:

    conda create -n gdal -c conda-forge gdal
    conda activate gdal

## How to run

1. Place nigeria_srtm.vrt and the nigeria_srtm data folder in the project folder
2. Open a GDAL-enabled command prompt in that folder
3. Run:

       terrain_workflow.bat

Outputs are written to nigeria_terrain\

## Workflow

1. **gdalwarp** reprojects the DEM from WGS 84 to UTM Zone 32N at 90 m, so slope and distances are calculated in metres
2. **gdaldem** derives hillshade, slope, aspect, TRI, TPI and roughness, with -compute_edges to keep border pixels
3. **gdal_contour** extracts 100 m contour lines with an elev_m attribute
4. **gdalinfo -stats** reports summary statistics for each product

All outputs use DEFLATE compression and internal tiling.

## Maps

See the maps/ folder.

## Author

Friday Imaji Igbah 
GIS and Remote Sensing