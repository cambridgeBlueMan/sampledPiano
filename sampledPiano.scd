(
// *********************************************************************************************
//                    LOAD THE SAMPLES
// *********************************************************************************************

// ******************************************************
// put the file names for the piano samples into an array
var theFiles= (thisProcess.nowExecutingPath.dirname ++ "/Steinway Grand Piano/*.*").pathMatch;

// ****************************************
// make a dictionary for the actual samples
~theSamples = Dictionary.new;

theFiles.do({|item, i|
	//item.postln;
	item.basename.splitext[0].right(7).removeItems(" ").postln;
	}
);

// ****************
// load the buffers
s.waitForBoot({
	theFiles.do({|path, i|
		Buffer.read(
			s,
			path,
			action:{|buffer|
				~theSamples[path.basename.splitext[0].right(7).removeItems(" ")] = buffer;
				if (i == (theFiles.size-1),
					{ "buffers loaded".postln;}
				); // end if
			} // end action
		); // end read
	}); // end do
}); // end wait for boot

// *******************************
// clear all buffers on cmd period

CmdPeriod.add({
	Buffer.freeAll
});

) // END CODE

(
SynthDef(\sampledPiano, {|bufnum=5, powerNumerator= 1, gate=1, outbus= 0, amp = 0.5|
	var sig = PlayBuf.ar(2, bufnum: bufnum, rate: 2.pow(powerNumerator/12));
	var env = EnvGen.ar(Env.cutoff(0.1, amp), gate: gate, doneAction: 2);
	Out.ar(outbus, sig*env)
}).add

)

(
var pedalStatus = "V"; // pseudo pedal control, set lower case for pedal
var notes, on, off;
notes = Array.newClear(128);
on = MIDIFunc.noteOn({|val, num, chan, src|
	var synthArgs;
	var theSample;
	var powerNumerator=0;
	var veloc;
	var sampleInfo;

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
});	 // end note on function

off = MIDIFunc.noteOff({|val, num, chan, src|
	notes[num].set( \gate, 0);

});	//args.postln}); // match any noteOn

 CmdPeriod.add({
 	off.free; on.free;
 }); // end cmd period

); END CODE BLOCK

