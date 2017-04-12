//
//  SudokuCalculator.swift
//  SudokuSolver
//
//  Created by Tamilarasu on 05/04/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//

import UIKit

let kDarkGreenColor = UIColor.init(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0)

struct UniqueCountData {
    var count = 0
    var lastSudoku:Sudoku!
}
struct IntersectedData {
    var intersectSudoku:Array<Sudoku>
    var intersectArray:Array<Int>
}
public protocol SudokuDelegate : class{
    func invalidSudoku()
    func sudokuCompleted()
    func refreshView(newArray:Array<Sudoku>)
}
class SudokuCalculator: NSObject, SudokuDelegate {

    weak open var delegate: SudokuDelegate?
    var array = Sudoku.getSudokuArray()
    private var changeOccured = false
    private var invalid = false
    private var completed = false
    private var lastsudoku:Sudoku!
    private var lastnoteValue = 10
    private var innerSudokuCalculator : SudokuCalculator!
    private var initialString:String!
    public override init() {
        super.init()
        //Filling the Values
        var string = "020501090800203006030060070001000600540000019002000700090030080200804007010907060"
        //        let string = "000800000400015030029040518040000120000602000032000090693050870050480001000003000"
        let emptyValueArray = [String](repeatElement("0", count: 80))
        string = emptyValueArray.joined()
        string = "1" + string
        initialize(string: string)
    }
    public init(string:String) {
        super.init()
        initialize(string: string)
    }
    public func initialize(string:String) {
        //Intializing Sets
        intializeTheSudokuSets()
        initialString = string
        for i in 0..<string.characters.count{
            let startIndex = string.index(string.startIndex, offsetBy: i)
            let endIndex = string.index(string.startIndex, offsetBy: i)
            let strValue = string[startIndex...endIndex]
            self.replace(value: Int("\(strValue)")!, index: i)
        }
//                startCalculation()
    }
    //MARK: Initializing the Default Sudoku Sets
    func intializeTheSudokuSets() {
        for sudoku in array{
            sudoku.arraySets = getAllSetArray(index: sudoku.index)
            sudoku.delegate = self
        }
    }
    //MARK: Sudoku Delegate
    func invalidSudoku() {
//        if invalid {
//            return
//        }
//        invalid = true
        if lastsudoku != nil{
            guard !checkCompletion() else{
                return;
            }
            //Needs to handle invalid sudoku
            calculateByRandomValue()
            
        }else{
            if !completed{
                delegate?.invalidSudoku()
            }
        }
    }
    func sudokuCompleted() {
        completed = true
        delegate?.sudokuCompleted()
    }
    func refreshView(newArray: Array<Sudoku>) {
        delegate?.refreshView(newArray: newArray)
    }
    //MARK: Start calculation
    //Created static varialbe for maintain the count for testing purpose
    static var count = 0
    public func startCalculation(){
//        return;
        //Calculate the Solemate Digits
        calculateSoleCanditate()
        //Calculate unique canditate
        calculateUniqueCanditate()
        //Calculate the naked subset
        calculateNakedSubset()
        if changeOccured == true {
            SudokuCalculator.count = SudokuCalculator.count + 1
            changeOccured = false
            startCalculation()
        }
        else{
            changeOccured = false
            handleRandomInserstion()
        }
    }
    static var nextCount = -1
    public func performNextCalculation(){
        guard innerSudokuCalculator == nil else {
            innerSudokuCalculator.performNextCalculation()
            return
        }
        SudokuCalculator.nextCount = SudokuCalculator.nextCount + 1
        switch SudokuCalculator.nextCount%4 {
        case 1:
            calculateUniqueCanditate()
        case 2:
            calculateNakedSubset()
        case 3:
            if changeOccured {
                changeOccured = false
                performNextCalculation()
            }else {
                handleRandomInserstion()
            }
        default:
            calculateSoleCanditate()
        }
//        delegate!.refreshView(newArray: array)
    }
    func checkCompletion()->Bool{
       var completed = array.filter({ (sudoku) -> Bool in
            return sudoku.digit == 0
        }).count == 0
        if completed{
            completed = true
            delegate?.sudokuCompleted()
            print("Number of times calculated \(SudokuCalculator.count)")
        }
        return completed
    }
    //MARK: Inserst random value
    func handleRandomInserstion(){
        guard !checkCompletion() else{
            return;
        }
        for sudoku in array where sudoku.digit == 0 {
                lastsudoku = sudoku
                break
        }
        calculateByRandomValue()
    }
    func calculateByRandomValue(){
        if lastsudoku != nil {
            var calulating = false
            for noteValue in lastsudoku.note.reversed() where invalid == false && noteValue != 0 && noteValue < lastnoteValue {
                var newString = initialString
                let startIndex = newString?.index((newString?.startIndex)!, offsetBy: lastsudoku.index)
                let endIndex = newString?.index((newString?.startIndex)!, offsetBy: lastsudoku.index)
                newString?.replaceSubrange(startIndex!...endIndex!
                    , with: "\(noteValue)")
                innerSudokuCalculator = SudokuCalculator.init(string: newString!)
                innerSudokuCalculator.delegate = self
                calulating = true
                delegate!.refreshView(newArray: innerSudokuCalculator.array)
                lastnoteValue = noteValue
                innerSudokuCalculator.startCalculation()
                break;
            }
            if !calulating && !completed{
                delegate?.invalidSudoku()
            }
        }

    }
    //MARK: Replace new value and recaluculte notes
    public func replace(value:Int,index:Int,color:UIColor){
        changeOccured = true
        replace(value: value, index: index)
        let sudoku = array[index]
        sudoku.digitColor =  UIColor.blue//color
    }
    func replace(value:Int,index:Int){
        let sudoku = array[index]
        sudoku.digit = value
        refreshForChangeInIndex(index: index)
    }
    //MARK: Refreshing the notes when new index inserted
    func refreshForChangeInIndex(index:Int){
        let changedSudoku = array[index]
        refreshForChange(changedSudoku: changedSudoku)

    }
    func refreshForChange(changedSudoku:Sudoku){
        guard changedSudoku.digit != 0 else {
            return
        }
//        var arrayUniqueCandiate = [Sudoku]()
        
        for sudoku in getUnionArray(index: changedSudoku.index) where invalid == false{
            guard sudoku.note[changedSudoku.digit-1] != 0 else {
                continue
            }
            invalid = sudoku.replaceNote(index: changedSudoku.digit-1, value: 0)
            if invalid {
                invalidSudoku()
            }
//            arrayUniqueCandiate.append(sudoku)
        }
        //Calculte Unique Canditate
//        calculateUniqueCanditate(arraySudoku: arrayUniqueCandiate)
    }
    //MARK: Calculation Sole Canditate
    func calculateSoleCanditate(){
        for sudoku in array where invalid == false && sudoku.digit == 0{
            let arraySoleCanditate = sudoku.note.filter({ (value) -> Bool in
                return value != 0
            })
            if arraySoleCanditate.count == 1{
                replace(value: arraySoleCanditate[0], index: sudoku.index, color: .blue)
            }
        }
        if changeOccured {
            changeOccured = false
            calculateSoleCanditate()
        }
    }
    //MARK: Calculation Unique canditate
    func calculateUniqueCanditate(){
        for sudoku in array where invalid == false{
            calculateUniqueCanditate(sudoku: sudoku)
        }
    }
    func calculateUniqueCanditate(sudoku:Sudoku) {
        calculateUniqueCanditate(setArray: sudoku.arraySets.rowArray)
        calculateUniqueCanditate(setArray: sudoku.arraySets.columnArray)
        calculateUniqueCanditate(setArray: sudoku.arraySets.sectionArray)
    }
    func calculateUniqueCanditate(setArray:Array<Sudoku>) {
        var arrayUniqueCandiate = [UniqueCountData](repeatElement(UniqueCountData.init(count: 0, lastSudoku: nil), count: 9))
        for rowSudoku in setArray where invalid == false{
            if rowSudoku.digit == 0 {
                for noteValue in rowSudoku.note where invalid == false{
                    if noteValue != 0 {
                        var uniqueCal = arrayUniqueCandiate[noteValue-1]
                        uniqueCal.count = uniqueCal.count+1
                        uniqueCal.lastSudoku = rowSudoku
                        arrayUniqueCandiate[noteValue-1] = uniqueCal
                    }
                }
            }
        }
        for i in 0..<arrayUniqueCandiate.count where invalid == false{
            let dictUnique = arrayUniqueCandiate[i]
            if dictUnique.count == 1 {
                replace(value: i+1, index:dictUnique.lastSudoku.index,color: UIColor.red)
            }
        }
    }
    //MARK: Calculate NakedSubset
    func calculateNakedSubset(){
        for i in 0...8 where invalid == false{
            calculateNakedSubset(setArray: getRowArray(row: i))
            calculateNakedSubset(setArray: getColumnArray(column: i))
            calculateNakedSubset(setArray: getSectionArray(section: i))
        }
    }
    func calculateNakedSubset(setArray:Array<Sudoku>){
        
        for firstSudoku in setArray where firstSudoku.digit == 0 && invalid == false{
            var matchedSudoko = [Sudoku]()
            //Adding first compare object
            matchedSudoko.append(firstSudoku)
            //Compare with second sudoko
            for secondSudoku in setArray where invalid == false && firstSudoku != secondSudoku && secondSudoku.digit == 0 {
                // Adding matched object
                if (secondSudoku.notesValue() == (firstSudoku.notesValue()) ) {
                    matchedSudoko.append(secondSudoku)
                }
            }
            if matchedSudoko.count == firstSudoku.notesValue().characters.count {
                for sudoku in Set(setArray).subtracting(matchedSudoko) where invalid == false && sudoku.digit == 0{
                    for noteValue in firstSudoku.note where invalid == false && noteValue != 0 && sudoku.note[noteValue-1] != 0{
                        invalid = sudoku.replaceNote(index: noteValue-1, value: 0)
                        changeOccured = true
                        if invalid {
                            invalidSudoku()
                        }
                    }
                }
            }
        }
    }
    //MARK: Compare two arrays
    func containSameElements<T: Comparable>(_ array1: [T], _ array2: [T]) -> Bool {
        guard array1.count == array2.count else {
            return false // No need to sorting if they already have different counts
        }
        
        return array1.sorted() == array2.sorted()
    }
    //MARK: Calculate Hidden Naked subset
    func calculateHiddenSubset(){
//        for i in 0...8 where invalid == false{
//            calculateHiddenSubset(setArray: getRowArray(row: i))
//            calculateHiddenSubset(setArray: getColumnArray(column: i))
//            calculateHiddenSubset(setArray: getSectionArray(section: i))
//        }
    }
    func calculateHiddenSubset(setArray:Array<Sudoku>){
        for firstSudoku in setArray where invalid == false && firstSudoku.digit == 0 {
            var arrayIntersectedDatas = [IntersectedData]()
            //            var matchedSudoko = [Sudoku]()
            //Adding first compare object
            //            matchedSudoko.append(firstSudoku)
            //Compare with second sudoko
            for secondSudoku in setArray where invalid == false && firstSudoku != secondSudoku && secondSudoku.digit == 0 {
                // Adding matched object
                let intersectSet = Set(firstSudoku.note).intersection(secondSudoku.note)
                var intersectArray = Array(intersectSet).sorted()
                intersectArray.removeFirst()
                if intersectArray.count > 0 {
                    var matchFound = false
                    var sudokuArray = [secondSudoku]
                    for var previousIntersectData in arrayIntersectedDatas where invalid == false{
                        let arrayInteractInteract = Array(Set(previousIntersectData.intersectArray).intersection(intersectArray)).sorted()
                        if(previousIntersectData.intersectArray == intersectArray){
                            previousIntersectData.intersectSudoku.append(contentsOf: sudokuArray)
                            matchFound = true;
                        }else if arrayInteractInteract.count > 0 {
                            if arrayInteractInteract == previousIntersectData.intersectArray {
                                let currentsudokuArray = sudokuArray
                                sudokuArray.append(contentsOf: previousIntersectData.intersectSudoku)
                                previousIntersectData.intersectSudoku.append(contentsOf: currentsudokuArray)
                            }else if arrayInteractInteract == intersectArray {
                                sudokuArray.append(contentsOf: previousIntersectData.intersectSudoku)
                            }
                        }
                    }
                    if !matchFound {
                        arrayIntersectedDatas.append(IntersectedData.init(intersectSudoku: sudokuArray, intersectArray: intersectArray))
                    }
                }
            }
            for var intersectData in arrayIntersectedDatas where invalid == false{
                if intersectData.intersectArray.count == intersectData.intersectSudoku.count+1 {
                    intersectData.intersectSudoku.append(firstSudoku)
                    for hiddenNakedSubsetSudoku in intersectData.intersectSudoku where invalid == false{
                        for noteValue in hiddenNakedSubsetSudoku.note where invalid == false && noteValue != 0 && !intersectData.intersectArray.contains(noteValue){
                            invalid = hiddenNakedSubsetSudoku.replaceNote(index: noteValue-1, value: 0)
                            changeOccured = true
                            if invalid {
                                invalidSudoku()
                            }
                        }
                    }
                }
            }
            //            if matchedSudoko.count == firstSudoku.notesValue().characters.count {
            //                for sudoku in Set(setArray).subtracting(matchedSudoko) where sudoku.digit == 0{
            //                    for noteValue in firstSudoku.note where noteValue != 0 && sudoku.note[noteValue-1] != 0{
            //                        sudoku.replaceNote(index: noteValue-1, value: 0)
            //                        changeOccured = true
            //                    }
            //                }
            //                break
            //            }
            
            
        }
    }
    //MARK: Getting Arrays
    func getUnionArray(index:Int) -> Array<Sudoku>{
        let unionTuples = array[index].arraySets
        let unionArray = Array(Set(unionTuples.rowArray).union(Set(unionTuples.columnArray)).union(Set(unionTuples.sectionArray)))
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
