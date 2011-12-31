/**
 * XMLLoader.as
 * Author : Kushagra Gour a.k.a. Chin Chang 
 * version 1.0  <29-06-11 PM 08:35:51>
 * 
 * Description:  A XML Loader class to load the game settings in the xml file.
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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class XMLLoader extends EventDispatcher 
	{
		public static var ON_LOADED:String = "onloaded";
		public var data:XML;	// The complete XML tree.
		
		/**
		 * Ctor
		 * @param	file	XML filename to load.
		 */
		public function XMLLoader(file:String) {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoaded);
			loader.load(new URLRequest(file));
		}
		
		/**
		 * On Complete listener. Dispacthes an ON_LOADED event.
		 */
		private function onLoaded(e:Event):void {
			data = new XML(e.target.data); 
			var newEvent:Event = new Event(ON_LOADED);
			dispatchEvent(newEvent);
		}
		
	}// end class
}// end package
