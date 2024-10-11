

(
m = MixerChannel.new("master", s, 2, 2);
a = MixerChannel.new("reverb", s,2,2);
a.play(Instr.at([\busfx, \rvb_allpass2]));
b = MixingBoard.new("Raindirk", mixers: [m,a]);
//b.add([m, a])
)
s.makeGui
MixerChannel.freeAll
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
})

) // END CODE

// *********************************************************************************************
//                    LOGIC PRO PIANO SAMPLES LOAD
// *********************************************************************************************

(
SynthDef(\sampledPiano, {|bufnum=5, powerNumerator= 1, gate=1, outbus= 0, amp = 0.5|
	var sig = PlayBuf.ar(2, bufnum: bufnum, rate: 2.pow(powerNumerator/12), doneAction: 2);
	var env = EnvGen.ar(Env.cutoff(0.1, amp), gate: gate, doneAction: 2);
	Out.ar(outbus, sig*env)
}).add

)

// *********************************************************************************************
//                    HARPSICHORD SYNTHDEF
// *********************************************************************************************

(
    s = Server.local;
    SynthDef(\harps, { arg i_out=0, freq, gate=1;
        var out;
        out = RLPF.ar(
            LFSaw.ar( freq, mul: EnvGen.kr( Env.adsr(0.001, 2, 0.01, 0.1, 1, -4), gate: gate, levelScale: 0.3, doneAction: 2 )),
            LFNoise1.kr(1, 36, 110).midicps,
            0.1
        );
        // out = [out, DelayN.ar(out, 0.04, 0.04) ];
        4.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
        Out.ar( i_out, out );
    }).send(s);
)

// *********************************************************************************************
//                    CODE FOR HARPSICHORD
// *********************************************************************************************

(

// var pedalStatus = "V"; // pseudo pedal control, set lower case for pedal
var notes, on, off;
notes = Array.newClear(128);
on = MIDIFunc.noteOn({|val, num, chan, src|
	var synthArgs;
	// var theSample;
	// var powerNumerator=0;
	var veloc;
	// var sampleInfo;



	//notes[num] = Synth.new(\sampledPiano,
	notes[num] = Synth.new(\harps,
		[ \freq, num.midicps,
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

)

// *********************************************************************************************
//                    CODE FOR LOGIC PRO PIANO
// *********************************************************************************************

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

	//notes[num] = Synth.new(\sampledPiano,
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

