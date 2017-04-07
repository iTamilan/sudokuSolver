//
//  ViewController.swift
//  SudokuSolver
//
//  Created by Tamilarasu on 04/04/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: Class Variables
    @IBOutlet weak var collectionView: UICollectionView!
    private var sudokuCalculator = SudokuCalculator()
    private var array = [Sudoku]()
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("before")
        array = sudokuCalculator.array
        NSLog("after")
        collectionView.reloadData()
        NSLog("afterReloading")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Collection View Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9*9;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = "SudokuCollectionViewCell"
        var cell: SudokuCollectionViewCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! SudokuCollectionViewCell
        cell.configure(sudoku: array[indexPath.row])
        cell.contentView.backgroundColor = array[indexPath.row].section % 2 == 0 ? UIColor.lightGray.withAlphaComponent(0.3) : UIColor.white
        return cell;
    }
    //MARK: Collection View FlowLayout Delegate
    //Item Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : Int = Int((collectionView.frame.size.width - 14)*1.0/9.0)
        let height = width
        
//        let column:Int = (indexPath.row+1)%9
//        let row:Int = (indexPath.row+1)/9 + 1
//        print("Row \(row) column \(column)")
//        if(column % 3 == 0 && column % 9 != 0){
//            width += 3
//        }
//        
//        if(row % 3 == 0 && row % 9 != 0 ){
//            height += 3
//        }
//        print("IndexPath Row : \(indexPath.row) width : \(width) height : \(height) Collection Frame : \(collectionView.frame)")
        return CGSize.init(width: width, height: height)
    }
    // Line Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    // Item Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    //MARK: Actions
    
    @IBAction func actionBtnNext(_ sender: Any) {
        sudokuCalculator.performNextCalculation()
        collectionView.reloadData()
    }
}

