//
//  File.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 11.04.2024.
//

import Foundation
import UIKit

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
    }
}
