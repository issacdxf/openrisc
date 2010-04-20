// еЊзд 130d.v
//-----------------------------------------------------------------------------

module Debouncer (
// Switch debouncer for Digilent FPGA boards
//
// Requires a 50MHz clock, and implements a 10ms wait period.
// Includes glitch suppression. Built-in synchronizer.
// Outputs include a debounced replica of the input signal, and
// single clock period pulse outputs to indicate rising edge and
// falling edge detected (of clean signal).
//
// 10ms at 50MHz is 500,000 master clock cycles, requiring 19 bits
// of register space.

	// Global system resources:
	input gClock,	// System clock (must be 50 MHz)
	input gReset,	// Master reset (asynchronous, active high)

	// Inputs:
	input iBouncy,	// Bouncy switch signal

	// Outputs:
	output reg oDebounced,	// Debounced replica of switch signal
	output reg oPulseOnRisingEdge,	// Single pulse to indicate rising edge detected
	output reg oPulseOnFallingEdge	// Single pulse to indicate falling edge detected
);

// Constant parameters
parameter pInitialValue = 0;
parameter pTimerWidth = 19;
parameter pInitialTimerValue = 19'd500_000; // for synthesis
//parameter pInitialTimerValue = 19'd20; // for simulation

// Registered identifiers:
reg	rInitializeTimer;
reg	rWaitForTimer;
reg	rSaveInput;
reg	rBouncy_Syncd;
reg	[pTimerWidth-1:0] rTimer;

// Wire identifiers:
wire	wTransitionDetected;
wire	wTimerFinished;

// Controller:
always @ (posedge gClock or posedge gReset)
	if (gReset)
		{rInitializeTimer,rWaitForTimer,rSaveInput} <= {3'b100};
	else begin
		rInitializeTimer <= rInitializeTimer && !wTransitionDetected ||
							rSaveInput;
		rWaitForTimer <= rInitializeTimer && wTransitionDetected ||
							rWaitForTimer && !wTimerFinished;
		rSaveInput <= rWaitForTimer && wTimerFinished;
	end		

// Datapath:
always @ (posedge gClock or posedge gReset)
	if (gReset) begin
		rBouncy_Syncd <= 0;
		oDebounced <= pInitialValue;
		oPulseOnRisingEdge <= 0;
		oPulseOnFallingEdge <= 0;
		rTimer <= pInitialTimerValue;
	end
	else begin
		rBouncy_Syncd <= iBouncy;
		oDebounced <= (rSaveInput) ? rBouncy_Syncd : oDebounced;
		oPulseOnRisingEdge <= (rSaveInput && rBouncy_Syncd);
		oPulseOnFallingEdge <= (rSaveInput && !rBouncy_Syncd);
		rTimer <= (rInitializeTimer) ? pInitialTimerValue : rTimer - 1;
	end

assign wTransitionDetected = rBouncy_Syncd ^ oDebounced;
assign wTimerFinished = (rTimer == 0);

endmodule
