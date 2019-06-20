//
//  ActorCollectionViewCell.swift
//  Project2
//
//  Created by cuonghx on 6/16/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Kingfisher

final class ActorCollectionViewCell: UICollectionViewCell, NibReusable {
    
    // MARK: - Outlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var characterLabel: UILabel!
    
    // MARK: - Methods
    func bindViewModel(actor: Actor) {
        avatarImageView.image = UIImage(named: "avatar")
        if !actor.profilePath.isEmpty {
            avatarImageView.kf.setImage(with: URL(string: API.Urls.profileUrl + actor.profilePath))
        }
        nameLabel.text = actor.name
        characterLabel.text = actor.character
    }
}
