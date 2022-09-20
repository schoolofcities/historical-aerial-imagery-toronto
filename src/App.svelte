<script>
	import { onMount } from 'svelte'

	import Top from "./lib/Top.svelte"

	// mapboxgl.accessToken = 'pk.eyJ1Ijoic2Nob29sb2ZjaXRpZXMiLCJhIjoiY2w3aml0dHdlMHlpazNwbWh0em4xOHNlaCJ9.fXNtPGq0DqYiFvPH6p4fjQ';

	// const data = Places.features;

	// let map;
	// let ctuid = "0";

	// let pageWidth;
	
	// onMount(() => {
	// 	map = new mapboxgl.Map({
	// 		container: 'map', 
	// 		style: 'mapbox://styles/schoolofcities/cl7j75gbd003b14ocub8skc7c',
	// 		center: [-79.45, 43.65], 
	// 		zoom: 10,
	// 		maxZoom: 12,
	// 		minZoom: 5,
	// 		projection: 'globe',
	// 		scrollZoom: true,
	// 		attributionControl: false
	// 	});
		
		
	// 	map.addControl(new mapboxgl.AttributionControl({
	// 		customAttribution: 'Map by <a href="http://jamaps.github.io/about.html">Jeff Allen</a>'
	// 	}), 'bottom-right');
	// 	map.addControl(new mapboxgl.NavigationControl(), 'top-right');

	// 	const scale = new mapboxgl.ScaleControl({
	// 		maxWidth: 100,
	// 		unit: 'metric'
	// 		});
	// 	map.addControl(scale, 'bottom-right');

	// 	map.on('mouseenter', 'ct_fill', () => {
	// 		map.getCanvas().style.cursor = 'pointer';
	// 	});
	// 	map.on('mouseleave', 'ct_fill', () => {
	// 		map.getCanvas().style.cursor = '';
	// 	})

	// 	map.on('click', 'ct_fill', (e) => {		

	// 		var features = map.queryRenderedFeatures(e.point, { layers: ['ct_fill'] });

	// 		if (ctuid != features[0].properties.CTUID) {
	// 			var style = [
	// 				"match",
	// 				["get", "CTUID"],
	// 				[features[0].properties.CTUID],
	// 				"#f1c500",
	// 				"#fff"
	// 			]
	// 			map.setPaintProperty('ct_fill', 'fill-color', style)
	// 			ctuid = features[0].properties.CTUID

	// 		} else {
	// 			map.setPaintProperty('ct_fill', 'fill-color', '#fff')
	// 			ctuid = '0'
	// 		}

	// 	});

	// });

	

	// function placeClick(city) {
	// 	ctuid = "0";
	// 	map.setPaintProperty('ct_fill', 'fill-color', '#fff');
	// 	map.panTo(city.original.geometry.coordinates);
	// 	map.zoonTo(10);
	// }


</script>

<svelte:head>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin> 
	<link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
</svelte:head>




<Top/>
















<style>
	
	
	@font-face {
		font-family: TradeGothicBold;
		src: url("./assets/Trade Gothic LT Bold.ttf");
	}
	:root {
		font-family: 'Roboto', sans-serif;
	}


	
	
</style>
