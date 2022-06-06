#!/usr/bin/env python3
import argparse
import sys
import socket
import random
import struct
import argparse

from scapy.all import sendp, send, get_if_list, get_if_hwaddr, hexdump
from scapy.all import Packet
from scapy.all import Ether, IP, UDP, TCP
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

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('ip_addr', type=str, help="The destination IP address to use")
    #parser.add_argument('message', type=str, help="The message to include in packet")
    parser.add_argument('--dst_id', type=int, default=None, help='The myTunnel dst_id to use, if unspecified then myTunnel header will not be included in packet')
    parser.add_argument('--host_iface', type=str, default="eth1", help='The host interface use')
    parser.add_argument('--count', type=int, default=1, help="Number of photons to transmit to destination host")
    parser.add_argument('--version', type=int, default=None, help="1 if want to individually send #count packets, 2 if want to use recirculate, 3 for fancy version")

    args = parser.parse_args()

    addr = socket.gethostbyname(args.ip_addr)
    dst_id = args.dst_id
    iface = get_if(args.host_iface)
    
    count = args.count
    version = args.version

    if(count <= 0):
        print("error: invalid count %d. exiting..." % (count))
        exit(-1)

    if(version == 1):
        print("version 1, sending %d photon packets" % (count))
        for i in range(count):
            print(("sending on interface {} to IP addr {}".format(iface, str(addr))))
            pkt =  Ether(src=get_if_hwaddr(iface), dst='ff:ff:ff:ff:ff:ff')
            sport=random.randint(49152,65535)            
            pkt = pkt / IP(dst=addr) / UDP(dport=1234, sport=sport) / Photon(more_photons = (i != count-1))
            pkt.show2()
            sendp(pkt, iface=iface, verbose=True)
    
    elif(version == 2 or version == 3):
        print(("sending on interface {} to IP addr {}".format(iface, str(addr))))
        pkt =  Ether(src=get_if_hwaddr(iface), dst='ff:ff:ff:ff:ff:ff')
        sport=random.randint(49152,65535)            
        pkt = pkt / IP(dst=addr) / UDP(dport=1234, sport=sport) / Photon(count = count)
        sendp(pkt, iface=iface, verbose=True)
    
    else: # should not have got here
        print("error: invalid version. exiting...")
        exit(-1)
 


if __name__ == '__main__':
    main()
