package tools {
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Класс с небольшими инструментами. 
	 * Пока что содержит только генератор текстовового поля.
	 * 
	 * @author illuzor
	 */
	
	public class Tools {
		/**
		 * Генератор текстфилда по заданным параметрам
		 * 
		 * @param	size Размер шрифта
		 * @param	text Текст для отображения
		 * @param	color Цвет текста
		 * @return  Настроенное текстовое поле
		 */
		public static function generateTextField(size:uint, text:String = "", color:uint = 0xFFFFFF):TextField {
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = color;
			textFormat.size = size;
			
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.defaultTextFormat = textFormat;
			textField.text = text;
			textField.width = textField.textWidth +4;
			textField.height = textField.textHeight +4;
			
			return textField;
		}
		
	}
}