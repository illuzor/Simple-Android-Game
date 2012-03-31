package  {
	
	import constants.ControlType;
	import constants.VibroType;
	
	/**
	 * Класс для хранения настроек
	 * 
	 * @author illuzor
	 */
	
	public class Settings {
		/** Тип управления */
		public static var controlType:String = ControlType.TOUCH_CONTROL;
		/** Тип вибрации */
		public static var vibroType:String = VibroType.VIBRO_SHORT;
		
	}
}