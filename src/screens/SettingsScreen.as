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
	 * Экран настроек. Позволяет выбрать тип управления и тип вибрации
	 * 
	 * @author illuzor
	 */
	
	public class SettingsScreen extends Sprite {
		/** @private Кнопка-триггер для активации управления пальцем */
		private var touchButton:Button;
		/** @private Кнопка-триггер для активации управления наклоном устройства */
		private var sensorButton:Button;
		/** @private Кнопка-триггер для отключения вибрации */
		private var vibroOffButton:Button;
		/** @private Кнопка-триггер для активации короткой вибрации */
		private var vibroShortButton:Button;
		/** @private Кнопка-триггер для активации длинной вибрации */
		private var vibroLongButton:Button;
		/** Кнопка save для выхода из экрана настроек и возвращения в главное меню */
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
		 * @param	e Событие добавления на сцену
		 */
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			// Добавляем заголовок
			var header:TextField = Tools.generateTextField(50, "SETTINGS");
			header.x = (stage.stageWidth - header.width) / 2;
			header.y = 40;
			addChild(header);
			
			// Создаём кнопку для выхода в главное меню
			saveButton = new Button("SAVE");
			addChild(saveButton);
			saveButton.width = stage.stageWidth / 2;
			saveButton.scaleY = saveButton.scaleX;
			saveButton.x = (stage.stageWidth - saveButton.width) / 2;
			saveButton.y = stage.stageHeight - saveButton.height - 20;
			
			controlSettings(); // Добавляем элементы для настройки типа управления
			
			if (Vibration.isSupported) { // Если вибрация поддерживается ...
				vibrationSettings(); // ... создаём элементы управления вибрацией
			} else { // Если не поддерживается, выключаем вибрацию
				Settings.vibroType = VibroType.VIBRO_OFF;
			}
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		/**
		 * @private Создание элементов для выбора типа управления
		 */
		private function controlSettings():void {
			// Текстовое поле для отображения текста "Control Type:"
			var controlText:TextField = Tools.generateTextField(30, "Control Type:");
			controlText.x = (stage.stageWidth - controlText.width) / 2;
			controlText.y = (stage.stageHeight - controlText.height) / 3;
			addChild(controlText);
			
			// Создаём две кнопки
			touchButton = new Button("TOUCH");
			addChild(touchButton);
			touchButton.activate();
			touchButton.width = stage.stageWidth / 3.2;
			touchButton.scaleY = touchButton.scaleX;
			touchButton.x = stage.stageWidth / 2 - touchButton.width - 10;
			touchButton.y = controlText.y + controlText.height + 20;
			
			if (Accelerometer.isSupported) { // Кнопку "SENSOR" создаём только если в устройстве есть акселерометр
				sensorButton = new Button("SENSOR");
				addChild(sensorButton);
				sensorButton.width = stage.stageWidth / 3.2;
				sensorButton.scaleY = sensorButton.scaleX;
				sensorButton.x = stage.stageWidth / 2 + 10;
				sensorButton.y = controlText.y + controlText.height + 20;
				// Если в настройках выставлен тип ControlType.SENSOR_CONTROL, активируем кнопку "SENSOR"
				if (Settings.controlType == ControlType.SENSOR_CONTROL) setSensorControl(null); 
				touchButton.addEventListener(TouchEvent.TOUCH_TAP, setTouchControl);
				sensorButton.addEventListener(TouchEvent.TOUCH_TAP, setSensorControl);
			} else { // Если акселерометра в устройстве нет, просто центруем кнопку "TOUCH"
				touchButton.x = (stage.stageWidth - touchButton.width) / 2;
			}
		}
		/**
		 * @private Задаём значение переменной в настройках, активируем/деактивируем кнопки
		 * 
		 * @param	e Событие прикосновения к кнопке "TOUCH"
		 */
		private function setTouchControl(e:TouchEvent):void {
			Settings.controlType = ControlType.TOUCH_CONTROL;
			touchButton.activate();
			sensorButton.deactivate();
		}
		/**
		 * @private Задаём значение переменной в настройках, активируем/деактивируем кнопки
		 * 
		 * @param	e Событие прикосновения к кнопке "SENSOR"
		 */
		private function setSensorControl(e:TouchEvent):void {
			Settings.controlType = ControlType.SENSOR_CONTROL;
			sensorButton.activate();
			touchButton.deactivate();
		}
		/**
		 * @private Создание элементов для выбора типа вибрации
		 */
		private function vibrationSettings():void {
			// Текстовое поле для отображения текста "Vibration Type:"
			var vibrationTypeText:TextField = Tools.generateTextField(30, "Vibration Type:");
			vibrationTypeText.x = (stage.stageWidth - vibrationTypeText.width) / 2;
			vibrationTypeText.y = (stage.stageHeight - vibrationTypeText.height) / 2;
			addChild(vibrationTypeText);
			
			// Три кнопки-триггера. По аналогии.
			vibroOffButton = new Button("OFF");
			addChild(vibroOffButton);
			vibroOffButton.vibroType = VibroType.VIBRO_OFF; // Добавляем свойство кнопке, чтобы можно было определить, какая кнопка нажата
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
			
			// На основе значения из настроект активируем нужную кнопку
			if (Settings.vibroType == VibroType.VIBRO_OFF) {
				vibroShortButton.deactivate();
				vibroOffButton.activate();
			}
			
			if (Settings.vibroType == VibroType.VIBRO_LONG) {
				vibroShortButton.deactivate();
				vibroLongButton.activate();
			}
			// Добавляем слушатель к кнопкам
			vibroOffButton.addEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
			vibroShortButton.addEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
			vibroLongButton.addEventListener(TouchEvent.TOUCH_TAP, changeVibroType);
		}
		/**
		 * @private Применяем тип вибрации в зависимости от нажатой кнопки
		 * 
		 * @param	e Событие прикосновения к кнопке типа вибрации
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
			
			Settings.vibroType = e.currentTarget.vibroType; // Применяем настройку типа вибрации
		}
		/**
		 * Удаление со сцены, отключение ненужных слушателей
		 * 
		 * @param	e Событие удаления со сцены
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