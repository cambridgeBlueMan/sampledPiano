MIDIClient.init

// ***************
// make a midi out
(
~mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);
)


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
// var trebleNotesC = Pseq([[60,64], 62], 8);
// var trebleDursC = Pseq([0.5], 16);

// randomised pattern between a two note chord and asingle note
// c and e being the teo note chord which gives us:

// C, Cmaj7, Am and Cmaaj7

// d being the single notw which gives us:

// C9, Emin7, Asus4, C9

var clock = TempoClock.new(2);

var trebleNotesC = Prand([[60,64], 62], 16);
var trebleDursC = Pseq([0.5], 16);

// // bar 3
// this is a doodle from the piano implemented as pattern
var trebleNotesEmin_1 = Pseq([64, 59, 67, 59, 64, 59, 67, 59], 2);
var trebleDursEmin_1 = Pseq([0.5], 16);

// // bar 4
var trebleNotesAmin = Pxrand([69, 67, 64, 67, 69, 67/*, Rest*/], 16 );
var trebleDursAmin = Pseq([0.5],16);
//
// // bar 5
var trebleNotesEmin_2 = Pseq([64, 59, 67, 59, 64, 59, 67, 59, 71, 59, 67, 59, 64, 59, 67, 59], 1);
var trebleDursEmin_2 = Pseq([0.5], 16);
var bassC_Emin_Amin_Emin_1, trebleC_Emin_Amin_Emin_1, sustain;


 var bassDmin_F_G_G7 = Pbind(
 	//\pan, -1,
 	\type, \midi,
 	\midicmd, \noteOn,
 	\midiout, ~mOut,
 	\chan, 0,
 	\midinote, Pseq([
 		50, 62, 62, 48, 60, 60, 43, 41,
 		48,60,60,47,59,59, 41, 43
 	], inf),
 	\dur  , Pseq([2,1,1,2,1,1,4,4], 4)
 );


 var trebleDmin_F_G_G7 = Pbind(
 	//\pan, -1,
 	\type, \midi,
 	\midicmd, \noteOn,
 	\midiout, ~mOut,
 	\chan, 0,
 	\midinote, Prand([Rest, 67, 65, 62, 65, 64, 60, 64, 62, 55, 57, 60], 96),
 	\dur  , Pseq([Pseq([0.5], 8), Pseq([1], 4)], 8)
 );

bassC_Emin_Amin_Emin_1 = Pbind(
	//\pan, -1,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~mOut,
	\chan, 0,
	 \midinote, Pseq([48,60,60,47,59,59, 45, 47], 6),
	\dur  , Pseq([2,1,1,2,1,1,4,4], 6)
).postln;

trebleC_Emin_Amin_Emin_1 = Pbind(
	//\pan, 1,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~mOut,
	\chan, 0,
	\midinote,  Pseq([trebleNotesC, trebleNotesEmin_1 , trebleNotesAmin, trebleNotesEmin_2], 3), //++ trebleNotesAmin,
	\dur  , Pseq([trebleDursC , trebleDursEmin_1, trebleDursAmin, trebleDursEmin_2], 3  )   //++ trebleDursAmin
).postln;

 sustain = Pbind(
	\type, \midi,
	\midicmd, \control,
	\midiout, ~mOut,
	\chan, 0,
	\midicmd, \control,
	\ctlNum, 64,
	\control, 127,
	\dur  , 4
).postln;


Ppar([
	bassDmin_F_G_G7  ++bassC_Emin_Amin_Emin_1,
	 trebleDmin_F_G_G7 ++ trebleC_Emin_Amin_Emin_1,
 sustain
]).play(clock)





)