(
var lick1, lick2, lick3, lick4, lick5, lick6, lick7, lick8, lick9;
var feel1, feel2, feel3, feel4, feel5;
var sectionA, sectionB;
var pipeOnTheHob;

// ****************************************************************
// rhythmic feels expressed as ratios, hence we need a rhthmic unit
var rhythmicUnit = 0.2
;

// ***************************************
// scale from which to derive the melodies
var d7Sus4 = ["d5", "c5", "a5", "g5", "f5#" , "d4"];
var dMajor = ["d5", "c#5", "f5#" , "d4"];
var cMajor9 = ["c5", "d5", "e5", "g5"];
// ***************
// make a midi out
var mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);

// **********************************
// rhythmic feels expressed as arrays
feel1 = [1,1,1,2,1]*rhythmicUnit;
feel2 = [2,1,2,1]*rhythmicUnit;
feel3 = [1,1,1,1,1,1]*rhythmicUnit;
feel4 = [2,1,3]*rhythmicUnit;
feel5 = [2,1,1,1,1]*rhythmicUnit;

// *****************************
// chords converted to midinotes
d7Sus4 = d7Sus4.midi;
dMajor = dMajor.midi;
cMajor9 = cMajor9.midi;

// lick1
lick1 = Pseq(
	feel1.collect({|item, i|
		[d7Sus4.choose, item]
	})
	, 1);

// lick2
lick2 = Pseq(
	feel2.collect({|item, i|
		[d7Sus4.choose, item]
	})
	, 1);

// lick3
lick3 = Pseq(
	feel3.collect({|item, i|
		[cMajor9.choose, item]
	})
	, 1);

// lick4
lick4 = Pseq(
	feel3.collect({|item, i|
		[d7Sus4.choose, item]
	})
	, 1);


// lick5
lick5 = Pseq(
	feel1.collect({|item, i|
		[d7Sus4.choose, item]
	})
	, 1);



// lick6
lick6 = Pseq(
	feel5.collect({|item, i|
		[dMajor.choose, item]
	})
	, 1);


// lick7
lick7 = Pseq(
	feel1.collect({|item, i|
		[d7Sus4.choose, item]
	})
	, 1);

// lick8
lick8 = Pseq(
	feel3.collect({|item, i|
		[cMajor9.choose, item]
	})
	, 1);

// lick9
lick9 = Pseq(
	feel3.collect({|item, i|
		[d7Sus4.choose, item]
	})
	, 1);



// **************************
// build the A and B sections
sectionA = Pseq([lick1,lick2, lick3, lick2, lick4, lick5, lick3, lick2 ], 1);
sectionB = Pseq([lick6, lick7, lick8, lick9, lick6 , lick7, lick3, lick2 ], 1);

// ************************
// now build the whole tune
pipeOnTheHob = Pseq([sectionA, sectionA, sectionB, sectionB], 2);

// **************************
// bit of delay, then play it
SystemClock.sched(1, {
	Pbind(
		\type, \midi,
		\midicmd, \noteOn,
		\midiout, mOut,
		\chan, 0,
		[\midinote, \dur],  pipeOnTheHob
	).play; // end pbind
});

)


