//
//  AudioCaptureHelper.swift
//  MyCity
//
//  Captures microphone audio for Navoice routeAudio (STT + routing). Uses AVAudioSession + AVAudioRecorder.
//

import AVFoundation
import Foundation

final class AudioCaptureHelper: NSObject {
    private var recorder: AVAudioRecorder?
    private var recordingURL: URL?

    /// Request recording permission; calls completion with true if granted.
    func requestPermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    /// Configure session and start recording. Call stopRecording when user taps stop.
    func startRecording(completion: @escaping (Bool, String?) -> Void) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            DispatchQueue.main.async { completion(false, error.localizedDescription) }
            return
        }

        let dir = FileManager.default.temporaryDirectory
        let name = "navoice_capture_\(UUID().uuidString).m4a"
        recordingURL = dir.appendingPathComponent(name)

        guard let url = recordingURL else {
            DispatchQueue.main.async { completion(false, "No recording URL") }
            return
        }

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]

        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.prepareToRecord()
            recorder?.record()
            DispatchQueue.main.async { completion(true, nil) }
        } catch {
            DispatchQueue.main.async { completion(false, error.localizedDescription) }
        }
    }

    /// Stop recording and return audio as Data, or nil on failure.
    func stopRecording(completion: @escaping (Data?) -> Void) {
        guard let rec = recorder, rec.isRecording, let url = recordingURL else {
            DispatchQueue.main.async { completion(nil) }
            return
        }
        rec.stop()
        recorder = nil
        defer { try? FileManager.default.removeItem(at: url) }

        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async { completion(data) }
        } catch {
            DispatchQueue.main.async { completion(nil) }
        }
    }

    var isRecording: Bool {
        recorder?.isRecording ?? false
    }
}
