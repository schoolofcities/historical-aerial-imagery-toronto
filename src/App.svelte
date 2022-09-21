<script>
	import { onMount } from 'svelte';
	import Top from "./lib/Top.svelte";

	import {Map, View} from 'ol';
	import TileLayer from 'ol/layer/Tile';
	import OSM from 'ol/source/OSM';
	import {getRenderPixel} from 'ol/render';
	import {useGeographic} from 'ol/proj';
	import WMTS from 'ol/source/WMTS';
	import WMTSTileGrid from 'ol/tilegrid/WMTS';
	import {get as getProjection} from 'ol/proj';
	import {getWidth} from 'ol/extent';

	let lineBreak = 50;
	let pageWidth = 420;

	$: lineLeft = parseInt(pageWidth * (lineBreak / 100));

	$: console.log(lineLeft);


	onMount(() => {

		useGeographic();

		lineBreak = 50;

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

		const osm = new TileLayer({
				source: new OSM()
				});

		const t1965 =new TileLayer({
			opacity: 1,
			source: new WMTS({
				url: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1965/MapServer/WMTS/',
				layer: 'basemap_cot_historic_aerial_1965',
				matrixSet: 'default028mm',
				format: 'image/jpg',
				projection: 'EPSG:3857',
				tileGrid: tileGrid,
				style: 'default',
				attributions:
					'meow',
				})
		});

		const t2021 =new TileLayer({
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
					'cat',
				})
		});

		const map = new Map({
			target: 'map',
			layers: [osm, t1965, t2021],
			view: new View({
				center: [-79.395,43.66],
				zoom: 17
			})
		});

		const swipe = document.getElementById('swipe');

		t2021.on('prerender', function (event) {
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

		t2021.on('postrender', function (event) {
			const ctx = event.context;
			ctx.restore();
		});

		swipe.addEventListener('input', function () {
			map.render();
		});
	})

</script>

<svelte:head>
	<script src="https://unpkg.com/elm-pep@1.0.6/dist/elm-pep.js"></script>
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.8.0/dist/leaflet.css"
	integrity="sha512-hoalWLoI8r4UszCkZ5kL8vayOGVae1oxXe/2A4AO6J9+580uKHDO3JdHb7NzwwzK5xr/Fs0W40kiNHxM9vyTtQ=="
	crossorigin=""/>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin> 
	<link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
</svelte:head>




<main>

	<Top/>

	<input id="swipe" type="range" bind:value={lineBreak} style="width: 100%">

	<div id="line" style="left: {lineLeft}px;"></div>

	<div id="map" bind:offsetWidth={pageWidth}></div>
	
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

	main {
		margin: auto;
		width: 100%;
		/* margin-bottom: -15px; */
	}

	#map {
		/* margin-top: 50px; */
		height: 100%;
		width: 100%;
		top: 0;
        left: 0;
		position: absolute;
		z-index: -99;
	}

	#line {
		position: absolute;
		top: 0px;
		/* left: calc(var(--left)); */
		z-index: 0;
		width: 2px;
		height: 100%;
		background-color: #AB1368;
	}

	#swipe {
		background-color: none;
		margin-top: 50px;
		z-index: 99;
	}
	
	
</style>
