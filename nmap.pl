#! /usr/bin/perl

###########################################################################################
# This script was created by cypherround
# The purpose of the script is to simplify my favorite nmap scans
# without having to input the parameters of the specific scan.
# Feel free to use this scan for yourself and if you would like me
# to add any other types of scans let me know and I will input them 
# into the script. Thanks happy hacking!
###########################################################################################
 
use strict;
use warnings;

print "\nScript created by ASHU\n\n";

my @a;         #aggressive scan
my @ao;        #aggressive scan with output to file
my @aa;        #aggressive scan of all 65535 ports
my @aao;    #aggressive scan of all 65535 ports with output
my @ap;        #aggressive scan with specific port
my @apo;    #aggressive scan with specific port and output
my @os;        #os fingerprint scan
my @oso;    #os fingerprint scan with output
my @oss;    #os fingerprint service scan
my @osso;    #os fingerprint service scan with output
my @osp;    #os fingerprint scan with specific port
my @ospo;    #os fingerprint scan with specific port and output
my @osps;    #os fingerprint service scan with specific port
my @ospso;    #os fingerprint service scan with specific port and output
my @r;        #random IP scan
my @ro;        #random IP scan with output to file
my @ra;        #random IP scan of all 65535 ports
my @rao;    #random IP scan of all 65535 ports with output
my @rp;        #random IP scan with specific port
my @rpo;    #random IP scan with specific port and output
my @s;        #stealth scan
my @so;        #stealth scan with output to file
my @sa;        #stealth scan of all 65535 ports
my @sao;    #stealth scan of all 65535 ports with output
my @sp;        #stealth scan with specific port
my @spo;    #stealth scan with specific port and output
my @sss;    #stealth service scan
my @ssso;    #stealth service scan with output to file
my @sssa;    #stealth service scan of all 65535 ports
my @sssao;    #stealth service scan of all 65535 ports with output
my @sssp;    #stealth service scan with specific port
my @ssspo;    #stealth service scan with specific port and output
my @u;        #udp scan
my @uo;        #udp scan with output to file
my @ua;        #udp scan of all 65535 ports
my @uao;    #udp scan of all 65535 ports with output
my @up;        #udp scan with specific port
my @upo;    #udp scan with specific port and output
my @ut;        #udp & tcp scan
my @uto;    #udp & tcp scan with output to file
my @uta;    #udp & tcp scan of all 65535 ports
my @utao;    #udo & tcp scan of all 65535 ports with output
my @utp;    #udp & tcp scan with specific port
my @utpo;    #udp & tcp scan with specific port and output
my $ip;        #specified ip
my $output;    #specified output file
my $port;    #specified port
my $random;    #specifide amount of random IPs
my $scan;    #specified type of scan to use

print "Here are your options for your nmap scan (enter the abbreviation in parenthesis):\n\n aggressive(a)\n aggresive with output(ao)\n aggressive 65535 ports(aa)\n aggressive 65535 ports with output(aao)\n aggressive with specific port(ap)\n aggressive specific port and output (apo)\n os fingerprint scan(os)\n os fingerprint scan with output(oso)\n os fingerprint service scan(oss)\n os fingerprint service scan with output(osso)\n os fingerprint scan with specific port(osp)\n os fingerprint scan with specific port and output(ospo)\n os fingerprint service scan with specific port(osps)\n os fingerprint scan with specific port and output(ospso)\n random IPs(r)\n random IPs with output(ro)\n random IPs all 65535 ports(ra)\n random IPs all 65535 ports with output(rao)\n random IPs with specific port(rp)\n random IPs with specific port and output(rpo)\n stealth(s)\n stealth with output(so)\n stealth scan of all 65535 ports(sa)\n stealth scan with all 65535 ports with output(sao)\n stealth scan with specific port(sp)\n stealth scan with specfifi port and output(spo)\n stealth service scan(sss)\n stealth service scan with output(ssso)\n stealth service scan of all 65535 ports(sssao)\n stealth service scan of all 65535 ports with output(sssao)\n stealth service scan with specific port(sssp)\n stealth service scan with specific port and output(ssspo)\n udp(u)\n udp with output(uo)\n udp of all 65535 ports(ua)\n udp of all 65535 ports with output(uao)\n udp with specifc port(up)\n udp with specific port and output(upo)\n udp/tcp(ut)\n udp/tcp with output(uto)\n udp/tcp of all 65535 ports(uta)\n udp/tcp if all 65535 ports with output(utao)\n udp/tcp with specific port(utp)\n udp/tcp with specific port and output(utpo)\n" ;
$scan=<STDIN>;
chomp($scan);

if ($scan eq "r" or $scan eq "ro" or $scan eq "ra" or $scan eq "rao" or $scan eq "rp" or $scan eq "rpo") {
    print "How many random IPs would you like to scan? \n";
    $random=<STDIN>;
    chomp($random);
}

elsif ($scan eq "ao" or $scan eq "aao" or $scan eq "apo" or $scan eq "oso" or $scan eq "osso" or $scan eq "ospo" or $scan eq "ospso" or $scan eq "ro" or $scan eq "rao" or $scan eq "rpo" or $scan eq "so" or $scan eq "sao" or $scan eq "spo" or $scan eq "ssso" or $scan eq "sssao" or $scan eq "ssspo" or $scan eq "uo" or $scan eq "uao" or $scan eq "upo" or $scan eq "uto" or $scan eq "utao" or $scan eq "utpo") {
    print "What would you like your file to be named? add .txt to the filenname (ex: aggressive.txt) \n";
    $output=<STDIN>;
    chomp($output);
}

elsif ($scan eq "a" or $scan eq "ao" or $scan eq "aa" or $scan eq "aao" or $scan eq "ap" or $scan eq "apo" or $scan eq "os" or $scan eq "oso" or $scan eq "oss" or $scan eq "osso" or $scan eq "osp" or $scan eq "ospo" or $scan eq "osps" or $scan eq "ospso" or $scan eq "s" or $scan eq "so" or $scan eq "sa" or $scan eq "sao" or $scan eq "sp" or $scan eq "spo" or $scan eq "sss" or $scan eq "ssso" or $scan eq "sssa" or $scan eq "sssao" or $scan eq "sssp" or $scan eq "ssspo" or $scan eq "u" or $scan eq "uo" or $scan eq "ua" or $scan eq "uao" or $scan eq "up" or $scan eq "upo" or $scan eq "ut" or $scan eq "uto" or $scan eq "uta" or $scan eq "utao" or $scan eq "utp" or $scan eq "utpo") {
    print "Enter the IP you are searching for: \n";
    $ip=<STDIN>;
    chomp($ip);
}

if ($scan eq "ap" or $scan eq "apo" or $scan eq "osp" or $scan eq "ospo" or $scan eq "osps" or $scan eq "ospso" or $scan eq "rp" or $scan eq "rpo" or $scan eq "up" or $scan eq "upo" or $scan eq "utp" or $scan eq "utpo" or $scan eq "sp" or $scan eq "spo" or $scan eq "sssp" or $scan eq "ssspo") {
    print "Enter the ports you would like to scan: (ex: 21,22,80,443)\n";
    $port=<STDIN>;
    chomp($port);
}

if ($scan eq "a") {
    @a = `nmap -v -A $ip`;
        print "@a\n";
}

if ($scan eq "ao") {
    @ao = `nmap -v -A $ip -oG $output`;
        print "@ao\n";
}

if ($scan eq "aa") {
    @aa = `nmap -v -A $ip -p-`;
        print "@aa\n";
}

if ($scan eq "aao") {
    @aao = `nmap -v -A $ip -p- -oG $output`;
        print "@aao\n";
}

if ($scan eq "ap") {
    @ap = `nmap -v -A $ip -p $port`;
        print "@ap\n";
}

if ($scan eq "apo") {
    @apo = `nmap -v -A $ip -p $port -oG $output`;
        print "@apo\n";
}

if ($scan eq "os") {
    @os = `sudo nmap -v -O $ip`;
        print "@os\n";
}

if ($scan eq "oso") {
    @oso = `sudo nmap -v -O $ip -oG $output`;
        print "@oso\n";
}

if ($scan eq "oss") {
    @oss = `sudo nmap -v -O -sV $ip`;
        print "@oss\n";
}

if ($scan eq "osso") {
    @osso = `sudo nmap -v -O -sV $ip -oG $output`;
        print "@osso\n";
}

if ($scan eq "osp") {
    @osp = `sudo nmap -v -O $ip -p $port`;
        print "@osp\n";
}

if ($scan eq "ospo") {
    @ospo = `sudo nmap -v -O $ip -p $port -oG $output`;
        print "@ospo\n";
}

if ($scan eq "osps") {
    @osps = `sudo nmap -v -O -sV $ip -p $port`;
        print "@osps\n";
}

if ($scan eq "ospso") {
    @ospso = `sudo nmap -v -O -sV $ip -p $port -oG $output`;
        print "@ospso\n";
}

if ($scan eq "r") {
    @r = `nmap -v -iR $random -PN`;
        print "@r\n";
}

if ($scan eq "ro") {
    @ro = `nmap -v -iR $random -PN -oG $output`; 
        print "@ro";
}

if ($scan eq "ra") {
    @ra = `nmap -v -iR $random -PN -p-`;
        print "@ra\n";
}

if ($scan eq "rao") {
    @rao = `nmap -v -iR $random -PN -p- -oG $output`;
        print "@rao\n";
}

if ($scan eq "rp") {
    @rp = `nmap -v -iR $random -PN -p $port`;
        print "@rp\n";
}

if ($scan eq "rpo") {
    @rpo = `nmap -v -iR $random -PN -p $port -oG $output`;
        print "@rpo\n";
}


if ($scan eq "s") {
    @s = `nmap -v -v -PN $ip`;
        print "@s\n";
}

if ($scan eq "so") {
    @so = `nmap -v -PN $ip -oG $output`;
        print "@so\n";
}

if ($scan eq "sa") {
    @sa = `nmap -v -PN $ip -p-`;
        print "@sa\n";
}

if ($scan eq "sao") {
    @sao = `nmap -v -PN $ip -p- -oG $output`;
        print "@sao\n";
}

if ($scan eq "sp") {
    @sp = `nmap -v -PN $ip -p $port`;
        print "@sp\n";
}

if ($scan eq "spo") {
    @spo = `nmap -v -PN $ip -p $port -oG $output`;
        print "@spo\n";
}

if ($scan eq "sss") {
    @sss = `nmap -v -v -sV -PN $ip`;
        print "@sss\n";
}

if ($scan eq "ssso") {
    @ssso = `nmap -v -sV -PN $ip -oG $output`;
        print "@ssso\n";
}

if ($scan eq "sssa") {
    @sssa = `nmap -v -sV -PN $ip -p-`;
        print "@sssa\n";
}

if ($scan eq "sssao") {
    @sssao = `nmap -v -sV -PN $ip -p- -oG $output`;
        print "@sssao\n";
}

if ($scan eq "sssp") {
    @sssp = `nmap -v -sV -PN $ip -p $port`;
        print "@sssp\n";
}

if ($scan eq "ssspo") {
    @ssspo = `nmap -v -sV -PN $ip -p $port -oG $output`;
        print "@ssspo\n";
}

if ($scan eq "u") {
    @u = `sudo nmap -v -sU $ip`;
        print "@u\n";
}

if ($scan eq "uo") {
    @uo = `sudo nmap -v -sU $ip -oG $output`;
        print "@uo\n";
}

if ($scan eq "ua") {
    @ua = `sudo nmap -v -sU $ip -p-`;
        print "@ua\n";
}

if ($scan eq "uao") {
    @uao = `sudo nmap -v -sU $ip -p- -oG $output`;
        print "@uao\n";
}

if ($scan eq "up") {
    @up = `sudo nmap -v -sU $ip -p $port`;
        print "@up\n";
}

if ($scan eq "upo") {
    @upo = `sudo nmap -v -sU $ip -p $port -oG $output`;
        print "@upo\n";
}

if ($scan eq "ut") {
    @ut = `sudo nmap -v -sU -sS $ip`;
        print "@ut\n";
}

if ($scan eq "uto") {
    @uto = `sudo nmap -v -sU -sS $ip -oG $output`;
        print "@uto\n";
}

if ($scan eq "uta") {
    @uta = `sudo nmap -v -sU -sS $ip -p-`;
        print "@uta\n";
}

if ($scan eq "utao") {
    @utao = `sudo nmap -v -sU -sS $ip -p- -oG $output`;
        print "@utao\n";
}

if ($scan eq "utp") {
    @utp = `sudo nmap -v -sU -sS $ip -p $port`;
        print "@utp\n";
}

if ($scan eq "utpo") {
    @utpo = `sudo nmap -v -sU -sS $ip -p $port -oG $output`;
        print "@utpo\n";
}