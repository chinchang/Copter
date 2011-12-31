/**
 * Smoke.as
 * Author : Kushagra Gour a.k.a. Chin Chang 
 * version 1.0  <29-06-11 AM 02:40:36>
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
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;	
	
	public class Smoke extends MovieClip
	{
		private var speed:Number;
		
		/**
		 * Ctor
		 * @param	s	Speed for a smoke particle
		 */
		public function Smoke(s:Number) 
		{
			speed = s;
			drawMe();		
			
			this.addEventListener(Event.ENTER_FRAME, moveMe, false, 0, true);
		}
		
		/**
		 * Draw the smoke particle.
		 */
		public function drawMe():void {
			with (this.graphics) {
				beginFill(0);
				drawRect(0, 0, 4, 4);
			}			
		}
		
		/**
		 * Move the smoke particle on every frame.
		 */
		public function moveMe(e:Event):void {
			this.x += speed;
			this.alpha -= 0.1;
			// It fades out completely, remove it
			if (alpha <= 0) {
				removeMe();
			}
		}
		
		/**
		 * Remove me please.
		 */
		private function removeMe():void {
			this.removeEventListener(Event.ENTER_FRAME, moveMe);
			Sprite(this.parent).removeChild(this);
		}	
		
	}// end class
}// end package
