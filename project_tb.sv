module project_tb;

//input ports
  logic              clk;
  logic              rst;
  logic              symb_val;
  logic              rotors_rst;
  logic        [7:0] symb_numb;
  logic signed [6:0] symbol;

//output ports
  logic              symb_val;
  logic signed [6:0] symbol;

	integer i;
  integer j;

  logic [6:0] def_mem [127:0];
  
  integer outfile;

//clock
initial                               
  begin
    clk = 1'b0;
    forever
      begin
        #10.0 clk <= ~clk;
      end
  end
  
//reset  
initial                               
  begin
    rst = 1'b1;
    #10;
    rst <= 1'b0;
  end

//only rotors reset  
initial                               
  begin
    rotors_rst = 1'b0;
    #10;
    rotors_rst <= 1'b1;
  end

//incoming symbol is valid
initial
  begin
    symb_val = 1'b0;
    @( posedge clk );
    @( posedge clk );
    symb_val <= 1'b1;
    repeat( 101 )
      begin
        @( posedge clk );
      end
    //#2010;
    //@( posedge clk_i );
    symb_val <= 1'b0;
  end

//symbols' number
initial
  begin
    symb_numb = 8'd100;
  end

//reading from file to memory (reading file to wrapper input memory)
initial 
  begin
    symbol = 0;
    @( posedge clk );
    @( posedge clk );
    $readmemb( "in_file.txt", def_mem );
    for( i = 0; i <= symb_numb_i; i = i + 1 )                      
      begin
        symbol <= def_mem[i];
        @( posedge clk );
        symbol <= 0;
      end
  end
  
//writing final symbols in the file
initial
  begin
    outfile = $fopen( "out_file.txt", "w" );
    j = 0;
      forever begin
        #10 if( symb_val_o )
          begin
            j = j + 1;
            $fwrite ( outfile, "%b\t", symbol_o );
            @( posedge clk_i );
          end
      end
    $fclose( outfile );
  end

enigma_top et(
  .clk_i         ( clk         ),
  .rst_i         ( rst         ),
  .symb_val_i    ( symb_val    ),
  .rotors_rst_i  ( rotors_rst  ),
  .symb_numb_i   ( symb_numb   ),
  .symbol_i      ( symbol      ),

  .symb_val_o    ( symb_val    ),
  .symbol_o      ( symbol      )
);


endmodule
