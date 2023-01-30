## historical-aerial-imagery-toronto

A simple web app for comparing historical aerial imagery (i.e. air photos) in the City of Toronto. Built for teaching and research purposes at the School of Cities, but made openly available for anyone interested in Toronto history.

https://schoolofcities.github.io/historical-aerial-imagery-toronto/

### Data Sources:

Imagery for [1947](https://mdl.library.utoronto.ca/collections/geospatial-data/toronto-aerial-photographs-1947-black-and-white-and-colourized) comes from the University of Toronto's Map and Data Library. We additionally processed these by clipping and combining them into a single raster tile package.

Images for all other years are sourced from the [City of Toronto](https://open.toronto.ca/dataset/web-map-services/). These are shared as WMTS (Web Map Tiled Services):

- [1954](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1954/MapServer/WMTS/)

- [1965](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1965/MapServer/WMTS/)

- [1978](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1978/MapServer/WMTS/)

- [2011](https://gis.toronto.ca/arcgis/rest/services/primary/cot_ortho_2011_color_10cm_webm/MapServer/WMTS/)

- [2021](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho/MapServer/WMTS)

