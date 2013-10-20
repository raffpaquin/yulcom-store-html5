<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title></title>
	<meta name="description" content="">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="/static/css/main.css">
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,500' rel='stylesheet' type='text/css'>
	<script type="text/javascript">
        window.configs = (<?= json_encode(include 'config/get.php'); ?>);
    </script>
</head>
    <body>

    	<div class="wrapper">
    		
	    	<header>
	    		<a class="logo" href="/">
	    			my<span style="font-weight: 700;">company</span>.
	    		</a>

	    		<ul class="menu">
	    			<li data-href="products"><a href="/products">Products</a></li>
	    			<li data-href="refill"><a href="/refill">Auto-Refill</a></li>
	    			<li data-href="cart"><a href="/cart">Cart</a></li>
	    			<li data-href="help"><a href="/help">Help</a></li>
	    			<li data-href="login"><a href="/login">Join</a></li>
	    		</ul>
	    	</header>


	    	<div id="content"></div>

    	</div>

        <script src="/static/js/vendor.js"></script>
        <script src="/static/js/app.js"></script>
        <script type="text/javascript">
           	app.init();
        </script>