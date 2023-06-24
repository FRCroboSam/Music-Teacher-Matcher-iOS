/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Photos

struct PhotoView: View {
    var asset: PhotoAsset


    var cache: CachedImageManager?
    var usePhotoClosure: () -> Void

    @EnvironmentObject private var viewModel: ProfileModel
    @State private var image: Image?
    @State private var usePhoto = false
    @State private var imageRequestID: PHImageRequestID?
    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel(asset.accessibilityLabel)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.secondary)
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            buttonsView()
                .offset(x: 0, y: -50)
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            Button("Use this photo"){
                print("USE THIS PHOTO ")
                let uiImage = asset.phAsset!.getAssetThumbnail()
                let image2 = Image(uiImage: uiImage)
                viewModel.setImageState(imageState: .success(image2))
                usePhoto = true
                dismiss()
                usePhotoClosure()
            }
            
            Button {

//                Task {
//                    await asset.setIsFavorite(!asset.isFavorite)
//                }
            } label: {
                Label("Favorite", systemImage: asset.isFavorite ? "checkmark.circle" : "heart")
                    .font(.system(size: 24))
            }

            Button {
                Task {
                    await asset.delete()
                    await MainActor.run {
                        dismiss()
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
                    .font(.system(size: 24))
            }
        }

        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
        .background(Color.secondary.colorInvert())
        .cornerRadius(15)
    }
}
extension PHAsset {
func getAssetThumbnail() -> UIImage {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    option.isSynchronous = true
    manager.requestImage(for: self,
                         targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                         contentMode: .aspectFit,
                         options: option,
                         resultHandler: {(result, info) -> Void in
                            thumbnail = result!
                         })
    return thumbnail
    }
}
