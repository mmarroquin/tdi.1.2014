
<?php
require_once('/Users/ERG/tdi.1.2014/proyecto/vtiger/vtwsclib/Vtiger/Net/HTTP_Client.php')
//url path to vtiger/webservice.php like http://vtiger_url/webservice.php
$endpointUrl = 'http://integra.ing.puc.cl/vtigerCRM';
//username of the user who is to logged in. 

$userName="grupo1";

$httpc = new HTTP_Client();
//getchallenge request must be a GET request.
$httpc->get("$endpointUrl?operation=getchallenge&username=$userName");
$response = $httpc->currentResponse();
//decode the json encode response from the server.
$jsonResponse = Zend_JSON::decode($response['body']);

//check for whether the requested operation was successful or not.
if($jsonResponse['success']==false) 
    //handle the failure case.
    die('getchallenge failed:'.$jsonResponse['error']['errorMsg']);

//operation was successful get the token from the reponse.
$challengeToken = $jsonResponse['result']['token'];

?>
