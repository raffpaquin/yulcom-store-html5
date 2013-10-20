<?php
	switch($_SERVER['SERVER_NAME']){
		case 'local.tadose.ca':
			return include 'local.php';
			break;
		case 'www.tadose.ca':
			return include 'prod.php';
			break;
		case 'beta.tadose.ca':
			return include 'beta.php';
			break;
		default:
			return array();
			break;
	}