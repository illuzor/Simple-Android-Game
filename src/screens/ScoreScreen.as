package screens {
	
	import elements.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import tools.Tools;
	
	/**
	 * Экран для отображения результата игры в виде количества набранных очков.
	 * Состоит из текста "YOUR SCORE: " и кнопок "MENU" и "AGAIN"
	 * 
	 * @author illuzor
	 */
	
	public class ScoreScreen extends Sprite {
		/** @private количество очков для отображения */
		private var score:uint;
		/** кнопка  "MENU" */
		public var menuButton:Button;
		/** кнопка  "AGAIN" */
		public var againButton:Button;
		/**
		 * В конструкторе ждём добавления на stage. Тут stage нужен для позиционирования элементов
		 * @param	score количество очков для отображения
		 */
		public function ScoreScreen(score:uint) {
			this.score = score;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		/**
		 * @private Создаём текстовое поле для отображения очков и кнопки для повтора игры и возврата в главное меню.
		 * 
		 * @param	e событие добавления на сцену
		 */
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			// текстовое поле отображает количество набранных очков
			var scoreText:TextField = Tools.generateTextField(40, "YOUR SCORE: " + score );
			scoreText.x = (stage.stageWidth - scoreText.width) / 2;
			scoreText.y = (stage.stageHeight - scoreText.height) / 2 - stage.stageHeight / 6;
			addChild(scoreText);
			
			// кнопка для выхода в главное меню
			menuButton = new Button("MENU");
			addChild(menuButton);
			menuButton.width = stage.stageWidth / 2;
			menuButton.scaleY = menuButton.scaleX;
			menuButton.x = (stage.stageWidth - menuButton.width) / 2;
			menuButton.y = scoreText.y + scoreText.height + 30;
			
			// кнопка "сыграть ещё"
			againButton = new Button("AGAIN");
			addChild(againButton);
			againButton.width = stage.stageWidth / 2;
			againButton.scaleY = againButton.scaleX;
			againButton.x = (stage.stageWidth - againButton.width) / 2;
			againButton.y = menuButton.y + menuButton.height + 30;
		}
		
	}
}