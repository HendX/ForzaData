//
//  ForzaDataGenerator.swift
//  ForzaData
//
//  Created by Quentin Zervaas on 1/12/18.
//

import Foundation

public class ForzaDataGenerator {
    
    public var packetGeneratedCallack: ((ForzaPacket.ForzaDashPacket) -> Void)?
    
    private var timer: Timer?
    private var startDate: Date!
    
    private var paused = false
    
    let packetsPerSecond: Int

    public init(packetsPerSecond: Int) {
        self.packetsPerSecond = packetsPerSecond
    }
    
    public func startGeneratingDash(paused: Bool) {
        
        self.paused = paused
        self.startDate = Date()
        
        let interval: TimeInterval = 1 / Double(packetsPerSecond)
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(ForzaDataGenerator.timerTriggered(_:)), userInfo: nil, repeats: true)
    }
    
    public func pauseRace() {
        self.paused = true
    }
    
    public func resumeRace() {
        self.paused = false
    }
    
    public func stopGenerating() {
        self.timer?.invalidate()
    }
    
    @objc func timerTriggered(_ timer: Timer) {
        let elapsed = Date().timeIntervalSince(self.startDate)
        let packet = self.buildPacket(elapsed: elapsed)
        
        self.packetGeneratedCallack?(packet)
    }
    
    func buildPacket(elapsed: TimeInterval) -> ForzaPacket.ForzaDashPacket {
        
        let timestampMs = UInt32(elapsed * 1000)
    
        let v0 = ForzaPacket.RawPacket.V0Packet(
            IsRaceOn: self.paused ? 0x0 : 0x1,
            TimestampMS: timestampMs,
            EngineMaxRpm: 0,
            EngineIdleRpm: 0,
            CurrentEngineRpm: 0,
            AccelerationX: 0,
            AccelerationY: 0,
            AccelerationZ: 0,
            VelocityX: 0,
            VelocityY: 0,
            VelocityZ: 0,
            AngularVelocityX: 0,
            AngularVelocityY: 0,
            AngularVelocityZ: 0,
            Yaw: 0,
            Pitch: 0,
            Roll: 0,
            NormalizedSuspensionTravelFrontLeft: 0,
            NormalizedSuspensionTravelFrontRight: 0,
            NormalizedSuspensionTravelRearLeft: 0,
            NormalizedSuspensionTravelRearRight: 0,
            TireSlipRatioFrontLeft: 0,
            TireSlipRatioFrontRight: 0,
            TireSlipRatioRearLeft: 0,
            TireSlipRatioRearRight: 0,
            WheelRotationSpeedFrontLeft: 0,
            WheelRotationSpeedFrontRight: 0,
            WheelRotationSpeedRearLeft: 0,
            WheelRotationSpeedRearRight: 0,
            WheelOnRumbleStripFrontLeft: 0,
            WheelOnRumbleStripFrontRight: 0,
            WheelOnRumbleStripRearLeft: 0,
            WheelOnRumbleStripRearRight: 0,
            WheelInPuddleDepthFrontLeft: 0,
            WheelInPuddleDepthFrontRight: 0,
            WheelInPuddleDepthRearLeft: 0,
            WheelInPuddleDepthRearRight: 0,
            SurfaceRumbleFrontLeft: 0,
            SurfaceRumbleFrontRight: 0,
            SurfaceRumbleRearLeft: 0,
            SurfaceRumbleRearRight: 0,
            TireSlipAngleFrontLeft: 0,
            TireSlipAngleFrontRight: 0,
            TireSlipAngleRearLeft: 0,
            TireSlipAngleRearRight: 0,
            TireCombinedSlipFrontLeft: 0,
            TireCombinedSlipFrontRight: 0,
            TireCombinedSlipRearLeft: 0,
            TireCombinedSlipRearRight: 0,
            SuspensionTravelMetersFrontLeft: 0,
            SuspensionTravelMetersFrontRight: 0,
            SuspensionTravelMetersRearLeft: 0,
            SuspensionTravelMetersRearRight: 0,
            CarOrdinal: 0,
            CarClass: 0,
            CarPerformanceIndex: 100,
            DrivetrainType: 0,
            NumCylinders: 6
        )
        
        let v1 = ForzaPacket.RawPacket.V1Packet(
            PositionX: 0,
            PositionY: 0,
            PositionZ: 0,
            Speed: 0,
            Power: 0,
            Torque: 0,
            TireTempFrontLeft: 0,
            TireTempFrontRight: 0,
            TireTempRearLeft: 0,
            TireTempRearRight: 0,
            Boost: 0,
            Fuel: 0,
            DistanceTraveled: 0,
            BestLap: 0,
            LastLap: 0,
            CurrentLap: 0,
            CurrentRaceTime: 0,
            LapNumber: 1,
            RacePosition: 1,
            Accel: 0,
            Brake: 0,
            Clutch: 0,
            HandBrake: 0,
            Gear: 0,
            Steer: 0,
            NormalizedDrivingLine: 0,
            NormalizedAIBrakeDifference: 0
        )
        
        let packet = ForzaPacket.ForzaDashPacket.init(
            v0: v0,
            v1: v1
        )
        
        return packet
    }
}
