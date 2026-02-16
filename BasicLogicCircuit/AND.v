`timescale 1ns / 1ps

module AND(X, Y, C, Q  );

input X, Y, C;

output Q;

assign Q = (X&Y&C);


endmodule
