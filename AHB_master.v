module AHB_master( input [31:0]Hrdata,
		   output reg Hclk,Hwrite,Hresetn,Hreadyin,[1:0]Htrans,[31:0]Haddr,[31:0]Hwdata);

always  begin
	Hclk = 1'b1;
	forever #10 Hclk = ~Hclk;
	end


task s_write();
begin   #21;
	Hresetn = 1;
	Htrans = 2'b10;
	Hreadyin = 1;
	Haddr = 32'h80000001;
	Hwrite = 1;
	

	#20;
	Htrans = 2'b00;
	Hreadyin = 0;
	Hwdata = 32'h1234;
	Hwrite = 0;
	
end
endtask

task b_write();
begin   #21;
	Hresetn = 1;
	Htrans = 2'b10;
	Hreadyin = 1;
	Haddr = 32'h80000001;
	Hwrite = 1;
	

	#20;
	Htrans = 2'b11;
	Hreadyin = 1;
	Haddr = 32'h80000002;
	Hwdata = 32'h1234;
	Hwrite = 1;
	
	#20;
	Htrans = 2'b11;
	Hreadyin = 1;
	Haddr = 32'h80000003;
	Hwdata = 32'h1235;
	Hwrite = 1;

	#40;
	Htrans = 2'b11;
	Hreadyin = 1;
	Haddr = 32'h80000004;
	Hwdata = 32'h1236;
	Hwrite = 1;
	
	#40;
	Htrans = 2'b00;
	Hreadyin = 0;
	Hwdata = 32'h1237;
	Hwrite = 0;
	
end
endtask

task s_read();
begin   #21;
	Hresetn = 1;
	Htrans = 2'b11;
	Hreadyin = 1;
	Haddr = 32'h80004001;
	Hwrite = 0;
	
	#40;
	Htrans = 2'b00;
	Hreadyin = 0;

	#20;
	Hwrite = 1;
	
end
endtask

endmodule
