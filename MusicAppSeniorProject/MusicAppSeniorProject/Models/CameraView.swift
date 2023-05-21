/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import PhotosUI

struct CameraView: View {
    @StateObject private var model = DataModel()
    @EnvironmentObject private var viewModel: ProfileModel
    private static let barHeightFactor = 0.15
    @State var move: Bool = false
    @State var goToGallery = false
    @State var previousPhotoAssetsCount = 0
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                ViewfinderView(image:  $model.viewfinderImage )
                    .overlay(alignment: .top) {
                        Color.black
                            .opacity(0.75)
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                    }
                    .overlay(alignment: .bottom) {
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(.black.opacity(0.75))
                    }
                    .overlay(alignment: .center)  {
                        Color.clear
                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                            .accessibilityElement()
                            .accessibilityLabel("View Finder")
                            .accessibilityAddTraits([.isImage])
                    }
                    .background(.black)
            }
            .task {
                await model.camera.start()
                await model.loadPhotos()
                await model.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
//            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Took a photo"))) { _ in
//                move.toggle()
//                print("Photo NUMBERS: " + String(model.photoCollection.photoAssets.count))
//            }
        }
//        .navigationDestination(isPresented: $move) {
//            if(model.photoCollection.photoAssets.first != nil){
//                PhotoView(asset: model.photoCollection.photoAssets.first!, cache: model.photoCollection.cache)
//            }
//
//        }
        .onChange(of: viewModel.numSelectedItem){ _ in
            dismiss()
        }
        .sheet(isPresented: $move, onDismiss: {
            // Code to execute after dismissing the new view
        }) {
            if(model.photoCollection.photoAssets.first != nil){
                PhotoView(asset: model.photoCollection.photoAssets.first!, cache: model.photoCollection.cache, usePhotoClosure: usePhotoClosure)
            }
        }
        .onChange(of: model.photoCollection.photoAssets.count) { newCount in
            if newCount > previousPhotoAssetsCount && previousPhotoAssetsCount != 0 {
                // New photo captured, update UI or perform any necessary actions
                move = true
                print("Photo NUMBERS: \(model.photoCollection.photoAssets.count)")
            }
            previousPhotoAssetsCount = newCount
        }

    }
    public func usePhotoClosure(){
        dismiss()

    }
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            //go to photos picker when choosing the photo

            
            PhotosPicker(selection: $viewModel.imageSelection,
                         matching: .images,

                         photoLibrary: .shared()) {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            
            .buttonStyle(.borderless)
            
            
            Button {
                model.camera.takePhoto()
                previousPhotoAssetsCount = model.photoCollection.photoAssets.count
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}
