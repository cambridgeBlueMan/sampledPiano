

(
var asIGaeDoonTae, huntlyToon, huntlyForTae, fee, thereIFellWith, bogie, sheFellInWith, me;
var feel1, feel2, feel3, feel4;
var sectionA, sectionB;
var athloneHighlanders;

// ****************************************************************
// rhythmic feels expressed as ratios, hence we need a rhthmic unit
var rhythmicUnit = 0.2;

// ***************************************
// scale from which to derive the melodies
var bFlat = [65, 67, 69, 70, 72, 74, 76, 77];
var chBb = [58, 62, 65];
var chC = [60, 64, 67];
var chF = [65,69,72];
var chBb9 = [65,70,72,74];

var mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);


// **********************************
// rhythmic feels expressed as arrays
feel1 = [2,2,3,1]*rhythmicUnit;
feel2 = [2,2,2,2]*rhythmicUnit;
feel3 = [7,1]*rhythmicUnit;
// ************************************************************************************
// now build each melodic fragment from its rhtmic feel and the appropriate scale notes

// lick1
asIGaeDoonTae = Pseq(
	feel1.collect({|item, i|
		if (i < 2,
			{
				[chF.choose, item]
			},
			{
				[chBb9.choose, item]
			}
		) // end if
	}) // end collect
		, 1);
	huntlyToon = Pseq(
		feel1.collect({|item, i|
			if (i < 2,
				{
					[chBb9.choose, item]
				},
				{
					[chC.choose, item]
			})
			}) // end collect

			, 1);

		huntlyForTae = Pseq(
			feel2.collect({|item, i|
				if (i < 2,
					{
						[chBb9.choose, item]
					},
					{
						[chC.choose, item]

				})
			}) // end collect

				, 1);
			fee = Pseq(
				feel3.collect({|item, i|
					[chF.choose, item]
				})
				, 1);
			thereIFellWith = Pseq(
				feel1.collect({|item, i|
					[chBb9.choose, item]
				})
				, 1);

			bogie = Pseq(
				feel2.collect({|item, i|
					if (i < 2,
						{
							[chC.choose, item]
						},
						{
							[chBb.choose, item]
					})
			}) // end collect

					, 1);

				sheFellInWith = Pseq(
			  feel2.collect({|item, i|
						[chBb9.choose, item]
					})
					, 1);

me = Pseq(
				feel3.collect({|item, i|
					[chC.choose, item]
				})
				, 1);
				// **************************
				// build the A and B sections
				sectionA = Pseq([asIGaeDoonTae, huntlyToon, huntlyForTae,
					fee, thereIFellWith, bogie, sheFellInWith, me ], 4);



				// **************************
				// bit of delay, then play it
				SystemClock.sched(1, {
					Pbind(
						\type, \midi,
						\midicmd, \noteOn,
						\midiout, mOut,
						\chan, 0,

						[\midinote, \dur],  sectionA
					).play; // end pbind
				});
				)
				