<script>
	import logo from '../assets/top-logo.svg'
</script>

<div id="container">
<div id="bar">
	<a href="https://www.schoolofcities.utoronto.ca/"><img src={logo} alt="School of Cities"></a>
</div>
</div>

<style>
	#container {
		display: flex;
		justify-content: center;
	}
	#bar {
		transform: translate3d(0,0,0);
		opacity: 0.96;
		position: fixed;
   		top: 0px;
		height: 50px;
		background-color: #fff;
		margin-bottom: 20px;
		border-bottom: 2px solid #AB1368;
		border-left: 2px solid #AB1368;
		border-right: 2px solid #AB1368;
		border-bottom-right-radius: 15px;
		border-bottom-left-radius: 15px;
		width: 200px;
		min-width: 200px;
		padding-left: 0px;
		padding-right: 0px;
		text-align: center;
		z-index: 5;
		box-shadow: 0 3px 0 0 rgba(197, 197, 197, 0.168);
	}
	img {
		color: blue;
	}
	img:hover {
		opacity: 0.7;
		cursor: pointer;
	}
</style>