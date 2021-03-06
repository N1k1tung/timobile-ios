//
//  StoryCompleteViewController.swift
//  ThoroughbredInsider
//
//  Created by TCCODER on 11/2/17.
//  Copyright © 2017 Topcoder. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/**
 * story completed screen
 *
 * - author: TCCODER
 * - version: 1.0
 */
class StoryCompleteViewController: UIViewController {

    /// outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var cardsDescription: UILabel!
    
    /// story details
    var story: StoryDetails!
    
    /// viewmodels
    var rewardsVM = CollectionViewModel<Card, RewardCell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize.width = (SCREEN_SIZE.width - 100) / 3
        titleLabel.text = "Congratulations!\nYou got \(story.cards) trading cards!".localized
        rewardsVM.configureCell = { _, value, _, cell in
            cell.titleLabel.text = value.name
            cell.rewardImage.load(url: value.image)
        }
        let rewards = story.rewards.toArray()
        let font = cardsDescription.font!
        let bold = UIFont(name: "OpenSans-Bold", size: 14.0)!
        let attributedString = NSMutableAttributedString(string: "Wow! You have unlocked ", attributes: [.font: font])
        let texts = rewards.map { NSAttributedString(string: $0.name, attributes: [.font: bold]) }
        for t in texts.enumerated() {
            attributedString.append(t.element)
            if t.offset < texts.count-1 {
                attributedString.append(NSAttributedString(string:", ", attributes: [.font: font]))
            }
        }
        attributedString.append(NSAttributedString(string:".\nCheck your trading card gallery for details!", attributes: [.font: font]))
        cardsDescription.attributedText = attributedString
        
        rewardsVM.bindData(to: collection)
        rewardsVM.entries.value = rewards
        
        Observable.just([]).delaySubscription(1.25, scheduler: MainScheduler.instance)
            .showLoading(on: view)
            .subscribe(onNext: { value in
                
            }).disposed(by: rx.bag)
    }
    
    /// back button tap handler
    ///
    /// - Parameter sender: the button
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// main menu button tap handler
    ///
    /// - Parameter sender: the button
    @IBAction func backToMenuTapped(_ sender: Any) {
        _ = (presentingViewController as? ContainerViewController)?.slideController?.containerNavigationController.popViewController(animated: false)
        dismiss(animated: true, completion: nil)
    }
    
}
