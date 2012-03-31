package screens {
	
	import elements.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import tools.StorageManager;
	import tools.Tools;
	
	/**
	 * Отображение пяти последних результатов.
	 * Экран содержит заголовок, список результатов и кнопку выхода
	 * 
	 * @author illuzor
	 */
	
	public class LastScoresScreen extends Sprite {
		/** кнопка для возврата в меню */
		public var backButton:Button;
		/**
		 * Ждём добавления на сцену
		 */
		public function LastScoresScreen() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		/**
		 * Отображаем графические элементы
		 * 
		 * @param	e событие добавления на сцену
		 */
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			// текстовое поле заголовка
			var headerText:TextField = Tools.generateTextField(40, "YOUR LAST SCORES:");
			headerText.x = (stage.stageWidth - headerText.width) / 2;
			headerText.y = stage.stageHeight / 4;
			addChild(headerText)
			// контейнер для текстовых полей результатов
			var scoresContainer:Sprite = new Sprite();
			addChild(scoresContainer);
			// массив с актуальными результатами.
			// берётся из StorageManager
			var scoresList:Vector.<uint> = StorageManager.lastScores;
			
			// на основании длины массива добавляем в контейнер текстовые поля с результатами
			for (var i:int = 0; i < scoresList.length ; i++) {
				var scoreText:TextField =  Tools.generateTextField(30, "SCORE #" + String(i + 1) + " — " + scoresList[i]);
				if (i != 0) scoreText.y = scoresContainer.height + 20;
				scoresContainer.addChild(scoreText);
			}
			// позиционируем контейнер с результатами
			scoresContainer.x = (stage.stageWidth - scoresContainer.width) / 2;
			scoresContainer.y = headerText.y + headerText.height + 40;
			
			backButton = new Button("BACK"); // кнопка для возвращения в главное меню
			addChild(backButton);
			backButton.width = stage.stageWidth / 2;
			backButton.scaleY = backButton.scaleX;
			backButton.x = (stage.stageWidth - backButton.width) / 2;
			backButton.y = stage.stageHeight - backButton.height - 20;
		}
		
	}
}