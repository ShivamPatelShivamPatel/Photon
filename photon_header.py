from scapy.all import *
import sys, os

#header photon_h {
#bit<32>             more_photon;
#bit<32>             count;
#int<64>             weight;

#int<64>             d;
#int<64>             phi;
#int<64>             theta;

#int<64>             x;
#int<64>             y;
#int<64>             z;
#}



#PHOTON_PROTOCOL = 0x92
UDP_PROTOCOL = 0x11
ETHERTYPE_IPV4 = 0x0800
#DPORT = 0x4d2
class Photon(Packet):
    name = "Photon"
    fields_desc = [ IntField("more_photons",1),
                    IntField("count",0),
                    SignedLongField("weight",1<<56),
                    SignedLongField("d",0),
                    SignedLongField("phi",0),
                    SignedLongField("theta",0),
                    SignedLongField("x",0),
                    SignedLongField("y",0),
                    SignedLongField("z",0),
            ]

bind_layers(UDP, Photon)#, dport = DPORT)
bind_layers(IP, UDP, proto=UDP_PROTOCOL)
bind_layers(Ether,IP,type=ETHERTYPE_IPV4)

