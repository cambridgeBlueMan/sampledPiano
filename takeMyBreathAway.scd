(
// "take my breath away"

/*
Here I took the chord sequence for Take My Breath Away and put some arpeggios across the top. The bass rythmic pattern is taken from Delicate Piano 1, I should add, but appied to the new chords



*/
// bar 1
// this is simply a doodle I worked ut on the piano implememted as a pattern
var rightNotesBar1 = Pseq([60,  60, 62,60,62,60, 62,64 ], 16);
var rightDursBar1 = Pseq([1.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 3.5], 16);
//
//
// // // bar2
// this is a simple alternating pattern, which was not used
// but it formed the basis for the randomised pattern
// which occurs in the next attempt at a bar2
// var rightNotesBar2 = Pseq([[60,64], 62], 8);
// var rightDursBar2 = Pseq([0.5], 16);

// randomised pattern between a two note chord and asingle note
// c and e being the teo note chord which gives us:

// C, Cmaj7, Am and Cmaaj7

// d being the single notw which gives us:

// C9, Emin7, Asus4, C9
var rightNotesBar2 = Prand([[60,64], 62], 16);
var rightDursBar2 = Pseq([0.5], 16);

// // bar 3
// this is a doodle from the piano implemented as pattern
var rightNotesBar3 = Pseq([64, 59, 67, 59, 64, 59, 67, 59], 2);
var rightDursBar3 = Pseq([0.5], 16);

// // bar 4
var rightNotesBar4 = Pxrand([69, 67, 64, 67, 69, 67/*, Rest*/], 16 );
var rightDursBar4 = Pseq([0.5],16);
//
// // bar 5
var rightNotesBar5 = Pseq([64, 59, 67, 59, 64, 59, 67, 59, 71, 59, 67, 59, 64, 59, 67, 59], 1);
var rightDursBar5 = Pseq([0.5], 16);
var leftHand1, rightHand1, sustain;

var leftHand2 = Pbind([


]);

leftHand1 = Pbind(
	//\pan, -1,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~mOut,
	\chan, 0,
	 \midinote, Pseq([48,60,60,47,59,59, 45, 47], inf),
	\dur  , Pseq([2,1,1,2,1,1,4,4], inf)
).play(TempoClock(2));

rightHand1 = Pbind(
	//\pan, 1,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~mOut,
	\chan, 0,
	\midinote,  Pseq([rightNotesBar2, rightNotesBar3 , rightNotesBar4, rightNotesBar5], 4), //++ rightNotesBar4,
	\dur  , Pseq([rightDursBar2 , rightDursBar3, rightDursBar4, rightDursBar5], 4  )   //++ rightDursBar4
).play(TempoClock(2));
 sustain = Pbind(
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