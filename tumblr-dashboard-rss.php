<?php

/*
LICENSE INFO
This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more details.

CONTACT INFO
Created by Josh Mock
Website: http://joshmock.com
Email: josh@joshmock.com
*/

// Authorization info
$tumblr_email    = 'test@example.com';
$tumblr_password = 'password';

// Data for new record
$num_posts = '50';

// Prepare POST request
$request_data = http_build_query(array('email' => $tumblr_email, 'password' => $tumblr_password, 'num' => $num_posts));

// Send the POST request with cURL
$c = curl_init('http://www.tumblr.com/api/dashboard');
curl_setopt($c, CURLOPT_POST, true);
curl_setopt($c, CURLOPT_POSTFIELDS, $request_data);
curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
$result = curl_exec($c);
$status = curl_getinfo($c, CURLINFO_HTTP_CODE);
curl_close($c);

// Check for success
if ($status == 200) { xsl_transform($result); }
else { echo "Error: $result\n"; }

function xsl_transform($xml) {
	// load XML file
	$XML = new DOMDocument();
	$XML->loadXML($xml);
	
	// XSL transform
	$xslt = new XSLTProcessor();
	$XSL = new DOMDocument();
	$XSL->load('tumblr-dashboard-rss.xsl', LIBXML_NOCDATA);
	$xslt->importStylesheet($XSL);
	
	echo $xslt->transformToXML($XML); 
}

?>