<script>
	import { onMount } from 'svelte';

	import L from 'leaflet';

	import Top from "./lib/Top.svelte";

	// mapboxgl.accessToken = 'pk.eyJ1Ijoic2Nob29sb2ZjaXRpZXMiLCJhIjoiY2w3aml0dHdlMHlpazNwbWh0em4xOHNlaCJ9.fXNtPGq0DqYiFvPH6p4fjQ';

	// const data = Places.features;

	// let map;
	// let ctuid = "0";

	// let pageWidth;
	
	onMount(() => {
		var map = L.map('map').setView([51.505, -0.09], 13);

		L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
			attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
		}).addTo(map);
	})
		
		
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
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.8.0/dist/leaflet.css"
	integrity="sha512-hoalWLoI8r4UszCkZ5kL8vayOGVae1oxXe/2A4AO6J9+580uKHDO3JdHb7NzwwzK5xr/Fs0W40kiNHxM9vyTtQ=="
	crossorigin=""/>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin> 
	<link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
</svelte:head>









<main>
	<Top/>

	<div id="map"></div>

</main>











<style>
	
	
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
	
	
</style>
