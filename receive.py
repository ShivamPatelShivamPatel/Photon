#!/usr/bin/env python3
import argparse
import sys
import struct
import os

from scapy.all import sniff, sendp, hexdump, get_if_list, get_if_hwaddr
from scapy.all import Packet, IPOption
from scapy.all import ShortField, IntField, LongField, BitField, FieldListField, FieldLenField, SignedLongField
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


def construct(result, attr):
    return getattr(result,attr) / (1 << 56)

def handle_pkt(pkt, contents):
    if Photon in pkt:
        result = pkt.getlayer(Photon)
        more_photons = getattr(result, "more_photons")
        count = getattr(result, "count")

        x, y, z, phi, theta, d = (construct(result, "x"), construct(result, "y"), construct(result, "z"),
                                  construct(result, "phi"), construct(result, "theta"), construct(result, "d"))
        result_string = str(x) + "," + str(y) + "," + str(z) + "," + str(phi) + "," + str(theta) + "," + str(d) + "\n"
        print(result_string[:-1])

        contents.append(result_string)
        print("more photons is %d" % (more_photons))
        if(not more_photons):
            with open("result_coordinatesV3.csv", "w") as f:
                f.writelines(contents)
            print("finished, check result_coordinatesV3.csv")
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
   
    contents = ["x,y,z,phi,theta,d\n"]
    sniff(iface = iface,
          prn = lambda x: handle_pkt(x, contents))

if __name__ == '__main__':
    main()
