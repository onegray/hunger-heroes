//
//  HomeView.swift
//  HungerHeroes
//
//  Created by onegray on 28.08.22.
//

import SwiftUI

protocol HomeViewDelegate: AnyObject {
    func onSignInBtn()
    func onOpenGameBtn()
    func onViewPlayersBtn()
}

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    weak var delegate: HomeViewDelegate?

    var body: some View {

        VStack(alignment: .center) {

            if self.viewModel.loginStatus == .signed {

                Text("Hello \(self.viewModel.username)!")
                    .padding()

                Button("View Players") {
                    self.delegate?.onViewPlayersBtn()
                }
                .padding()

                Button("Open Game") {
                    self.delegate?.onOpenGameBtn()
                }
                .padding()

                Spacer()

            } else {

                GeometryReader { metrics in
                    LoginView(viewModel: self.viewModel, delegate: self.delegate)
                        .padding(.top, metrics.size.height * 0.15)
                        .padding(.horizontal, metrics.size.width * 0.15)
                }
                .ignoresSafeArea()
            }
        }
        .animation(.default)
    }
}


struct LoginView: View {

    @ObservedObject var viewModel: HomeViewModel
    weak var delegate: HomeViewDelegate?

    var body: some View {

        VStack(alignment: .center) {

            TextField("username", text: self.$viewModel.username)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.asciiCapableNumberPad)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()

            SecureField("password", text: self.$viewModel.password)
                .textFieldStyle(.roundedBorder)
                .padding()

            if case .notSigned(let error) = self.viewModel.loginStatus {

                Button("SignIn") {
                    self.delegate?.onSignInBtn()
                }
                .padding()

                if let errMsg = error {
                    Text("Login error: \(errMsg)")
                        .foregroundColor(.orange)
                        .padding()
                }

            } else if self.viewModel.loginStatus == .loading {

                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
            }

        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
#endif
