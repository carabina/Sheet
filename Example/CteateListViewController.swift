//
//  CteateListViewController.swift
//  Sheeeeeeeeet
//
//  Created by NAVER on 2018. 10. 1..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit
import Sheet

class CteateListViewController: SheetContentsViewController {
    
    @IBOutlet weak var customToolBar: UIView!

    override var visibleContentsHeight: CGFloat {
        return 370
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registNotifications()
        sheetToolBar = customToolBar
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let cell = self.collectionView?.cellForItem(at: IndexPath(row: 0, section: 0)) as? CreateCell
            cell?.titleTextField.becomeFirstResponder()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func setupSheetLayout() {
        layout.settings.itemSize = { _ in
            return CGSize(width: UIScreen.main.bounds.width, height: 260)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedDoneButton(_ sender: Any) {
        close()
    }
}

extension CteateListViewController {
    
    func registNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc
    func willShowKeyboard(notification: Notification) {
        notification.keyboardAnimation({ [weak self] size in
            self?.collectionView?.frame.origin.y -= size.height
            self?.sheetNavigationController?.toolBarBottomConstraint?.constant -= size.height
            self?.sheetNavigationController?.toolBarHeightConstraint?.constant = SheetManager.shared.options.sheetToolBarHeight
            self?.sheetNavigationController?.view.layoutIfNeeded()
        }) { [weak self] _, size in
            let topMargin = self?.topMargin ?? 0
            self?.topMargin = max(topMargin - size.height, 0)
        }
    }
    
    @objc
    func willHideKeyboard(notification: Notification) {
        notification.keyboardAnimation({ [weak self] size in
            self?.collectionView?.frame.origin.y += size.height
            self?.sheetNavigationController?.toolBarBottomConstraint?.constant += size.height
            self?.sheetNavigationController?.toolBarHeightConstraint?.constant = self?.collectionView?.contentInset.bottom ?? 0
            self?.sheetNavigationController?.view.layoutIfNeeded()
        }) { _, _ in
        }
    }
}

class CreateCell: UICollectionViewCell {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
}