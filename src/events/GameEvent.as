package events {
	
	import flash.events.Event;
	
	/**
	 * События экрана GameScreen (то есть игровые события)
	 * 
	 * @author illuzor
	 */
	
	public class GameEvent extends Event {
		/** выход из игры в главное меню через кнопку menu */
		public static const EXIT_GAME:String = "exitGame";
		/** игра проиграна */
		public static const GAME_OVER:String = "gameOver";
		
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new GameEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("GameEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
}