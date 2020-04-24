#!/usr/bin/perl

use SNMP::Info;
use Data::Dumper;
use Text::ASCIITable;

$ip = $ARGV[0];
$comu = $ARGV[1];
my $l3 = new SNMP::Info(
                         AutoSpecify => 1,
                         #Debug       => 1,
                         DestHost    => $ip,
                         Community   => $comu,
                         Version     => 2
                       )
   or die "Can't connect to DestHost.\n";
 
my $class = $l3->class();
print "SNMP::Info determined this device to fall under subclass : $class\n";
 
# Let's get some basic Port information
#my $interfaces = $l3->interfaces();
#my $i_up       = $l3->i_up();
#my $i_speed    = $l3->i_speed();
my $ospf1	=$l3->router_ip();
my $peers = $l3->ospf_peers();
my $id_peers = $l3->ospf_peer_id();
my $state_peers = $l3->ospf_peer_state();

$t = Text::ASCIITable->new({ headingText => 'OSPF  Neighbor Table' });
$t->setCols('Peer','ID','State');

foreach my $iid (keys %$peers) {
   my $id  = $id_peers->{$iid};
    my $state  = $state_peers->{$iid};
    $t->addRow($iid,$id,$state);
    #print "|\t $iid \t | $id \t | $state |\n";
}

print $t;

$t2 = Text::ASCIITable->new({ headingText => 'OSPF Interface Table (ospfIfTable)'});

$t2->setCols('IP','Area','Type','Hello','Dead','Admin','State');
my $ip		=	$l3->ospf_if_ip();
my $area	=	$l3->ospf_if_area();
my $type	=	$l3->ospf_if_type();
my $hello	=	$l3->ospf_if_hello();
my $dead	=	$l3->ospf_if_dead();
my $admin	=	$l3->ospf_if_admin();
my $state	=	$l3->ospf_if_state();



foreach my $iip (keys %$ip){
    $aarea = $ip->{$iip};
    $ttype = $type->{$iip};
    $hhello = $hello->{$iip};
    $ddead = $dead->{$iip};
    $aadmin = $admin->{$iip};
    $sstate= $state->{$iip};
    $t2->addRow($iip,$aarea,$ttype,$hhello,$ddead,$aadmin,$sstate);
}

print $t2;



