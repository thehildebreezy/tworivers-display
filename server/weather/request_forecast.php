<?php

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