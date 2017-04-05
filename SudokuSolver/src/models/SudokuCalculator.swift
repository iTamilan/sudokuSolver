//
//  SudokuCalculator.swift
//  SudokuSolver
//
//  Created by Tamilarasu on 05/04/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//

import UIKit
let kDictKeyCount = "count"
let kDictKeyLastSudoku = "lastSudoku"
let kDarkGreenColor = UIColor.init(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0)

struct UniqueCalculator {
    var count = 0
    var lastSudoku:Sudoku!
}
class SudokuCalculator: NSObject {
    var array = Sudoku.getSudokuArray()
    public override init() {
        super.init()
        //Intializing Sets
        intializeTheSudokuSets()
        //Filling the Values
        let string = "020501090800203006030060070001000600540000019002000700090030080200804007010907060"
        for i in 0..<string.characters.count{
            let startIndex = string.index(string.startIndex, offsetBy: i)
            let endIndex = string.index(string.startIndex, offsetBy: i)
            let strValue = string[startIndex...endIndex]
            self.replace(value: Int("\(strValue)")!, index: i)
        }
        //Calculate the Solemate Digits
        calculateSoleCanditate()
        //Calculate unique canditate
        calculateUniqueCanditate(arraySudoku: array)
    }
    func intializeTheSudokuSets() {
        for sudoku in array{
            sudoku.arraySets = getAllSetArray(index: sudoku.index)
        }
    }
    //MARK: Replace new value and recaluculte notes
    public func replace(value:Int,index:Int,color:UIColor){
        replace(value: value, index: index)
        let sudoku = array[index]
        sudoku.digitColor = color
    }
    func replace(value:Int,index:Int){
        let sudoku = array[index]
        sudoku.digit = value
        refreshForChangeInIndex(index: index)
    }
    func refreshForChangeInIndex(index:Int){
        let changedSudoku = array[index]
        refreshForChange(changedSudoku: changedSudoku)
    }
    func refreshForChange(changedSudoku:Sudoku){
        guard changedSudoku.digit != 0 else {
            return
        }
//        var arrayUniqueCandiate = [Sudoku]()
        
        for sudoku in getUnionArray(index: changedSudoku.index){
            guard sudoku.note[changedSudoku.digit-1] != 0 else {
                continue
            }
            sudoku.replaceNote(index: changedSudoku.digit-1, value: 0)
//            arrayUniqueCandiate.append(sudoku)
        }
        //Calculte Unique Canditate
//        calculateUniqueCanditate(arraySudoku: arrayUniqueCandiate)
    }
    //Mark: Calculation Sole Canditate
    func calculateSoleCanditate(){
        var finded = false
        for sudoku in array{
            if sudoku.digit == 0 {
                let arraySoleCanditate = sudoku.note.filter({ (value) -> Bool in
                    return value != 0
                })
                if arraySoleCanditate.count == 1{
                    replace(value: arraySoleCanditate[0], index: sudoku.index, color: .blue)
                    finded = true
                }
            }
        }
        if finded{
            //Calculate unique canditate
            calculateUniqueCanditate(arraySudoku: array)
        }
    }
    //MARK: Calculation Unique canditate
    func calculateUniqueCanditate(arraySudoku:Array<Sudoku>) {
        for sudoku in arraySudoku {
            calculateUniqueCanditate(sudoku: sudoku)
        }
    }
    func calculateUniqueCanditate(sudoku:Sudoku) {
        calculateUniqueCanditateAnyOneArray(setArray: sudoku.arraySets.rowArray)
        calculateUniqueCanditateAnyOneArray(setArray: sudoku.arraySets.columnArray)
        calculateUniqueCanditateAnyOneArray(setArray: sudoku.arraySets.sectionArray)
        calculateSoleCanditate()
    }
    func calculateUniqueCanditateAnyOneArray(setArray:Array<Sudoku>) {
        var arrayUniqueCandiate = [UniqueCalculator]()
        for _ in 0...8 {
            arrayUniqueCandiate.append(UniqueCalculator.init(count: 0, lastSudoku: nil))
        }
        for rowSudoku in setArray{
            if rowSudoku.digit == 0 {
                for noteValue in rowSudoku.note{
                    if noteValue != 0 {
                        var uniqueCal = arrayUniqueCandiate[noteValue-1]
                        uniqueCal.count = uniqueCal.count+1
                        uniqueCal.lastSudoku = rowSudoku
                        arrayUniqueCandiate[noteValue-1] = uniqueCal
                    }
                }
            }
        }
        for i in 0..<arrayUniqueCandiate.count{
            let dictUnique = arrayUniqueCandiate[i]
            if dictUnique.count == 1 {
                replace(value: i+1, index:dictUnique.lastSudoku.index,color: UIColor.red)
            }
        }
    }
    //MARK: Getting Arrays
    func getUnionArray(index:Int) -> Array<Sudoku>{
        let unionTuples = array[index].arraySets
        let unionArray = Array(Set(unionTuples.rowArray).union(Set(unionTuples.columnArray)).union(Set(unionTuples.sectionArray)))
//        print("Index:\(index) Array:\(unionArray)")
        return unionArray
    }
    func getAllSetArray(index:Int) -> (rowArray:Array<Sudoku>,columnArray:Array<Sudoku>,sectionArray:Array<Sudoku>) {
        let sudoku = array[index]
        let rowArray = self.getRowArray(row: sudoku.row)
        let columnArray = self.getColumnArray(column: sudoku.column)
        let sectionArray = self.getSectionArray(section: sudoku.section)
        return (rowArray,columnArray,sectionArray)
    }
    func getRowArray(row:Int) -> Array<Sudoku> {
        return self.array.filter { (sudoku:Sudoku) -> Bool in
            return sudoku.row == row
        }
    }
    func getColumnArray(column:Int) -> Array<Sudoku> {
        return self.array.filter { (sudoku:Sudoku) -> Bool in
            return sudoku.column == column
        }
    }
    func getSectionArray(section:Int) -> Array<Sudoku> {
        return self.array.filter { (sudoku:Sudoku) -> Bool in
            return sudoku.section == section
        }
    }
}
