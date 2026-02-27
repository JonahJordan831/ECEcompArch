`timescale 1ns / 1ps
module main(
    inbev1, inbev2, inbev3, inbev4,
    inQuarter, inDime, inNickel,
    resetCount,
    cancel,
    outbev1, outbev2, outbev3, outbev4,
    outquarter, outdime, outnickel,
    clk, rst
);

input inbev1, inbev2, inbev3, inbev4;
input inQuarter, inDime, inNickel;
input resetCount;
input cancel;
input clk, rst;

output outbev1, outbev2, outbev3, outbev4;
output outquarter, outdime, outnickel;

wire [9:0] moneyin;
wire [9:0] moneyout_wire;
wire [9:0] change;
reg [9:0] refund;
reg cancel_delay; 

always @(posedge clk) begin
    if(rst)
        cancel_delay <= 0;
    else
        cancel_delay <= cancel;
end

always @(posedge clk) begin
    if(rst) begin
        refund <= 0;
    end else if(cancel) begin
        refund <= moneyin;  // latch moneyin on cancel
    end else begin
        refund <= 0;
    end
end

assign change = (cancel | cancel_delay) ? refund : moneyout_wire;  // CHANGED: hold change signal valid for two cycles

CoinCounter cc(
    .inQuarter(inQuarter),
    .inDime(inDime),
    .inNickel(inNickel),
    .outCount(moneyin),
    .resetCount(cancel_delay),  // CHANGED: clear one cycle after cancel
    .clk(clk),
    .rst(rst)
);

BevDispenser bd(
    .inbev1(inbev1),
    .inbev2(inbev2),
    .inbev3(inbev3),
    .inbev4(inbev4),
    .moneyin(moneyin),
    .outbev1(outbev1),
    .outbev2(outbev2),
    .outbev3(outbev3),
    .outbev4(outbev4),
    .moneyout(moneyout_wire),
    .clk(clk),
    .rst(rst | cancel)
);

CoinDispenser cd(
    .change(change),
    .outquarter(outquarter),
    .outdime(outdime),
    .outnickel(outnickel),
    .clk(clk),
    .rst(rst)
);

endmodule




