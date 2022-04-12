#ifndef PARSING_P4_
#define PARSING_P4_

#include "targets.h"

typedef bit<48> MacAddress;

header eth_h
{
    MacAddress dst;
    MacAddress src;
    bit<16> type;
}

header ipv4_h {
  	bit<4>   version;
  	bit<4>   ihl;
//	bit<8>   tos;
  	bit<6>   diffserv;
  	bit<2>   ecn;
  	bit<16>  len;
  	bit<16>  id;
  	bit<3>   flags;
  	bit<13>  frag;
  	bit<8>   ttl;
  	bit<8>   proto;
  	bit<16>  chksum;
  	bit<32>  src;
  	bit<32>  dst;
}

// from tutorials/exercises/basic_tunnel
const bit<16> TYPE_MYTUNNEL = 0x1212;
header myTunnel_t {
    bit<16> proto_id;
    bit<16> dst_id;
}

#define ETHERTYPE_WHARF 0x081C
#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_LLDP  0x88CC

#define TCP_PROTOCOL 0x06
const bit<16>  FEC_PROTOCOL = 0x91;
const bit<16>  PHOTON = 0x92;
#define UDP_PROTOCOL 0x11

header tlv_t {
  bit<7> tlv_type;
  bit<9> tlv_length;
  bit<8> tlv_value;
}

header prefix_tlv_t {
  bit<7> tlv_type;
  bit<9> tlv_length;
}

header activate_fec_tlv_t {
  bit<8> tlv_value;
}

header tcp_h {
    bit<16>             sport;
    bit<16>             dport;
    bit<32>             seq;
    bit<32>             ack;
    bit<4>              dataofs;
    bit<4>              reserved;
    bit<8>              flags;
    bit<16>             window;
    bit<16>             chksum;
    bit<16>             urgptr;
}

header udp_h {
    bit<16>             sport;
    bit<16>             dport;
    bit<16>             len;
    bit<16>             chksum;
}

header photon_h { 
    bit<32>		more_photon;
    bit<32>		count;

    bit<64>		x_coord;
    bit<32>		x_sign;
    bit<32>		x_exp;
    bit<32>		x_randsign;

    bit<64>		y_coord;
    bit<32>		y_sign;
    bit<32>		y_exp;
    bit<32>		y_randsign;

    bit<64>		z_coord;
    bit<32>		z_sign;
    bit<32>		z_exp;
    bit<32>		z_randsign;

    bit<32>		rand_index;
    bit<128>		B;
}

header fec_h{
    int<32> state;
    int<32> votes;
    int<32> counted;
    int<32> phase;
    int<32> candidate;
}

struct headers_t {
    eth_h  eth;
    myTunnel_t   myTunnel;
    ipv4_h ipv4;
    tcp_h tcp;
    udp_h udp;
    fec_h fec;
    photon_h photon;
    tlv_t              lldp_tlv_chassis_id;
    tlv_t              lldp_tlv_port_id;
    tlv_t              lldp_tlv_ttl_id;
    prefix_tlv_t       lldp_prefix;
    activate_fec_tlv_t lldp_activate_fec;
    tlv_t              lldp_tlv_end;
}


parser ALVParser(packet_in pkt, out headers_t hdr) {
    state start {
        transition parse_eth;
    }

    state parse_eth {
        pkt.extract(hdr.eth);
        transition select(hdr.eth.type) {
//            ETHERTYPE_WHARF : parse_fec;
            ETHERTYPE_IPV4 : parse_ipv4;
            ETHERTYPE_LLDP: parse_lldp;
            TYPE_MYTUNNEL: parse_myTunnel; // from tutorials/exercises/basic_tunnel
            default : accept;
        }
    }

    // from tutorials/exercises/basic_tunnel
    state parse_myTunnel {
        pkt.extract(hdr.myTunnel);
        transition select(hdr.myTunnel.proto_id) {
            ETHERTYPE_IPV4: parse_ipv4;
            default: accept;
        }
    }

    state parse_ipv4 {
        pkt.extract(hdr.ipv4);
		transition select(hdr.ipv4.proto) {
            TCP_PROTOCOL: parse_tcp;
            UDP_PROTOCOL: parse_udp;
            default: accept;
        }
    }

    state parse_tcp {
        pkt.extract(hdr.tcp);
        transition accept;
    }

    state parse_udp {
        pkt.extract(hdr.udp);
       		#transition select(hdr.udp.dport) {
	    #FEC_PROTOCOL: parse_fec;
	    #PHOTON: parse_photon;
	    #default: accept;
	    transition parse_photon;
	#}
    }
    
    state parse_fec {
        pkt.extract(hdr.fec);
	transition accept;
    }

    state parse_photon {
    	pkt.extract(hdr.photon);
	transition accept;
    }

    state parse_lldp {
        pkt.extract(hdr.lldp_tlv_chassis_id);
        pkt.extract(hdr.lldp_tlv_port_id);

        // NOTE when this and subsequent parsing code is enabled, 
        // we get this warning, it seems related to the parser: 
        //   *** Warning: Truncation of sized constant detected while generating C++ model:
        //    target width:5, value:48, width of value:6"
        pkt.extract(hdr.lldp_tlv_ttl_id); 
        pkt.extract(hdr.lldp_prefix);

        // FIXME ensure that hdr.lldp_prefix.tlv_type == 7w127
        transition select(hdr.lldp_prefix.tlv_length) {
            9w1 : parse_lldp_activate_fec;
            default        : accept;
        }
    }

    state parse_lldp_activate_fec {
        pkt.extract(hdr.lldp_activate_fec);
        // FIXME ensure that lldp_tlv_end has type=0 etc
        pkt.extract(hdr.lldp_tlv_end);
        transition accept;
    }
}

control ALVDeparser(packet_out pkt, in headers_t hdr) {
    apply {
        pkt.emit(hdr.eth);
        pkt.emit(hdr.myTunnel);
        pkt.emit(hdr.ipv4);
        pkt.emit(hdr.tcp);
        pkt.emit(hdr.udp);
	pkt.emit(hdr.fec);
	pkt.emit(hdr.photon);
        pkt.emit(hdr.lldp_tlv_chassis_id);
        pkt.emit(hdr.lldp_tlv_port_id);
        pkt.emit(hdr.lldp_tlv_ttl_id);
        pkt.emit(hdr.lldp_prefix);
        pkt.emit(hdr.lldp_activate_fec);
        pkt.emit(hdr.lldp_tlv_end);
    }
}

#endif //PARSING_P4_
