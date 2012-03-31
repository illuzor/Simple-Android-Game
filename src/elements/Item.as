package elements {
	
	import constants.ItemType;
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	
	/**
	 * Класс айтема (предмета), который падаёт сверху экрана.
	 * 
	 * @author illuzor
	 */
	
	public class Item extends Shape {
		/** Тип айтема из constants.ItemType */
		public var type:String;
		/** Скорость движения айтема */
		public var speed:uint;
		/**
		 * В конструкторе рисуется графика айтема.
		 * 
		 * @param	type Тип айтема
		 */
		public function Item(type:String) {
			this.type = type;
			
			switch (type) { // Проверяем, какой тип передан в конструктор
				// и в зависимости от этого рисуем соответствующую графику.
				case ItemType.GOOD: // Рисуем зелёный квадрат
					this.graphics.beginFill(0x00A400);
					this.graphics.drawRect(0, 0, 14, 14);
					this.graphics.endFill();
				break;
				
				case ItemType.VERY_GOOD: // Рисуем синий квадрат со свечением
					this.graphics.beginFill(0x01A6FE);
					this.graphics.drawRect(0, 0, 14, 14);
					this.graphics.endFill();
					this.filters = [new GlowFilter(0x00FF00, 1, 4, 4, 4, 2)];
				break;
				
				case ItemType.EVIL: // Рисуем красный круг
					graphics.beginFill(0xFF0000);
					graphics.drawCircle(0, 0, 7);
					graphics.endFill();
				break;
			}
		}
		
	}
}