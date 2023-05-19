/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct CameraView: View {
    @StateObject private var model = DataModel()
 
    private static let barHeightFactor = 0.15
    @State var move: Bool = false
    @State var previousPhotoAssetsCount = 0
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
        }.navigationDestination(isPresented: $move) {
            if(model.photoCollection.photoAssets.first != nil){
                PhotoView(asset: model.photoCollection.photoAssets.first!, cache: model.photoCollection.cache)
            }
        }.onChange(of: model.photoCollection.photoAssets.count) { newCount in
            if newCount > previousPhotoAssetsCount {
                // New photo captured, update UI or perform any necessary actions
                move = true
                print("Photo NUMBERS: \(model.photoCollection.photoAssets.count)")
            }
            previousPhotoAssetsCount = newCount
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            NavigationLink {
                PhotoCollectionView(photoCollection: model.photoCollection)
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            
            
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
