<script>
	
	import { onMount } from 'svelte';

	/* ------------------
	   PAGE COMPONENTS
	------------------ */
	import Title from "./lib/Title.svelte";
	import Information from "./lib/Information.svelte";
	import Select from 'svelte-select';

	/* ------------------
	   STYLES & DATA
	------------------ */
	import "./ol.css";

	import notToronto from "./assets/not_toronto.geo.json";
	import missing1939 from "./assets/missing1939.geo.json";
	import majorStreets from "./assets/major-streets-split.geo.json";

	/* ------------------
	   OPENLAYERS IMPORTS
	------------------ */
	import { Map, View } from 'ol';
	import TileLayer from 'ol/layer/Tile';
	import VectorLayer from 'ol/layer/Vector';
	import XYZ from 'ol/source/XYZ';
	import VectorSource from 'ol/source/Vector';
	import GeoJSON from 'ol/format/GeoJSON';

	import { Fill, Stroke, Style, Text } from 'ol/style';
	import { getRenderPixel } from 'ol/render';
	import { useGeographic } from 'ol/proj';

	import ZoomSlider from 'ol/control/ZoomSlider';
	import { defaults as defaultControls } from 'ol/control';
	import { ScaleLine } from 'ol/control';

	/* ------------------
	   STATE
	------------------ */

	let map;
	let loaded = false;

	let labels = false;
	let lineBreak = 50;

	// bound from <div id="map">
	let pageWidth = 0;
	let lineLeft = 0;

	let leftYear = 1947;
	let rightYear = 2024;

	const leftYearSet = [
		1939, 1947, 1954, 1965, 1978,
		1985, 1995, 1999,
		2005, 2009,
		2012, 2018, 2020, 2022, 2024
	];

	const rightYearSet = [
		1947, 1954, 1965, 1978,
		1985, 1995, 1999,
		2005, 2009,
		2012, 2018, 2020, 2022, 2024
	];

	function handleSelectLeft(e) {
		leftYear = e.detail.value;
	}

	function handleSelectRight(e) {
		rightYear = e.detail.value;
	}

	useGeographic();

	/* ------------------
	   IMAGERY SOURCES
	------------------ */

	const sources = {
		1939: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1939/MapServer/tile/{z}/{y}/{x}',
		1947: 'https://maps.library.utoronto.ca/tiles1947/{z}/{x}/{y}.png',
		1954: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1954/MapServer/tile/{z}/{y}/{x}',
		1965: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1965/MapServer/tile/{z}/{y}/{x}',
		1978: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_historic_aerial_1978/MapServer/tile/{z}/{y}/{x}',
		1985: 'https://maps.library.utoronto.ca/tiles1985/{z}/{x}/{y}.png',
		1995: 'https://maps.library.utoronto.ca/tiles1995/{z}/{x}/{y}.png',
		1999: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_1999_greyscale_15cm/MapServer/tile/{z}/{y}/{x}',
		2005: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2005_color_20cm/MapServer/tile/{z}/{y}/{x}',
		2009: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2009_color_10cm/MapServer/tile/{z}/{y}/{x}',
		2012: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2012_color_5cm/MapServer/tile/{z}/{y}/{x}',
		2018: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2018_color_8cm/MapServer/tile/{z}/{y}/{x}',
		2020: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_2020_NightTimeLight_20cm/MapServer/tile/{z}/{y}/{x}',
		2022: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2022_color_8cm/MapServer/tile/{z}/{y}/{x}',
		2024: 'https://gis.toronto.ca/arcgis/rest/services/basemap/cot_ortho_2024_color_8cm/MapServer/tile/{z}/{y}/{x}'
	};

	/* ------------------
	   VECTOR LAYERS
	------------------ */

	const notTorontoLayer = new VectorLayer({
		source: new VectorSource({
			features: new GeoJSON().readFeatures(notToronto)
		}),
		style: new Style({
			fill: new Fill({ color: '#fff' }),
			stroke: new Stroke({ color: '#0D534D', width: 2 })
		})
	});

	const missing1939Layer = new VectorLayer({
		source: new VectorSource({
			features: new GeoJSON().readFeatures(missing1939)
		}),
		style: new Style({
			fill: new Fill({ color: '#e3e3e3' })
		}),
		opacity: 0
	});

	const streetTextStyle = new Style({
		text: new Text({
			font: 'bold 12px Roboto, Arial, sans-serif',
			placement: 'line',
			fill: new Fill({ color: '#0D534D' }),
			stroke: new Stroke({ color: '#fff', width: 2 })
		})
	});

	const streetLayer = new VectorLayer({
		declutter: true,
		source: new VectorSource({
			features: new GeoJSON().readFeatures(majorStreets)
		}),
		style: f => {
			streetTextStyle.getText().setText(f.get('n'));
			return streetTextStyle;
		},
		opacity: 0
	});

	$: streetLayer.setOpacity(labels ? 1 : 0);

	/* ------------------
	   RASTER LAYERS (ONCE)
	------------------ */

	const leftLayer = new TileLayer({
		source: new XYZ({ url: sources[leftYear] })
	});

	const rightLayer = new TileLayer({
		source: new XYZ({ url: sources[rightYear] })
	});

	/* ------------------
	   SWIPE RENDERING
	------------------ */

	function swipePrerender(event) {
		if (!pageWidth) return;

		const ctx = event.context;
		const height = map.getSize()[1];
		const split = pageWidth * (lineBreak / 100);

		const tl = getRenderPixel(event, [split, 0]);
		const tr = getRenderPixel(event, [pageWidth, 0]);
		const bl = getRenderPixel(event, [split, height]);
		const br = getRenderPixel(event, [pageWidth, height]);

		ctx.save();

		ctx.beginPath();
		ctx.moveTo(tl[0], tl[1]);
		ctx.lineTo(bl[0], bl[1]);
		ctx.lineTo(br[0], br[1]);
		ctx.lineTo(tr[0], tr[1]);
		ctx.closePath();

		ctx.fillStyle = '#ffffff';
		ctx.fill();
		ctx.clip();
	}

	function swipePostrender(e) {
		e.context.restore();
	}

	rightLayer.on('prerender', swipePrerender);
	rightLayer.on('postrender', swipePostrender);

	/* ------------------
	   MAP INIT
	------------------ */

	onMount(() => {
		map = new Map({
			target: 'map',
			layers: [
				leftLayer,
				missing1939Layer,
				rightLayer,
				notTorontoLayer,
				streetLayer
			],
			view: new View({
				center: [-79.395, 43.64],
				zoom: 16,
				minZoom: 12,
				maxZoom: 18.99,
				extent: [-79.8302, 43.3046, -78.9160, 44.0295]
			}),
			controls: defaultControls().extend([new ZoomSlider()])
		});

		map.addControl(new ScaleLine({ units: 'metric', maxWidth: 75 }));

		document
			.getElementById('swipe')
			.addEventListener('input', () => map.render());

		loaded = true;
	});

	/* ------------------
	   REACTIVE UPDATES
	------------------ */

	$: if (loaded) {
		leftLayer.setSource(new XYZ({ url: sources[leftYear] }));
		missing1939Layer.setOpacity(leftYear === 1939 ? 1 : 0);
	}

	$: if (loaded) {
		rightLayer.setSource(new XYZ({ url: sources[rightYear] }));
	}

	// position the vertical swipe line
	$: lineLeft = Math.round(pageWidth * (lineBreak / 100) - 2);

	// redraw on resize
	$: pageWidth && map?.render();

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

	<div id="label-container">
		<div id="label-bar">
			<p>
				<label>
					<input 
					type=checkbox 
					bind:checked={labels}
					on:select={handleSelectRight}
					> Show Labels (based on 2022 street data)
				</label>
				
			</p>
		</div>
	</div>

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
			value="2024"
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

	#label-container {
		display: flex;
		justify-content: center;
	}

	#label-bar {
		opacity: 0.95;
		position: absolute;
   		bottom: 5px;
		right: 10px;
		height: 20px;
		background-color: #fff;
		border:1px solid #c8c8c8;
		border-right: 2px solid #0D534D;
		width: 257px;
		text-align: left;
		padding-left: 2px;
		padding-right: 2px;
		z-index: 99;
	}

	#label-bar p {
		margin: 3px;
		margin-left: 4px;
		
		font-family: Roboto, sans-serif;
		font-size: 11px;
		line-height: 14px;
		color: #5a5a5a
	}

	input[type=checkbox] {
		padding: 0px;
		margin: 0px;
		width: 11px;
        height: 11px;
	}

	input[type=checkbox]:hover {
		cursor: pointer;
	}

	#left-select {
		position: absolute;
		top: 10px;
		left: 10px;
		max-height: 200px;
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
		--listMaxHeight: 300px;
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
		outline: none;
		}

	input[type=range]::-ms-track {
		width: 100%;
		cursor: pointer;
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
		height: 45px;
		width: 45px;
		background-color: white;
		border-radius: 22px;
		border: 2px solid white;
		cursor: grab;
		background-image: url('./assets/arrows.svg');
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
