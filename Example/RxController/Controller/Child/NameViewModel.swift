//
//  NameViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/16.
//  Copyright © 2019 XFLAG. All rights reserved.
//

import RxCocoa
import RxController
import RxSwift


struct NameEvent {
    static let firstName = RxControllerEvent.identifier()
    static let lastName = RxControllerEvent.identifier()
}

class NameViewModel: BaseViewModel {
    
    private let nameRelay = BehaviorRelay<String?>(value: nil)
    private let numberRelay = BehaviorRelay<String?>(value: nil)
    
    override func prepareForParentEvents() {
        bindParentEvents(to: nameRelay, with: InfoEvent.name)
        bindParentEvents(to: numberRelay, with: InfoEvent.number)
    }

    var name: Observable<String?> {
        Observable.merge(
            nameRelay.asObservable(),
            Observable.combineLatest(
                events.unwrappedValue(of: NameEvent.firstName),
                events.unwrappedValue(of: NameEvent.lastName)
            ).map { $0 + " " + $1 }
        )
    }
    
    var number: Observable<String?> {
        numberRelay.asObservable()
    }
    
    func updateName() {
        let firstName = "firstName"
        let lastName = "lastName"
        parentEvents.accept(InfoEvent.name.event(firstName + " " + lastName))
        events.accept(NameEvent.firstName.event(firstName))
        events.accept(NameEvent.lastName.event(lastName))
    }

    
}
