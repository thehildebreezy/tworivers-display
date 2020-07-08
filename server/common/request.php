<?php
/**
 * Common function request to request content from the manetheren host
 * Contains service request method wrappers
 */

require_once( '../common/common.php' );

/**
 * Request a response from the Manetheren control server
 * @param url the path to the service being requested
 * @param opts reserved for future use
 * @return string JSON value of the requested service response, OR {"success":fail} if no response
 */
function manetheren_service( $url, $opts ){
	global $MANETHEREN_HOME;

	$response = @file_get_contents( $MANETHEREN_HOME . $url);
	if($response==FALSE):
		return "{\"success\":false}";
	endif;
	return $response;
}

/**
 * Request a response from the Numenor file server
 * @param url the path to the service being requested
 * @param opts reserved for future use
 * @return string JSON value of the requested service response, OR {"success":fail} if no response
 */
function numenor_service( $url, $opts ){
	global $NUMENOR_HOME;

	$response = @file_get_contents( $NUMENOR_HOME . $url);
	if($response==FALSE):
		return "{\"success\":false}";
	endif;
	return $response;
}

?>
