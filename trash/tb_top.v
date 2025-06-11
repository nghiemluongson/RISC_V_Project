module tb_top();

    reg clk;
    reg reset;

    top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial clk = 0;
    always #10 clk = ~clk;

    // Reset sequence
    initial begin
        reset = 1;
        #50 reset = 0;
        #1000 $stop;
    end

endmodule
