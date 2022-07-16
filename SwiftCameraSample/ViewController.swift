import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    
    // カメラデバイスの設定
    // メインカメラ管理オブジェクトの設定
    var mainCamera: AVCaptureDevice?
    // インカメ管理オブジェクトの設定
    var innerCamera: AVCaptureDevice?
    // 現在使用しているカメラデバイス管理オブジェクト作成
    var currentDevice: AVCaptureDevice?
    
    // Sessionの出力を指定するためのオブジェクト
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
    }
    
    // カメラのプレビューを表示するレイヤの設定
    func setupPreviewLayer() {
        // プレビューを表示するレイヤの初期化
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // プレビューレイヤをキャプチャーレイヤの縦横比を維持した状態にする
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤの表示の向きを設定
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        cameraPreviewLayer?.frame = view.frame
        view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }
    
    // 入出力データの設定
    func setupInputOutput() {
        do {
            // CaptureDeviceからCaptureSessionに向けてデータを提供するInputを初期化
            let caputureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            
            // 入力をセッションに追加
            captureSession.addInput(caputureDeviceInput)
            
            // 出力データを受け取るオブジェクト
            photoOutput = AVCapturePhotoOutput()
            
            let outPutPhotoSettings = [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])]
            // 出力の設定。ここではフォーマットを指定。
            photoOutput!.setPreparedPhotoSettingsArray(outPutPhotoSettings, completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    // デバイスの設定
    func setupDevice () {
        // カメラデバイスのプロパティ設定。どの種類のデバイスをどのメディアのために使うかなど設定。
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        // プロパティの条件を満たしたカメラデバイスの取得。DiscoverySessionで指定した基準に満たしたデバイスのみを取得。
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        
        // 起動時のカメラを設定
        currentDevice = mainCamera
    }
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
}

