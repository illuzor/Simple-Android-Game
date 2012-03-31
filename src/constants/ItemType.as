package constants {
	
	/**
	 * Статические константы для определения типа игрового объекта.
	 * 
	 * @author illuzor
	 */
	
	public class ItemType {
		/** обычный объект. Прибавляет единицу к очкам */
		public static const GOOD:String = "goodItem";
		/** "очень хороший" объект. Прибавляет 5 к очкам */
		public static const VERY_GOOD:String = "veryGoodItem";
		/** "злой" объект. Отнимает единицу от очков */
		public static const EVIL:String = "evilitem";
		
	}
}