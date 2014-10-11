(
var lick1, lick2, lick3, lick4, lick5, lick6, lick7, lick8, lick9, lick10, lick11, lick12;
var feel1, feel2, feel3, feel4, feel5;
var sectionA, sectionB;
var eMinorJig;
var eMinPlusB ;
// ****************************************************************
// rhythmic feels expressed as ratios, hence we need a rhthmic unit
var rhythmicUnit = 0.2;

// ***************************************
// scale from which to derive the melodies
var eMin = [0,1,2,3,4];
var dMajor = [-1, 0, 1, 2, 3, ];
// ***************
// make a midi out
var mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);

// **********************************
// rhythmic feels expressed as arrays
feel1 = [1,1,1,2,1]*rhythmicUnit;
feel2 = [2,1,1,1,1]*rhythmicUnit;
feel3 = [2,1,2,1]*rhythmicUnit;
feel4 = [1,1,1,1,1,1]*rhythmicUnit;
feel5 = [1,1,1,3]*rhythmicUnit;

// chords converted to midi notes
//eMin = eMin.midi;
//dMajor = dMajor.midi;

// lick1
lick1 = Pseq(
	feel1.collect({|item, i|
		[eMin.choose, item]; // wchoose([add to 1])
	})
	, 1);

lick2 = Pseq(
	feel2.collect({|item, i|
		[eMin.choose, item]; // wchoose([add to 1])
	})
	, 1);

/*lick3 = lick1 ++ 2;
lick4 = lick2 ++ 2;*/
lick1.list.postn("lick 1's list");
lick3 = Pseq(
	feel1.collect({|item, i|
		[(lick1.list[i][0].postn("it")-1) , item]; // wchoose([add to 1])
	})
	, 1);


lick4 = Pseq(
	feel2.collect({|item, i|
		[(lick2.list[i][0]-1) , item]; // wchoose([add to 1])
	})
	, 1);

lick5 = Pseq(
	feel3.collect({|item, i|
		[eMin.choose , item]; // wchoose([add to 1])
	})
	, 1);


// ********************
// add a b to the array
eMinPlusB = eMin.add(5);

lick6 = Pseq(
	feel4.collect({|item, i|
		[eMinPlusB.choose, item]; // wchoose([add to 1])
	})
	, 1);

lick7 = Pseq(
	feel5.collect({|item, i|
		[[0], item]; // wchoose([add to 1])
	})
	, 1);


// ************************************************
//          END OF A PART LICKS
// ************************************************

lick8 = Pseq(
	feel3.collect({|item, i|
		[eMin.choose , item]; // wchoose([add to 1])
	})
	, 1);

lick9 = Pseq(
	feel2.collect({|item, i|
		[eMin.choose , item]; // wchoose([add to 1])
	})
	, 1);

lick10 = Pseq(
	feel3.collect({|item, i|
		[(lick8.list[i][0]-1) , item]; // wchoose([add to 1])
	})
	, 1);

lick11 = Pseq(
	feel4.collect({|item, i|
		[dMajor.choose , item]; // wchoose([add to 1])
	})
	, 1);

lick12 = Pseq(
	feel2.collect({|item, i|
		[eMin.choose , item]; // wchoose([add to 1])
	})
	, 1);
// **************************
// build the A and B sections
sectionA = Pseq([lick1,lick2, lick3, lick4, lick1, lick5, lick6, lick7], 2);
sectionB = Pseq([lick8, lick9, lick10, lick11, lick8, lick12, lick6, lick7 ], 2);

// ************************
// now build the whole tune
eMinorJig = Pseq([sectionA, sectionB] , 2);

// **************************
// bit of delay, then play it
SystemClock.sched(1, {
	Ppar([
		Pbind(
			\octave , Pseq([4], 78) ++ Pseq([5], 76) ,
			\root, 4,
			\scale, #[0,2,3,5,7,8,10],
			\type, \midi,
			\midicmd, \noteOn,
			\midiout, mOut,
			\chan, 0,
			[\degree, \dur],   eMinorJig ++ eMinorJig
		),
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
		)


	]).play;
});



) // end of code