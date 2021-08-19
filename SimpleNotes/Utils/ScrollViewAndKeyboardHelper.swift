//
//  ScrollViewHelper.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/19/21.
//

import UIKit

class ScrollViewAndKeyboardHelper {
    
    let scrollView: UIScrollView
    let view: UIView
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrameRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height + keyboardFrameRect.size.height)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameRect.height, right: 0)
    }
    
    @objc private func keyboardDidHide(notification: Notification) {
        scrollView.contentSize = view.bounds.size
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    init(scrollView: UIScrollView, view: UIView) {
        self.scrollView = scrollView
        self.view = view
    }
}
