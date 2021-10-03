//
//  SynthManager.swift
//  monoleap
//
//  Created by Dan on 07/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import AudioKit
import SoundpipeAudioKit

@objc public class SynthManager : NSObject {
    
    let engine = AudioEngine()
    var osc: PWMOscillator
    var osc2: DynamicOscillator
    
    var playingNote: Int?
    var filter: MoogLadder
    var limiter : PeakLimiter
    var delay: Delay
    var dryWetMixer: DryWetMixer
    var mixer: Mixer
    
    override init() {
        
        osc = PWMOscillator()
        osc2 = DynamicOscillator()
        osc2.setWaveform(Table(.sawtooth))
        osc2.amplitude = 0.8;
        
        mixer = Mixer(osc2)
        
        filter = MoogLadder(mixer)
        filter.start()
        
        delay = Delay(filter)
        dryWetMixer = DryWetMixer(filter, delay)
        dryWetMixer.balance = 0.2
        delay.time = 0.4
        
        limiter = PeakLimiter(dryWetMixer)
        engine.output = limiter
        
//        osc.setWaveform(Table(.sawtooth))
        osc.stop()
        osc2.stop()
        osc.amplitude = 0.6
        
        filter.cutoffFrequency = 0
        filter.resonance = 0
        
        super.init()
        
        start()
    }
    
    private func start() {
        do {
            try engine.start()
        } catch let err {
            Log(err)
        }
    }
    
    @objc func noteOn(_ noteNumber: Int) {
        start()
        osc.frequency = noteNumber.midiNoteToFrequency()
        osc2.frequency = noteNumber.midiNoteToFrequency()
        
        if (playingNote == nil) {
            osc.start();
            osc2.start();
        }
        
        playingNote = noteNumber;
    }
    
    @objc func noteOff(_ noteNumber: Int) {
        if (playingNote == noteNumber) {
            osc.stop();
            osc2.stop();
            playingNote = nil;
        }
    }
    
    @objc func filterCutoff(_ value: Int) {
        NSLog("Setting Filter cutoff: %d", value)
        let cutoff =  max(200, Float(value) / 127 * 6000)
        NSLog("Filter cutoff: %f", cutoff)
        filter.cutoffFrequency = cutoff
    }
    
    @objc func resonance(_ value: Int) {
        let resonance = min(Float(value) / 127, 0.8)
        filter.resonance = resonance
    }
}
