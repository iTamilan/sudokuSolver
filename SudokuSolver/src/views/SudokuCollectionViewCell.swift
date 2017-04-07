//
//  SudokuCollectionViewCell.swift
//  SudokuSolver
//
//  Created by Tamilarasu on 04/04/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//

import UIKit

class SudokuCollectionViewCell: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var labelSudoku: UILabel!
    @IBOutlet private weak var collectionView : UICollectionView!
    weak var sudoku : Sudoku!
    
    public func configure(sudoku: Sudoku){
        self.sudoku = sudoku
        labelSudoku.text = sudoku.stringValue()
        labelSudoku.textColor = sudoku.digitColor
        if (collectionView != nil) {
            collectionView.isHidden =  !(labelSudoku.text?.isEmpty)!
            collectionView.reloadData()
            guard collectionView.isHidden else {
                return
            }
            collectionView.reloadData()
        }
    }
    //MARK: Collection View Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = "SudokuCollectionViewCell"
        var cell: SudokuCollectionViewCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! SudokuCollectionViewCell
        cell.labelSudoku.text = self.sudoku.noteValue(index:indexPath.row)
        return cell;
    }
    //MARK: Collection View FlowLayout Delegate
    //Item Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : Int = Int((collectionView.frame.size.width-4)/3.0)
//        let height = width
//        let column:Int = (indexPath.row+1)%9
//        let row:Int = (indexPath.row+1)/9 + 1
        return CGSize.init(width: width, height: width)
    }
    // Line Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    // Item Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
