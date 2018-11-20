//
//  NotificationPopUpExtension.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 18/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let closePopUp = Notification.Name(rawValue: "closePopUp")
}


// Put this in the presented view controller
//NotificationCenter.default.post(name: .closePopUp, object: self)


//// Notification Center Code ///

/*
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("JAJJAAJAJAJAJAJAAJAAJ")
}


override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    print("HVA FUCK ER")
}

observer = NotificationCenter.default.addObserver(forName: .closePopUp, object: nil, queue: OperationQueue.main) { (notification) in
    self.view.backgroundColor = UIColor(white: 1, alpha: 1)
    if let observer = self.observer {
        NotificationCenter.default.removeObserver(self.observer)
}
*/
