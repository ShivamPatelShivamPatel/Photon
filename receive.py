#!/usr/bin/env python3
import argparse
import sys
import struct
import os

from scapy.all import sniff, sendp, hexdump, get_if_list, get_if_hwaddr
from scapy.all import Packet, IPOption
from scapy.all import ShortField, IntField, LongField, BitField, FieldListField, FieldLenField
from scapy.all import IP, TCP, UDP, Raw
from scapy.layers.inet import _IPOption_HDR
from photon_header import Photon

def get_if(host_iface):
    ifs=get_if_list()
    iface=None # "h1-eth0"
    for i in get_if_list():
        if host_iface in i:
            iface=i
            break;
    if not iface:
        print("Cannot find " + host_iface + " interface")
        exit(1)
    return iface

def signed(x):
    assert(x == 0 or x == 1)
    return -1 if x == 1 else 1

def construct(result, B, dim):
    sign = signed(getattr(result, dim + "_signed"))
    randsign = signed(getattr(result, dim + "_randsign"))
    exp = getattr(result, dim + "_exp")
    
    coord = ((getattr(result, dim + "_coord") * sign) + (B * randsign * 10000)) * (10 ** -exp)
    return coord

def handle_pkt(pkt, contents):
    if Photon in pkt:
        result = pkt.getlayer(Photon)
        more_photons = getattr(result, "more_photons")
        count = getattr(result, "count")
        rand_index = getattr(result, "rand_index")
        B = getattr(result, "B")

        x, y, z = (construct(result, B, "x"), construct(result, B, "y"), construct(result, B, "z"))
        result_string = str(x) + "," + str(y) + "," + str(z) + "," + str(rand_index) + "\n"
        print(result_string)

        contents.append(result_string)
        if(not more_photons):
            with open("result_coordinates.csv", "w") as f:
                f.writelines(contents)
            print("finished, check result_coordinates.csv")
            exit(0)

#        pkt.show2()
#        hexdump(pkt)
#        print "len(pkt) = ", len(pkt)
        sys.stdout.flush()
    else:
        print("Photon not in there")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--host_iface', type=str, default="eth1", help='The host interface use')
    args = parser.parse_args()

    iface = get_if(args.host_iface)
    print(("sniffing on %s" % iface))
    sys.stdout.flush()
   
    contents = ["new_x,new_y,new_z,original_index\n"]
    sniff(iface = iface,
          prn = lambda x: handle_pkt(x, contents))

if __name__ == '__main__':
    main()
