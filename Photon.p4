#include "Parsing.p4"
#include "EmptyBMDefinitions.p4"

#define WIDTH_PORT_NUMBER 9

register<bit<64>>(26) pow10;

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
	bit<32> sign;
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
	    
	    if(hdr.photon.count > 0 && photon_coordinates.apply().hit) {
	    	// compute candidate for upper bound on uniform dist such that after +- a sample B, all coordinates are bound by +-C
	    	// do as function of coordinates, and pick minimum one.  Use scratch to index a coordinates exponent factor into the pow table
		bit<64> min;	    
		bit<64> temp;
	    	// begin with x 
	    	
		//hdr.photon.scratch = (bit<64>)(hdr.photon.x_exp + 1);
		//pow_table.apply(); // applying table its 10^exp into scratch, it really is scratch paper
		//min = 10 * hdr.photon.scratch - hdr.photon.x_coord; //10 is upper bd on change in coords, this scheme works for all C >= 9
		min = hdr.photon.x_coord;

		// now check y
		//hdr.photon.scratch = (bit<64>)(hdr.photon.y_exp + 1);
		//pow_table.apply(); 
		//temp = 10 * hdr.photon.scratch - hdr.photon.y_coord;
		temp = hdr.photon.y_coord;
		if(temp < min){
		    min = temp;
		}
		
		// now check z
		//hdr.photon.scratch = (bit<64>)(hdr.photon.z_exp + 1);
		//pow_table.apply(); 
		//temp = 10 * hdr.photon.scratch - hdr.photon.z_coord;
		temp = hdr.photon.z_coord;
		if(temp < min){
		    min = temp;
		}

		bit<128> alpha = 150; // 150% upper bound on change of component before and after
		// now select, B chosen uniformly with upper bound min, solves the underlying system of (i = # coordinates) inequalities
	    	random<bit<128>>(hdr.photon.B, 0, alpha*(bit<128>)min);
	
		if(hdr.photon.count == 1){
		    hdr.photon.more_photon = 0;
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
	}
        }
	drop();
    
    }
}

control MyEgress(inout headers_t hdr,
		 inout booster_metadata_t m, 
		 inout metadata_t meta){
 
    action recirculate_packet() {
        // Send again the packet through both pipelines
        meta.instance_type = 1;
	recirculate({});
    }
    
    action clone_packet() {
        //const bit<32> REPORT_MIRROR_SESSION_ID = 500;
        // Clone from egress to egress pipeline
	meta.instance_type = 2;
	if(hdr.photon.count <= 1){
	    hdr.photon.more_photon = 0;
	}
        clone3(CloneType.E2E, 2, {});
    }

    apply {
	log_msg("count = {}, instance_type = {}",{hdr.photon.count,meta.instance_type});  
	
	if(hdr.photon.count == 0){
	    drop();
	}
	else if(meta.instance_type != 2){
	    hdr.photon.count = hdr.photon.count - 1;
	    recirculate_packet();
	    clone_packet();
        }
    }
}

V1Switch(CompleteParser(), NoVerify(), Process(), MyEgress(), ComputeCheck(), ALVDeparser()) main;
