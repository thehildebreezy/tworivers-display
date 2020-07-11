<?php
/**
 * Request_forecast.php
 * Sends a request to the manetheren service provider for forecast data
 * 
 */
require_once( '../common/request.php' );
require_once( '../common/common.php' );

function request_forecast( $opts ){
	global $FORECAST_SERVICE;
	$response = manetheren_service( $FORECAST_SERVICE, $opts );
	if ( $response != NULL ){
		return $response;
	}
}

echo request_forecast( NULL );
?>