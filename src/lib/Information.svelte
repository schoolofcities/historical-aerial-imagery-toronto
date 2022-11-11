<script>
	import logo from '../assets/top-logo.svg'
</script>

<div id="container">
	<div id="bar">

		<p>
			Imagery is sourced from the City of Toronto's Open Data portal. This web page was build by Jeff Allen at the School of Cities. Source code is on GitHub.
		</p>
		<!-- <a href="https://www.schoolofcities.utoronto.ca/"><img src={logo} alt="School of Cities"></a> -->
	</div>
</div>

<style>
	#container {
		display: flex;
		justify-content: center;
	}
	#bar {
		opacity: 0.95;
		position: absolute;
   		bottom: 10px;
		right: 10px;
		height: 57px;
		background-color: #fff;
		border:1px solid #c8c8c8;
		border-right: 2px solid #0D534D;
		width: 200px;
		text-align: left;
		padding-left: 2px;
		padding-right: 2px;
		z-index: 99;
	}
	/* #bar: hover { */
	#bar p {
		margin: 5px;
		font-family: 'Roboto', sans-serif;
		font-size: 9px;
	}
</style>