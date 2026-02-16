`timescale 1ns / 1ps


module HW2_tb;

	// Inputs
	reg A;
	reg B;
	reg C;

	// Outputs
	wire Q;

	// Instantiate the Unit Under Test (UUT)
	TOP uut (
		.A(A), 
		.B(B), 
		.C(C), 
		.Q(Q)
	);
	integer file;
	initial begin
	
/*
		// Initialize Inputs       // initial test before i made a file
		A = 0;B = 0;C = 0; #20;
		A = 0;B = 0;C = 1; #20;
		A = 0;B = 1;C = 0; #20;
		A = 0;B = 1;C = 1; #20;
		A = 1;B = 0;C = 0; #20;
		A = 1;B = 0;C = 1; #20;
		A = 1;B = 1;C = 0; #20;
		A = 1;B = 1;C = 1; #20;

		$finish;
        
		// Add stimulus here

	end
      */
		
	
		file = $fopen("truth_table.txt", "w"); //stores truth table in this file
		$fwrite(file, "Truth Table:\n");
		$fwrite(file, "A B C | Q\n");
		$fwrite(file, "------|--\n");
		
		A = 0;B = 0;C = 0; #20;
		$fwrite(file, "%b %b %b | %b\n", A, B, C, Q);
		A = 0;B = 0;C = 1; #20;
		$fwrite(file, "%b %b %b | %b\n", A, B, C, Q);
		A = 0;B = 1;C = 0; #20;
		$fwrite(file, "%b %b %b | %b\n", A, B, C, Q);
		A = 0;B = 1;C = 1; #20;
		$fwrite(file, "%b %b %b | %b\n", A, B, C, Q);
		A = 1;B = 0;C = 0; #20;
		$fwrite(file, "%b %b %b | %b\n", A, B, C, Q);
		A = 1;B = 0;C = 1; #20;
		$fwrite(file, "%b %b %b | %b\n", A, B, C, Q);
		A = 1;B = 1;C = 0; #20;
		$fwrite(file, "%b %b %b | %b\n", A, B, C, Q);
		A = 1;B = 1;C = 1; #20;
		$fwrite(file, "%b %b %b | %b\n", A, B, C, Q);
		
		$fclose(file);
		$finish;
		end
endmodule

