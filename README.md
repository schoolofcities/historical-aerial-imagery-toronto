## historical-aerial-imagery-toronto

A simple web app for comparing historical aerial imagery (i.e. air photos) in the City of Toronto. Built for teaching and research purposes at the School of Cities, but made openly available for anyone interested in Toronto history.

https://schoolofcities.github.io/historical-aerial-imagery-toronto/

### Data Sources:

Imagery for [1947](https://mdl.library.utoronto.ca/collections/geospatial-data/toronto-aerial-photographs-1947-black-and-white-and-colourized) comes from the University of Toronto's Map and Data Library. We additionally processed these by clipping and combining them into a single raster tile package.

Imagery for [1985](https://www.toronto.ca/city-government/accountability-operations-customer-service/access-city-information-or-records/city-of-toronto-archives/whats-online/maps/aerial-photographs/aerial-photographs-1985/) comes from the City of Toronto Archives. We additionally processed these images by clipping and geo-referencing them, and then combing them into a single raster tile package.

Imagery for [1995](https://mdl.library.utoronto.ca/collections/air-photos/greater-toronto-and-golden-horseshoe-colour-digital-orthophotos) comes from the University of Toronto's Map and Data Library. We additionally processed these by combining them into a single raster tile package. The same imagery is also available as open data via [Ontario GeoHub](https://geohub.lio.gov.on.ca/documents/05abf73ee4c84b8088e953c2a3cbc93f/about)

Images for all other years are sourced from the [City of Toronto](https://open.toronto.ca/dataset/web-map-services/). Note that for 1939 we blacked-out a significant portion of the imagery that was not geo-referenced properly.

- [1939](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1939/MapServer) 

- [1954](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1954/MapServer)

- [1965](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1965/MapServer)

- [1978](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1978/MapServer)

- [1999](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_1999_greyscale_15cm/MapServer)

- [2005](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2005_color_20cm/MapServer)

- [2009](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2009_color_10cm/MapServer)

<!-- - [2011](https://gis.toronto.ca/arcgis/rest/services/primary/cot_ortho_2011_color_10cm_webm/MapServer/WMTS/) -->

- [2012](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2012_color_5cm/MapServer)

- [2018](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2018_color_8cm/MapServer)

- [2020](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_2020_NightTimeLight_20cm/MapServer)

- [2022](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2022_color_8cm/MapServer)

- [2024](https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2024_color_8cm/MapServer)

Labels on the maps are derived from the City of Toronto's [Centerline](https://open.toronto.ca/dataset/toronto-centreline-tcl/) data.


### Development

```
git clone https://github.com/schoolofcities/historical-aerial-imagery-toronto
cd historical-aerial-imagery-toronto
npm install
npm run dev
```

