module project_tb;

// input ports
  logic              clk;
  logic              rst;
  logic              in_symb_val;
  logic              rotors_rst;
  logic        [7:0] symb_numb;
  logic signed [6:0] in_symbol;

// output ports
  logic              out_symb_val;
  logic signed [6:0] out_symbol;

  logic [6:0] def_mem [127:0];
  
  integer j;
  integer outfile;

// clock
initial                               
  begin
    clk = 1'b0;
    forever
      begin
        #10.0 clk <= ~clk;
      end
  end
  
// reset  
initial                               
  begin
    rst = 1'b1;
    #20;
    rst <= 1'b0;
  end

// only rotors reset  
initial                               
  begin
    rotors_rst = 1'b1;
    #20;
    rotors_rst <= 1'b0;
  end

// incoming symbol is valid
initial
  begin
    in_symb_val = 1'b0;
    @( posedge clk );
    @( posedge clk );
    in_symb_val <= 1'b1;
    repeat( 101 )
      begin
        @( posedge clk );
      end
    in_symb_val <= 1'b0;
  end

// symbols' number
initial
  begin
    symb_numb = 8'd100;
  end

// reading from file to memory (reading file to wrapper input memory)
initial 
  begin
    in_symbol = 0;
    @( posedge clk );
    @( posedge clk );
    $readmemb( "in_file.txt", def_mem );
    for( int i = 0; i <= symb_numb; i = i + 1 )                      
      begin
        in_symbol <= def_mem[i];
        @( posedge clk );
        in_symbol <= 0;
      end
  end
  
// writing final symbols in the file
initial
  begin
    outfile = $fopen( "out_file.txt", "w" );
    j = 0;
      forever begin
        @( posedge clk );
        if( out_symb_val )
          begin
            j = j + 1;
            $fwrite ( outfile, "%b\t", out_symbol );
          end
      end
    $fclose( outfile );
  end

enigma_top et(
  .clk_i         ( clk          ),
  .rst_i         ( rst          ),
  .symb_val_i    ( in_symb_val  ),
  .rotors_rst_i  ( rotors_rst   ),
  .symb_numb_i   ( symb_numb    ),
  .symbol_i      ( in_symbol    ),

  .symb_val_o    ( out_symb_val ),
  .symbol_o      ( out_symbol   )
);


endmodule
