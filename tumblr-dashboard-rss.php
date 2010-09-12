<?php

// Authorization info
$tumblr_email    = 'josh@joshmock.com';
$tumblr_password = '(k+[zjj9,5$}"QT';

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