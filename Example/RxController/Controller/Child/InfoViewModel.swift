//
//  InfoViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/09.
//  Copyright © 2019 XFLAG. All rights reserved.
//

import RxSwift
import RxCocoa
import RxController

struct InfoEvent {
    static let name = RxControllerEvent.identifier()
    static let number = RxControllerEvent.identifier()
}

class InfoViewModel: BaseViewModel {
    
    var name: Observable<String?> {
        events.value(of: InfoEvent.name)
    }
    
    var number: Observable<String?> {
        events.value(of: InfoEvent.number)
    }
    
    func updateAll() {
        events.accept(InfoEvent.name.event("name"))
        events.accept(InfoEvent.number.event("phone-number"))
    }

}
