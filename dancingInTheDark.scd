
// **************************
// bit of delay, then play it
//SystemClock.sched(1, {
(
var mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);

var rhythmicUnit = 0.25;
// *******
// A CHORD
var aMaj = #[0, 7 , 9];
var aMaj6 = #[0,7, 9, 12];
var aLick =  Pseq([aMaj], 4) ++ Pseq([aMaj6], 4);


// *******
// D CHORD

// E CHORD
var eMaj = #[4, 6, 8];
var eLick = Pseq([eMaj], 8);

var dMaj = [3, 5, 7];
var dMaj6 = [3,5,7,8];
var dLick =  Pseq([dMaj], 4) ++ Pseq([dMaj6], 4);
	Ppar([
		Pbind(
			\octave , 3,
			\root, 9,
			\type, \midi,
		\scale, #[0, 2, 4, 5,7,9,11],
			\midicmd, \noteOn,
			\midiout, mOut,
			\chan, 0,
		\degree ,  Pseq([aLick ++ aLick ++ dLick ++ aLick ++ eLick ++ dLick ++ aLick], 2),
			\dur, Pseq([3*rhythmicUnit, 5*rhythmicUnit], inf)
		)
		/*,
		Pbind(
		\octave, 3,
		\root, 4,
		\scale, #[0,2,3,5,7,8,10],
		\type, \midi,
		\midicmd, \noteOn,
		\midiout, mOut,
		\chan, 0,
		\dur , rhythmicUnit*12,
		\degree,  Pseq([0, -1], 8)
		)*/


		]
	).play;
)
//});

