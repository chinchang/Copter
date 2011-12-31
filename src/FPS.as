/**
 * FPS.as
 * Author : Kushagra Gour a.k.a. Chin Chang 
 * version 1.0  <28-06-11 PM 11:13:31>
 * 
 * Description:  A class to calculate FPS and show it in a textfield.
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
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	
	public class FPS extends Sprite 
	{
		private var prevTime:int;
		private var fps:Number;
		private var txt:TextField;
		
		/**
		 * Ctor
		 * @param	t	A textfield to write the fps to.
		 */
		public function FPS(t:TextField) {
			txt = t;
			addEventListener(Event.ENTER_FRAME, getFPS, false, 0, true);
		}
		
		/**
		 * Enter frame listener
		 */
		public function getFPS(e:Event):void {
			var currTime:int = getTimer();
			
			fps = 1000 / (currTime-prevTime);
			prevTime = currTime;
			txt.text = fps + "";
		}
		
	}// end class
}// end package
