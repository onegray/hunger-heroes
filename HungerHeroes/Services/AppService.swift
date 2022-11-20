//
// Created by onegray on 31.08.22.
//

import Foundation
import Combine

enum LoginStatus {
    case success
    case failure(Error)
}

protocol AppService {
    var appState: CurrentValueSubject<AppStateDef?, Never> { get }
    func requestLogin(username: String, passwort: String, handler: @escaping (LoginStatus)->Void)
}

class CoreAppService: AppService {

    let appState = CurrentValueSubject<AppStateDef?, Never>(nil)

    let storage: Storage
    let httpClient: HttpClientProtocol

    init(storage: Storage, httpClient: HttpClientProtocol) {
        self.storage = storage
        self.httpClient = httpClient

        self.storage.loadStorage {
            if let appState = self.storage.appState {
                self.appState.value = appState
            }
        }
    }

    func requestLogin(username: String, passwort: String, handler: @escaping (LoginStatus)->Void) {
        let request = M3LoginRequest(username: username, password: passwort) { response in
            if case .success = response.status {
                handler(.success)
            } else if case .failure(let error) = response.status {
                print(error)
                handler(.failure(error))
            }
        }
        self.httpClient.perform(request)
    }

}
