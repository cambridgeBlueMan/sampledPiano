






// ***************
// make a midi out
(
~mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);
)

(
/*
This is simply Delicate Piano1 apple loop implemented as patterns. It acted as a starting point
*/
// bar 1
var rightNotesBar1 = Pseq([[67,76], 76, 67, [60,72], 67, 60, 64], 1);
var rightDursBar1 = Pseq([1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], 1);
// bar2
var rightNotesBar2 = Pseq([67,64,67,64,72,64,74,64], 1);
var rightDursBar2 = Pseq([0.5], 8);
// bar 3
var rightNotesBar3 = Pseq([79, 71, 74, 71, [79,67], 71, 81, [67,71]], 1);
var rightDursBar3 = Pseq([0.5], 8);
// bar 4
var rightNotesBar4 = Pseq([77, 76, 72,69,65, 67,69,[65,67,72], 74], 1);
var rightDursBar4 = Pseq([0.5], 5) ++ Pseq([0.25, 0.25, 0.5, 0.5],1);

var leftHand1 = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~mOut,
	\chan, 0,
	\midinote, Pseq([48, Rest(1),45, 57,57,55,53], 1),
	\dur  , Pseq([3,1,2,1,1,4,4], 1)
).play(TempoClock(2));
var rightHand1 = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~mOut,
	\chan, 0,
	\midinote,  rightNotesBar1 ++ rightNotesBar2 ++ rightNotesBar3 ++ rightNotesBar4,
	\dur  , rightDursBar1 ++ rightDursBar2 ++ rightDursBar3 ++ rightDursBar4
).play(TempoClock(2));
var sustain = Pbind(
	\type, \midi,
	\midicmd, \control,
	\midiout, ~mOut,
	\chan, 0,
	\midicmd, \control,
	\ctlNum, 64,
	\control, 127,
	\dur  , 4
).play(TempoClock(2));







)