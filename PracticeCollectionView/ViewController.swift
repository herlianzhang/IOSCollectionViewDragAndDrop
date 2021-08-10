//
//  ViewController.swift
//  PracticeCollectionView
//
//  Created by Ripin Li on 09/08/21.
//  Copyright © 2021 Herlian Zhang. All rights reserved.
//

import UIKit

struct MenuSection {
    let title: String
    var items: [MenuItem]
}

struct MenuItem {
    let title: String
    let color: UIColor
}

class ViewController: UIViewController {
    
    var collectionView: UICollectionView?
    
    var data: [MenuSection] = [
        MenuSection(title: "DRAG AN ICON UPWARD TO ADD", items: [
            MenuItem(title: "Wi-fi", color: .link),
            MenuItem(title: "Mobile data", color: .systemGreen),
            MenuItem(title: "Bluetooth", color: .red),
            MenuItem(title: "Silent Mode", color: .systemOrange),
            MenuItem(title: "Personal hotspot", color: .systemPurple)
        ]),
        MenuSection(title: "DRAG TO HERE TO REMOVE", items: [
            MenuItem(title: "Saving Mode", color: .systemYellow),
            MenuItem(title: "Clean storage", color: .systemPink)
        ])
    ]
    
    var colors: [UIColor] = [
        .link,
        .systemGreen,
        .systemBlue,
        .red,
        .systemOrange,
        .black,
        .systemPurple,
        .systemYellow,
        .systemPink
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let itemSize = view.frame.size.width / 3.2
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(UINib(nibName: "SectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "section cell")
        collectionView?.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "item cell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        view.addSubview(collectionView!)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView?.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else {
            return
        }
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].items.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "section cell", for: indexPath) as! SectionCollectionViewCell
            let tmp = data[indexPath.section]
            cell.title.text = tmp.title
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item cell", for: indexPath) as! ItemCollectionViewCell
            let tmp = data[indexPath.section].items[indexPath.row - 1]
            cell.backgroundColor = tmp.color
            cell.title.text = tmp.title
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: view.frame.size.width, height: 44)
        } else {
            let itemSize = view.frame.size.width / 3.2
            return CGSize(width: itemSize, height: itemSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = data[sourceIndexPath.section].items.remove(at: sourceIndexPath.row - 1)
        data[destinationIndexPath.section].items.insert(item, at: destinationIndexPath.row - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.row == 0 {
            return IndexPath(row: 1, section: proposedIndexPath.section)
        } else {
            return proposedIndexPath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.numberOfItems(inSection: section) == 2 {

             let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: collectionView.frame.width - flowLayout.itemSize.width)

        }

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

