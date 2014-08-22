module enigma_tb;

logic              clk_i;
logic              rst_i;

//wrapper ports
logic        [7:0] symb_numb_i;
logic signed [6:0] wrap_i;
logic signed [6:0] wrap_o;

//transit ports
logic signed [6:0] trans1;          //transit between in_symb_i and in_en_o
logic signed [6:0] trans2;          //transit between out_symb_o and out_en_i

integer i;
integer j;

reg[6:0]def_mem[0:127];
 
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
    symb_numb_i = 8'd100;
  end

//reading from file to memory (reading file to wrapper input memory)
initial 
  begin
    wrap_i = 0;
    @( posedge clk_i );
    @( posedge clk_i );
    $readmemb( "in_file.txt", def_mem );
    for ( i=0; i<=symb_numb_i; i=i+1 )                      
      begin
        wrap_i = 0;
        wrap_i = def_mem[i];
        @( posedge clk_i );
        wrap_i = 0;
        @( posedge clk_i );
        @( posedge clk_i );
      end
  end
  
//writing final symbols in the file
initial
  begin
    outfile = $fopen("out_file.txt", "w");
    j = 0;
      forever begin
        #10 if ( (wrap_o > 0) && (wrap_o < 27) )
          begin
            j = j + 1;
            $fwrite (outfile, "%b\t", wrap_o);
            @( posedge clk_i );
          end
      end
    $fclose(outfile);
  end

enigma_1 eg(
.clk_i          (clk_i),
.rst_i          (rst_i),

.in_symb_i      (trans1),

.out_symb_o     (trans2)
);

wrapper wp(
.clk_i          (clk_i),
.rst_i          (rst_i),

.symb_numb_i    (symb_numb_i),
.wrap_i         (wrap_i),
.out_en_i       (trans2),

.wrap_o         (wrap_o),
.in_en_o        (trans1)
);

endmodule
