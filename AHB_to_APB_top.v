module Bridge_top(input Hclk,Hwrite,Hresetn,Hreadyin,[1:0]Htrans,[31:0]Haddr,[31:0]Hwdata,Prdata,
		  output [31:0]Hrdata,[1:0]Hresp,
		  output Penable,Pwrite,Hreadyout,
		  output [2:0]Pselx,[31:0]Pwdata,Paddr);

wire [31:0]Haddr1_w,Haddr2_w,Hwdata1_w,Hwdata2_w;
wire [2:0]tempselx_w;
wire Hwritereg_w,valid_w;

AHB_slave_itfc sb1(Hclk,Hwrite,Hresetn,Hreadyin,
                      Htrans,Haddr,Hwdata,
                      Hresp,Haddr1_w,Haddr2_w,Hwdata1_w,Hwdata2_w,
		      tempselx_w,Hwritereg_w,valid_w);

APB_Controller sb2(Haddr,Haddr1_w,Haddr2_w,Hwdata,Hwdata1_w,Hwdata2_w,
		   tempselx_w,
		     Hwritereg_w,valid_w,Hresetn,Hwrite,Hclk,
		     Penable,Pwrite,Hreadyout,
		     Pselx,Pwdata,Paddr,Prdata,Hrdata);

endmodule 