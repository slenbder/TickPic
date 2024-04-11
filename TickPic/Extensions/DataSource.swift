//
//  UITableViewDataSource.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 10.04.2024.
//

import Foundation
import UIKit

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1
            
            guard let imageListCell = cell as? ImagesListCell else { // 2
                return UITableViewCell()
            }
            
            configCell(for: imageListCell) // 3
            return imageListCell // 4
        }
    
}
