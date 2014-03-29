(
var lick1, lick2, lick3, lick4, lick5, lick6, lick7;
var feel1, feel2, feel3, feel4;
var sectionA, sectionB;
var athloneHighlanders;

// ****************************************************************
// rhythmic feels expressed as ratios, hence we need a rhthmic unit
var rhythmicUnit = 0.3;

// ***************************************
// scale from which to derive the melodies
var gMajor = [67, 69, 71, 72, 74, 76, 78, 79];

// ***************
// make a midi out
var mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);

// **********************************
// rhythmic feels expressed as arrays
feel1 = [3,1,1,1]*rhythmicUnit;
feel2 = [1,1,1,1,1,1]*rhythmicUnit;
feel3 = [1,1,1,3]*rhythmicUnit;
feel4 = [1,1,1,2,1]*rhythmicUnit;

// ************************************************************************************
// now build each melodic fragment from its rhtmic feel and the appropriate scale notes

// lick1
lick1 = Pseq(
	feel1.collect({|item, i|
		[gMajor.choose, item]
	})
	, 1);

// lick2
lick2 = Pseq(
	feel2.collect({|item, i|
		[gMajor.choose, item]
	}); // end collect
	, 1);
// lick3
lick3 = Pseq(
	feel2.collect({|item, i|
		[gMajor.choose, item]
	}); // end collect

	, 1);
// lick4
lick4 = Pseq(
	feel2.collect({|item, i|
		[gMajor.choose, item]
	}) ++ feel3.collect({|item, i|
		[gMajor.choose, item]
	});
	, 1);
// lick5
lick5 = Pseq(
	feel2.collect({|item, i|
		[gMajor.choose, item]
	}); // end collect
	, 1);

// lick6
lick6 = Pseq(
	feel2.collect({|item, i|
		[gMajor.choose, item]
	}); // end collect
	, 1);
// lick7
lick7 = Pseq(
	feel4.collect({|item, i|
		[gMajor.choose, item]
	}).postln; // end collect
	, 1);


// **************************
// build the A and B sections
sectionA = Pseq([lick1,lick2, lick1, lick3, lick1, lick2, lick4 ], 1);
sectionB = Pseq([lick5, lick6, lick5, lick7, lick5 , lick6, lick4], 1);

// ************************
// now build the whole tune
athloneHighlanders = Pseq([sectionA, sectionA, sectionB, sectionB], 2);

// **************************
// bit of delay, then play it
SystemClock.sched(1, {
	Pbind(
		\type, \midi,
		\midicmd, \noteOn,
		\midiout, mOut,
		\chan, 0,
		[\midinote, \dur],  athloneHighlanders
	).play; // end pbind
});
)
