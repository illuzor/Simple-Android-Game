package constants {
	
	/**
	 * Статические константы для определения типа игрового объекта.
	 * 
	 * @author illuzor
	 */
	
	public class ItemType {
		/** Обычный объект. Прибавляет единицу к очкам */
		public static const GOOD:String = "goodItem";
		/** "Очень хороший" объект. Прибавляет 5 к очкам */
		public static const VERY_GOOD:String = "veryGoodItem";
		/** "Злой" объект. Отнимает единицу от очков */
		public static const EVIL:String = "evilitem";
		
	}
}