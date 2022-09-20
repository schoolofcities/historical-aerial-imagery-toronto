<script>
	import { onMount } from 'svelte';
	import Top from "./lib/Top.svelte";

	import {Map, View} from 'ol';
	import TileLayer from 'ol/layer/Tile';
	import OSM from 'ol/source/OSM';
	import {getRenderPixel} from 'ol/render';
	import {useGeographic} from 'ol/proj';
	import TileWMS from 'ol/source/TileWMS';
	import WMTS from 'ol/source/WMTS';
	import WMTSTileGrid from 'ol/tilegrid/WMTS';
	import {fromLonLat, get as getProjection} from 'ol/proj';
	import {getWidth} from 'ol/extent';


	// mapboxgl.accessToken = 'pk.eyJ1Ijoic2Nob29sb2ZjaXRpZXMiLCJhIjoiY2w3aml0dHdlMHlpazNwbWh0em4xOHNlaCJ9.fXNtPGq0DqYiFvPH6p4fjQ';

	// const data = Places.features;

	// let map;
	// let ctuid = "0";

	// let pageWidth;
	
	onMount(() => {
		// var map = L.map('map').setView([43.672, -79.384], 15);

		// var osm = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {});

		// var cart = L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {});

		// cart.addTo(map);

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

		const osm2 = new TileLayer({
				source: new OSM()
				});
		const osm = new TileLayer({
				source: new OSM()
				});

		const t1965 =new TileLayer({
			// extent: [-13884991, 2870341, -7455066, 6338219],
			opacity: 1,
			// source: new WMTS({
			// 	url: 'https://wxs.ign.fr/choisirgeoportail/geoportail/wmts',
			// 	layer: 'GEOGRAPHICALGRIDSYSTEMS.PLANIGNV2',
			// 	matrixSet: 'PM',
			// 	format: 'image/png',
			// 	projection: 'EPSG:3857',
			// 	tileGrid: tileGrid,
			// 	style: 'normal',
			// 	attributions:
			// 		'meow',
			// 	})
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

		const map = new Map({
			target: 'map',
			layers: [t1965, osm],
			view: new View({
				center: [-79.42,43.66],
				zoom: 12
			})	
		});

		const swipe = document.getElementById('swipe');

		osm.on('prerender', function (event) {
			const ctx = event.context;
			const mapSize = map.getSize();
			const width = mapSize[0] * (swipe.value / 100);
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

		osm.on('postrender', function (event) {
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
	<!-- <Top/> -->

	<input id="swipe" type="range" style="width: 100%">

	<div id="map"></div>

	
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

	#swipe {
		background-color: none;
	}
	
	
</style>
