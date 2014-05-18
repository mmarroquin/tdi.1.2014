<?php


// Incluir el archivo base de la libreria para PHP
include_once('/Users/ERG/tdi.1.2014/proyecto/vtiger/vtwsclib/Vtiger/WSClient.php');
 
// Configurar el usuario con el que deseamos conectar con Vtiger
$user = 'grupo1';
$key  = 'Cyz9KPyu0sNNknpm';
 
// Aqui va el URL de tu instalacion de Vtiger
$url = 'http://integra.ing.puc.cl/vtigerCRM';
 
// Se genera se inicializa el Obejto WSClient pasandole como parametro el URL
$client = new Vtiger_WSClient($url);
 
// Lo siguiente es hacer el Login usando el Usuario y Key para acceso
$login = $client->doLogin($user, $key);
 
// $login debe ser TRUE si se ha logrado entrar correctamente, si ocurrio un error sera FALSE
if(!$login) {
echo 'Login Failed';
}
else {
    // En el caso de este script, se
    $modulename = (isset($_POST['mod']))?$_POST['mod']:$_GET['mod'];
 
    //** Imprimir el combo con la lista de modulos del CRM **//
 
    // Se obtienen todos los modulos que actualmente estan instalados en Vtiger
    $modules = $client->doListTypes();
 
    $html_string1 = '<form name="modules" method="get">'.
                   '<select name="mod">';
 
    foreach($modules as $modname => $moduleinfo) {
        $selected = '';
        if($modname == $modulename) $selected = 'selected=selected';
     
        $html_string1 .= '<option '.$selected.' value='.$modname.'>'.$modname.'</option>';
    }
 
    $html_string1 .= '</select>' .
                 '<input type="submit" name="checkMod" value="Consultar"/>' .
              '</form>';
 
    echo $html_string1;
    /**  Fin de crear la lista de modulos **/
 
    if($modulename!='')
    {
        $html = getModuleDescription($modulename);
        echo $html;
    }
}
 
/**
* Devuelve  la descripcion del Modulo, cuyo nombre se pase como parametro en $modulename
*/
function getModuleDescription($modulename)
{
    // globales, definidas fuera de la funcion
    global $client;
    global $user;
 
    $maxcols = 8;
 
    // Se ejecuta el metodo "doDescribe" que obtiene la configuracion del modulo, en este
    //   se incluyen permisos y campos del modulo.
 
    $describe = $client->doDescribe($modulename);
 
    $wasError= $client->lastError();
    if($wasError) {
        echo $wasError['code'] . ':' . $wasError['message'];
    }
    else{
        // Recuperar los permisos que el usuario actual tiene sobre el modulo seleccionado
        $cancreate     = ($describe['createable'])?'Si':'No';
        $canupdate     = ($describe['updateable'])?'Si':'No';
        $candelete     = ($describe['deleteable'])?'Si':'No';
        $canread     = ($describe['retrieveable'])?'Si':'No';
        $fields     = ($describe['fields']);
 
        $html_string = '<table width="200">'.
                         '<th colspan="2">Permisos para el usuario: <b>'.$user.'</b> en Modulo '.$modulename.'</th>' .
                          '<tr><td>Crear:</td><td>'.$cancreate.         '</td></tr>' .
                          '<tr><td>Actualizar:</td><td>'.$canupdate.    '</td></tr>' . 
                          '<tr><td>Eliminar:</td><td>'.$candelete.    '</td></tr>' .
                          '<tr><td>Leer:</td><td>'.$canread.    '</td></tr>' . 
                        '</table><br/>';
 
        // Aqui comienza el proceso para formar un "table" en HTML para mostrar la descripcion del modulo y sus campos
        //  incluyendo los campos personalizados
 
        $html_string .= '<table border="1"><th colspan='.$maxcols.'>Campos</th>';
        $col = 0;
        for($i=0; $i<count($fields); $i++)
        {
            $col ++;
            $tableseppref = '<td style="float: left; margin: 2px 5px 0pt;height:260px; width: 170px;">';
            $tablesepsuf = '</td>';
            if($col == 1) {
                $tableseppref = '<tr>'.$tableseppref;
            }
            elseif($col == $maxcols)
            {
                $tablesepsuf = $tablesepsuf.'</tr>';
                $col = 0;
            }
         
            $fieldlabel         = ($fields[$i]['label']) ? $fields[$i]['label'] : $fields[$i]['name'];
            $fieldname            = $fields[$i]['name'];
            $fieldismandatory     = ($fields[$i]['mandatory'])?'Si':'No';
            $fieldtype            = $fields[$i]['type']['name'];
            $dateformat            = ($fields[$i]['type']['name'] == 'date') ? '<br/>format: '.$fields[$i]['type']['format'] : '';
            $valuesLabel = '';
             
            // Hacemos una llamada a la función local "getRelList()" con la que nos regresa un string en formato HTML con los valores
            //  de los campos si estos fueran de tipo "picklist" o "reference"
            $fieldValues = getRelList($fieldtype, $fields[$i]);
         
            if($fieldValues != ''){
                $valuesLabel = 'Valores';
            }
         
            // Aqui solo formaremos un string de HTML para mostrar la descripcion del campo en una "table"
            $html_string .= $tableseppref.
                '<table style="float: left; width: 100%;"><th style="float: none; background-color: rgb(194, 194, 194);">'.$fieldlabel.'</th>'.
                '<tr><td>DB Name: '.$fieldname.'</td></tr>'.
                '<tr><td>Obligatorio: '. $fieldismandatory .'</td></tr>'.
                '<tr><td>Tipo: '.$fieldtype.' '.$dateformat.'</td></tr>'.
                '<tr><td>'.$valuesLabel.'</td></tr>'.
                '<tr><td>'.
                     '<div style="float: left;width: 100%;height: 100px; overflow: auto;">'.
                         $fieldValues.
                     '</div>'.
                '</td></tr>'.
                '</table>'.
                $tablesepsuf;
        }
 
        $html_string .= '</table>';
        return utf8_decode($html_string);
    }
}
 
/**
* Devuelve los valores de los campos de tipo "picklist" y "reference"
*/
function getRelList($fieldtype, $field, $tag = 'ul', $itemtag = 'li'){
    if(($fieldtype == 'picklist') || ($fieldtype == 'reference'))
    {
    $fieldValues = '<'.$tag.'>';
    if($fieldtype == 'picklist') $cellValues     = 'picklistValues';
    if($fieldtype == 'reference') $cellValues     = 'refersTo';
 
    for($f=0; $f&lt;count($field['type'][$cellValues]); $f++)
    {
        $value = '';
        if($fieldtype == 'picklist')
        $value = $field['type'][$cellValues][$f]['label'].'<br/>('.$field['type'][$cellValues][$f]['value'].')';
        if($fieldtype == 'reference')
            $value = $field['type'][$cellValues][$f];
 
            $fieldValues .= '<'.$itemtag.'>'.$value.'</'.$itemtag.'>';
        }
        $fieldValues .= '</'.$tag.'>';
 
        return $fieldValues;
    }
    return '';
}
 








?>
