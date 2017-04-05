//
//  SudokuCalculator.swift
//  SudokuSolver
//
//  Created by Tamilarasu on 05/04/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//

import UIKit

class SudokuCalculator: NSObject {
    var array = Sudoku.getSudokuArray()
    public override init() {
        super.init()
        let string = "020501090800203006030060070001000600540000019002000700090030080200804007010907060"
        for i in 0..<string.characters.count{
            let startIndex = string.index(string.startIndex, offsetBy: i)
            let endIndex = string.index(string.startIndex, offsetBy: i)
            let strValue = string[startIndex...endIndex]
            self.replace(value: Int("\(strValue)")!, index: i)
        }
    }
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
        guard changedSudoku.digit != 0 else {
            return
        }
        for sudoku in getAllSetsArray(index: index){
            sudoku.replaceNote(index: changedSudoku.digit-1, value: 0)
        }
    }
    func getAllSetsArray(index:Int) -> Array<Sudoku>{
        let sudoku = array[index]
        let rowArray = self.getRowArray(row: sudoku.row, except: sudoku)
        let columnArray = self.getColumnArray(column: sudoku.column, except: sudoku)
        let sectionArray = self.getSectionArray(section: sudoku.section, except: sudoku)
        let unionArray = Array(Set(rowArray).union(Set(columnArray)).union(Set(sectionArray)))
        print("Index:\(index) Array:\(unionArray)")
        return unionArray
    }
    func getRowArray(row:Int,except:Sudoku) -> Array<Sudoku> {
        return self.array.filter { (sudoku:Sudoku) -> Bool in
            return sudoku.row == row && sudoku != except
        }
    }
    func getColumnArray(column:Int,except:Sudoku) -> Array<Sudoku> {
        return self.array.filter { (sudoku:Sudoku) -> Bool in
            return sudoku.column == column && sudoku != except
        }
    }
    func getSectionArray(section:Int,except:Sudoku) -> Array<Sudoku> {
        return self.array.filter { (sudoku:Sudoku) -> Bool in
            return sudoku.section == section && sudoku != except
        }
    }
}
