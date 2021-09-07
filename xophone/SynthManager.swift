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
    
    @objc static public let instance = SynthManager()
    
    let engine = AudioEngine()
    var osc: PWMOscillator
    var playingNote: Int?
    var filter: MoogLadder
    var limiter : PeakLimiter
    var delay: Delay
    var dryWetMixer: DryWetMixer
    
    private override init() {
        osc = PWMOscillator()
        filter = MoogLadder(osc)
        filter.start()
        
        delay = Delay(filter)
        dryWetMixer = DryWetMixer(filter, delay)
        dryWetMixer.balance = 0.16
        delay.time = 0.4
        
        limiter = PeakLimiter(dryWetMixer)
        engine.output = limiter
        
//        osc.setWaveform(Table(.sawtooth))
        osc.stop()
        osc.amplitude = 0.6
        
        filter.cutoffFrequency = 0
        filter.resonance = 0
        
        do {
            try engine.start()
        } catch let err {
            Log(err)
        }
    }
    
    @objc func noteOn(_ noteNumber: Int) {
        if (playingNote == nil) {
            osc.start();
        }
        osc.frequency = noteNumber.midiNoteToFrequency()

        playingNote = noteNumber;
    }
    
    @objc func noteOff(_ noteNumber: Int) {
        if (playingNote == noteNumber) {
            osc.stop();
            playingNote = nil;
        }
    }
    
    @objc func filterCutoff(_ value: Int) {
        NSLog("Setting Filter cutoff: %d", value)
        let cutoff =  Float(value) / 127 * 3000
        NSLog("Filter cutoff: %f", cutoff)
        filter.cutoffFrequency = cutoff
    }
    
    @objc func resonance(_ value: Int) {
        let resonance = Float(value) / 127
        filter.resonance = resonance
    }
}
