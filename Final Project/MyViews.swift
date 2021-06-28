//
//  MyViews.swift
//  Final Project
//
//  Created by מוטי שקורי on 28/05/2021.
//

import Foundation
import UIKit


class RoundedButton : UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame);
        setupButton();
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupButton();
    }

    private func setupButton() {
  //      view.addSubview(lp_BTN_login)
     layer.cornerRadius = 12
        backgroundColor = .systemGray2
        tintColor = .white
     translatesAutoresizingMaskIntoConstraints = false
//     heightAnchor.constraint(equalToConstant: 50).isActive = true
//     widthAnchor.constraint(equalToConstant: 235).isActive = true
//     centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//     bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
    }
}
    class ConfirmButton : UIButton {

        override init(frame: CGRect) {
            super.init(frame: frame);
            setupButton();
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder);
            setupButton();
        }

        private func setupButton() {
      //      view.addSubview(lp_BTN_login)
         layer.cornerRadius = 12
         backgroundColor = .green
         translatesAutoresizingMaskIntoConstraints = false
         heightAnchor.constraint(equalToConstant: 50).isActive = true
         widthAnchor.constraint(equalToConstant: 235).isActive = true
    //     centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    //     bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        }
    }
        class RemoveButton : UIButton {

            override init(frame: CGRect) {
                super.init(frame: frame);
                setupButton();
            }

            required init?(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder);
                setupButton();
            }

            private func setupButton() {
          //      view.addSubview(lp_BTN_login)
             layer.cornerRadius = 12
             backgroundColor = .red
             translatesAutoresizingMaskIntoConstraints = false
             heightAnchor.constraint(equalToConstant: 50).isActive = true
             widthAnchor.constraint(equalToConstant: 235).isActive = true
        //     centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //     bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
            }
}

