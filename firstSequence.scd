(
var moveOn = false;
~storedNoteVals = List.new(0);
x = TempoClock.new;
x.sched(0, {
	var num, val;
	if (moveOn == true, {
		"in if".postln;
		y = x.next;
		num = y[0].postln; val = y.next[1];
		},
		{
			"in else".postln;
			num  = Prand(Array.series(32, 40, 1), inf).asStream.next; // (rrand(48,72); // get some note
			val =  rrand(20, 127); // get some velocity
			~storedNoteVals.add([num, val]);
			if (~storedNoteVals.size.postln ==10,
				{
					moveOn = true;x = Pseq(~storedNoteVals.asArray, 4).asStream
			});
	});
	~doANote.value(num, val);
	1
});

)

(
~doANote = {|num, val|
	var pedalStatus = "V"; // pseudo pedal control, set lower case for pedal
	var notes, on, off;
	var veloc;
	var synthArgs;
	var theSample;
	var powerNumerator=0;
	var sampleInfo;
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

~storedNoteVals
s.makeGui
s.freeAll





