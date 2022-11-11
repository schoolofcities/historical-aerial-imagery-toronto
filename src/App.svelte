<script>
	import { onMount } from 'svelte';
	import Top from "./lib/Top.svelte";
	import Select from 'svelte-select';
	import Icon from './lib/Icon.svelte';

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
	
	let map = 0;
	let load = 0;

	let leftYear = 1965;
	const leftYearSet = [
		1954, 1965, 1978, 2011, 2021
	];
	function handleSelectLeft(event) {
		console.log('selected item', event.detail);
		leftYear = event.detail.value
	}

	let rightYear = 2021;
	let rightYearSet = [
		1954, 1965, 1978, 2011, 2021
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
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1954/MapServer/WMTS/',
			'layer': 'basemap_cot_historic_aerial_1954',
			'matrixSet': 'default028mm'
		},
		'1965': {
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1965/MapServer/WMTS/',
			'layer': 'basemap_cot_historic_aerial_1965',
			'matrixSet': 'default028mm'
		},
		'1978': {
			'url': 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1978/MapServer/WMTS/',
			'layer': 'basemap_cot_historic_aerial_1978',
			'matrixSet': 'default028mm'
		},
		'2011': {
			'url': 'https://gis.toronto.ca/arcgis/rest/services/primary/cot_ortho_2011_color_10cm_webm/MapServer/WMTS/',
			'layer': 'primary_cot_ortho_2011_color_10cm_webm',
			'matrixSet': 'default028mm'
		},
		'2021': {
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
		
	
	var leftLayer = new TileLayer({
			opacity: 1,
			source: new WMTS({
				url: sources[leftYear]['url'],
				layer: sources[leftYear]['layer'],
				matrixSet: sources[leftYear]['matrixSet'],
				format: 'image/jpg',
				projection: 'EPSG:3857',
				tileGrid: tileGrid,
				style: 'default'
			})
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
				center: [-79.38,43.67],
				zoom: 14,
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
					style: 'default'
				})
			});
			map.addLayer(leftLayer);

			rightLayer = new TileLayer({
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






<main>

	<Top/>

	<div id="line" style="left: {lineLeft}px" ></div>


	<div id="map" bind:offsetWidth={pageWidth}></div>

	<div id="range">
		<input id="swipe" type="range" bind:value={lineBreak} style="width: 100%">
	</div>

	<div id="left-select" class="select">

		<Select 
			{Icon}
			items={leftYearSet} 
			value="1965"
			isClearable={false}
			on:select={handleSelectLeft}
		>
		</Select>

	</div>

	<div id="right-select" class="select">

		<Select 
			{Icon}
			items={rightYearSet} 
			value="2021"
			isClearable={false}
			on:select={handleSelectRight}
		>
		</Select>

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
		width:82Spx;
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
		--clearSelectWidth: 40px;
		--indicatorWidth: 0px;
		--multiClearWidth: 0px;
		--spinnerWidth: 0px;
		--itemPadding: 0px 0px 0px 10px;
		--itemMargin: 0px;
		--inputColor: white;
		--borderHoverColor: #0D534D;
	}


	
		


	/* select {
		appearance: none;
		background-color: transparent;
		border: none;
		padding: 0 1em 0 0;
		margin: 0;
		width: 100%;
		font-family: inherit;
		font-size: inherit;
		cursor: inherit;
		line-height: inherit;
	} */

	/* #select {
		width: 75px;
		border: 1px solid #F1C500;
		border-radius: 0.25em;
		padding: 0.25em 0.5em;
		font-size: 15px;
		cursor: pointer;
		line-height: 1.1;
		background-color: #fff;
		background-image: linear-gradient(to top, #f9f9f9, #fff 33%);
	} */

	#line {
		position: absolute;
		height: 100%;
		width: 4px;
		background-color: rgb(255, 255, 255);
		margin: 0px;
		margin-top: -10px;
		z-index: 50;
	}

	#range {
		position: absolute;
		top: calc(100vh / 2.1 );
		height: 0px;
		width: calc(100vw + 44px);
		margin-left: -10px;
		margin-right: -4px;
		z-index: 99;
	}

	/* #swipe {
		z-index: -99;
		height: 1px;
		color: white;
	} */

	input[type="range"] {
		height: 0px;
		margin-left: -22px;
		-webkit-appearance: none; 
	}

	input[type=range]::-webkit-slider-thumb {
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

	input[type="range"]::-webkit-slider-thumb {
		-webkit-appearance: none;
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
	
	


	/* input[type="range"]::-moz-range-track {
		height: 1px;
		background-color: white;
		z-index: 10
	} */
	
	
</style>
