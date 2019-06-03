<?php
require_once "appInfoObject.php";

$pid = $_GET['pid'];

if (empty($pid)){
    exit(0);
}

$test_info = new appInfoObject(constant("test-product-id"), "1.1" ,"bug fixed.\nnew feature.", "https://github.com/hsiangho", 0);

switch ($pid){
    case constant("test-product-id"):
        $test_info->echoAppInfoJson();
        break;

    default:
}
