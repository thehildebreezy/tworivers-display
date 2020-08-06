<?php
/**
 * Dim.php
 * This script will set brightness off of the raspberry pi by writing to 
 * a file in the same directory
 * That file is then symlinked to the appropriate location on the raspberry pi:
 * /sys/class/backlight/rpi_backlight/brightness
 * @author Tanner Hildebrand
 * @version 1.0
 */
$_GET['level'] = 0;
require('set.php');
?>