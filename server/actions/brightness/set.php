<?php
/**
 * Set.php
 * This script will set the brightness of the raspberry pi by writing to 
 * a file in the same directory
 * That file is then symlinked to the appropriate location on the raspberry pi:
 * /sys/class/backlight/rpi_backlight/brightness
 * @author Tanner Hildebrand
 * @version 1.0
 */
if(!isset($_GET['level'])){
    die;
}
$write = intval($_GET['level']);
if( $write > 255 || $write < 0 ){
    $write = 55;
}
file_put_contents('/sys/class/backlight/rpi_backlight/brightness', sprintf("%d",$write));
echo "Brightness set to $write";
?>