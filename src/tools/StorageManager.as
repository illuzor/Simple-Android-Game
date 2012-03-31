package tools {
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * Класс менеджера локального хранилища.
	 * Считывает из локальной памяти устройства файл с настройками и записывает в него изменения.
	 * Если файл не существует (то есть это первый запуск приложения), то он создаётся и записывается.
	 * Также может отдавать и получать некоторые данные.
	 * 
	 * @author illuzor
	 */
	
	public class StorageManager {
		/** @private объект файла для чтения/сохранения */
		static private var settingsFile:File;
		/** @private xml объект с данными (а именно с типом управления и последними результатами) */
		static private var settingXML:XML;
		/** @private массив с результатами игры ( с количеством набранных очков) */
		static private var scoresList:Vector.<uint> = new Vector.<uint>();
		/**
		 * Инициализация.
		 * Создаётся объект файла и проверяется на существование в локальной памяти устройства.
		 */
		public static function init():void {
			// задание пути к локальному файлу для хранения данных
			settingsFile = File.applicationStorageDirectory.resolvePath("gameSettings.xml");
			if (!settingsFile.exists) { // если файл не существует...
				settingXML = createXML(); // ...создаём начальный xml ...
				writeFile(); // ... и записываем его в файл.
			} else { // если файл существует ...
				settingXML = readFile(); // ... считываем его и на основе этого файла создаём xml ...
				createList(); // ... заполняем массив с результатами из считанного xml
			}
		}
		/**
		 * @private Создаём начальный xml
		 * Записываем тип управления из настроек.
		 * 
		 * @return начальный xml объект
		 */
		private static function createXML():XML {
			return new XML("<xml><controlType>"+Settings.controlType+"</controlType><vibroType>"+Settings.vibroType+"</vibroType><scores></scores></xml>");
		}
		/**
		 * @private Считывание файла из постоянной памяти устройства.
		 * 
		 * @return xml на основе считанного файла
		 */
		private static function readFile():XML {
			var xml:XML; // временный xml
			var stream:FileStream = new FileStream(); // поток для считывания
			stream.open(settingsFile, FileMode.READ); // открываем объект файла на чтение
			xml = XML(stream.readUTFBytes(stream.bytesAvailable)); // создаём xml на основе считанного файла
			stream.close(); // закрываем поток
			return xml;
		}
		/**
		 * @private запись xml файла в локальное хранилище(память) устройства.
		 */
		private static function writeFile():void {
			var stream:FileStream = new FileStream(); // поток для записи
			stream.open(settingsFile, FileMode.WRITE); // открываем объект файла на запись
			stream.writeUTFBytes(settingXML.toXMLString()); // записываем файл
			stream.close(); // закрываем поток
		}
		/**
		 * Сеттер для задания типа управления извне (используется в главном классе после выхода из экрана настроек)
		 */
		public static function set controlType(value:String):void {
			settingXML.controlType.setChildren(value) // задаём значение в xml
			writeFile(); // и сразу записываем изменённый xml в файл
		}
		/**
		 * Геттер типа управления. Нужен в главном классе для задания настройки управления при запуске приложения
		 */
		public static function get controlType():String {
			return settingXML.controlType; // возвращает тип управления их xml
		}
		/**
		 * Сеттер для задания типа вибрации извне (используется в главном классе после выхода из экрана настроек)
		 */
		public static function set vibroType(value:String):void {
			settingXML.vibroType.setChildren(value) // задаём значение в xml
			writeFile(); // и сразу записываем изменённый xml в файл
		}
		/**
		 * Геттер типа вибрации. Нужен в главном классе для задания настройки вибрации при запуске приложения
		 */
		public static function get vibroType():String {
			return settingXML.vibroType; // возвращает тип управления их xml
		}
		
		/**
		 * Сеттер для добавления нового результата
		 * Используется в главном классе , когда игра проиграна. (получено событие проигрыша от игрового экрана)
		 */
		public static function set newScore(value:uint):void {
			scoresList.unshift(value); // добавляем полученный результат в начало массива.
			updateScores(); // запуск функции обновления списка результатов в xml
		}
		/**
		 * Геттер возвращает 5(или меньше) последних результатов в виде массива
		 * на основе xml с данными. используется в LastScoresScreen для получения списка результатов
		 */
		public static function get lastScores():Vector.<uint> {
			var list:Vector.<uint> = new Vector.<uint>();
			for (var i:int = 0; i < settingXML.scores.children().length(); i++) {
				list.push(settingXML.scores.children()[i]);
			}
			return list;
		}
		/**
		 * @private заполнение массива с результатами.
		 * Используется при считываении файла данных.
		 */
		private static function createList():void {
			for (var i:int = 0; i < settingXML.scores.children().length(); i++) {
				scoresList.push(settingXML.scores.children()[i]);
			}
		}
		/**
		 * @private Обновление xml. Считываение первых пяти результатов из массива,
		 * запись их в xml и запись xml в файл
		 */
		private static function updateScores():void {
			var scoresTempXML:XML = new XML("<scores></scores>") // временный xml элемент для списка очков
			var counter:uint; // счётчик итераций ...
			if (scoresList.length <= 5) { // ... он не должен быть больше пяти
				counter = scoresList.length;
			} else {
				counter = 5;
			}
			for (var i:int = 0; i < counter; i++) { // добавление элементов в scoresTempXML
				scoresTempXML.appendChild(new XML("<score>" + scoresList[i] + "</score>"))
			}
			// применение изменений к основному xml (settingXML)
			settingXML.scores.setChildren(scoresTempXML.children());
			writeFile(); // и запись xml в файл.
		}
		
	}
}