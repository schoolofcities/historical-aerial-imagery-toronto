<script>
	import { onMount } from 'svelte';
	import Title from "./lib/Title.svelte";
	import Information from "./lib/Information.svelte";
	import Select from 'svelte-select';

	import "./ol.css";

	import notToronto from "./assets/not_toronto.geo.json"

	import {Map, View} from 'ol';
	import TileLayer from 'ol/layer/Tile';
	import {Fill, Stroke, Style} from 'ol/style';
	import {getRenderPixel} from 'ol/render';
	import {useGeographic} from 'ol/proj';
	import WMTS from 'ol/source/WMTS';
	import XYZ from 'ol/source/XYZ';
	import WMTSTileGrid from 'ol/tilegrid/WMTS';
	import {get as getProjection} from 'ol/proj';
	import {getWidth} from 'ol/extent';
	import GeoJSON from 'ol/format/GeoJSON';
	import VectorLayer from 'ol/layer/Vector';
	import VectorSource from 'ol/source/Vector';

	import ZoomSlider from 'ol/control/ZoomSlider';
	import {defaults as defaultControls} from 'ol/control';
	import {ScaleLine} from 'ol/control';


	let lineBreak = 50;
	let pageWidth = 420;
	
	let map = 0;
	let load = 0;

	let leftYear = 1947;
	const leftYearSet = [
		1947, 1954, 1965, 1978, 2011, 2021
	];
	function handleSelectLeft(event) {
		console.log('selected item', event.detail);
		leftYear = event.detail.value
	}

	let rightYear = 2021;
	let rightYearSet = [
		1947, 1954, 1965, 1978, 2011, 2021
	];
	function handleSelectRight(event) {
		console.log('selected item', event.detail);
		rightYear = event.detail.value
	}


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
		'1954': {
			'type': 'WMTS',
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1954/MapServer/WMTS/',
			'layer': 'basemap_cot_historic_aerial_1954',
			'matrixSet': 'default028mm'
		},
		'1965': {
			'type': 'WMTS',
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1965/MapServer/WMTS/',
			'layer': 'basemap_cot_historic_aerial_1965',
			'matrixSet': 'default028mm'
		},
		'1978': {
			'type': 'WMTS',
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1978/MapServer/WMTS/',
			'layer': 'basemap_cot_historic_aerial_1978',
			'matrixSet': 'default028mm'
		},
		'2011': {
			'type': 'WMTS',
			'url': 'https://gis.toronto.ca/arcgis/rest/services/primary/cot_ortho_2011_color_10cm_webm/MapServer/WMTS/',
			'layer': 'primary_cot_ortho_2011_color_10cm_webm',
			'matrixSet': 'default028mm'
		},
		'2021': {
			'type': 'WMTS',
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho/MapServer/WMTS',
			'layer': 'basemap_cot_ortho',
			'matrixSet': 'default028mm'
		},

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
	
	var leftSource;
	if (leftYear !== 1947) {
		leftSource = new WMTS({
			url: sources[leftYear]['url'],
			layer: sources[leftYear]['layer'],
			matrixSet: sources[leftYear]['matrixSet'],
			format: 'image/jpg',
			projection: 'EPSG:3857',
			tileGrid: tileGrid,
			style: 'default'
		});
	} else {
		console.log("moo");
		leftSource = new XYZ({
			url:
			'https://maps.library.utoronto.ca/tiles1947/{z}/{x}/{y}.png'
		});
	}

	var leftLayer = new TileLayer({
			opacity: 1,
			source: leftSource
		});

	var rightLayer = new TileLayer({
		opacity: 1,
		source: new WMTS({
			url: sources[rightYear]['url'],
			layer: sources[rightYear]['layer'],
			matrixSet: sources[rightYear]['matrixSet'],
			format: 'image/jpg',
			projection: 'EPSG:3857',
			tileGrid: tileGrid,
			style: 'default'
		})
	});

	onMount(() => {

		load = 1;

		map = new Map({
			target: 'map',
			layers: [leftLayer, rightLayer, vectorLayer],
			view: new View({
				center: [-79.3792,43.6450],
				zoom: 16,
				maxZoom: 18.99,
				minZoom: 12,
				extent: [-79.8302,43.3046,-78.9160,44.0295],
			}),
			controls: defaultControls().extend([new ZoomSlider()])
		});

		map.addControl(new ScaleLine({units: 'metric', maxWidth: 75}));

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

			map.removeLayer(leftLayer);
			map.removeLayer(rightLayer);

			var leftSource;
			if (leftYear !== 1947) {
				leftSource = new WMTS({
					url: sources[leftYear]['url'],
					layer: sources[leftYear]['layer'],
					matrixSet: sources[leftYear]['matrixSet'],
					format: 'image/jpg',
					projection: 'EPSG:3857',
					tileGrid: tileGrid,
					style: 'default'
				});
			} else {
				console.log("moo");
				leftSource = new XYZ({
					url:
					'https://maps.library.utoronto.ca/tiles1947/{z}/{x}/{y}.png'
				});
			}

			leftLayer = new TileLayer({
				opacity: 1,
				source: leftSource
			});
			map.addLayer(leftLayer);

			var rightSource;
			if (rightYear !== 1947) {
				rightSource = new WMTS({
					url: sources[rightYear]['url'],
					layer: sources[rightYear]['layer'],
					matrixSet: sources[rightYear]['matrixSet'],
					format: 'image/jpg',
					projection: 'EPSG:3857',
					tileGrid: tileGrid,
					style: 'default'
				});
			} else {
				console.log("moo");
				rightSource = new XYZ({
					url:
					'https://maps.library.utoronto.ca/tiles1947/{z}/{x}/{y}.png'
				});
			}

			rightLayer = new TileLayer({
				opacity: 1,
				source: rightSource
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
	$: rightYear && layerSwitch()

	$: lineLeft = parseInt(pageWidth * (lineBreak / 100) -2 );

</script>



<svelte:head>
	<meta name="viewport" content="width=device-width; initial-scale=1.0;">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin> 
	<link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
</svelte:head>





<main>

	<Title/>

	<Information/>

	<div id="line" style="left: {lineLeft}px" ></div>


	<div id="map" bind:offsetWidth={pageWidth}></div>

	<div id="range">
		<input id="swipe" type="range" bind:value={lineBreak} style="width: 100%">
	</div>

	<div id="left-select" class="select">

		<Select 
			items={leftYearSet} 
			value="1947"
			isSearchable={false}
			isClearable={false}
			on:select={handleSelectLeft}
		>
		</Select>

	</div>

	<div id="right-select" class="select">

		<Select 
			items={rightYearSet} 
			value="2021"
			isSearchable={false}
			isClearable={false}
			on:select={handleSelectRight}
		>
		</Select>

	</div>

</main>





<style>

	/* @import "../node_modules/ol/ol.css"; */
	
	@font-face {
		font-family: TradeGothicBold;
		src: url("./assets/Trade Gothic LT Bold.ttf");
	}

	:root {
		font-family: Roboto, sans-serif;
	}
	
	:global(body) {
		overflow: hidden;
		padding: 0px;
		margin: 0px;
		height: 100%;
		width: 100%;
		position:fixed;
	}

	main {
		margin: 0px;
		padding: 0px;
		width: 100%;
		max-width: 100%;
		overflow: hidden;
	}

	#map {
		cursor: grab;
		height: calc(100vh);
		width: calc(100vw);
		top: 0;
        left: 0;
		position: absolute;
		z-index: 1;
		margin: 0px;
	}

	#left-select {
		position: absolute;
		top: 10px;
		left: 10px;
		float: left;
	}

	#right-select {
		position: absolute;
		top: 10px;
		right: 10px;
		float: right;
	}

	.select {
		z-index: 99;
		width: 70px;
		font-family: 'Roboto', sans-serif;
		font-size: 14px;
		opacity: 0.95;
		border-right: 2px solid #0D534D;
		--padding: 0px 0px 0px 7px;
		--border: 1px solid rgb(242, 242, 242);
		--borderRadius: 0px;
		--height: 28px;
		--borderFocusColor: #0D534D;
		--itemColor: black;
		--itemHoverBG: #F1C500;
		--itemIsActiveBG: #0D534D;
		--listBorderRadius: 0px;
		--itemFirstBorderRadius: 0px;
		--itemPadding: 0px 0px 0px 10px;
		--itemMargin: 0px;
		--inputColor: white;
		--borderHoverColor: #0D534D;
		--indicatorWidth: 20px;
		--indicatorTop: 4px;
		--indicatorColor: #0D534D;
		--indicatorRight: 3px;
	}

	#line {
		position: absolute;
		height: 100%;
		width: 4px;
		background-color: rgb(255, 255, 255);
		margin: 0px;
		margin-top: 0px;
		z-index: 5;
	}

	#range {
		position: absolute;
		top: calc(100vh / 2.1 );
		height: 0px;
		width: calc(100vw + 45px);
		margin-left: -35px;
		margin-right: 40px;
		z-index: 99;
	}

	input[type="range"] {
		height: 0px;
		margin-left: 12px;
		margin-right: -22px;
		pointer-events: none;
		-webkit-appearance: none; 
	}

	

	input[type=range]:focus {
		outline: none; /* Removes the blue border. You should probably do some kind of focus styling for accessibility reasons though. */
		}

	input[type=range]::-ms-track {
		width: 100%;
		cursor: pointer;

		/* Hides the slider so custom styles can be added */
		background: transparent; 
		border-color: transparent;
		color: transparent;
		}

	input[type=range]::-webkit-slider-thumb {
		-webkit-appearance: none;
		pointer-events:auto;
	}

	input[type="range"]::-webkit-slider-thumb {
		-webkit-appearance: none;
		pointer-events:auto;
		/* overflow: hidden; */
		height: 45px;
		width: 45px;
		background-color: white;
		border-radius: 22px;
		border: 2px solid white;
		cursor: grab;
		background-image: url('./assets/arrows.svg');
		/* margin-top: -15px; */
	}

	input[type="range"]::-webkit-slider-thumb:hover {
		background-color: #F1C500;
	}


	input[type="range"]::-moz-range-thumb {
		pointer-events:auto;
		overflow: hidden;
		height: 42px;
		width: 42px;
		background-color: white;
		border-radius: 22px;
		border: 2px solid white;
		cursor: grab;
		background-image: url('./assets/arrows.png');
	}
	input[type="range"]::-moz-range-thumb:hover {
		background-color: #F1C500;
	}
	
</style>
