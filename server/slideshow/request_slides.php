<?php
/**
 * Request_slides.php
 * Sends a request to either the manetheren service provider or the numenor service provider
 * Mantheren goes to Numenora s well for photos, so either will return the same
 */
require_once( '../common/request.php' );
require_once( '../common/common.php' );

/**
 * Requests slides from the control server slides service.
 * In general, the Manetheren server will just forward the response from the Numenor file server
 * so the middle man could be skipped, however, I will retain this set up for future extensibility
 */
function request_slides( $opts ){
	global $SLIDE_SERVICE;
	$response = manetheren_service( $SLIDE_SERVICE, $opts );
	if ( $response != NULL ){
		return $response;
	}
}
function request_slides2( $opts ){
	global $PHOTOBOOTH_SERVICE;
	$response = numenor_service( $PHOTOBOOTH_SERVICE, $opts );
	if ( $response != NULL ){
		return $response;
	}
}

// request slides is called without options to forward the manetheren service
echo request_slides( NULL );
?>