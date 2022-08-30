# historical-air-photos-toronto

## Objective:

Create an interactive web map that allows readers to view and compare 
historical areal imagery for Toronto (hopefully going back as far 1947)

### Examples:

This is the only project I know of for Toronto that has done something that allows to easily compare layers
https://yuriyczoli.com/written_thoughts/2017/03/06/Toronto1954.html

This has some older maps (not air photos), and no slider, still really cool!
https://www.arcgis.com/apps/View/index.html?appid=d38469bfb363441d98b21f239adfd0a3

Mapbox has a pretty straightforward method for creating comparable maps, we just need to build the tiles! https://docs.mapbox.com/mapbox-gl-js/example/mapbox-gl-compare/


## Steps:

0. Do a bit of research to see what other examples there are out there online, beyond the couple I noted above. Even if they aren't focused on Toronto, it would be great to see how historical air photos/satellite imagery have been displayed online in other parts of the world

1. Research which years have historical air photos already geo-referenced. Check the Map and Data Library, Toronto Archives, and the Toronto Public Library to start. Create a simple table/spreadsheet with the results and links to where to download.

2. Based on 1), select which years to include. Ideally, we would have air photos for every decade or so (e.g. one for 47, one for the 50s, one for the 60s, etc.)

3. Figure out how to automate clipping out unneeded boundaries on air photos so they are one continuous surface. Check out this resource to start: http://yuriyczoli.com/written_thoughts/2017/03/25/RemovingUnwantedPixels.html 

4. Create a set of raster tiles for each year that we have. Will require some thought as to which zoom levels to include. Use the "Generate XYZ tiles (Directory)" tool in QGIS, it works quite well, but can be a little slow. Here's a very short tutorial: https://www.orrbodies.com/tutorial/generating-tiles-qgis/

5. Use Mapbox GL JS (https://docs.mapbox.com/mapbox-gl-js/) to create a web map that shows two maps with a slider that allows for dragging and comparing between them. (https://docs.mapbox.com/mapbox-gl-js/example/mapbox-gl-compare/). The map should have options for selecting a year (for each side) and toggling labels to the map.












