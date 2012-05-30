package {
	
	import constants.ScreenType;
	import events.GameEvent;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import screens.GameScreen;
	import screens.LastScoresScreen;
	import screens.MainMenu;
	import screens.ScoreScreen;
	import screens.SettingsScreen;
	import tools.StorageManager;
	
	/**
	 * Основной класс игры. Управляет отображением разных экранов игры.
	 * Игра представляет из себя следующее: внизу экрана находится "платформа", которую можно передвигать.
	 * Сверху падают "предметы" трёх типов: красный, зелёный, синий. Нужно ловить их платформой.
	 * Два типа управления: пальцем и акселерометром.
	 * Три типа вибрации - короткая, дилнная, вибрация выключена.
	 * Таблица пяти полследних результатов.
	 * 
	 * Создано с помощью FlashDevelop 4.0.1 и Flex SDK 4.6 + AIR SDK 3.2
	 * С использованием библиотеки от greensock - http://www.greensock.com/v11/
	 * 
	 * @author illuzor
	 * @version 0.94
	 */
	
	public class Main extends Sprite {
		/** @private Экран главного меню */
		private var menuScreen:MainMenu;
		/** @private Экран игры */
		private var gameScreen:GameScreen;
		/** @private Экран отображения результата игры (набранных очков) */
		private var scoreScreen:ScoreScreen;
		/** @private Экран настроек */
		private var settingsScreen:SettingsScreen;
		/** @private Экран с последними результатами (таблица пяти последних результатов)*/
		private var lastScoreScreen:LastScoresScreen;
		/** @private Эта переменная хранит текстовое значения типа экрана 
		 * из constants.ScreenType, который отображается в данный момент.
		 * Нужна для корректной очистки от слушателей и экранных объектов */
		private var currentScreen:String;
		
		/**
		 * Конструктор. Задание начальных параметров
		 */
		public function Main():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// Событие деактивации приложения. То есть выхода из него или сворачивания
			// (нажитие кнопки "домой" или "назад")
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			// Тип ввода. TOUCH_POINT выставлен по умолчанию и нам он подходит
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			StorageManager.init(); // Запускаем инициализацию менеджера локального хранилища
			Settings.controlType = StorageManager.controlType; // На основе данных из локального хранилища применяем тип управления
			Settings.vibroType = StorageManager.vibroType; // На основе данных из локального хранилища применяем тип вибрации
			
			showMenu(); // Показываем главное меню.
		}
		/**
		 * @private Показ главное меню
		 */
		private function showMenu():void {
			currentScreen = ScreenType.MAIN_MENU; // Применяем тип экрана
			menuScreen = new MainMenu(); // Создаём меню и добавляем его на сцену
			addChild(menuScreen);
			// вешаем слушатель для кнопок на menuScreen
			menuScreen.addEventListener(TouchEvent.TOUCH_TAP, onButtonTap);
		}
		/**
		 * @private Показ нужного экрана в зависимости от нажатой копки
		 * 
		 * @param	e Событие прикосновения к кнопке на экране menuScreen
		 */
		private function onButtonTap(e:TouchEvent):void {
			switch (e.target) {
				case menuScreen.playButton: // Показываем игровой экран
					startGame(null);
				break;
				
				case menuScreen.settingButton: // Показ экрана настроек после нажатия на кнопку "SETTINGS"
					clear(); // Очищаем
					currentScreen = ScreenType.SETTINGS_SCREEN; // Применяем тип экрана
					settingsScreen = new SettingsScreen(); // Создаём и показываем экран настроек после нажатия на кнопку "PLAY"
					addChild(settingsScreen);
					settingsScreen.saveButton.addEventListener(TouchEvent.TOUCH_TAP, saveSettings);
				break;
				
				case menuScreen.scoresButton: // Показ экрана с последними рзультатами после нажатия на кнопку "SCORE"
					clear(); // Очищаем
					currentScreen = ScreenType.LAST_SCORES_SCREEN; // Применяем тип экрана
					lastScoreScreen = new LastScoresScreen(); // Создаём экран и добавленяем на сцену
					addChild(lastScoreScreen);
					lastScoreScreen.backButton.addEventListener(TouchEvent.TOUCH_TAP, exitLastScores);
				break;
				
				case menuScreen.exitButton: // Выход из приложения при нажатии кнопки "EXIT"
					deactivate(null);
				break;
			}
		}
		/**
		 * Запуск игрового процесса - показ экрана gameScreen
		 * 
		 * @param	e событие прикосновения к кнопке
		 */
		private function startGame(e:TouchEvent):void {
			clear(); // Очищаем
			currentScreen = ScreenType.GAME_SCREEN; // Применяем тип экрана
			gameScreen = new GameScreen(); // Создаём игровой экран и добавляем на сцену
			addChild(gameScreen);
			gameScreen.addEventListener(GameEvent.EXIT_GAME, exitGame); // Слушатель События выхода из игры по кнопке
			gameScreen.addEventListener(GameEvent.GAME_OVER, gameOver); // Слушатель События проигрыша
		}
		/**
		 * @private Игра проиграна, показ результата
		 * 
		 * @param	e Событие проигрыша
		 */
		private function gameOver(e:GameEvent):void {
			var score:uint = gameScreen.maxScore; // Количество очков. Берётся из игрового экрана из переменной maxScore
			StorageManager.newScore = score; // Добавляем новый результат в менеджер локального хранилища
			clear(); // Очищаем
			currentScreen = ScreenType.SCORE_SCREEN; // Применяем тип экрана
			scoreScreen = new ScoreScreen(score); // Создаём и показываем экран результатов
			addChild(scoreScreen);
			scoreScreen.menuButton.addEventListener(TouchEvent.TOUCH_TAP, exitScore); // Слушатели кнопок экрана результатов
			scoreScreen.againButton.addEventListener(TouchEvent.TOUCH_TAP, startGame); 
		}
		/**
		 * @private Выход из экрана настроек по нажитию на кнопку "SAVE"
		 * Нужно сделать то же самое, что и при нажатии кнопки выхода из игры, поэтому просто вызываем exitGame()
		 * 
		 * @param	e Прикосновение к кнопке "SAVE" экрана настроек
		 */
		private function saveSettings(e:TouchEvent):void {
			// Отдаём значения типа управления и типа вибрации в StorageManager
			StorageManager.controlType = Settings.controlType;
			StorageManager.vibroType = Settings.vibroType;
			exitGame(null);
		}
		/**
		 * @private Выход из игры по нажатию кнопки
		 * 
		 * @param	e Событие выхода из игры
		 */
		private function exitGame(e:GameEvent):void {
			clear(); // Очищаем
			showMenu(); // Показываем главное меню
		}
		/**
		 * @private Выход из экрана результатов по кнопке.
		 * Нужно сделать то же самое, что и при нажатии кнопки выхода из игры, поэтому просто вызываем exitGame()
		 * 
		 * @param	e Событие прикосновения к кнопке выхода из экрана результатов
		 */
		private function exitScore(e:TouchEvent):void {
			exitGame(null);
		}
		/**
		 * @private Выход из экрана с последними результатами
		 * Нужно сделать то же самое, что и при нажатии кнопки выхода из игры, поэтому просто вызываем exitGame()
		 * 
		 * @param	e Событие прикосновения к кнопке lastScoreScreen.backButton
		 */
		private function exitLastScores(e:TouchEvent):void {
			exitGame(null);
		}
		/**
		 * @private Очистка от ненужных слушателей и экранных объектов
		 * в зависимости от значения переменной текущего экрана (currentScreen).
		 */
		private function clear():void {
			switch (currentScreen) {
				case ScreenType.MAIN_MENU:
					menuScreen.removeEventListener(TouchEvent.TOUCH_TAP, onButtonTap);
					removeChild(menuScreen);
					menuScreen = null;
				break;
				
				case ScreenType.GAME_SCREEN:
					gameScreen.removeEventListener(GameEvent.EXIT_GAME, exitGame);
					gameScreen.removeEventListener(GameEvent.GAME_OVER, gameOver);
					removeChild(gameScreen);
					gameScreen = null;
				break;
				
				case ScreenType.SCORE_SCREEN:
					scoreScreen.menuButton.removeEventListener(TouchEvent.TOUCH_TAP, exitScore);
					scoreScreen.againButton.removeEventListener(TouchEvent.TOUCH_TAP, startGame);
					removeChild(scoreScreen);
					scoreScreen = null;
				break;
				
				case ScreenType.SETTINGS_SCREEN:
					settingsScreen.saveButton.removeEventListener(TouchEvent.TOUCH_TAP, saveSettings);
					removeChild(settingsScreen);
					settingsScreen = null;
				break;
				
				case ScreenType.LAST_SCORES_SCREEN:
					lastScoreScreen.backButton.removeEventListener(TouchEvent.TOUCH_TAP, exitLastScores);
					removeChild(lastScoreScreen);
					lastScoreScreen = null;
				break;
			}
		}
		/**
		 * @private Выход из приложения через NativeApplication
		 * при нажатии кнопки "домой" или "назад" приложение закрывается
		 * 
		 * @param	e Событие деактивации приложения
		 */
		private function deactivate(e:Event):void {
			NativeApplication.nativeApplication.exit();
		}
		
	}
}