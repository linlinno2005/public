//
//  ControlCenter.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//
import UIKit

class ControlCenter {

    var mazeController: MazeController!

    func moveComplexRobot(_ myRobot: ComplexRobotObject) {
      
        // You may want to paste your Part 2 implementation of moveComplexRobot() here
        let robotIsBlocked = isFacingWall(myRobot , direction:myRobot.direction)

        
        // Save the return value of checkWalls() to a constant called myWallInfo.
        let myWallInfo = checkWalls(myRobot)
        

        // Categorize the robot's current location based on the number of walls
        let isThreeWayJunction = (myWallInfo.numberOfWalls == 1)
        let isTwoWayPath:Bool = (myWallInfo.numberOfWalls == 2)
        let isDeadEnd:Bool = (myWallInfo.numberOfWalls == 3)
        

        // Three-way Path - else-if statements
        if isThreeWayJunction && robotIsBlocked {
            randomlyRotateRightOrLeft(myRobot)
        }
        else if(isThreeWayJunction && !robotIsBlocked){
            continueStraightOrRotate(myRobot, wallInfo: myWallInfo)
        }
            
        // Two-way Path - else-if statements
            
        // Step 3.2
        // Two-way Path - else-if statements
            
        // TODO: If the robot encounters a two way path and there is NO wall ahead it should continue forward.
            
        // TODO: If the robot encounters a two way path and there IS a wall ahead, it should turn in the direction of the clear path.
            
        else if(isTwoWayPath && !robotIsBlocked){
            myRobot.move()
        }
        else if(isTwoWayPath && robotIsBlocked){
            //randomlyRotateRightOrLeft(myRobot)
            turnTowardClearPath(myRobot,wallInfo: myWallInfo)
        }
            
        // Dead end - else-if statements
        else if(isDeadEnd && !robotIsBlocked){
            myRobot.move()
        }
        else if(isDeadEnd && robotIsBlocked){
            myRobot.rotateRight()
        }
        else{
            print("@@@@@should not be here")
        }
        
    }
    
    func previousMoveIsFinished(_ robot: ComplexRobotObject) {
            self.moveComplexRobot(robot)
    }
    
}
