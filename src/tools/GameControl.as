package tools {
	
	import com.greensock.TweenLite;
	import constants.ControlType;
	import elements.Platform;
	import flash.display.Stage;
	import flash.events.AccelerometerEvent;
	import flash.events.MouseEvent;
	import flash.sensors.Accelerometer;
	
	/**
	 * Менеджер управления.
	 * Определяет способ управления платформой.
	 * Есть два способа - движение пальцем по дисплею и управление наклоном устройства
	 * 
	 * @author illuzor
	 */
	
	public class GameControl {
		/** @private Ссылка на stage */
		private var container:Stage;
		/** @private Ссылка на платформу */
		private var platform:Platform;
		/** @private Акселерометр */
		private var accelerometer:Accelerometer;
		/**
		 * Конструктор. Проверяет строку типа управления из настроек 
		 * и на основании её активирует соответствующий тип управления.
		 * 
		 * @param	platform Ссылка на платформу
		 * @param	container Ссылка на stage
		 */
		public function GameControl(platform:Platform, container:Stage) {
			this.platform = platform;
			this.container = container;
			
			// Проверяем тип управления и запускаем соответствующую функцию
			if (Settings.controlType == ControlType.TOUCH_CONTROL) {
				activateTouchControl();
			} else {
				activateAccelerometerControl();
			}
		}
		/**
		 * @private Активация управления пальцем
		 */
		private function activateTouchControl():void {
			container.addEventListener(MouseEvent.MOUSE_MOVE, moveplatform); // Событие движения пальца по экрану
			container.addEventListener(MouseEvent.MOUSE_UP, moveplatform); // Событие убирания пальца с экрана
		}
		/**
		 * @private Двигаем платформу в зависимости от положения пальца на дисплее по оси X
		 * 
		 * @param	e Событие движения пальца по экрану или его убирания с экрана
		 */
		private function moveplatform(e:MouseEvent):void {
			if(container.mouseY > 50)TweenLite.to(platform, .36, { x:container.mouseX - platform.width/2 } );
		}
		/**
		 * @private Активация управления акселерометром
		 */
		private function activateAccelerometerControl():void {
			accelerometer = new Accelerometer(); // Создаём акселерометр
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, updateAccelerometer); // И слушаем его обновление
		}
		/**
		 * @private В зависимости от наклона устройства по оси .x двигаем платформу.
		 * 
		 * @param	e Событие обновления акселерометра
		 */
		private function updateAccelerometer(e:AccelerometerEvent):void {
			var percent:uint = -e.accelerationX * 100 + 50; // процент наклона из диапазона 0.5 - -.05
			if (e.accelerationX < -.5) percent = 100;
			if (e.accelerationX > .5) percent = 0;
			// Двигаем платформу в зависимости от процента наклона устройства
			TweenLite.to(platform, .36, { x:percent / 100 * container.stageWidth - platform.width / 2 } );
		}
		/**
		 *  Очистка. Удаление слушателей в зависимости от текущего типа настроек.
		 */
		public function clear():void {
			if (Settings.controlType == ControlType.TOUCH_CONTROL) {
				container.removeEventListener(MouseEvent.MOUSE_MOVE, moveplatform);
				container.removeEventListener(MouseEvent.MOUSE_UP, moveplatform);
			} else {
				accelerometer.removeEventListener(AccelerometerEvent.UPDATE, updateAccelerometer);
				accelerometer = null;
			}
		}
		
	}
}