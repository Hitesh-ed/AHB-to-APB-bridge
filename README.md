# AHB-to-APB-bridge

## About the AMBA Buses
The Advanced Microcontroller Bus Architecture (AMBA) specification defines an on-chip communications standard for designing high-performance embedded microcontrollers. Three distinct buses are defined within the AMBA specification:

* Advanced High-performance Bus (AHB)
* Advanced System Bus (ASB)
* Advanced Peripheral Bus (APB).

### Advanced High-performance Bus (AHB)
The AMBA AHB is for high-performance, high clock frequency system modules. The AHB acts as the high-performance system backbone bus. AHB supports the efficient connection of processors, on-chip memories and off-chip external memory interfaces with low-power peripheral macrocell functions. AHB is also specified to ensure ease of use in an efficient design flow using synthesis and automated test techniques.

### Advanced System Bus (ASB)
The AMBA ASB is for high-performance system modules. AMBA ASB is an alternative system bus suitable for use where the high-performance features of AHB are not required. ASB also supports the efficient connection of processors, on-chip memories and off-chip external memory interfaces with low-power peripheral macrocell functions.

### Advanced Peripheral Bus (APB)
The AMBA APB is for low-power peripherals. AMBA APB is optimized for minimal power consumption and reduced interface complexity to support peripheral functions. APB can be used in conjunction with either version of the system bus.

The overall architecture looks like the following:
![image](https://github.com/user-attachments/assets/2d58a090-392f-4be7-9a94-9c716b50f856)

## AMBA System

### Basic Terminology
#### Bus cycle
A bus cycle is a basic unit of one bus clock period and for the purpose of AMBA AHB or APB protocol descriptions is defined from rising-edge to rising-edge transitions.

#### Bus transfer
An AMBA ASB or AHB bus transfer is a read or write operation of a data object, which may take one or more bus cycles. The bus transfer is terminated by a completion response from the addressed slave. An AMBA APB bus transfer is a read or write operation of a data object, which always requires two bus cycles.

#### Burst operation
A burst operation is defined as one or more data transactions, initiated by a bus master, which have a consistent width of transaction to an incremental region of address space. The increment step per transaction is determined by the width of transfer (byte, halfword, word). No burst operation is supported on the APB.

## AMBA Signals
### AMBA AHB Signals
| Name       | Source           | Description |
|------------|------------------|-------------|
| HCLK       | Clock source     | This clock times all bus transfers. All signal timings are related to the rising edge of HCLK. |
| HRESETn    | Reset controller | The bus reset signal is active LOW and is used to reset the system and the bus. This is the only active LOW signal. |
| HADDR[31:0] | Master           | The 32-bit system address bus. |
| HTRANS[1:0] | Master           | Indicates the type of the current transfer, which can be NONSEQUENTIAL, SEQUENTIAL, IDLE or BUSY. |
| HWRITE     | Master           | When HIGH this signal indicates a write transfer and when LOW a read transfer. |
| HSIZE[2:0] | Master           | Indicates the size of the transfer, typically byte (8-bit), halfword (16-bit), or word (32-bit). Allows for larger sizes up to 1024 bits. |
| HBURST[2:0] | Master           | Indicates if the transfer forms part of a burst. Supports four, eight, and sixteen beat bursts, with incrementing or wrapping options. |
| HPROT[3:0]  | Master           | The protection control signals provide additional information about a bus access, primarily for implementing protection (optional). |
| HWDATA[31:0] | Master          | Write data bus for transferring data from master to bus slaves during write operations. Minimum width is 32 bits. |
| HSELx      | Decoder          | Each AHB slave has its own slave select signal; this signal indicates the current transfer is for the selected slave. |
| HRDATA[31:0] | Slave           | Read data bus for transferring data from bus slaves to the bus master during read operations. Minimum width is 32 bits. |
| HREADY     | Slave            | When HIGH, indicates a transfer has finished on the bus. Can be driven LOW to extend a transfer. |
| HRESP[1:0] | Slave            | Provides additional information on the status of a transfer response: OKAY, ERROR, RETRY, SPLIT. |

### AMBA APB Signals
| Name       | Source            | Description |
|------------|-------------------|-------------|
| PCLK       | Clock Source      | The rising edge of PCLK is used to time all transfers on the APB. |
| PRESETn    | Reset Controller  | The APB bus reset signal is active LOW and is typically connected to the system bus reset signal. |
| PADDR[31:0] | Master            | APB address bus, up to 32-bits wide, driven by the peripheral bus bridge unit. |
| PSELx      | Decoder           | Signal from secondary decoder to each peripheral bus slave x, indicating the slave device is selected for data transfer. |
| PENABLE    | Master            | Strobe signal timing all accesses on the peripheral bus. Indicates the second cycle of an APB transfer; rising edge occurs mid-transfer. |
| PWRITE     | Master            | When HIGH indicates APB write access; when LOW indicates read access. |
| PRDATA[31:0] | Slave            | Read data bus driven by selected slave during read cycles (PWRITE is LOW). Up to 32 bits wide. |
| PWDATA[31:0] | Master           | Write data bus driven by peripheral bus bridge unit during write cycles (PWRITE is HIGH). Up to 32 bits wide. |

## Implementation
### Objective
To design and simulate a synthesizable AHB to APB bridge interface using Verilog and run single read and single write tests using AHB Master and APB Slave testbenches. The bridge unit converts system bus transfers into APB transfers and performs the following functions:

* Latches the address and holds it valid throughout the transfer.
* Decodes the address and generates a peripheral select, PSELx. Only one select signal can be active during a transfer.
* Drives the data onto the APB for a write transfer.
* Drives the APB data onto the system bus for a read transfer.
* Generates a timing strobe, PENABLE, for the transfer
* Can implement single read and write operations successfully.

The diagram below shows the interface:

![image](https://github.com/user-attachments/assets/4946540e-2079-4992-8d34-36bf3ca08de4)

## Design Sub Modules
### AHB Slave Interface
An AHB bus slave responds to transfers initiated by bus masters within the system. The slave uses a HSELx select signal from the decoder to determine when it should respond to a bus transfer. All other signals required for the transfer, such as the address and control information, will be generated by the bus master.

### APB Controller
The AHB to APB bridge comprises a state machine, which is used to control the generation of the APB and AHB output signals, and the address decoding logic which is used to generate the APB peripheral select lines.

# FILES
You can use the files that I have attached here with the repo.

# CONTACT
You may approach me for further assistance through :
* Telegram. [Click here to reach Telegram Account](t.me/Online_Tute)
* Whatsapp me on +91 8095227579
