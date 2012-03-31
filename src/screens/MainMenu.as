package screens
{
	
	import elements.Button;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import tools.Bitmaps;
	
	/**
	 * Класс главного меню игры.
	 * Тут отображется фон, логотип и две кнопки.
	 *
	 * @author illuzor
	 */
	public class MainMenu extends Sprite {
		/** @private Фоновое изображение */
		private var background:Bitmap;
		/** Кнопка "PLAY" */
		public var playButton:Button;
		/** Кнопка "EXIT" */
		public var exitButton:Button;
		/** Кнопка "SETTINGS" */
		public var settingButton:Button;
		/** Кнопка "SCORES" */
		public var scoresButton:Button;
		/**
		 * В конструкторе просто слушаем добавление на сцену
		 */
		public function MainMenu() {
			addEventListener(Event.ADDED_TO_STAGE, adddedToStage);
		}
		/**
		 * Создаём и добавляем фон, логотип, кнопки
		 * 
		 * @param	e Событие добавления на сцену
		 */
		private function adddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, adddedToStage);
			
			// Создаём битмап фона и добавляем его на сцену
			background = Bitmaps.backgroundBitmap;
			background.smoothing = true;
			addChild(background);
			placeBackground(background); // Позиционируем фон
			
			// Создаём битмап логотипа, задаём размер относительно ширины сцены
			// Задаём его положение и добавляем на сцену
			var logo:Bitmap = Bitmaps.logoBitmap;
			logo.smoothing = true;
			logo.width = stage.stageWidth * .7;
			logo.scaleY = logo.scaleX;
			logo.x = (stage.stageWidth - logo.width) / 2;
			logo.y = stage.stageHeight / 5;
			addChild(logo);
			
			// Контейнер для кнопок. Нужен для удобного позиционирования этих кнопок
			var buttonsContainer:Sprite = new Sprite();
			addChild(buttonsContainer);
			
			// Создание кнопок "PLAY", "SETTINGS", "EXIT", подгонка их размеров и добавление в контейнер
			playButton = new Button("PLAY");
			buttonsContainer.addChild(playButton);
			playButton.width = stage.stageWidth / 2;
			playButton.scaleY = playButton.scaleX;
			
			settingButton = new Button("SETTINGS");
			buttonsContainer.addChild(settingButton);
			settingButton.width = stage.stageWidth / 2;
			settingButton.scaleY = settingButton.scaleX;
			settingButton.y = buttonsContainer.height + 25;
			
			scoresButton = new Button("SCORES");
			buttonsContainer.addChild(scoresButton);
			scoresButton.width = stage.stageWidth / 2;
			scoresButton.scaleY = scoresButton.scaleX;
			scoresButton.y = buttonsContainer.height + 25;
			
			exitButton = new Button("EXIT");
			buttonsContainer.addChild(exitButton);
			exitButton.width = stage.stageWidth / 2;
			exitButton.scaleY = exitButton.scaleX;
			exitButton.y = buttonsContainer.height + 25;
			
			// Позиционирование контейнера с кнопками
			buttonsContainer.x = (stage.stageWidth - buttonsContainer.width) / 2;
			// По .y ровно между логотипом и нижней границей экрана
			buttonsContainer.y = ((stage.stageHeight - logo.height - logo.y) - buttonsContainer.height) / 2 + logo.height + logo.y;
			
			stage.addEventListener(Event.RESIZE, resize);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		/**
		 * @private В Android 4 происходит неприятная фигня. После запуска приложения верхняя статусная панель не резко исчезает, а плавно уезжает вверх,
		 * это влияет на размер сцены и сразу после запуска приложения размер сцены чуть меньше, чем размер дисплея.
		 * Нужно слушать ресайз, чтобы подогнать фон. А по-хорошему и все остальные графические элементы тоже.
		 * 
		 * @param	e  событие ресайза сцены
		 */ 
		private function resize(e:Event):void {
			placeBackground(background); // позиционируем фон
		}
		/**
		 * Эта функция делает так, что переданный ей DisplayObject заполняет собой всю сцену
		 * без изменения пропорций. В нашем случае это фоновое изображение
		 * 
		 * @param	scaledObject DisplayObject для подгонки
		 */
		private function placeBackground(scaledObject:DisplayObject):void {
			scaledObject.scaleX = scaledObject.scaleY = 1;
			var scale:Number;
			if (scaledObject.width / scaledObject.height > stage.stageWidth / stage.stageHeight){
				scale = stage.stageHeight / scaledObject.height;
			}
			else {
				scale = stage.stageWidth / scaledObject.width;
			}
			scaledObject.scaleX = scaledObject.scaleY = scale;
			scaledObject.x = (stage.stageWidth - scaledObject.width) / 2;
			scaledObject.y = (stage.stageHeight - scaledObject.height) / 2;
		}
		/**
		 * @private При удалении со сцены убиваем ненужные слушатели
		 * 
		 * @param	e Событие удаления со сцены
		 */
		private function removedFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			stage.removeEventListener(Event.RESIZE, resize);
		}
	
	}
}