//
//  ProgressManager.swift
//  MoneyBox
//
//  Created by s.m.fedorov on 19/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ProgressManager: IProgressDisplayable {
    static let shared = ProgressManager()
    private var counter = 0
    private var showProgressRequested = false
    
    func showProgress() {
        guard Thread.isMainThread else {
            assertionFailure("showProgress() called from background thread")
            return
        }
        
        self.counter += 1
        self.showProgressRequested = true
        DispatchQueue.main.asyncAfter(deadline: .now() + GlobalConstants.ui.defaultDelay) {
            if self.showProgressRequested /*&& !self.loaderView.isPresented*/ {
                self.startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        //        window.addSubview(self.loaderView)
        //        self.loaderView.startAnimation()
        print("PROGRESS STARTED")
    }
    
    func hideProgress() {
        guard Thread.isMainThread else {
            assertionFailure("hideProgress() called from background thread")
            return
        }
        
        self.counter -= 1
        if self.counter < 1 && self.showProgressRequested {
            self.showProgressRequested = false
            UIApplication.shared.endIgnoringInteractionEvents()
            //            self.loaderView.stopAnimation()
            //            self.loaderView.removeFromSuperview()
            print("PROGRESS FINISHED")
            self.counter = 0
        }
    }
}
