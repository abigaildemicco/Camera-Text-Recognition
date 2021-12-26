//
//  CameraView.swift
//  CameraTextRecognition
//
//  Created by Abigail De Micco on 15/12/21.
//

import SwiftUI
import Combine
import AVFoundation

final class CameraModel: ObservableObject {
    private let service = CameraService()
    
    @Published var photo: Photo!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        service.capturePhoto()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
}

struct CameraView: View {
    @StateObject var model = CameraModel()
    
    @State var currentZoomFactor: CGFloat = 1.0
    
    @Binding var image: UIImage?
    
    @State var isPresenting: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var captureButton: some View {
        Button(action: {
            model.capturePhoto()
        }, label: {
            Image(systemName: "camera.aperture")
                .font(.system(size: 20, weight: .medium, design: .default))
        })
            .accentColor(.pink)
    }
    
    var switchFlashButton: some View {
        Button(action: {
            model.switchFlash()
        }, label: {
            Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                .font(.system(size: 20, weight: .medium, design: .default))
        })
            .accentColor(.pink)
    }
    
    var photoLibraryButton: some View {
        Button(action: {
            isPresenting = true
        }, label: {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 20, weight: .medium, design: .default))
        })
            .accentColor(.pink)
    }
    
    var capturedPhoto: some View {
        Group {
            if model.photo != nil {
                Image(uiImage: model.photo.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .animation(.spring())
                    .onAppear() {
                        image = model.photo.image
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    var body: some View {
        NavigationView{
            GeometryReader{ reader in
                        ZStack {
                            Color.white.edgesIgnoringSafeArea(.all)
                            
                            VStack {
                                ZStack{
                                    CameraPreview(session: model.session)
                                        .gesture(
                                            DragGesture().onChanged({ (val) in
                                                //  Only accept vertical drag
                                                if abs(val.translation.height) > abs(val.translation.width) {
                                                    //  Get the percentage of vertical screen space covered by drag
                                                    let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                                    //  Calculate new zoom factor
                                                    let calc = currentZoomFactor + percentage
                                                    //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                                    let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                                    //  Store the newly calculated zoom factor
                                                    currentZoomFactor = zoomFactor
                                                    //  Sets the zoom factor to the capture device session
                                                    model.zoom(with: zoomFactor)
                                                }
                                            })
                                        )
                                        .onAppear {
                                            model.configure()
                                        }
                                        .alert(isPresented: $model.showAlertError, content: {
                                            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                                model.alertError.primaryAction?()
                                            }))
                                        })
                                        .overlay(
                                            Group {
                                                if model.willCapturePhoto {
                                                    Color.black
                                                }
                                            }
                                        )
                                        .animation(.easeInOut)
                                    
                                    Text("Allinea il testo")
                                        .foregroundColor(.white)
                                        .opacity(0.8)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 5, style: .continuous)
                                                        .foregroundColor(.black)
                                                        .opacity(0.6))
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.pink, lineWidth: 5)
                                        .opacity(0.4)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 60)
                                }
                                
                                
                                capturedPhoto
                                
                                HStack {
                                    Spacer()
                                    
                                    Text("Testo")
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(width: 100, height: 40)
                                        .background(RoundedRectangle(cornerRadius: 3, style: .continuous)
                                                        .foregroundColor(.pink))
                                    
                                    Text("Oggetto")
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(width: 100, height: 40)
                                        .background(RoundedRectangle(cornerRadius: 3, style: .continuous)
                                                        .foregroundColor(.gray))
                                    Spacer()
                                }
                                .padding()
                                
//                                Divider()
//
//                                HStack {
//                                    switchFlashButton
//
//                                    Spacer()
//
//                                    captureButton
//
//                                    Spacer()
//
//                                    photoLibraryButton
//
//                                }
//                                .padding(20)
                            }
                        }
                        .sheet(isPresented: $isPresenting) {
                            ImagePicker(uiImage: $image, isPresenting: $isPresenting)
                                .onDisappear() {
                                    if(image != nil) {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                        }
                    }
            .toolbar{
                ToolbarItemGroup(placement: .bottomBar){
                    switchFlashButton
                    
                    Spacer()
                    
                    captureButton
                    
                    Spacer()
                    
                    photoLibraryButton
                }
            }
        }
    }
}

