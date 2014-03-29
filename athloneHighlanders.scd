(
var lick1, lick2, lick3, lick4, lick5, lick6, lick7;
var feel1, feel2, feel3, feel4;
var pFeel1, pFeel2, pFeel3, pFeel4;
var phraseA, phraseB, phraseC, phraseD, phraseE, phraseF;
var bars = Dictionary.new;
var deltas = Dictionary.new;
var rhythmicUnit = 0.3;
//
var gMajor = [67, 69, 71, 72, 74, 76, 78, 79];
var mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);
// rhythmic feels expressed as patterns
/*
feel1 = Pseq([0.375, Pseq([0.125], 3)], 1).asStream; // 4 items
feel2 = Pseq([0.125], 6).asStream; // 6 items
feel3 = Pseq([Pseq([0.125], 3), 0.375], 1).asStream; // 4 items
feel4 = Pseq([Pseq([0.125,], 3), 0.25, 0.125], 1).asStream; // 5 items
*/

// rhythmic feels expressed as arrays
feel1 = [3,1,1,1]*rhythmicUnit;
feel2 = [1,1,1,1,1,1]*rhythmicUnit;
feel3 = [1,1,1,3]*rhythmicUnit;
feel4 = [1,1,1,2,1]*rhythmicUnit;
"twattock1".postln;
//
"twattock1".postln;

// lick1
lick1 = Pseq(
	feel1.collect({|item, i|
		gMajor.choose
	})
	, 1);

// lick2
lick2 = Pseq(
	feel2.collect({|item, i|
		gMajor.choose
	}); // end collect
	, 1);
// lick3
lick3 = Pseq(
	feel2.collect({|item, i|
		gMajor.choose
	}); // end collect

	, 1);
// lick4
lick4 = Pseq(
	feel2.collect({|item, i|
		gMajor.choose
	}) ++ feel3.collect({|item, i|
		gMajor.choose
	});
	, 1);
// lick5
lick5 = Pseq(
	feel2.collect({|item, i|
		gMajor.choose
	}); // end collect
	, 1);

// lick6
lick6 = Pseq(
	feel2.collect({|item, i|
		gMajor.choose
	}); // end collect
	, 1);
// lick7
lick7 = Pseq(
	feel4.collect({|item, i|
		gMajor.choose
	}).postln; // end collect
	, 1).postln;


pFeel1 = Pseq(feel1, 1);
pFeel2 = Pseq(feel2, 1);
pFeel3 = Pseq(feel3, 1);
pFeel4 = Pseq(feel4, 1);

// (lick1 ++ lick2 ++ lick3 ++ lick4 ++ lick5 ++ lick6 ++ lick7).postln;


// SECTION A

//~sectionA = phraseA + phraseB + phraseA + phraseC;

bars[1] = lick1; deltas[1] = feel1;
bars[2] = lick2; deltas[2] = feel2;
bars[3] = lick1; deltas[3] = feel1;
bars[4] = lick3; deltas[4] = feel2;


bars[5] = lick1; deltas[5] = feel1;
bars[6] = lick2; deltas[6] = feel2;
// a two bars lick and cadence
"twattock1".postln;

bars[7] = lick4; deltas[7] = feel2 + feel3;



// SECTION B

//~sectionB = phraseD = phraseE + phraseD + phraseF;

bars[9] = lick1;  deltas[9] = feel2;
bars[10] = lick2; deltas[10] = feel2;
bars[11] = lick1; deltas[11] = feel2;
bars[12] = lick3; deltas[12] = feel4;


bars[13] = lick1; deltas[13] = feel2;
bars[14] = lick2; deltas[13] = feel2;

// a two bars lick and cadence
bars[15] = lick4; deltas[15] = feel2 + feel3;

//~tune = ~sectionA + ~sectionA + ~sectionB + ~sectionB;
~arrDeltas =
~deltas = Pseq([

Pseq([
	Pseq([pFeel1, pFeel2], 3),
	pFeel2,
	pFeel3
], 2)
,
Pseq([

	Pseq([pFeel2], 3),
	pFeel4,
	Pseq([pFeel2], 3),
	pFeel3;
], 2);
]);
SystemClock.sched(1, {
	Pbind(
		\type, \midi,
		\midicmd, \noteOn,
		\midiout, mOut,    // must provide the MIDI target here
		\chan, 0,
		\midinote,  Pseq([
		Pseq(
			[lick1,lick2, lick1, lick3, lick1, lick2, lick4 ],
			2),
			Pseq([lick5, lick6, lick5, lick7, lick5 , lick6, lick4])


		], 2),
		\dur, ~deltas
	).play; // end pbind
});
)

// the process is to generate lick1 from feel1 and some notes.
// the notes might relate to a harmonic structure

// there are two possible approaches. one is to generate the stuff before playing it, and the other is to
// record the stuff as it plays.
// I am inclined towards the idea of generating the stuff before you play it