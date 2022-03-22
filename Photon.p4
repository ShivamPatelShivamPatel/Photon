/*
Accompanying P4 program for my implementation of Al-Fares, Loukissas and Vahdat's SIGCOMM 2008 paper.
Nik Sultana, UPenn, February 2020
Nik Sultana, Illinois Tech, November 2021
*/

#include "Parsing.p4"
#include "EmptyBMDefinitions.p4"

#define WIDTH_PORT_NUMBER 9

parser CompleteParser(packet_in pkt, out headers_t hdr, inout booster_metadata_t m, inout metadata_t meta) {
    state start {
        ALVParser.apply(pkt, hdr);
        transition accept;
    }
}

control Process(inout headers_t hdr, inout booster_metadata_t m, inout metadata_t meta) {
    action mac_forward_set_egress(bit<WIDTH_PORT_NUMBER> port) {
        meta.egress_spec = port;
    }

    table mac_forwarding {
        key = {
            hdr.eth.dst : exact;
        }
        actions = {
            mac_forward_set_egress;
            NoAction;
        }
    }

    action coordinates_select(bit<64> x_coord, bit<32> x_sign, bit<32> x_exp,
			      bit<64> y_coord, bit<32> y_sign, bit<32> y_exp, 
			      bit<64> z_coord, bit<32> z_sign, bit<32> z_exp){
	// add extra randomness
	bit<64> B;
	bit<32> sign;

	random<bit<64>>(B, 1000000, 1000000000000);
	hdr.photon.B = B;	

	random<bit<32>>(sign, 0, 1);
	hdr.photon.x_coord = x_coord; 
	hdr.photon.x_sign = x_sign;
	hdr.photon.x_exp = x_exp;
	hdr.photon.x_randsign = sign;
	
	random<bit<32>>(sign, 0, 1);
	hdr.photon.y_coord = y_coord;
	hdr.photon.y_sign = y_sign;
	hdr.photon.y_exp = y_exp;
	hdr.photon.y_randsign = sign;
	
	random<bit<32>>(sign, 0, 1);
	hdr.photon.z_coord = z_coord;
	hdr.photon.z_sign = z_sign;
	hdr.photon.z_exp = z_exp;
	hdr.photon.z_randsign = sign;

	hdr.photon.count = hdr.photon.count - 1;
	
    }

    table photon_coordinates {
    	key = {
	    hdr.photon.rand_index : exact;
	}
	actions = {
	    coordinates_select;
	    NoAction;
	}
    }

    bit<32> dst_gateway_ipv4 = 0;

    action ipv4_forward(bit<32> next_hop, bit<WIDTH_PORT_NUMBER> port) {
        meta.egress_spec = port;
        dst_gateway_ipv4 = next_hop;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }

    table ipv4_forwarding {
        key = {
            hdr.ipv4.dst : ternary;
        }
        actions = {
            ipv4_forward;
            NoAction;
        }
    }

    action arp_lookup_set_addresses(bit<48> mac_address) {
        hdr.eth.src = hdr.eth.dst;
        hdr.eth.dst = mac_address;
    }

    table next_hop_arp_lookup {
        key = {
            dst_gateway_ipv4 : exact;
        }
        actions = {
            arp_lookup_set_addresses;
            NoAction;
        }
    }

    apply {
	if (hdr.photon.isValid()) {
	    random<bit<32>>(hdr.photon.rand_index, 0, 999);
	    if(photon_coordinates.apply().hit == true) {
	    	
            }
	    //else{
	      
	    //}
	}
        if (hdr.eth.isValid()) {
            if (mac_forwarding.apply().hit) return;
            if (hdr.ipv4.isValid() &&
                  hdr.ipv4.ttl > 1 &&
                  ipv4_forwarding.apply().hit) {
                if (next_hop_arp_lookup.apply().hit) {
                    return;
                }
            }
        }
        drop();
    }
}

V1Switch(CompleteParser(), NoVerify(), Process(), NoEgress(), ComputeCheck(), ALVDeparser()) main;
