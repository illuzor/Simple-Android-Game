package screens {
	
	import com.adobe.nativeExtensions.Vibration;
	import constants.ControlType;
	import constants.VibroType;
	import elements.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import tools.Tools;
	
	/**
	 * Экран настроек. Позволяет выбрать тип управления
	 * 
	 * @author illuzor
	 */
	
	public class SettingsScreen extends Sprite {
		/** @private кнопка-триггер для управления пальцем */
		private var touchButton:Button;
		/** @private кнопка-триггер для управления наклоном устройства */
		private var sensorButton:Button;
		private var vibroOffButton:Button;
		private var vibroShortButton:Button;
		private var vibroLongButton:Button;
		/** кнопка save для выхода из экрана настроек и возвращения в главное меню */
		public var saveButton:Button;
		/**
		 * Слушаем добавление на сцену
		 */
		public function SettingsScreen() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		/**
		 * @private Создаём графические элементы и кнопку выхода в меню
		 * 
		 * @param	e событие добавления на сцену
		 */
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			// добавляем заголовок
			var header:TextField = Tools.generateTextField(50, "SETTINGS");
			header.x = (stage.stageWidth - header.width) / 2;
			header.y = 40;
			addChild(header);
			
			// создаём кнопку для выхода в главное меню
			saveButton = new Button("SAVE");
			addChild(saveButton);
			saveButton.width = stage.stageWidth / 2;
			saveButton.scaleY = saveButton.scaleX;
			saveButton.x = (stage.stageWidth - saveButton.width) / 2;
			saveButton.y = stage.stageHeight - saveButton.height - 20;
			
			controlSettings(); // добавляем элементы для настройки типа управления
			
			if (Vibration.isSupported) { // если вибрация поддерживается ...
				vibrationSettings(); // ... создаём элементы управления вибрацией
			} else { // если не поддерживается, выключаем вибрацию
				Settings.vibroType = VibroType.VIBRO_OFF;
			}
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		/**
		 * @private создание элементов для настройки типа управления
		 */
		private function controlSettings():void {
			// текстовое поле для отображения текста "Control Type:"
			var controlText:TextField = Tools.generateTextField(30, "Control Type:");
			controlText.x = (stage.stageWidth - controlText.width) / 2;
			controlText.y = (stage.stageHeight - controlText.height) / 3;
			addChild(controlText);
			
			// далее создаём две кнопки
			touchButton = new Button("TOUCH");
			addChild(touchButton);
			touchButton.activate();
			touchButton.width = stage.stageWidth / 3.2;
			touchButton.scaleY = touchButton.scaleX;
			touchButton.x = stage.stageWidth / 2 - touchButton.width - 10;
			touchButton.y = controlText.y + controlText.height + 20;
			
			if (Accelerometer.isSupported) { // кнопку "SENSOR" создаём только если в устройстве есть акселерометр
				sensorButton = new Button("SENSOR");
				addChild(sensorButton);
				sensorButton.width = stage.stageWidth / 3.2;
				sensorButton.scaleY = sensorButton.scaleX;
				sensorButton.x = stage.stageWidth / 2 + 10;
				sensorButton.y = controlText.y + controlText.height + 20;
				// если в настройках выставлен тип ControlType.SENSOR_CONTROL, активируем кнопку "SENSOR"
				if (Settings.controlType == ControlType.SENSOR_CONTROL) setSensorControl(null); 
				touchButton.addEventListener(TouchEvent.TOUCH_TAP, setTouchControl);
				sensorButton.addEventListener(TouchEvent.TOUCH_TAP, setSensorControl);
			} else { // если акселерометра в устройстве нет, просто центруем кнопку "TOUCH"
				touchButton.x = (stage.stageWidth - touchButton.width) / 2;
			}
		}
		/**
		 * @private задаём значение переменной в настройках, активируем/деактивируем кнопки
		 * 
		 * @param	e событие прикосновения к кнопке "TOUCH"
		 */
		private function setTouchControl(e:TouchEvent):void {
			Settings.controlType = ControlType.TOUCH_CONTROL;
			touchButton.activate();
			sensorButton.deactivate();
		}
		/**
		 * @private задаём значение переменной в настройках, активируем/деактивируем кнопки
		 * 
		 * @param	e событие прикосновения к кнопке "SENSOR"
		 */
		private function setSensorControl(e:TouchEvent):void {
			Settings.controlType = ControlType.SENSOR_CONTROL;
			sensorButton.activate();
			touchButton.deactivate();
		}
		/**
		 * @private создание элементов для настройки типа вибрации
		 */
		private function vibrationSettings():void {
			// текстовое поле для отображения текста "Vibration Type:"
			var vibrationTypeText:TextField = Tools.generateTextField(30, "Vibration Type:");
			vibrationTypeText.x = (stage.stageWidth - vibrationTypeText.width) / 2;
			vibrationTypeText.y = (stage.stageHeight - vibrationTypeText.height) / 2;
			addChild(vibrationTypeText);
			
			// три кнопки-триггера. по аналогии.
			vibroOffButton = new Button("OFF");
			addChild(vibroOffButton);
			vibroOffButton.vibroType = VibroType.VIBRO_OFF; // добавляем свойство кнопке, чтобы определить, какая кнопка нажата
			vibroOffButton.width = stage.stageWidth / 3.2;
			vibroOffButton.scaleY = vibroOffButton.scaleX;
			vibroOffButton.x = stage.stageWidth / 2 - vibroOffButton.width * 1.5 - 10;
			vibroOffButton.y = vibrationTypeText.y + vibrationTypeText.height + 20;
			
			vibroShortButton = new Button("SHORT");
			addChild(vibroShortButton);
			vibroShortButton.vibroType = VibroType.VIBRO_SHORT;
			vibroShortButton.activate();
			vibroShortButton.width = stage.stageWidth / 3.2;
			vibroShortButton.scaleY = vibroShortButton.scaleX;
			vibroShortButton.x = (stage.stageWidth - vibroOffButton.width)/ 2;
			vibroShortButton.y = vibrationTypeText.y + vibrationTypeText.height + 20;
			
			vibroLongButton = new Button("LONG");
			addChild(vibroLongButton);
			vibroLongButton.vibroType = VibroType.VIBRO_LONG;
			vibroLongButton.width = stage.stageWidth / 3.2;
			vibroLongButton.scaleY = vibroLongButton.scaleX;
			vibroLongButton.x = stage.stageWidth / 2 + vibroLongButton.width * .5 + 10;
			vibroLongButton.y = vibrationTypeText.y + vibrationTypeText.height + 20;
			
			// на основе значения из настроект активируем нужную кнопку
			if (Settings.vibroType == VibroType.VIBRO_OFF) {
				vibroShortButton.deactivate();
				vibroOffButton.activate();
			}
			
			if (Settings.vibroType == VibroType.VIBRO_LONG) {
				vibroShortButton.deactivate();
				vibroLongButton.activate();
			}
			// добавляем слушатель к кнопкам
			vibroOffButton.addEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
			vibroShortButton.addEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
			vibroLongButton.addEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
		}
		/**
		 * @private Применяем тип вибрации в зависимости от нажатой кнопки
		 * 
		 * @param	e событие прикосновения к кнопке типа вибрации
		 */
		private function changeVibroType(e:TouchEvent):void {
			switch (e.currentTarget.vibroType) {
				
				case VibroType.VIBRO_OFF:
					vibroOffButton.activate();
					vibroShortButton.deactivate();
					vibroLongButton.deactivate();
				break;
				
				case VibroType.VIBRO_SHORT:
					vibroOffButton.deactivate();
					vibroShortButton.activate();
					vibroLongButton.deactivate();
				break;
				
				case VibroType.VIBRO_LONG:
					vibroOffButton.deactivate();
					vibroShortButton.deactivate();
					vibroLongButton.activate();
				break;
			}
			
			Settings.vibroType = e.currentTarget.vibroType; // применяем настройку типа вибрации
		}
		/**
		 * Удаление со сцены, отключение ненужных слушателей
		 * 
		 * @param	e событие удаления со сцены
		 */
		private function removedFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			touchButton.removeEventListener(TouchEvent.TOUCH_TAP, setTouchControl);
			sensorButton.removeEventListener(TouchEvent.TOUCH_TAP, setSensorControl);
			vibroOffButton.removeEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
			vibroShortButton.removeEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
			vibroLongButton.removeEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
		}
		
	}
}