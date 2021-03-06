`timescale 10 ns/ 1 ns
module tb_dht11;
    parameter BYTE_SZ  = 8;           // widht byte
    parameter VALUE_SZ = 2 * BYTE_SZ; // widht value
  
//------------------------------------------------------------------------       
    reg                        CLK;         // clk 50 MHz
    reg                        RST_n;       // asynchronous reset
    reg                        I_EN;        // starts sensor polling  
    wire                       strobe;      // clock enable (strobe) 
    wire                       IO_DHT11;    // data line    
    wire                       rs_dht11_in; // rising edge of the data line from DHT11
    wire                       fl_dht11_in; // falling edge of the data line from DHT11          
    wire signed [VALUE_SZ-1:0] O_VALUE;     // data Temperature & Humidity  
    wire                       O_ERR;       // received data error flag
    wire                       O_CONV;      // signal start converting binary to BCD
    wire                       O_BUSY;      // busy
    reg                        en_dht_slv;  // enable DHT11
    reg                        dht_slv;     // transfer from DHT11

//------------------------------------------------------------------------       
    assign IO_DHT11 = en_dht_slv ? dht_slv : 1'b1;
    assign strobe   = dut.strobe;
    assign rs_dht11_in      = dut.rs_dht11_in;   
    assign fl_dht11_in     = dut.fl_dht11_in;

//------------------------------------------------------------------------       
    top_dht11 dut
        (
         .CLK(CLK),
         .RST_n(RST_n),
         .I_EN(I_EN),
         .O_VALUE(O_VALUE),
         .O_ERR(O_ERR),
         .O_CONV(O_CONV),
         .O_BUSY(O_BUSY),
         .IO_DHT11(IO_DHT11)
        );

//------------------------------------------------------------------------       
    initial begin
      CLK = 1'b1;
      RST_n = 1'b1;
      I_EN = 1'b0;    
      en_dht_slv = 1'b0;
      dht_slv = 1'b0;
//    start reset
      #1; RST_n = 0;
//    stop reset
      #2; RST_n = 1; 
      #100099; I_EN = 1'b1;
      #2; I_EN = 1'b0;      
      en_dht_slv = 1'b1; dht_slv = 1'b0;
      #2000000; en_dht_slv = 1'b0;
      #2000; en_dht_slv = 1'b1; dht_slv = 1'b0;
      #8000; en_dht_slv = 1'b0;
      #8000; en_dht_slv = 1'b1; dht_slv = 1'b0;
      
//    transfer of the first byte 8'b0101_0101;
      repeat (4)
        begin
          #5000; en_dht_slv = 1'b0; dht_slv = 1'b1;
          #2800; en_dht_slv = 1'b1; dht_slv = 1'b0;
          #5000; en_dht_slv = 1'b0; dht_slv = 1'b1;
          #7000; en_dht_slv = 1'b1; dht_slv = 1'b0;           
        end 

//    transfer of the second byte 8'b0000_0000;
      repeat (8)
        begin
          #5000; en_dht_slv = 1'b0; dht_slv = 1'b1;
          #2800; en_dht_slv = 1'b1; dht_slv = 1'b0;
        end

//    transfer of the third byte 8'b1010_1010;       
      repeat (4)
        begin
          #5000; en_dht_slv = 1'b0; dht_slv = 1'b1;
          #7000; en_dht_slv = 1'b1; dht_slv = 1'b0;
          #5000; en_dht_slv = 1'b0; dht_slv = 1'b1;
          #2800; en_dht_slv = 1'b1; dht_slv = 1'b0;
        end
         
//    transfer of the fourth byte 8'b0000_0000;
      repeat (8)
        begin
          #5000; en_dht_slv = 1'b0; dht_slv = 1'b1;
          #2800; en_dht_slv = 1'b1; dht_slv = 1'b0;
        end 
         
//    transfer of the fifth byte 8'b1111_1111;
      repeat (8)
        begin
          #5000; en_dht_slv = 1'b0; dht_slv = 1'b1;
          #7000; en_dht_slv = 1'b1; dht_slv = 1'b0;
        end
      
      #5000; en_dht_slv = 1'b0; 
    end
    
    always #1 CLK = ~CLK;
    
    initial begin
      // $dumpvars;
      #2510000 $finish;
    end   

    
endmodule