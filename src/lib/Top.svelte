<script>
	import logo from '../assets/top-logo.svg'
</script>

<div id="bar">
	<a href="https://www.schoolofcities.utoronto.ca/"><img src={logo} alt="School of Cities"></a>
</div>

<style>
	#bar {
		transform: translate3d(0,0,0);
		position: fixed;
   		top: 0px;
		height: 50px;
		background-color: #fff;
		margin-bottom: 20px;
		border-bottom: 1px solid rgb(219, 219, 219);
		width: 100%;
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