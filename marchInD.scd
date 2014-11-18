/* This file contains a number of different code snippets.


* two synth defs which are variants of the Patterns tutorial harpsichord
* code to allow a keyboard player for one or other of these synths
* J S Bach's musette in D played on patterns
* a 3 channel mixer and code to control recording from
* the famous "Bach loop" designed to run with the 3-channel mixer

*/
(
// =============================================================================
//
//             A SYNTH DEF WITH AN ADJUSTABLE RELEASE TIME
// =============================================================================

s = Server.local;
SynthDef(\harpsichord, { |out=0, freq, gate = 1, releaseTime = 1|
	var sig;
	sig = RLPF.ar(
		LFSaw.ar( freq, mul: EnvGen.kr( Env.perc(releaseTime: releaseTime), gate, levelScale: 0.3, doneAction: 2 )),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	);
	// sig = [sig, DelayN.ar(sig, 0.04, 0.04) ];
	4.do({ sig = AllpassN.ar(sig, 0.05, [0.05.rand, 0.05.rand], 4) });
	Out.ar( out, sig );
}).add;
)

// =============================================================================
//
//             A SYNTH DEF WITH AN ABILITY TO CLIP THE RELEASE TIME
// =============================================================================
(
s = Server.local;
SynthDef(\harpsichord2, { |out=0, freq, gate = 1, releaseTime = 1|
	var sig;
	sig = RLPF.ar(
		LFSaw.ar( freq, mul: EnvGen.kr( Env.perc(releaseTime: releaseTime), levelScale: 0.3, doneAction: 2 )),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	);
	// sig = [sig, DelayN.ar(sig, 0.04, 0.04) ];
	4.do({ sig = AllpassN.ar(sig, 0.05, [0.05.rand, 0.05.rand], 4) });
	sig = EnvGen.ar(Env.cutoff(0.1), gate: gate)*sig;
	Out.ar( out, sig );
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


// ************************************************************************************
//                          MUSETTE IN D
// ************************************************************************************
(

var treble, trebleA, trebleB;
var bass, bassA, bassB;
var clock;
clock = TempoClock.new(1.6);

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

// ************************************************************************************
//                                 MIXER CHANNELS
// ************************************************************************************
(
// get a mixer def
TwoPFMixerDef.new;

// make some channels
~channels = ["treble", "bass", "middle"].collectAs({|item, i|
	// put mixer channel in Dictionary
	item -> MixerChannel.newFromDef(item, \twoPF1X2, s);

}, Dictionary); // end collect

// *******************
// make a mixing board
~mixer = MixingBoard.new("Rupert Neve", nil, ~channels);


CmdPeriod.add( {
	MixerChannel.freeAll(s);
}); // end CmdPeriod
)
// ************************************************************************************
//                   STUFF TO SET SAMPLE RATE
// ************************************************************************************
// SAMPLE RATE
// get current server options
o = s.options;
// set sample rate
o.sampleRate.postln = 48000;
// implement the revised options
s.options = o;

// now boot and quit, lthough in fact you really need to quite SC and start again
s.quit
s.boot

// BIT DEPTH  AND FILE FORMAT
s.recHeaderFormat.postln; // can be "aiff" or "wav"
s.recSampleFormat = "int24"; // can also be "float" and "int16"

/* Note that when MixerChannels are being used that these these values should be supplied as
arguments to the startRecord method of MixerChannel. See Below
*/
// ************************************************************************************
//                    FRAGMENT TO START RECORD
// ************************************************************************************

(
~channels.do({|item, i|
	item.startRecord(headerformat: "aiff", sampleformat: "int24")
});

)

// ************************************************************************************
//                    FRAGMENT TO END RECORD
// ************************************************************************************
/*
not really necessary, happens anyway on CmdPeriod
*/
(

~channels.do({|item, i|
	item.stopRecord
});
)

// ************************************************************************************
//                   CODE BLOCK TO RUN THE SEQUENCE
// ************************************************************************************
(
~clock = TempoClock(0.7);

~repeats = 2;
// treble notes
Ppar([
	Pbind(
		\instrument, \harpsichord,
		\midinote, Pseq([64, 63, 52, 62, 61, 69, 68], 2*~repeats) ++ Pseq([[64, 71, 68]], 1),
		\releaseTime, Pseq([1], 14*~repeats) ++ Pseq([2], 1),
		\dur, Pseq([0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25], 2*~repeats) ++ Pseq([1], 1),
		\out, ~channels["treble"].inbus.index
	),

	// bass
	Pbind (
		\instrument, \harpsichord,
		\midinote, Pseq([40,52], 8*~repeats) ++ Pseq([40], 1),
		\releaseTime, Pseq([1], 16*~repeats) ++ Pseq([2], 1),
		\dur, 0.25,
		\out, ~channels["bass"].inbus.index
	),

	Pbind (
		\instrument, \harpsichord,
		\midinote, Pseq([68, 71, 73, 71, 69, 73, 71, 73, 71, 68, 71, 73, 76 ], ~repeats),
		\dur, Pseq([1/4, 1/4, 1/2,
			1/4, 1/4, 1/4, 1/4,
			1/4, 1/4, 1/2,
			1/2, 1/4, 1/4], ~repeats),
		\out,~channels["middle"].inbus.index
	),


]).play(~clock); // end ppar
)
