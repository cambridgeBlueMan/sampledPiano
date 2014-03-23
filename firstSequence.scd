(
var sectionB = false;
var aClock; // on which to run the main scheduler
var deltas; // a stream of deltas
var melodyNotes; // an array of notes from which the melody will be derived
var pMelodyNotes; // the pattern used to generate melody notes from the melodyNotes array
var savedMelody; // a List to hold randomly generated notes for recall later
var pSavedMelody; // a pattern with savedMelody as its list
var playNote; // afunction to process a note prior to sending to synth
var harmonyNotes; // an array of notes from which to derive the harmon notes
var pHarmonyNotes; // a pattern to generate the harmony notes
var element; //a temp variable so we
var counter = 0;
var withHarmony = false;

// initialise saved melody
savedMelody = List.new(0);


// build  pMelodyNotes
melodyNotes = Array.series(32, 40, 1);
pMelodyNotes = Prand(melodyNotes, inf);

// build pHarmonyNotes
harmonyNotes = [48, 60, 72, 55, 67, 53, 65];
pHarmonyNotes = Prand(harmonyNotes, inf).asStream;


aClock = TempoClock.new;

deltas = Pseq([1,1,1,1,1,1, 2], inf).asStream;

aClock.sched(0, {
	var num, val;
	// get velocity outside conditional stuff, cos it is always needed
	val =  rrand(20, 127);

	// ******************************************************************
	//                           SECTION A
	// ******************************************************************
	if (sectionB == false,
		{
			// ****************************
			// initially get values randomly
			num  = pMelodyNotes.asStream.next;

			// **********************************************************
			// and store these random values in an array to be used later
			savedMelody.add([num, val]);
			if (savedMelody.size ==7,
				{
					sectionB = true;
					pSavedMelody = Pseq(savedMelody, 3).asStream;
					withHarmony = true;
			});
		},

		// ******************************************************************
		//                           SECTION B
		// ******************************************************************
		{
			if (withHarmony == true, {

				// then put out a note
				if (0.5.coin == true , {
					playNote.value(pHarmonyNotes.next, val)
				});
			});

			// now prepare a note to output from the savedMelody array
			element = pSavedMelody.next;
			num = element[0];
			val = element[1];

			// increment the counter
			counter = counter + 1;

			// at end of savedMelody array then switch the harmony flag
			if (counter.mod(7) == 0,
				{
					if (withHarmony == true, {withHarmony = false} , {withHarmony = true});
				},
				{
			});
		}
	);

	playNote.value(num, val);
	deltas.next;
});

playNote = {|num, val|

	var pedalStatus = "V"; // pseudo pedal control, set lower case for pedal
	var notes, on, off;
	var veloc;
	var synthArgs;
	var theSample;
	var powerNumerator=0;
	var sampleInfo;
	// m.noteOn(0,num, val);
	notes = Array.newClear(128);

	// *****************************************************************
	// derive a velocity factor from val (which is of course midi veloc)
	veloc = case
	{val <= 32} {2}
	{val > 32 && val <=64} {3}
	{val > 64 && val <=96} {4}
	{val > 96} {5}; // end case;

	// **********************
	// determine which sample
	sampleInfo = case
	{num > 47} {[(((num/3).floor)*3), num.mod(3)]}
	{num < 45 } {[(((num/3).floor)*3), num.mod(3)]}
	{num == 45} {[42,3]}
	{num == 46} {[46,0]}
	{num == 47} {[46,1]}
	; // end case

	// *******************
	// put it all together
	if (num < 99,
		{theSample =  ~theSamples[pedalStatus ++ veloc.asString ++ "0" ++ sampleInfo[0].asString]},
		{theSample =  ~theSamples[pedalStatus ++ veloc.asString ++ sampleInfo[0].asString];}
	); // end if

	// *************************************
	// then make the synth and pass the args
	notes[num] = Synth.new(\sampledPiano,
		[ \powerNumerator, sampleInfo[1],
			\bufnum, theSample,
			\gate, 1,
			\amp, val*0.00315]
	);
}
)

melody
s.makeGui
s.freeAll





