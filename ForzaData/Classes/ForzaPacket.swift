//
//  ForzaPacket.swift
//  ForzaData
//
//  Created by Quentin Zervaas on 29/11/18.
//

import Foundation

public struct ForzaPacket {
    public struct RawPacket {
        
    }
}

// https://forums.forzamotorsport.net/turn10_postsm926839_Forza-Motorsport-7--Data-Out--feature-details.aspx

extension ForzaPacket.RawPacket {
    public struct V0Packet {
        public let IsRaceOn: Int32 // = 1 when race is on. = 0 when in public menus/race stopped …
        public let TimestampMS: UInt32 //Can overflow to 0 eventually

        public let EngineMaxRpm: Float32
        public let EngineIdleRpm: Float32
        public let CurrentEngineRpm: Float32

        public let AccelerationX: Float32 //In the car's local space; X = public right, Y = up, Z = forward
        public let AccelerationY: Float32
        public let AccelerationZ: Float32

        public let VelocityX: Float32 //In the car's local space; X = public right, Y = up, Z = forward
        public let VelocityY: Float32
        public let VelocityZ: Float32

        public let AngularVelocityX: Float32 //In the car's local space; public X = pitch, Y = yaw, Z = roll
        public let AngularVelocityY: Float32
        public let AngularVelocityZ: Float32

        public let Yaw: Float32
        public let Pitch: Float32
        public let Roll: Float32

        public let NormalizedSuspensionTravelFrontLeft: Float32 // public Suspension travel normalized: 0.0f = max stretch; 1.0 public = max compression
        public let NormalizedSuspensionTravelFrontRight: Float32
        public let NormalizedSuspensionTravelRearLeft: Float32
        public let NormalizedSuspensionTravelRearRight: Float32

        public let TireSlipRatioFrontLeft: Float32 // Tire normalized public slip ratio, = 0 means 100% grip and |ratio| > 1.0 public means loss of grip.
        public let TireSlipRatioFrontRight: Float32
        public let TireSlipRatioRearLeft: Float32
        public let TireSlipRatioRearRight: Float32

        public let WheelRotationSpeedFrontLeft: Float32 // Wheel rotation public speed radians/sec.
        public let WheelRotationSpeedFrontRight: Float32
        public let WheelRotationSpeedRearLeft: Float32
        public let WheelRotationSpeedRearRight: Float32

        public let WheelOnRumbleStripFrontLeft: Int32 // = 1 when wheel public is on rumble strip, = 0 when off.
        public let WheelOnRumbleStripFrontRight: Int32
        public let WheelOnRumbleStripRearLeft: Int32
        public let WheelOnRumbleStripRearRight: Int32

        public let WheelInPuddleDepthFrontLeft: Float32 // = from 0 to 1, public where 1 is the deepest puddle
        public let WheelInPuddleDepthFrontRight: Float32
        public let WheelInPuddleDepthRearLeft: Float32
        public let WheelInPuddleDepthRearRight: Float32
     
        public let SurfaceRumbleFrontLeft: Float32 // Non-dimensional public surface rumble values passed to controller force public feedback
        public let SurfaceRumbleFrontRight: Float32
        public let SurfaceRumbleRearLeft: Float32
        public let SurfaceRumbleRearRight: Float32

        public let TireSlipAngleFrontLeft: Float32 // Tire normalized public slip angle, = 0 means 100% grip and |angle| > 1.0 public means loss of grip.
        public let TireSlipAngleFrontRight: Float32
        public let TireSlipAngleRearLeft: Float32
        public let TireSlipAngleRearRight: Float32

        public let TireCombinedSlipFrontLeft: Float32 // Tire normalized public combined slip, = 0 means 100% grip and |slip| > 1.0 public means loss of grip.
        public let TireCombinedSlipFrontRight: Float32
        public let TireCombinedSlipRearLeft: Float32
        public let TireCombinedSlipRearRight: Float32

        public let SuspensionTravelMetersFrontLeft: Float32 // Actual public suspension travel in meters
        public let SuspensionTravelMetersFrontRight: Float32
        public let SuspensionTravelMetersRearLeft: Float32
        public let SuspensionTravelMetersRearRight: Float32

        public let CarOrdinal: Int32 //Unique ID of the car make/model
        public let CarClass: Int32 //Between 0 (D -- worst cars) and 7 (X public class -- best cars) inclusive
        public let CarPerformanceIndex: Int32 //Between 100 (slowest car) public and 999 (fastest car) inclusive
        public let DrivetrainType: Int32 //Corresponds to public EDrivetrainType; 0 = FWD, 1 = RWD, 2 = AWD
        public let NumCylinders: Int32 //Number of cylinders in the engine
    }

    public struct V1Packet {
        //Position (meters)
        public let PositionX: Float32
        public let PositionY: Float32
        public let PositionZ: Float32

        public let Speed: Float32 // meters per second
        public let Power: Float32 // watts
        public let Torque: Float32 // newton meter

        public let TireTempFrontLeft: Float32
        public let TireTempFrontRight: Float32
        public let TireTempRearLeft: Float32
        public let TireTempRearRight: Float32
        
        public let Boost: Float32
        public let Fuel: Float32
        public let DistanceTraveled: Float32
        public let BestLap: Float32
        public let LastLap: Float32
        public let CurrentLap: Float32
        public let CurrentRaceTime: Float32
        
        public let LapNumber: UInt16
        public let RacePosition: UInt8
        
        public let Accel: UInt8
        public let Brake: UInt8
        public let Clutch: UInt8
        public let HandBrake: UInt8
        public let Gear: UInt8
        public let Steer: Int8
        
        public let NormalizedDrivingLine: Int8
        public let NormalizedAIBrakeDifference: Int8
    }
}

extension ForzaPacket.RawPacket.V0Packet {
    public var isRaceOn: Bool {
        return self.IsRaceOn != 0
    }
}

extension ForzaPacket.RawPacket.V1Packet {
    public var speedKmh: Double {
        return Double(self.Speed) * 3.6
    }
    
    public var speedMph: Double {
        return Double(self.Speed) * 2.23694
    }
    
    
    public var currentGear: ForzaPacket.VehicleGear {
        if self.Gear <= 0 {
            return .reverse
        }
        else {
            return .forward(Int(self.Gear))
        }
    }
}

extension ForzaPacket {
    public enum VehicleGear {
        case reverse
        case forward(Int)
    }
}

extension ForzaPacket {
    public struct ForzaSledPacket {
        public let v0: ForzaPacket.RawPacket.V0Packet
        
        var toData: Data {
            return Data.encode(self)
        }
    }

    public struct ForzaDashPacket {
        public let v0: ForzaPacket.RawPacket.V0Packet
        public let v1: ForzaPacket.RawPacket.V1Packet
        
        var toData: Data {
            return Data.encode(self)
//            var mSelf = self
//            return Data(bytes: &mSelf, count: MemoryLayout<ForzaDashPacket>.size.self)
        }
    }
}

