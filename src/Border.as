/**
 * Border.as
 * Author : Kushagra Gour a.k.a. Chin Chang 
 * version 1.0  <28-06-11 PM 07:36:48>
 * 
 * Description: This is the class for each border element i.e. top and bottom borders  
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
	import flash.geom.Rectangle;
	
	public class Border extends Sprite 
	{		
		public function Border() {
		}
		
		/**
		 * Function to draw the border
		 * @param	gameH	The height of the game stage
		 * @param	rect	The imaginary rectangle used to draw borders
		 */
		public function drawMe(gameH:int, rect:Rectangle):void {
			// Draw 2 rectangles above and below the imaginary rectangle (rect) each in different sprite
			var topSprite:Sprite = new Sprite();
			var bottomSprite:Sprite = new Sprite();
			topSprite.name = "top";
			bottomSprite.name = "bottom";
			
			// draw the top one above the imaginary rectangle - rect
			with (topSprite.graphics) {
				beginFill(0x000000);
				drawRect(0, 0, rect.width, rect.y);
				endFill();
			}
			
			// now the second one below rect
			with (bottomSprite.graphics) {
				beginFill(0x000000);
				drawRect(0, rect.y + rect.height, rect.width, gameH - rect.y - rect.height);
				endFill();
			}
			addChild(topSprite);
			addChild(bottomSprite);
			
			// Apply a drop shadow filter
			var filter:DropShadowFilter = new DropShadowFilter(0, 0, 0xaaaaaa, 1, 0, 70);
			this.filters = [filter];
		}
		
		/**
		 * Call this to move the border with a speed
		 * @param	speed	Speed to move the border with
		 */
		public function moveMe(speed:int):void {
			this.x += speed;
		}
		
		/**
		 * Check collision of the border with any sprite
		 * @param	who	Sprite to check the collision for
		 * @return	True if both are colliding
		 */
		public function checkHit(who:Sprite):Boolean {
			// We check the sprite for collision with top and bottom border separately
			var top:Sprite = getChildByName("top") as Sprite;
			var bottom:Sprite = getChildByName("bottom") as Sprite;
			if (top.hitTestObject(who) || bottom.hitTestObject(who)) return true;
			return false;
		}
		
	}// end class
}// end package
