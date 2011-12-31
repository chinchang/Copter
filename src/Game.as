/**
 * Game.as
 * Author : Kushagra Gour a.k.a. Chin Chang 
 * version 1.0  <28-06-11 AM 10:05:38>
 * 
 * Description:  Document class for the Copter game. Manages all the game related functions.
 *  
 * Copyright 2011 Kushagra Gour (chinchang457@gmail.com)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
 package  
 {
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class Game extends MovieClip 
	{
		// game variables
		private var PAUSE:Boolean;
		private var gameW:Number = 550;
		private var gameH:Number = 400;
		private var playerSpeedX:Number;
		private var playerSpeedY:Number;
		private var obstacleSpeed:Number; // no of obs. on screen at one time
		
		// border variables		
		private var imaginaryRect:Rectangle; // Imaginary rectangle used to generate dynamic boundaries/borders
		
		// 2 Buffers for border and enemy (obstacle) sprites
		private var borderBuffer:Array;
		private var enemyBuffer:Array;
		
		// scoring
		private var time:int;
		private var bestTime:int;
		
		// sound
		var collideSnd:Sound = new CollideSound();
		
		
		public function Game() 
		{
			PAUSE = true;
			bestTime = 0;
			borderBuffer = new Array();
			enemyBuffer = new Array();
			var fps:FPS = new FPS(fps_txt);
			
			playInBg();
			
			var xmlLoader:XMLLoader = new XMLLoader("settings.xml");
			xmlLoader.addEventListener(XMLLoader.ON_LOADED, onXMLLoaded);			
			
		}
		
		// called when the xml file is loaded in the game
		private function onXMLLoaded(e:Event):void {
			var xml:XML = new XML(e.target.data);
			playerSpeedX = xml.param.(@title == "playerSpeedX");
			playerSpeedY = xml.param.(@title == "playerSpeedY");
			obstacleSpeed = xml.param.(@title == "obstacleSpeed");
			
			instruct_mc.msg_txt.text = "CLICK to start the game";
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMDown, false, 0, true);
			//stage.addEventListener(MouseEvent.CLICK, startGame, false, 0, true);
		}
		
		/**
		 * Called when game is clicked to start.
		 */
		public function startGame(e:MouseEvent):void {
			if (PAUSE) {
				PAUSE = false;
				instruct_mc.visible = false;
				resetGame();
				//stage.removeEventListener(MouseEvent.CLICK, startGame);
			}
		}
		
		/**
		 * Called when game ends. Updates the score, removes the listeners and creates explosion.
		 */
		private function endGame():void {
			PAUSE = true;			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
			stage.removeEventListener(Event.ENTER_FRAME, gameLoop);
			
			if (time > bestTime) bestTime = time;
			time_txt.text = "0";
			bestTime_txt.text = bestTime + "";
			
			// create an explosion
			var exp:Explosion = new Explosion();
			exp.x = copter_mc.x + copter_mc.width / 2;
			exp.y = copter_mc.y + copter_mc.height / 2;
			addChild(exp);
			
			collideSnd.play(10);			
		}
		
		/**
		 * Called just before starting the game. Resets all game variables for a new game.
		 */
		private function resetGame():void {				
			borderBuffer = [];
			enemyBuffer = [];
			
			/**
			 * Initialize the imaginary rectangle
			 * The rect width is set to 3 times of the player speed so as to keep
			 * the border generation in sync with the player speed using the factor 3
			 */
			imaginaryRect = new Rectangle(0, 20, playerSpeedX * 3, 300);
			
			time = 0; 
			
			// attach listeners
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, onMDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMUp, false, 0, true);
			stage.addEventListener(Event.ENTER_FRAME, gameLoop, false, 0, true);
		}
		
		public function onMDown(e:MouseEvent):void {
			if (PAUSE) {
				PAUSE = false;
				instruct_mc.visible = false;
				resetGame();
				//stage.removeEventListener(MouseEvent.CLICK, startGame);
			}
			playerSpeedY = -Math.abs(playerSpeedY);
		}
		
		private function onMUp(e:MouseEvent):void {
			playerSpeedY = Math.abs(playerSpeedY);
		}
		
		/**
		 * Main game loop
		 * creates game boudaries, enemies, smoke updates them all and check for collisions
		 */		
		private function gameLoop(e:Event):void {
			if (PAUSE) return;
			
			var hasCollided:Boolean = false; // has the collision occured
			
			// Increment the game time and show in score text field
			time++;
			time_txt.text = time + "";
			
			// Create a border after every 3 ticks
			if (time % 3 == 0) {
				createBorder();		
			}
			/**
			 * We need to draw a new enemy (obstacle) after a certain time difference.
			 * Time difference is calculated as follows :
			 * Enemy generates when the previous enemy is about to complete game width / obstacleSpeed
			 * Therefore, t=d/s   =>   ticks = (gameW/obstacleSpeed) / playerSpeedX
			 */
			if (time % Math.floor((gameW / obstacleSpeed) / playerSpeedX) == 0) {
				createEnemy();
			}
			
			// increase level after every 10 ticks
			if (time % 10 == 0) {
				imaginaryRect.height -= 1;
			}
			
			// Lets produce some pixel smoke after every 2 ticks
			if (time % 2 == 0) {
				var smoke:Smoke = new Smoke(-playerSpeedX);
				smoke.x = copter_mc.x;
				smoke.y = copter_mc.y + copter_mc.height / 2;
				addChild(smoke);
			}
			
			// update the border on the screen
			var removeSomeone:Boolean = false;
			for each(var objb:Border in borderBuffer) {
				objb.moveMe( -playerSpeedX);
				// if out of bound, remove it
				if (objb.x < -imaginaryRect.width - 15) {
					/**
					 * we set removeSomeone to true to remove the out-of-bound border
					 * from the buffer after the for loop as removing now creates inconsistency
					 */
					removeSomeone = true;
					borderContainer.removeChild(objb);					
				}
				
				// check collison with copter
				else if (objb.checkHit(copter_mc)) {
					hasCollided = true;
				}
			} 
			if (removeSomeone) {
				// remove the topmost element
				borderBuffer.splice(0, 1);
			}
			
			removeSomeone = false;

			// move the copter with bounds
			if (copter_mc.y > 5 && copter_mc.y + copter_mc.height < gameH - 5) {
				copter_mc.y += playerSpeedY;
			}
			
			
			
			// update the enemies/obstacles on the screen
			for each(var obje:Enemy in enemyBuffer) {
				obje.moveMe( -playerSpeedX);
				// if out of bound, remove it
				if (obje.x < -imaginaryRect.width - 15) {
					removeSomeone = true;
					this.removeChild(obje);
				}
				
				// check collison with copter if not already collided with a border
				else if (!hasCollided && obje.hitTestObject(copter_mc)) {
					hasCollided = true;
				}
			}
			if (removeSomeone) {
				// remove the topmost element
				enemyBuffer.splice(0, 1);
			}
			
			if (hasCollided) endGame();
		}
		
		/**
		 * Function to create a border element
		 */
		private function createBorder():void {
			// Calculate the new y-position of the imaginary rectangle
			var newY:int = gameH / 2 + Math.sin(time * 0.05) * 25 - imaginaryRect.height / 2;
			
			
			// Set the imaginary rectangle to new positions
			//imaginaryRect.x = newX;
			imaginaryRect.y = newY;
					
			// Create a new border
			var border:Border = new Border();
			border.drawMe(gameH, imaginaryRect);
			
			// position the border at extreme right...thats where it generates 
			border.x = gameW;
			
			// store a reference in the border buffer so we can control it here
			borderBuffer.push(border);
			borderContainer.addChild(border);

		}
		
		/**
		 * function to create a new enemy/obstacle
		 */
		private function createEnemy():void {			
			var enemy:Enemy = new Enemy();
			enemy.drawMe(70);
			
			// position the border at extreme right...thats where it generates 
			enemy.x = gameW;
			enemy.y = Math.floor(Math.random() * (imaginaryRect.height - 90)) + imaginaryRect.y;
			
			// store a reference in the enemy buffer so we can control it here
			enemyBuffer.push(enemy);
			this.addChild(enemy);
		}
		
		/**
		 * Removes all enemies and boundaries from the screen
		 */
		public function removeAll():void {
			// remove all objects on screen
			for each(var objb:Border in borderBuffer) {
				if(objb != null) borderContainer.removeChild(objb);
			}			
			for each(var obje:Enemy in enemyBuffer) {
				if(obje != null) this.removeChild(obje);
			}
		}
		
		private function playInBg():void {
			// play collide sound silently in bg...kinda caching to remove lag
			var sndTf:SoundTransform = new SoundTransform(0);
			collideSnd.play(0, 99999, sndTf);
		}
	
	}// end class
}// end package
