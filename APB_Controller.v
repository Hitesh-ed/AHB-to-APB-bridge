module APB_Controller(input [31:0]Haddr,Haddr1,Haddr2,Hwdata,Hwdata1,Hwdata2,
		      input [2:0]tempselx,
		      input Hwritereg,valid,Hresetn,Hwrite,Hclk,
		      output reg Penable,Pwrite,Hreadyout,
		      output reg [2:0]Pselx,[31:0]Pwdata,Paddr,
			input [31:0]Prdata,
			output [31:0] Hrdata);

// Parameters //
parameter ST_IDLE = 3'b000;
parameter ST_WWAIT = 3'b001;
parameter ST_READ = 3'b010;
parameter ST_WRITE = 3'b011;
parameter ST_WRITEP = 3'b100;
parameter ST_RENABLE = 3'b101;
parameter ST_WENABLE = 3'b110;
parameter ST_WENABLEP = 3'b111;

// Present State Logic //
reg [2:0]present_state,next_state;

always@(posedge Hclk)
	begin
		present_state <= ST_IDLE;
	if(~Hresetn) 
		present_state <= ST_IDLE;
	else 
		present_state <= next_state;   	
	end

// Next State Logic //

always@(*)
	begin
		case(present_state) 

		ST_IDLE :  begin if(~Hresetn && ~valid)
				next_state <= ST_IDLE;

			  else if(valid && Hwrite)
				next_state <= ST_WWAIT;

			  else if(valid&&~Hwrite) 
				next_state <= ST_READ;
				
			  else
				next_state <= ST_IDLE; end

		ST_WWAIT : begin if(valid)
				next_state <= ST_WRITEP;
			 
			   else if (~valid)
				next_state <= ST_WRITE;

			   else next_state <= ST_IDLE; end

		ST_WRITE : begin if(valid)
				next_state <= ST_WENABLEP;
				
			   else if(~valid)
				next_state <= ST_WENABLE;

			   else next_state <= ST_IDLE; end

		ST_WRITEP : next_state <= ST_WENABLEP;

		ST_WENABLEP : begin if(valid && Hwritereg)
			 	next_state <= ST_WRITEP;

			      else if(Hwritereg && ~valid)
				next_state <= ST_WRITE;

			      else if (~Hwritereg)
				next_state <= ST_READ;

			      else 
				next_state <= ST_IDLE; end
		
		ST_READ :  next_state <= ST_RENABLE;

		ST_WENABLE : begin if(valid && ~Hwrite)
				next_state <= ST_READ;

			     else if(~valid)
				next_state <= ST_IDLE;

			     else if(valid&&Hwrite)
				next_state <= ST_WWAIT;

			     else next_state <= ST_IDLE; end

		ST_RENABLE : begin if(valid && ~Hwrite)
				next_state <= ST_READ;

			     else if(~valid)
				next_state <= ST_IDLE;

			     else if(valid && Hwrite)
				next_state <= ST_WWAIT; 

			     else next_state <= ST_IDLE; end
				
		default : next_state <= ST_IDLE;
		
endcase
end

// State Combinational Logic //

reg Penable_temp,Hreadyout_temp,Pwrite_temp;
reg [2:0] Pselx_temp;
reg [31:0] Paddr_temp, Pwdata_temp;

always @(*)
 begin
   case(present_state)
    
	ST_IDLE: begin
			  if (valid && ~Hwrite) 
			   begin  // idle to read
			        Paddr_temp = Haddr;
				Pwrite_temp = 0;
				Pselx_temp = tempselx;
				Penable_temp = 0;
				Hreadyout_temp = 0;
			   end
			  
			  else if (valid && Hwrite) // idle to wwait
			   begin  
			        Pselx_temp = 0;
				Penable_temp = 0;
				Hreadyout_temp = 1;			   
			   end
			   
			  else // idle to idle
                            begin
			        Pselx_temp = 0;
				Penable_temp = 0;
				Hreadyout_temp = 1;	
			   end
		     end    

	ST_WWAIT:begin
			if (~valid) // wwait to write
			   begin
			    	Paddr_temp = Haddr1;
				Pwdata_temp = Hwdata;
				Pwrite_temp = 1;
				Pselx_temp = tempselx;
				Penable_temp = 0;
				Hreadyout_temp = 0;
			   end
			  
			else // wwait to writep
			   begin
			    	Paddr_temp = Haddr1;
				Pwrite_temp = 1;
				Pselx_temp = tempselx;
				Pwdata_temp = Hwdata;
				Penable_temp=0;
				Hreadyout_temp = 0;		   
			   end
			   
		     end  

	ST_READ: begin // read to renable
			  Penable_temp = 1;
			  Hreadyout_temp = 1;
		     end

	ST_WRITE:begin
			if (~valid) // write to wenable
			   begin
				Penable_temp = 1;
				Hreadyout_temp = 1;
			   end
			  
			else 
			   begin // write to wenablep
				Penable_temp = 1;
				Hreadyout_temp = 1;		   
			   end
		     end

	ST_WRITEP:begin // writep to write 
               		   Penable_temp = 1;
			   Hreadyout_temp = 1;
		      end

	ST_RENABLE:begin
	            if (valid && ~Hwrite) 
				 begin // renable to read
					Paddr_temp = Haddr;
					Pwrite_temp = 0;
					Pselx_temp = tempselx;
					Penable_temp=0;
					Hreadyout_temp=0;
				 end
			  
			  else if (valid && Hwrite)
			    begin // renable to wwait
				Pselx_temp = 0;
				Penable_temp = 0;
				Hreadyout_temp = 1;			   
			    end
			   
			  else
               		    begin // renable to idle 
			     Pselx_temp=0;
				 Penable_temp=0;
				 Hreadyout_temp=1;	
			    end

		       end

	ST_WENABLEP:begin
                 if (valid && Hwritereg) 
			      begin // wenablep to writep
			      	   Paddr_temp = Haddr2;
				   Pwdata_temp = Hwdata;				
				   Pwrite_temp = 1;
				   Pselx_temp = tempselx;
				   Penable_temp = 0;
				   Hreadyout_temp=0;
				end

			  
			    else if(~valid && Hwritereg)
			     begin // wenablep to write // doubt
			      	  Paddr_temp = Haddr2;
				  Pwrite_temp = 1;
				  Pselx_temp = tempselx;
				  Pwdata_temp = Hwdata;
				  Penable_temp = 0;
				  Hreadyout_temp = 0;		   
			     end

			   else if(~Hwritereg)
			    begin // wenablep to read 
				Hreadyout_temp = 1;
				Paddr_temp = Haddr;
				Pwrite_temp = 0;
				Pselx_temp = tempselx;
				Penable_temp = 1;
		 	    end
		        end

	ST_WENABLE :begin
			if (valid && Hwrite)
				begin // wenable to wwait
				   Pselx_temp = 0;
				   Penable_temp = 0;
				   Hreadyout_temp = 1;	
				end
			else if (valid && ~Hwrite)
				begin // wenable to read
				   Hreadyout_temp = 1;
				   Paddr_temp = Haddr;
				   Pwrite_temp = 0;
				   Pselx_temp = tempselx;
				   Penable_temp = 1;
				end
			else if (~valid) // wenable to idle
			      begin
				   Pselx_temp = 0;
				   Penable_temp = 0;
				   Hreadyout_temp = 1;
				end

		        end

		default :  begin
				   Pselx_temp = 0;
				   Penable_temp = 0;
				   Hreadyout_temp = 1;
				end


endcase
end

always@(posedge Hclk)
begin
	Paddr <= Paddr_temp;
	Penable <= Penable_temp;
	Hreadyout <= Hreadyout_temp;
	Pselx <= Pselx_temp;
	Pwdata <= Pwdata_temp; 
	Pwrite <= Pwrite_temp;
end

// for testbench purpose only
assign Hrdata = Prdata;
endmodule 