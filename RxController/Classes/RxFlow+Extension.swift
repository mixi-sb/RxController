//
//  RxFlow+Extension.swift
//  RxController
//
//  Created by Meng Li on 2019/01/30.
//  Copyright © 2019 MuShare. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import RxFlow

extension FlowContributors {
    
    public static func viewController<ViewModel: RxViewModel>(_ viewController: RxViewController<ViewModel>) -> FlowContributors {
        return .one(flowContributor: .viewController(viewController))
    }
    
    public static func flow(_ flow: Flow, with step: Step) -> FlowContributors {
        return .one(flowContributor: .flow(flow, with: step))
    }
    
}

extension FlowContributor {
    
    public static func viewController<ViewModel: RxViewModel>(_ viewController: RxViewController<ViewModel>) -> FlowContributor {
        return .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel)
    }
    
    public static func viewController(_ viewController: UIViewController, with viewModel: Stepper) -> FlowContributor {
        return .contribute(withNextPresentable: viewController, withNextStepper: viewModel)
    }
    
    public static func flow(_ flow: Flow, with step: Step) -> FlowContributor {
        return .contribute(withNextPresentable: flow, withNextStepper: OneStepper(withSingleStep: step))
    }
    
}

extension Flow {
    
    public typealias PresentComponents = (flow: Flow, contributors: FlowContributors)
    
    public func present(_ presentVC: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) -> FlowContributors {
        let components = createPresentComponents(presentVC)
        Flows.whenReady(flow1: components.flow) { [weak self] _ in
            self?.rootViewController?.present(presentVC, animated: animated, completion: completion)
        }
        return components.contributors
    }
    
    public func createPresentComponents(_ presentVC: UIViewController) -> PresentComponents {
        let presentFlow = PresentFlow(presentVC, with: presentVC.rootRxViewModel)
        let contributors: FlowContributors = .flow(presentFlow, with: PresentStep.start)
        return (presentFlow, contributors)
    }
}

extension Presentable {
    
    var rootViewController: UIViewController? {
        switch self {
        case let viewController as UIViewController:
            return viewController
        case let window as UIWindow:
            return window.rootViewController
        case let flow as Flow:
            return flow.root.rootViewController
        default:
            return nil
        }
    }
    
}

// MARK: - Private
private enum PresentStep: Step {
    case start
}

private class PresentFlow: Flow {
    private(set) var root: Presentable
    private let stepper: Stepper?
    
    func navigate(to step: Step) -> FlowContributors {
        guard step as? PresentStep != nil else {
            return .one(flowContributor: .forwardToParentFlow(withStep: step))
        }
        if let stepper = stepper {
            return .one(flowContributor: .contribute(withNextPresentable: root, withNextStepper: stepper))
        } else {
            return .none
        }
    }
    
    init(_ aRoot: Presentable, with aStepper: Stepper? = nil) {
        root = aRoot
        stepper = aStepper
    }
}
