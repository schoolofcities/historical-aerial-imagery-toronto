<script>
	import { onMount } from 'svelte';
	import Top from "./lib/Top.svelte";
	import notToronto from "./assets/not_toronto.geo.json"

	import {Map, View} from 'ol';
	import TileLayer from 'ol/layer/Tile';
	import {Fill, Stroke, Style} from 'ol/style';
	import {getRenderPixel} from 'ol/render';
	import {useGeographic} from 'ol/proj';
	import WMTS from 'ol/source/WMTS';
	import WMTSTileGrid from 'ol/tilegrid/WMTS';
	import {get as getProjection} from 'ol/proj';
	import {getWidth} from 'ol/extent';
	import GeoJSON from 'ol/format/GeoJSON';
	import VectorLayer from 'ol/layer/Vector';
	import VectorSource from 'ol/source/Vector';

	let lineBreak = 50;
	let pageWidth = 420;
	let leftYear = 1954;
	let map = 0;
	let load = 0;

	useGeographic();

	const resolutions = [];
	const matrixIds = [];
	const proj3857 = getProjection('EPSG:3857');
	const maxResolution = getWidth(proj3857.getExtent()) / 256;

	for (let i = 0; i < 20; i++) {
		matrixIds[i] = i.toString();
		resolutions[i] = maxResolution / Math.pow(2, i);
	}

	const tileGrid = new WMTSTileGrid({
		origin: [-20037508, 20037508],
		resolutions: resolutions,
		matrixIds: matrixIds,
	});

	const sources = {
		'1965': {
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1965/MapServer/WMTS/',
			'layer': 'basemap_cot_historic_aerial_1965',
			'matrixSet': 'default028mm'
		},
		'1954': {
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1954/MapServer/WMTS/',
			'layer': 'basemap_cot_historic_aerial_1954',
			'matrixSet': 'default028mm'
		}
	}

	var features = new GeoJSON().readFeatures(notToronto, {
		});

		var vectorSource = new VectorSource({
			features
		});

		const style = new Style({
			fill: new Fill({
				color: '#fff',
			}),
			stroke: new Stroke({
				color: '#0D534D',
				width: 2
			})
		});

		var vectorLayer = new VectorLayer({
			source: vectorSource,
			style: style
		});
		
	$: lineLeft = parseInt(pageWidth * (lineBreak / 100) + 1);

	var leftLayer = new TileLayer({
			opacity: 1,
			source: new WMTS({
				url: sources[leftYear]['url'],
				layer: sources[leftYear]['layer'],
				matrixSet: sources[leftYear]['matrixSet'],
				format: 'image/jpg',
				projection: 'EPSG:3857',
				tileGrid: tileGrid,
				style: 'default',
				attributions:
					'meow',
			})
		});

	var rightLayer = new TileLayer({
		opacity: 1,
		source: new WMTS({
			url: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho/MapServer/WMTS',
			layer: 'basemap_cot_ortho',
			matrixSet: 'default028mm',
			format: 'image/jpg',
			projection: 'EPSG:3857',
			tileGrid: tileGrid,
			style: 'default',
			attributions:
				'School of Cities | OpenStreetMap | City of Toronto | Map and Data Library | Jeff Allen',
			})
	});

	onMount(() => {

		load = 1;

		map = new Map({
			target: 'map',
			layers: [leftLayer, rightLayer, vectorLayer],
			view: new View({
				center: [-79.39676,43.66],
				zoom: 13,
				maxZoom: 19,
				minZoom: 12
			})
		});

		const swipe = document.getElementById('swipe');

		rightLayer.on('prerender', function (event) {
			const ctx = event.context;
			const mapSize = map.getSize();
			const width = mapSize[0] * (lineBreak / 100);
			const tl = getRenderPixel(event, [width, 0]);
			const tr = getRenderPixel(event, [mapSize[0], 0]);
			const bl = getRenderPixel(event, [width, mapSize[1]]);
			const br = getRenderPixel(event, mapSize);

			ctx.save();
			ctx.beginPath();
			ctx.moveTo(tl[0], tl[1]);
			ctx.lineTo(bl[0], bl[1]);
			ctx.lineTo(br[0], br[1]);
			ctx.lineTo(tr[0], tr[1]);
			ctx.closePath();
			ctx.clip();
		});

		rightLayer.on('postrender', function (event) {
			const ctx = event.context;
			ctx.restore();
		});
		
		swipe.addEventListener('input', function () {
			map.render();
		});

	})

	function layerSwitch() {
		if (load > 0) {
			console.log(leftYear)
			console.log("meow")

			map.removeLayer(leftLayer);
			map.removeLayer(rightLayer);

			leftLayer = new TileLayer({
				opacity: 1,
				source: new WMTS({
					url: sources[leftYear]['url'],
					layer: sources[leftYear]['layer'],
					matrixSet: sources[leftYear]['matrixSet'],
					format: 'image/jpg',
					projection: 'EPSG:3857',
					tileGrid: tileGrid,
					style: 'default',
					attributions:
						'meow',
				})
			});
			map.addLayer(leftLayer);

			rightLayer = new TileLayer({
				opacity: 1,
				source: new WMTS({
					url: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho/MapServer/WMTS',
					layer: 'basemap_cot_ortho',
					matrixSet: 'default028mm',
					format: 'image/jpg',
					projection: 'EPSG:3857',
					tileGrid: tileGrid,
					style: 'default',
					attributions:
						'School of Cities | OpenStreetMap | City of Toronto | Map and Data Library | Jeff Allen',
					})
			});
			map.addLayer(rightLayer);

			rightLayer.on('prerender', function (event) {
				const ctx = event.context;
				const mapSize = map.getSize();
				const width = mapSize[0] * (lineBreak / 100);
				const tl = getRenderPixel(event, [width, 0]);
				const tr = getRenderPixel(event, [mapSize[0], 0]);
				const bl = getRenderPixel(event, [width, mapSize[1]]);
				const br = getRenderPixel(event, mapSize);

				ctx.save();
				ctx.beginPath();
				ctx.moveTo(tl[0], tl[1]);
				ctx.lineTo(bl[0], bl[1]);
				ctx.lineTo(br[0], br[1]);
				ctx.lineTo(tr[0], tr[1]);
				ctx.closePath();
				ctx.clip();
			});

			rightLayer.on('postrender', function (event) {
				const ctx = event.context;
				ctx.restore();
			});

			map.removeLayer(vectorLayer);
			map.addLayer(vectorLayer);
		}
	}

	$: leftYear && layerSwitch()

</script>





<main>

	<Top/>

	<div id="map" bind:offsetWidth={pageWidth}></div>

	<div id="range">
		<input id="swipe" type="range" bind:value={lineBreak} style="width: 100%">
	</div>

	<div id="left-select">

		<label>
			<input type=radio bind:group={leftYear} value={1954}>
			1954
		</label>
		
		<label>
			<input type=radio bind:group={leftYear} value={1965}>
			1965
		</label>
		
		<!-- <label>
			<input type=radio bind:group={leftYear} value={2021}>
			2021
		</label> -->

	</div>

</main>











<style>

	@import "../node_modules/ol/ol.css";
	
	@font-face {
		font-family: TradeGothicBold;
		src: url("./assets/Trade Gothic LT Bold.ttf");
	}
	:root {
		font-family: 'Roboto', sans-serif;
	}
	
	:global(body) {
		overflow: hidden;
	}

	main {
		margin: 0px;
		padding: 0px;
		width: 100%;
		max-width: 100%;
		overflow: hidden;
	}

	#map {
		height: calc(100vh);
		width: calc(100vw);
		top: 0;
        left: 0;
		position: absolute;
		z-index: -99;
		margin: 0px;
	}

	#range {
		position: absolute;
		bottom: 0px;
		width: calc(100vw - 2px);
		margin-left: -10px;
		margin-right: -4px;
		z-index: 99;
	}

	#swipe {
		z-index: -99;
		height: 0px;
	}

	input[type="range"] {
		height: 0px;
	}

	input[type="range"]::-moz-range-thumb {
		border: solid 1px #0D534D;
		background-color: white;
		border-radius: 2px;
		height: calc(2 * 100vh);
		width: 10px;
		cursor: grab;
		/* background-image: url('./assets/arrows.png'); */
		/* background-repeat:no-repeat; */
		/* background-position: center center; */
		box-shadow: 2px 0px 3px #0d534d7b, -2px 0px 3px #0d534d7b;
	}
	input[type="range"]::-moz-range-thumb:hover {
		background-color: white;
	}

	input[type="range"]::-moz-range-track {
		height: 2px;
		background-color: white;
		z-index: 10
	}
	
</style>
