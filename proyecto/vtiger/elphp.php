

<?php

include_once("vtwsclib/Vtiger/WSClient.php");
$url = "http://integra.ing.puc.cl/vtigerCRM";
$client = new Vtiger_WSClient($url);
$login = $client->doLogin("grupo1", "Cyz9KPyu0sNNknpm");
if(!$login) echo 'Login Failed';
else{
	/*
    $data = array(
        'subject' => 'Test SalesOrder',
        'sostatus' => 'Created',
        'invoicestatus'=>'AutoCreated',
        'account_id'=> '46', // Existing account id
        'bill_street' => 'Bill Street',
        'ship_street' => 'Ship Street',
    );
    $record = $client->doCreate('SalesOrder', $data);
	*/

	
	$query = "SELECT firstname, contact_no, phone, lastname, otherstreet, othercity, otherstate FROM Contacts where firstname='Eleonor' and lastname='Bonapart'";
	//$query = "SELECT * FROM Accounts where accountname='ARANGUIZ & DUPRAT S.A.'";
$records = $client->doQuery($query);
if($records) 
{
$columns = $client->getResultColumns($records);
}



//$aaa=print_r($records[1],true);
$res = json_encode($records);
echo $res;

$aaa=print_r($records[1][1],true);
//echo $aaa;
//print_r($records[100]);
$a=$records[9];
print "$records[9].";
print "$records[2]";
print "$a[0]";

$error = $client->lasterror();
    if($error) {
    echo $error['code'] . ' : ' . $error['message'];
}

if($record) {
    $salesorderid = $client->getRecordId($record['id']);
}

}


/*
include_once('vtwsclib/Vtiger/WSClient.php');
$url = 'http://integra.ing.puc.cl/vtigerCRM';
$client = new Vtiger_WSClient($url);
$login = $client->doLogin('grupo1', "Cyz9KPyu0sNNknpm");
if(!$login) echo 'Login Failed';
else {
	echo "OK!";
}

*/
?>