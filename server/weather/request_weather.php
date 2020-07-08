<?php

require_once( '../common/request.php' );
require_once( '../common/common.php' );

function request_weather( $opts ){
	global $WEATHER_SERVICE;
	$response = manetheren_service( $WEATHER_SERVICE, $opts );
	if ( $response != NULL ){
		return $response;
	}
}

echo request_weather( NULL );
?>