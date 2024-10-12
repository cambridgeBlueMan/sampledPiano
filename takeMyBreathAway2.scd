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

// C,C,D,C,D,C,D,E
~rightNotesBar1 = Pseq([60,  60, 62,60,62,60, 62,64 ], 16);
~rightDursBar1 = Pseq([1.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 3.5], 16);

// ~temp = Pbind(
// 	//\pan, -1,
// 	\type, \midi,
// 	\midicmd, \noteOn,
// 	\midiout, ~mOut,
// 	\chan, 0,
// 	\midinote, ~rightNotesBar1,
// 	\dur  , ~rightDursBar1
// ).play ;

//
//
// // // bar2
// this is a simple alternating pattern, which was not used
// but it formed the basis for the randomised pattern
// which occurs in the next attempt at a bar2
// ~trebleNotesC = Pseq([[60,64], 62], 8);
// ~trebleDursC = Pseq([0.5], 16);

// randomised pattern between a two note chord and asingle note
// c and e being the teo note chord which gives us:

// C, Cmaj7, Am and Cmaaj7

// d being the single notw which gives us:

// C9, Emin7, Asus4, C9

~clock = TempoClock.new(2);

// following will produce a random major third chord or a ninth
~trebleNotesC = Prand([[60,64], 62], 16);
~trebleDursC = Pseq([0.5], 16);

// (
// ~temp = Pbind(
// 	//\pan, -1,
// 	\type, \midi,
// 	\midicmd, \noteOn,
// 	\midiout, ~mOut,
// 	\chan, 0,
// 	\midinote, ~trebleNotesC,
// 	\dur  , ~trebleDursC
// ).play;
// )
// // bar 3
// this is a doodle from the piano implemented as pattern
// E,B,A,B,E,B,A,B OR 1,5, 4, 5, a suspended fourth kind of thing
~trebleNotesEmin_1 = Pseq([64, 59, 67, 59], 4);
~trebleDursEmin_1 = Pseq([0.5], 16);

// // bar 4
// A, G, E, G, A, G , a minor seventh chord, no third
~trebleNotesAmin = Pxrand([69, 67, 64, 67, 69, 67/*, Rest*/], 16 );
~trebleDursAmin = Pseq([0.5],16);
//
// // bar 5
~trebleNotesEmin_2 = Pseq([64, 59, 67, 59, 64, 59, 67, 59, 71, 59, 67, 59, 64, 59, 67, 59], 1);
~trebleDursEmin_2 = Pseq([0.5], 16);
//~bassC_Emin_Amin_Emin_1, trebleC_Emin_Amin_Emin_1, sustain;


// D, D1, D1, C, C1, C1, G,F
// C, C1, C1, B, B1, B1, F, G
 ~bassDmin_F_G_G7 = Pbind(
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


 ~trebleDmin_F_G_G7 = Pbind(
 	//\pan, -1,
 	\type, \midi,
 	\midicmd, \noteOn,
 	\midiout, ~mOut,
 	\chan, 0,
 	\midinote, Prand([Rest, 67, 65, 62, 65, 64, 60, 64, 62, 55, 57, 60], 96),
 	\dur  , Pseq([Pseq([0.5], 8), Pseq([1], 4)], 8)
 );

~bassC_Emin_Amin_Emin_1 = Pbind(
	//\pan, -1,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~mOut,
	\chan, 0,
	 \midinote, Pseq([48,60,60,47,59,59, 45, 47], 6),
	\dur  , Pseq([2,1,1,2,1,1,4,4], 6)
).postln;

~trebleC_Emin_Amin_Emin_1 = Pbind(
	//\pan, 1,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~mOut,
	\chan, 0,
	\midinote,  Pseq([~trebleNotesC, ~trebleNotesEmin_1 , ~trebleNotesAmin, ~trebleNotesEmin_2], 3), //++ trebleNotesAmin,
	\dur  , Pseq([~trebleDursC , ~trebleDursEmin_1, ~trebleDursAmin, ~trebleDursEmin_2], 3  )   //++ trebleDursAmin
).postln;

~sustain = Pbind(
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
	~bassDmin_F_G_G7  ++ ~bassC_Emin_Amin_Emin_1,
	/* ~trebleDmin_F_G_G7 ++ ~trebleC_Emin_Amin_Emin_1,*/
 ~sustain
]).play(~clock)





)