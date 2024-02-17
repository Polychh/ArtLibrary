//
//  AddNewArtistViewModel.swift
//  ArtLibrary
//
//  Created by Polina on 16.02.2024.
//

import Foundation
import Combine
import UIKit

final class AddNewArtistViewModel{
    @Published var text1: String = ""
    @Published  var text2: String = ""
    @Published  var text3: String = ""
    @Published  var text4: String = ""
    @Published  var text5: String = ""
    @Published  var text6: String = ""
    @Published var canDismissed = false
    var textArrayPrivate: [String] = ["", "", "", "", "", ""]
    private var cancellables = Set<AnyCancellable>()
   
    init( ) {
        observe()
    }
    
    private func observe(){
        observeText(text: $text1, position: 0, numberElements: 1)
        observeText(text: $text2, position: 1, numberElements: 2)
        observeText(text: $text3, position: 2, numberElements: 3)
        observeText(text: $text4, position: 3, numberElements: 4)
        observeText(text: $text5, position: 4, numberElements: 5)
        observeText(text: $text6, position: 5, numberElements: 6)
    }
    
    private func observeText(text: Published<String>.Publisher, position: Int, numberElements: Int){
        let previousText = text
            .dropFirst()
            .scan("") { (previousValue, newValue) in
                return newValue
            }
        text
            .receive(on: DispatchQueue.main)
            .zip(previousText)
            .sink { previosText, newText in
                self.appendTextArtist(textOld: previosText, textNew: newText, array: &self.textArrayPrivate, position: position, numberElements: numberElements)
            }
            .store(in: &cancellables)
    }
    
    private func appendTextArtist(textOld: String, textNew: String, array: inout [String], position: Int, numberElements: Int){
        if array.count >= numberElements && textOld != textNew {
            array.remove(at: position)
        }
        if textOld != textNew{
            array.insert(textNew, at: position)
        }
    }
    
    func moveKeyboard(notification: NSNotification, keyboardWillShow: Bool, constraintTop: NSLayoutConstraint?, constraintBottom: NSLayoutConstraint?, view: UIView, vc: UIViewController ) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        guard  let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let paramCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {return}
        guard let keyboardCurve = UIView.AnimationCurve(rawValue: paramCurve) else {return}
        
        if keyboardWillShow {
            constraintBottom?.constant = -keyboardHeight - 10
            constraintTop?.constant = UIScreen.main.bounds.height - view.bounds.height - (keyboardHeight + 10)
        }else {
            constraintBottom?.constant = -((UIScreen.main.bounds.height - 400) / 2)
            constraintTop?.constant = ((UIScreen.main.bounds.height - 400) / 2) // 400 is hieght for all content in contentView
        }
        // Animate the view the same way the keyboard animates
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak vc] in
            vc?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}
