/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The profile image that reflects the selected item state.
*/

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI
struct CircleProfileImage: View {
    let imageState: ProfileModel.ImageState
    @State var finalImage = Image("blankperson")
    
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct CircularProfileImage: View {
    let imageState: ProfileModel.ImageState
    let size: CGFloat?
    var body: some View {
        CircleProfileImage(imageState: imageState)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: size ?? 100, height: size ?? 100)
            .background {
                Circle().fill(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
    }
}
struct ProfileImage: View{
    let image: Image
    let size: CGFloat
    var body: some View {
        image.resizable()
            .font(.system(size: 40))
            .foregroundColor(.white)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: size, height: size)
            .background {
                Circle().fill(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
    }
}
//TODO: IMPLEMENT THIS
struct ProfileImageFromURL: View{
    let url: String
    let size: CGFloat
    var body: some View {
        if(url.count > 5 && !url.localizedCaseInsensitiveContains("None")){
            WebImage(url: URL(string: url))
                .placeholder(Image(systemName: "person.fill"))
                .resizable()
                .foregroundColor(.white)
                .scaledToFill()
                .clipShape(Circle())
                .overlay{
                    Circle().strokeBorder(Color(UIColor.systemGray6), lineWidth: 1).opacity(0.5)
                }
                .frame(width: size, height: size)
                .minimumScaleFactor(0.01)
        }
        else{
            CircularProfileImage(imageState: .empty, size: size)
        }

    }
}
struct EditableCircularProfileImage: View {
    @EnvironmentObject var viewModel: ProfileModel
    var finalImage = Image("blankperson")
    
    var body: some View {
        CircularProfileImage(imageState: viewModel.imageState, size: 100)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.borderless)

            }
    }
}
