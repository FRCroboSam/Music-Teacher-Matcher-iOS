/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An observable state object that contains profile details.
*/

import SwiftUI
import PhotosUI
import CoreTransferable

@MainActor
class ProfileModel: ObservableObject {
    // MARK: - Profile Image
    var profileImage: ProfileImage?
    var gotTheSelectedItem = false
    var numSelectedItem = 0
    var uiImage2: UIImage?
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    func setUIImage(uiImage: UIImage){
        print("SETTING THE UIIMAGE 2131232133")
        uiImage2 = uiImage
        print(uiImage2!.size)
    }
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        let uiImage: UIImage?

        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                print("IMPORTING NSIMAGE")
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                print("IMPORTING UIKIT IMAGE")
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image, uiImage:uiImage)
            #else
                throw TransferError.importFailed
            #endif
            }
        }

    }
    
    @Published private(set) var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Private Methods
    //loads the image 
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                print("GOT THE SELECTED ITEM")
                switch result {
                case .success(let profileImage?):
                    print("Setting the profileImage")
                    self.profileImage = profileImage
                    self.imageState = .success(profileImage.image)
                    self.gotTheSelectedItem = true
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
                self.numSelectedItem += 1
            }
        }
    }
    public func setImageState(imageState:ImageState){
        DispatchQueue.main.async {
            self.imageState = imageState
        }
        
    }
    public func getImage() -> UIImage{
        let image = UIImage(systemName: "heart.fill")
        return profileImage?.uiImage ?? image!
    }
}
