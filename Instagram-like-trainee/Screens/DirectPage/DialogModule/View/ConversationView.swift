//
//  ConversationView.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 23.04.24.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isTextFieldTapped: Bool = false
    let coordinator: HomeCoordinator

    init(viewModel: ViewModel, coordinator: HomeCoordinator) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {

                            DialogHeaderView(viewModel: viewModel,
                                            coordinator: coordinator,
                                            id: viewModel.id)

                            Spacer(minLength: viewModel.calculateSpacerLength(for: geometry.size.height))

                            ForEach(viewModel.messages) { messeage in
                                if let user = viewModel.getCurrentUser()?.profileImage {
                                    MessageView(viewModel: viewModel,
                                                currentMessage: messeage,
                                                profileImageURL: user)
                                    .id(messeage.id)
                                }
                            }
                        }
                        .onChange(of: viewModel.messages.count) { _ in
                            if viewModel.messages.last != nil {
                                withAnimation {
                                    proxy.scrollTo(viewModel.messages.last?.id)
                                }
                            }
                        }
                    }
                    ZStack {
                        Rectangle()
                            .frame(height: 40.0)
                            .foregroundStyle(Color.gray.opacity(0.1))
                            .clipShape(.capsule)
                        HStack {
                            ZStack {
                                Circle()
                                    .frame(width: 30.0, height: 30.0)
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(
                                                colors: [Color.purple, Color.blue]),
                                            startPoint: .leading, endPoint: .trailing))
                                Button(action: {
                                    // TODO: camera button pressed logic
                                }, label: {
                                    Image(.cameraFill)
                                        .foregroundStyle(.white)
                                })
                            }
                            .padding(.leading, 10.0)
                            TextField(R.string.localizable.directDialogPlaceholder(), text: $viewModel.typingMessage)
                                .onChange(of: viewModel.typingMessage) { newValue in
                                    isTextFieldTapped = !newValue.isEmpty
                                }

                            if !isTextFieldTapped {
                                Button(action: {
                                    // TODO: - send voice message button pressed logic
                                }, label: {
                                    Image(.mic)
                                })
                                Button(action: {
                                    // TODO: - send media shot button pressed logic
                                }, label: {
                                    Image(.photo)
                                })
                                Button(action: {
                                    // TODO: - send sticker file button pressed logic
                                }, label: {
                                    Image(.appGift)
                                })
                                .padding(.trailing, 10.0)
                            } else {
                                ZStack {
                                    Capsule()
                                        .frame(width: 60.0, height: 30.0)
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(
                                                    colors: [Color.purple, Color.blue]),
                                                startPoint: .leading, endPoint: .trailing))
                                    Button(action: {
                                        viewModel.sendMessages()
                                        viewModel.typingMessage = ""
                                        isTextFieldTapped = false

                                    }, label: {
                                        Image(.paperplaneFill)
                                            .foregroundStyle(.white)
                                    })
                                }
                                .padding(.trailing, 10.0)
                            }
                        }
                    }
            }.padding(.horizontal, 18.0)
                .navigationBarBackButtonHidden(true)
        }
    }
}

extension ConversationView {
    final class ViewModel: ObservableObject {
        @Published var messages: [Dialog] = []
        @Published var users: [User] = []
        @Published var typingMessage: String = ""
        private var currentMessage: Dialog?
        private var jsonService = JsonService()
        let id: Int

        init(id: Int) {
            self.id = id
            getMessages()
            getUsers()
        }

        func getMessages() {
            let dialogsJsonPath = Bundle.main.path(
                forResource: R.string.localizable.dialogs(),
                ofType: R.string.localizable.json())

            let dialogsData = (
                jsonService.fetchFromJson(
                    objectType: messages,
                    filePath: dialogsJsonPath ?? ""
                )
            )
            switch dialogsData {
            case .success(let success):
                    messages.append(contentsOf: success)
                    self.currentMessage = self.messages.popLast()
            case .failure(let failure):
                    print(failure.description)
            }
        }

        func getUsers() {
            let usersJsonPath = Bundle.main.path(
                forResource: R.string.localizable.users(),
                ofType: R.string.localizable.json())

            let usersData = (
                jsonService.fetchFromJson(
                    objectType: users,
                    filePath: usersJsonPath ?? ""
                )
            )

            switch usersData {
            case .success(let success):
                    users.append(contentsOf: success)
                    print("\(users)")
            case .failure(let failure):
                    print(failure.description)
            }
        }

        func sendMessages() {
            if typingMessage != "" {
                messages.append(
                    Dialog(
                        usersId: [1, 0],
                        id: UUID(),
                        messages: [
                            Message(
                                senderId: 1,
                                text: typingMessage)]))
            } else {
                return
            }
        }

        func getUserWithId(_ id: Int) -> User? {
            guard let user = users.filter({ user in
                user.id == id
            }).first else {
                return nil
            }
            return user
        }

        func getCurrentUser() -> User? {
            return getUserWithId(id)
        }

        func calculateSpacerLength(for height: CGFloat) -> CGFloat {
            switch height {
            case 800...:
                    return 280
            case 700...780:
                    return 200
            case 671...699:
                    return 150
            case 550...670:
                    return 70
            default:
                    return 170
            }
        }
    }
}
