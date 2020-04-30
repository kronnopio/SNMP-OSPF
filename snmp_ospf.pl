#!/usr/bin/perl

BEGIN { push @INC, $ENV{PWD}.'/lib';} 

use SNMP::Info;
use Text::ASCIITable;

$ip = $ARGV[0];
$comu = $ARGV[1];
my $l3 = new SNMP::Info(
                         AutoSpecify => 1,
                         #Debug       => 1,
                         DestHost    => $ip,
                         Community   => $comu,
                         Version     => 2,
			 MibDirs           => ['./mibs/']
                       )
   or die "Can't connect to DestHost.\n";
 
#my $class = $l3->class();
 
my $peers = $l3->ospf_peers();
my $id_peers = $l3->ospf_peer_id();
my $state_peers = $l3->ospf_peer_state();

$t = Text::ASCIITable->new({ headingText => 'OSPF  Neighbor Table' });
$t->setCols('Peer','ID','State');

foreach my $iid (keys %$peers) {
   my $id  = $id_peers->{$iid};
    my $state  = $state_peers->{$iid};
    $t->addRow($iid,$id,$state);
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
    my $aarea = $ip->{$iip};
    my $ttype = $type->{$iip};
    my $hhello = $hello->{$iip};
    my $ddead = $dead->{$iip};
    my $aadmin = $admin->{$iip};
    my $sstate= $state->{$iip};
    $t2->addRow($iip,$aarea,$ttype,$hhello,$ddead,$aadmin,$sstate);
}

print $t2;



