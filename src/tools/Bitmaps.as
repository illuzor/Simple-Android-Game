package tools {
	
	import flash.display.Bitmap;
	
	/**
	 * "Генератор" битмапов из прикреплённых файлов
	 * 
	 * @author illuzor
	 */
	
	public class Bitmaps {
		/** @private Прикреплённый файл графики фона */
		[Embed(source = "../../assets/MenuBackground.jpg")] private static const BackgroundBitmap:Class;
		/** @private Прикреплённый файл графики кнопки */
		[Embed(source = "../../assets/ButtonImage.png")] private static const ButtonBitmap:Class;
		/** @private Прикреплённый файл графики логотипа */
		[Embed(source = "../../assets/GameLogo.png")] private static const LogoBitmap:Class;
		
		/** Битмап фона */
		public static function get backgroundBitmap():Bitmap {
			return new BackgroundBitmap() as Bitmap;
		}
		/**  Битмап кнопки  */
		public static function get buttonBitmap():Bitmap {
			return new ButtonBitmap() as Bitmap;
		}
		/** Битмап логотипа  */
		public static function get logoBitmap():Bitmap {
			return new LogoBitmap() as Bitmap;
		}
		
	}
}