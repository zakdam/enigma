module enigma_tb;

logic              clk_i;
logic              rst_i;
logic        [5:0] symb_numb_i;
logic signed [5:0] wrap_i;     //receiving encoded symbol from enigma
logic signed [5:0] wrap_o;     //generating incoming symbol for enigma

integer i;

reg[5:0]def_mem[0:15];
  
integer outfile;


//clock
initial                               
  begin
    clk_i = 1'b0;
    forever
      begin
        #10.0 clk_i = ~clk_i;
      end
  end
  
//reset  
initial                               
  begin
    rst_i = 1'b0;
    #10;
    rst_i = 1'b1;
  end

//symbols' number
initial
  begin
    symb_numb_i = 6'd3;
  end

//reading from file to memory  
initial 
  begin
    $readmemb( "in_file.txt", def_mem );
    for ( i=0; i<=(symb_numb_i); i=i+1 )
      begin
        wrap_o = 0;
        wrap_o = def_mem[i];
        @( posedge clk_i );
        wrap_o = 0;
        @( posedge clk_i );
        @( posedge clk_i );
        @( posedge clk_i );
        @( posedge clk_i );
      end
  end
  
//writing final symbols in the file
initial
  begin
    outfile = $fopen("out_file.txt", "w");
       forever begin
        #10 if ( (wrap_i > 0) && (wrap_i < 27) )
          begin
            $fwrite (outfile, "%d\t", wrap_i);
            @( posedge clk_i );
            @( posedge clk_i );
            @( posedge clk_i );
            @( posedge clk_i );
            @( posedge clk_i );
          end
      end
    $fclose(outfile);
  end

enigma_1 eg(
.clk_i          (clk_i),
.rst_i          (rst_i),
.in_symb_i      (wrap_o),

.out_symb_o     (wrap_i)
);

endmodule
