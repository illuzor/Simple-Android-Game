package elements {
	
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import tools.Bitmaps;
	import tools.Tools;
	
	/**
	 * Класс кнопки, которая используется в меню и в других местах.
	 * Класс динамический, это пригодится.
	 * 
	 * @author illuzor
	 */
	
	public dynamic class Button extends Sprite {
		/** @private текст для отображения на кнопке */
		private var text:String;
		/** @private битмап для фона кнопки */
		private var buttonImage:Bitmap;
		/** @private активирована ли кнопка */
		private var activated:Boolean;
		/**
		 * Конструктор слушает добавление на сцену.
		 * Тут stage нам нужен на случай, если произойдёт тап по кнопке и перемещение пальца в сторону от кнопки
		 * 
		 * @param	text Текст для отображения на кнопке
		 */
		public function Button(text:String) {
			this.text = text;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		/**
		 * @private Добавляем графику и текстовое поле кнопки.
		 * 
		 * @param	e Событие добавления на сцену
		 */
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			buttonImage = Bitmaps.buttonBitmap; // Добавляем битмап
			buttonImage.smoothing = true;
			addChild(buttonImage);
			
			var textField:TextField = Tools.generateTextField(50, text); // Генерируем текстовое поле...
			textField.mouseEnabled = false;
			textField.x = (buttonImage.width - textField.width) / 2; // ... позиционируем его и добавляем на экран
			textField.y = (buttonImage.height - textField.height) / 2;
			addChild(textField);
			
			this.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin); // Прикосновение к кнопке
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage); // Слушатель удаления со сцены
		}
		/**
		 * @private Анимируем по альфе на половину
		 * 
		 * @param	e Событие прикосновения пальцем к кнопке
		 */
		private function touchBegin(e:TouchEvent):void {
			if (!activated) { // если кнопка не активирована
				TweenLite.to(buttonImage, .3, { alpha:.5 } );
				stage.addEventListener(TouchEvent.TOUCH_END, touchEnd); // убирание пальца от дисплея после прикосновения к кнопке
			}
		}
		/**
		 * @private Возвращаем альфу к единице
		 * 
		 * @param	e Событие убирания пальца от дисплея
		 */
		private function touchEnd(e:TouchEvent):void {
			if (!activated) { // если кнопка не активирована
				TweenLite.to(buttonImage, .3, { alpha:1 } );
				stage.removeEventListener(TouchEvent.TOUCH_END, touchEnd);
			}
		}
		/**
		 * Активация кнопки. Снижаем прозрачность
		 */
		public function activate():void {
			TweenLite.killTweensOf(buttonImage);
			buttonImage.alpha = .3;
			activated = true;
		}
		/**
		 * Дективация кнопки. Возвращаем прозрачность к единице
		 */
		public function deactivate():void {
			buttonImage.alpha = 1;
			activated = false;
		}
		/**
		 * @private При удалении со stage убиваем более не нужные слушатели
		 * 
		 * @param	e Событие удаления со сцены
		 */
		private function removedFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			this.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			stage.removeEventListener(TouchEvent.TOUCH_END, touchEnd);
			buttonImage = null;
		}
		
	}
}