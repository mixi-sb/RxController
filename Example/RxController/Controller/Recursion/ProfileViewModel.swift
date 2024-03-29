//
//  ProfileViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RxCocoa
import RxSwift

class ProfileViewModel: BaseViewModel {
    
    private let nameRelay = BehaviorRelay<String?>(value: nil)
    
    init(name: String? = nil) {
        super.init()
        nameRelay.accept(name ?? "name")
    }
    
    var name: Observable<String?> {
        nameRelay.asObservable()
    }
    
    func showFriends() {
        guard let name = nameRelay.value else {
            return
        }
        steps.accept(ProfileStep.friends(name))
    }
    
}
