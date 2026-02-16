`timescale 1ns / 1ps

module ThreeToEightDEC(A,H,I,J,K,L,M,N,O);
input [2:0] A;
output reg H,I,J,K,L,M,N,O;

always @(A) begin
	if(A==3'h0) begin
	H<=1; I<=0;J<=0;K<=0;L<=0;M<=0;N<=0;O<=0;
	end else if(A== 3'h1) begin
	H<=0; I<=1;J<=0;K<=0;L<=0;M<=0;N<=0;O<=0;
	end else if(A== 3'h2) begin
	H<=0; I<=0;J<=1;K<=0;L<=0;M<=0;N<=0;O<=0;
	end else if(A== 3'h3) begin
	H<=0; I<=0;J<=0;K<=1;L<=0;M<=0;N<=0;O<=0;
	end else if(A== 3'h4) begin
	H<=0; I<=0;J<=0;K<=0;L<=1;M<=0;N<=0;O<=0;
	end else if(A== 3'h5) begin
	H<=0; I<=0;J<=0;K<=0;L<=0;M<=1;N<=0;O<=0;
	end else if(A== 3'h6) begin
	H<=0; I<=0;J<=0;K<=0;L<=0;M<=0;N<=1;O<=0;
	end else if(A== 3'h7) begin
	H<=0; I<=0;J<=0;K<=0;L<=0;M<=0;N<=0;O<=1;
	
	end
end

endmodule
