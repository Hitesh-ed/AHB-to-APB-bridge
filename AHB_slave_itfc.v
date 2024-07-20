module AHB_slave_itfc(input Hclk,Hwrite,Hresetn,Hreadyin,
                       [1:0]Htrans,[31:0]Haddr,[31:0]Hwdata,
                      output [1:0]Hresp,
		      output reg [31:0]Haddr1,Haddr2,Hwdata1,Hwdata2,
		      output reg [2:0]tempselx,
		      output reg Hwritereg,valid );

reg temp;

//Valid Logic  
always@(*)
	begin
		valid = 1'b0;
		if(Hreadyin && (Htrans[1:0] == 2'b10 |Htrans[1:0] == 2'b11) && (Haddr[31:0] >= 32'h80000000 && Haddr[31:0] < 32'h8C000000)) 	 
		valid = 1'b1; 
		else valid = 1'b0;
	end

//Slave Select Logic
always@( Haddr )
	begin
		
		if (Haddr>=32'h80000000 && Haddr < 32'h84000000 ) tempselx = 3'b001;
		else if (Haddr>=32'h84000000 && Haddr < 32'h88000000 ) tempselx = 3'b010;
		else if (Haddr>=32'h88000000 && Haddr < 32'h8C000000 ) tempselx = 3'b100;
		else tempselx = 3'b000;
	end

// Address and Data Pipeline
always@(posedge Hclk or negedge Hresetn)
	begin 
		if(~Hresetn) begin
		// Address Pipeline
		Haddr1<=0;
		Haddr2<=0;
				
		//Data Pipleline
		Hwdata1<=0;
		Hwdata2<=0; 

		Hwritereg <=0;	end
		
		else begin
		// Address Pipeline
		Haddr1<=Haddr;
		Haddr2<=Haddr1;
		
		//Data Pipleline
		Hwdata1<=Hwdata;
		Hwdata2<=Hwdata1; 

		temp <= Hwrite;
		Hwritereg <= temp; end		
	end 

assign Hresp = 2'b00;

endmodule
