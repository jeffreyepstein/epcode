<?php
/**
 * @package jecomm_nasa_pic
 * @version 0.1
 */
/*
Plugin Name:   jecomm_nasa_pic
Plugin URI: https://wordpress.org/plugins/JEComm_NASA_AstronomyPic/
Description: This plug-in displays astronomy pictures from NASA.
Author: Jeffrey Epstein
Purpose: This plug-in fetches and displays the Astronomy Picture of the day from NASA.
Version: 1.0
VersionDate: April 2017
License: GPL2
License URI: https://www.gnu.org/licenses/gpl-2.0.html
*/

$url = "https://api.nasa.gov/planetary/apod?api_key=DEMO_key";
$post_id = 1;
$desc = "NASA Astronomy Image of the Day";

$image = media_sideload_image($url, $post_id, $desc);
?>

