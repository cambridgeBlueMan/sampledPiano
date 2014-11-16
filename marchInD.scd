(
s = Server.local;
SynthDef(\harpsichord, { |i_out=0, freq, gate = 1|
	var out;
	out = RLPF.ar(
		LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, gate, levelScale: 0.3, doneAction: 2 )),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	);
	// out = [out, DelayN.ar(out, 0.04, 0.04) ];
	4.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
	Out.ar( i_out, out );
}).add;
)

(
s = Server.local;
SynthDef(\harpsichord2, { |i_out=0, freq, gate = 1|
	var out;
	out = RLPF.ar(
		LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: 2 )),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	);
	// out = [out, DelayN.ar(out, 0.04, 0.04) ];
	4.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
	out = EnvGen.ar(Env.cutoff(0.1), gate: gate)*out;
	Out.ar( i_out, out );
}).add;
)

~verbose = 999
// =============================================================================
//
//                 CODE TO HANDLE KEYBOARD SYNTH INPUT
// =============================================================================
~midiStream.postln
(
var notes, no, off, kay;
~midiStream = List.new;
notes = Array.newClear(128);
kay = BasicMIDISocket([~oxy,0],
	{| num, vel|
		num.post ;
		", ".post;
		notes[num] = Synth.new(\harpsichord2, [\freq, num.midicps, \amp, vel*0.00315, \gate, 1]);

	},
	{|num, vel|
		notes[num].set(\gate, 0);
});
CmdPeriod.add({
	kay.free
});
)
kay.clear


// **********
// March in D
(

var treble, trebleA, trebleB;
var bass, bassA, bassB;
var clock;
clock = TempoClock.new(1.5);

bassA = Pbind(
	\instrument, \harpsichord,
	\midinote, Place([
		Pseq([38, 50], 4),
		54, 55, 57, 55, 54, 52, 57, [54, 50], [50, Rest]], 2),
	\dur, Pseq([
		Pseq([0.5], 8),
		0.25,
		0.25,
		Pseq([0.5], 7)
	], 2).trace


); //.play(clock);
// )
// (
trebleA = Pbind(
	\instrument, \harpsichord,
	\midinote, Place([
		Pseq([69, 67, 66, 64, 62], 2),
		66, 67, 69, 67, 66, 64, 69, [66, 62], [62, Rest]],
		2),


	\dur, Pseq([
		Pseq([1, Pseq([0.25], 4)],2), // first two bars
	0.25,
		0.25,
		Pseq([0.5], 7)], 2
	)
); //.play(clock)


trebleB = Pbind(
	\instrument, \harpsichord,
	\midinote, Pseq([
		Pseq([61, 62, 64], 2),
		69, 64, 64, 69, 64, 69, 64, 62, 61, 59, 57, 59,52,
		Pseq([64, 63, 52, 62, 61, 69, 68], 2),
		Pseq([64, 63, 61, 63], 2),
		64, 56, 57, 62, 61, 62, 64, 57, 62, 61, 62, 64, 57
	], 1),
	\dur, Pseq([
		Pseq([0.25, 0.25, 0.5], 2),
		0.5, 0.5, 1,
		Pseq([0.5], 4),
		Pseq([0.25], 4),
		Pseq([0.5], 5),
		1,
		Pseq([0.5], 6),
		1,
		0.5, 0.5, 0.5,
		Pseq([0.25], 8),
		Pseq([0.5], 4),
		0.25, 0.25, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1],
		1)
); //.play(clock);



bassB = Pbind(
\instrument, \harpsichord,
\midinote, Pseq([
				Pseq([45, 57], 7),
				Pseq([40,52], 11),
					40, 50, 49, 50, 52, 45, 50, 49, 50, 52, 45]
				),
			\dur, Pseq([
				Pseq([0.5], 40),
				1, 0.5, 0.5, 0.25, 0.25, 0.5, 1],
				1)
); // .play(clock)

treble = trebleA ++ trebleA ++ trebleB ++ trebleA;
bass = bassA ++ bassA ++ bassB ++ bassA;
Ppar([
	treble,
	bass
]).play(clock)

)

