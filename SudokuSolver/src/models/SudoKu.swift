//
//  SudoKu.swift
//  SudokuSolver
//
//  Created by Tamilarasu on 04/04/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//

import UIKit

public class Sudoku : Hashable {
    private(set) var index: Int
    private(set) var row: Int
    private(set) var column: Int
    private(set) var section: Int
    private(set) var note : Array<Int>
    weak var delegate: SudokuDelegate?
    var arraySets:(rowArray:Array<Sudoku>,columnArray:Array<Sudoku>,sectionArray:Array<Sudoku>)
    var digit : Int
    var digitColor = UIColor.black
    
    public var hashValue: Int {
        return index.hashValue
    }
    
    public static func == (lhs: Sudoku, rhs: Sudoku) -> Bool {
        return lhs.index == rhs.index
    }
    
    init?(row: Int, column: Int, section: Int, index: Int){
        self.row = row
        self.column = column
        self.section = section
        self.index = index
        self.note = [Int]()
        self.digit = 0
        self.arraySets = ([Sudoku](),[Sudoku](),[Sudoku]())
    }
    public var description: String {
        return "\(Unmanaged.passUnretained(self).toOpaque()) Index:\(self.index)  \(self.digit == 0 ? "NoteValues:\(notesValue())":"Value:\(self.digit)")"
    }
    public func stringValue()->String{
            return digit>0 && digit<=9 ? "\(digit)":""
    }
    public func noteValue(index:Int)->String{
        return self.note[index] == 0 ? "":"\(index+1)"
    }
    public func notesValue()->String{
        var returnStr = ""
        for noteValue in self.note {
            if noteValue != 0 {
                returnStr.append("\(noteValue)")
            }
        }
        return returnStr;
    }
    public func initializeNote(){
        for position in 1...9 {
            note.append(position)
        }
    }
    public func replaceNote(index:Int,value:Int)->Bool{
        note[index] = value
//        print(description)
       let validSudoku = (note.filter({ (noteValue) -> Bool in
            noteValue != 0
        }).count>0 ) || (self.digit != 0)
        return !validSudoku
    }
    //MARK: Initialize the Array
    static public func getSudokuArray()->Array<Sudoku>{
        var array = [Sudoku]()
        for i in 0..<81{
            let row = i/9
            let column = i%9
            let section = (row/3)*3 + (column/3)
//            print("Row: \(row) Coumn: \(column) Section: \(section)")
            let sudoku = Sudoku.init(row: row, column: column, section: section,index: i)!
            sudoku.initializeNote()
            array.append(sudoku)
        }
        return array
    }
}

