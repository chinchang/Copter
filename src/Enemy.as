/**
 * Enemy.as
 * Author : Kushagra Gour a.k.a. Chin Chang 
 * version 1.0  <28-06-11 PM 07:36:48>
 * 
 * Description:  The enemy class. Used to create obstacles in the game.
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
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	public class Enemy extends Sprite 
	{
		
		public function Enemy() {
		}
		
		/**
		 * Draw the enemy
		 * @param	h	Height of the enemy
		 */
		public function drawMe(h:int):void {
			with (this.graphics) {
				beginFill(0);
				drawRect(0, 0, 20, h);
			}
			
			// apply a dropshadow filter
			var filter:DropShadowFilter = new DropShadowFilter(0, 0, 0x999999, 1, 16, 16);
			this.filters = [filter];
		}
		
		/**
		 * Function to move the enemy
		 * @param	speed	Speed to move with.
		 */
		public function moveMe(speed:int):void {
			this.x += speed;
		}
		
	}// end class
}// end package
