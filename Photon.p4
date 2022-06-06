#include "Parsing.p4"
#include "EmptyBMDefinitions.p4"

#define WIDTH_PORT_NUMBER 9
struct function_evals_t {
    int<64> lnx;
    int<64> exp;
    int<64> cosx;
    int<64> sinx;
    int<64> arccosx;
    int<64> phi;
    int<64> theta;
    int<64> scratch;
    bit<1>  is_sin;
}

// (-1)^(k+1)/k
register<int<64>>(21) ln_coefficients;

// 1/k!
register<int<64>>(19) exp_coefficients;

// (-1)^k/(2k)!
register<int<64>>(10)  cos_coefficients;

// (-1)^k/(2k+1)!
register<int<64>>(9)  sin_coefficients;

// (2k)!/((2^(2k))(k!^2)(2k+1))
register<int<64>>(21) arcsin_coefficients;

parser CompleteParser(packet_in pkt, out headers_t hdr, inout booster_metadata_t m, inout metadata_t meta) {
    state start {
        ALVParser.apply(pkt, hdr);
        transition accept;
    }
}

control Process(inout headers_t hdr, inout booster_metadata_t m, inout metadata_t meta ) {
    action operation_ln(inout function_evals_t func_evals) {
    	bit<32> k = 0;
    	int<64> temp = 0;
    	int<64> negone = -72057594037927936;
	int<64> x = func_evals.scratch;
    	int<64> xminusa = (x << 6) + negone;
    	int<64> xminusak = xminusa;
	int<128> prod = 0;
	int<128> zero = 0;
	int<64> ck = 0;
	ln_coefficients.read(ck,k);
    	int<64> lnx = -ck;
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    	
	k = 1;
    	lnx = lnx + xminusak;
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 2;
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	ln_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
   	k = 3;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 4;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 5;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 6;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 7;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 8;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 9;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 10;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});

    	k = 11;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 12;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp; 
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});

    	k = 13;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
   	k = 14;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 15;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 16;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 17;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 18;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 19;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx + temp;  
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});
    
    	k = 20;
	ln_coefficients.read(ck,k);
	xminusak = (int<64>)(((int<128>)(xminusak)*(int<128>)(xminusa)) >> 56);
	temp = (int<64>)(((int<128>)(xminusak)*(int<128>)(ck)) >> 56);
    	lnx = lnx - temp;
	log_msg("k ={},temp = {},negone ={},x ={},xminusa ={},xminusak = {},ck = {},-ck = {},lnx = {}",{k,temp,negone,x,xminusa,xminusak,ck,-ck,lnx});

	func_evals.lnx = lnx;  
    }    
    action operation_exp(inout function_evals_t func_evals) {
    	bit<32> k = 0;
    	int<64> temp_coef = 0;
    	int<64> temp_var = 0;
    	int<64> expua_a = 79933946771164448;
    	//int<64> expua_a = 78059059749059536;
	int<64> ua = -1441151880758558;
	int<64> ua2thek = ua;
	int<64> four = 373744408166364288;
	//int<64> four = 288230376151711744;
	int<64> xplus4 = func_evals.scratch + four;
    	int<64> xplus4k = xplus4;
	int<64> ck = 0;
	exp_coefficients.read(ck,k);
    	int<64> exp = (int<64>)(((int<128>)(expua_a)*(int<128>)(ck)) >> 56);

    	k = 1;
	exp_coefficients.read(ck,k);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    	
	k = 2;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);

    	k = 3;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
    	k = 4;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
    	k = 5;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
    	k = 6;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
    	k = 7;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
    	k = 8;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
    	k = 9;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
    	k = 10;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
	
	k = 11;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
	k = 12;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
	k = 13;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
	k = 14;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
	k = 15;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
	k = 16;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
	k = 17;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
    
	k = 18;
	exp_coefficients.read(ck,k);
	ua2thek = (int<64>)(((int<128>)(ua2thek)*(int<128>)(ua)) >> 56);
	xplus4k = (int<64>)(((int<128>)(xplus4k)*(int<128>)(xplus4)) >> 56);
	temp_coef = (int<64>)(((int<128>)(ua2thek)*(int<128>)(expua_a)) >> 56);
	temp_var = (int<64>)(((int<128>)(xplus4k)*(int<128>)(ck)) >> 56);
    	exp = exp + (int<64>)(((int<128>)(temp_coef)*(int<128>)(temp_var)) >> 56);
   
	func_evals.exp = exp;
    }
     
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
	function_evals_t func_evals;
	func_evals.lnx = 0;
	func_evals.exp = 0;
	func_evals.cosx = 0;
	func_evals.sinx = 0;
	func_evals.arccosx = 0;
	func_evals.phi = 0;
	func_evals.theta = 0;
	func_evals.scratch = 0;
	func_evals.is_sin = 0;
	if (hdr.photon.isValid()) {
	    
	    if(hdr.photon.count > 0) {
	
		if(hdr.photon.count == 1){
		    hdr.photon.more_photon = 0;
		}

		//int<64> x = 0;
		//bit<64> l = 72057594037927; 
		//bit<64> u = 2251799813685248;
		
		// select random.random()/us
		random<int<64>>(func_evals.scratch,72057594037927,2251799813685248);					     
		
		// compute natural log
		operation_ln(func_evals);
		
		// now the result is in func_evals.lnx so put it into scratch
		func_evals.scratch = -func_evals.lnx;
		hdr.photon.d = -func_evals.lnx;
	
		// now compute the exponential(with coefficient -0.02
		operation_exp(func_evals);

		// update weight before going to egress
		hdr.photon.weight = (int<64>)(((int<128>)(hdr.photon.weight)*(int<128>)(func_evals.exp)) >> 56);
		

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
		 inout metadata_t meta/*,
		 inout function_evals_t func_evals*/){

    action operation_cos(inout function_evals_t func_evals) {
    	bit<32> k = 0;
    	int<64> temp = 0;
	int<64> x = func_evals.scratch >> 1;
	
	int<64> xsquare = (int<64>)(((int<128>)(x)*(int<128>)(x)) >> 56);
    	int<64> x2k = xsquare;

	int<64> ck = 0;
	cos_coefficients.read(ck,k);
    	int<64> cosx = ck;


    	k = 1;
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(-ck)) >> 56);
   	cosx = cosx + temp;
    
    	k = 2;
	x2k = (int<64>)(((int<128>)(x2k)*(int<128>)(xsquare)) >> 56);
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(ck)) >> 56);
    	cosx = cosx + temp;
    
    	k = 3;
	x2k = (int<64>)(((int<128>)(x2k)*(int<128>)(xsquare)) >> 56);
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(-ck)) >> 56);
    	cosx = cosx + temp;
    
    	k = 4;
	x2k = (int<64>)(((int<128>)(x2k)*(int<128>)(xsquare)) >> 56);
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(ck)) >> 56);
    	cosx = cosx + temp;
    
    	k = 5;
	x2k = (int<64>)(((int<128>)(x2k)*(int<128>)(xsquare)) >> 56);
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(-ck)) >> 56);
    	cosx = cosx + temp;
    
    	k = 6;
	x2k = (int<64>)(((int<128>)(x2k)*(int<128>)(xsquare)) >> 56);
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(ck)) >> 56);
    	cosx = cosx + temp;

    	k = 7;
	x2k = (int<64>)(((int<128>)(x2k)*(int<128>)(xsquare)) >> 56);
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(-ck)) >> 56);
    	cosx = cosx + temp;

    	k = 8;
	x2k = (int<64>)(((int<128>)(x2k)*(int<128>)(xsquare)) >> 56);
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(ck)) >> 56);
    	cosx = cosx + temp;
    	
	k = 9;
	x2k = (int<64>)(((int<128>)(x2k)*(int<128>)(xsquare)) >> 56);
	cos_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k)*(int<128>)(-ck)) >> 56);
    	cosx = cosx + temp;


	// god has blessed us.  if it wasnt for trigonometry we would have to increase the bit count to the 200's
	if(func_evals.is_sin == 1){
	    //double angle formula Sin(2x) = 2Sin(x)Cos(x), for us x = theta/2 
	    func_evals.sinx = (((int<64>)(((int<128>)(func_evals.sinx)*(int<128>)(cosx)) >> 56)) << 1);
	}
	else{
	    //half angle formula cos(2x) = 2Cos^2(x) -1
	    func_evals.cosx = ((((int<64>)(((int<128>)(cosx)*(int<128>)(cosx)) >> 56)) << 1) - 72057594037927936);
	}
    }

    action operation_sin(inout function_evals_t func_evals) {
    	bit<32> k = 0;
    	int<64> temp = 0;
	int<64> x = func_evals.scratch >> 1;
	int<64> xsquare = (int<64>)(((int<128>)(x)*(int<128>)(x)) >> 56);
    	int<64> x2k1 = x;

	int<64> ck = 0;
	sin_coefficients.read(ck,k);
	int<64> sinx = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	
    	k = 1;
	sin_coefficients.read(ck,k);
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(-ck)) >> 56);
   	sinx = sinx + temp;
    
    	k = 2;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	sin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	sinx = sinx + temp;
    
    	k = 3;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	sin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(-ck)) >> 56);
    	sinx = sinx + temp;
    
    	k = 4;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	sin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	sinx = sinx + temp;
    
    	k = 5;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	sin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(-ck)) >> 56);
    	sinx = sinx + temp;
    
    	k = 6;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	sin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	sinx = sinx + temp;

    	k = 7;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	sin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(-ck)) >> 56);
    	sinx = sinx + temp;

    	k = 8;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	sin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	sinx = sinx + temp;
	
	// mark metadata as did invoke sin, therefore in sendback, sends back this modified value instead of normal cosine
	func_evals.sinx = sinx;
	func_evals.is_sin = 1;
	operation_cos(func_evals);
	func_evals.is_sin = 0;
    }

    action operation_arccos(inout function_evals_t func_evals) {
    	bit<32> k = 0;
    	int<64> temp = 0;
	int<64> piover2 = 113187804032455040;
	int<64> x = func_evals.scratch;
	int<64> xsquare = (int<64>)(((int<128>)(x)*(int<128>)(x)) >> 56);
    	int<64> x2k1 = x;
	
	int<64> ck = 0;
	arcsin_coefficients.read(ck,k);
	int<64> arcsinx = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);

    	k = 1;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
    
    	k = 2;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
    
    	k = 3;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 4;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 5;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 6;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 7;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 8;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 9;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 10;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 11;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 12;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 13;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 14;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 15;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 16;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 17;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
  	
	k = 18;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
 
    	k = 19;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
   
    	k = 20;
	x2k1 = (int<64>)(((int<128>)(x2k1)*(int<128>)(xsquare)) >> 56);
	arcsin_coefficients.read(ck,k);
	temp = (int<64>)(((int<128>)(x2k1)*(int<128>)(ck)) >> 56);
    	arcsinx = arcsinx + temp;
    	
	func_evals.arccosx = (piover2 - arcsinx);
    }
 
 
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
	function_evals_t func_evals;
	func_evals.lnx = 0;
	func_evals.exp = 0;
	func_evals.cosx = 0;
	func_evals.sinx = 0;
	func_evals.arccosx = 0;
	func_evals.phi = 0;
	func_evals.theta = 0;
	func_evals.scratch = 0;
	func_evals.is_sin = 0;
	log_msg("count = {}, instance_type = {}",{hdr.photon.count,meta.instance_type});  
	
	if(hdr.photon.count == 0){
	    drop();
	}
	else if(meta.instance_type != 2){
	    if(hdr.photon.weight > 7205759403792794){
	    	// this circulate is for if we didnt lose enough energy yet, like while weight > 0.1
	    	recirculate_packet();
	    }
	    else{
	    	hdr.photon.count = hdr.photon.count - 1;
	    	hdr.photon.weight = (1 << 56);
	    
            	int<64> d = hdr.photon.d;
	    
	    	// set argument to some val in between -1 to 1 for arccos

	    	// in principle we are setting it from 1.78ish to 2, and then subtracting one since cant put negatives into random
	    	random<int<64>>(func_evals.scratch,68454714336031536,1 << 56);
	    	//func_evals.scratch = func_evals.scratch + (-72057594037927936);					     
	    
	    	// call arccos on scratch, now func_evals.arccosx will be updated
	    	operation_arccos(func_evals);

	    	// prepare our angles
	    	int<64> phi = func_evals.arccosx;
	    	int<64> theta = 0;
	    
	    	// select random angle between 0 and 2pi but slid to -pi, pi
	    	// pi 226375608064910080

	    	// select random number in (0,1)
	    	random<int<64>>(theta,0,1 << 56);
	    
	    	// if x = theta
	    	// scale x -> pi(2x-1).  if 0 < x < 1, then -pi < pi(2x-1) < pi
	
	    	theta = (theta << 1) + (-72057594037927936);
	    	theta = (int<64>)(((int<128>)(theta)*(int<128>)(226375608064910080)) >> 56);
	
	    	// evaluate trig functions for phi
	    	func_evals.scratch = phi;
	    	operation_cos(func_evals);
	    	operation_sin(func_evals);
	    
	    	int<64> x = (int<64>)(((int<128>)(d)*(int<128>)(func_evals.sinx)) >> 56);
	    	int<64> y = (int<64>)(((int<128>)(d)*(int<128>)(func_evals.sinx)) >> 56);
	    	int<64> z = (int<64>)(((int<128>)(d)*(int<128>)(func_evals.cosx)) >> 56);
	
	    	// evaluate trig functions for theta
	    	func_evals.scratch = theta;
	    	operation_cos(func_evals);
	    	operation_sin(func_evals);
	    
	    	x = (int<64>)(((int<128>)(x)*(int<128>)(func_evals.cosx)) >> 56);
	    	y = (int<64>)(((int<128>)(y)*(int<128>)(func_evals.sinx)) >> 56);
	
	    	// fill header and send back to host
	    	hdr.photon.x = x;
	    	hdr.photon.y = y;
	    	hdr.photon.z = z;
	    
	    	// dont need these, but nice for analysis of the distribution
	    	hdr.photon.phi = phi;
	    	hdr.photon.theta = theta;
	
	    	// this recirculate decrements count like for i in range(0,count)
	    	recirculate_packet();
	    	// send a copy out on the egress port
	    	clone_packet();
	    }
        }
    }
}

V1Switch(CompleteParser(), NoVerify(), Process(), MyEgress(), ComputeCheck(), ALVDeparser()) main;
