//
// Created by onegray on 31.08.22.
//

import Foundation
import Combine

protocol AppService {
    var appState: CurrentValueSubject<AppStateDef?, Never> { get }
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
}
