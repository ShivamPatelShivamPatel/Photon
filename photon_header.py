from scapy.all import *
import sys, os

#header photon_h {
#    bit<1>              phase;
#    bit<32>             count;
#    int<64>             x_coord;
#    int<32>             x_exp;
#    int<64>             y_coord;
#    int<32>             y_exp;
#    int<64>             z_coord;
#    int<32>             z_exp;
#}



#PHOTON_PROTOCOL = 0x92
UDP_PROTOCOL = 0x11
ETHERTYPE_IPV4 = 0x0800
#DPORT = 0x4d2
class Photon(Packet):
    name = "Photon"
    fields_desc = [ IntField("more_photons",1),
                    IntField("count",0),
                    LongField("x_coord",0),
                    IntField("x_signed",0),
                    IntField("x_exp",0),
                    IntField("x_randsign",0),
                    LongField("y_coord",0),
                    IntField("y_signed",0),
                    IntField("y_exp",0),
                    IntField("y_randsign",0),
                    LongField("z_coord",0),
                    IntField("z_signed",0),
                    IntField("z_exp",0),
                    IntField("z_randsign",0),
                    IntField("rand_index",0),
                    LongField("B",0)
            ]

bind_layers(UDP, Photon)#, dport = DPORT)
bind_layers(IP, UDP, proto=UDP_PROTOCOL)
bind_layers(Ether,IP,type=ETHERTYPE_IPV4)

