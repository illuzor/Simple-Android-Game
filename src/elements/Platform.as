package elements {
	
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	
	/**
	 * Платформа для ловли объектов, которая находится в нижней части экрана и управляется игроком.
	 * Тут всё очень просто, рисуется белый прямоугольник и применяется фильтр свечения.
	 * Решил вынести её в свой класс, чтобы она была отдельной единицей игры для восприятия.
	 * 
	 * @author illuzor
	 */
	
	public class Platform extends Shape {
		
		public function Platform() {
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, 110, 24);
			this.graphics.endFill();
			this.filters = [new GlowFilter(0x00FF00, 3, 3)];
		}
		
	}
}