<?php
/**
 * Toggle.php
 * This script will toggle the brightness of the raspberry pi by writing to 
 * a file in the same directory
 * That file is then symlinked to the appropriate location on the raspberry pi:
 * /sys/class/backlight/rpi_backlight/brightness
 * @author Tanner Hildebrand
 * @version 1.0
 */
$read = file_get_contents('/sys/class/backlight/rpi_backlight/brightness');
$val = intval($read);
if($val > 100){
    $write = 100;
} elseif($val > 50 ){
    $write = 50;
} elseif($val > 0 ){
    $write = 0;
} else {
    $write = 255;
}
$_GET['level'] = $write;
require('set.php');
?>