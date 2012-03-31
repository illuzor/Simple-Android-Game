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
	 * Таблица пяти полследних результатов.
	 * 
	 * Создано с помощью FlashDevelop 4.0.1 и Flex SDK 4.6
	 * С использованием библиотеки от greensock - http://www.greensock.com/v11/
	 * 
	 * @author illuzor
	 * @version 0.93
	 */
	
	public class Main extends Sprite {
		/** @private экран главного меню */
		private var menuScreen:MainMenu;
		/** @private экран игры */
		private var gameScreen:GameScreen;
		/** @private экран отображения результата игры (набранных очков) */
		private var scoreScreen:ScoreScreen;
		/** @private экран настроек */
		private var settingsScreen:SettingsScreen;
		/** @private экран с последними результатами */
		private var lastScoreScreen:LastScoresScreen;
		/** @private эта переменная хранит текстовое значения типа экрана 
		 * из constants.ScreenType, который отображается в данный момент 
		 * нужна для корректной очистки от слушателей и экранных объектов */
		private var currentScreen:String;
		
		/**
		 * Конструктор. Задание начальных параметров
		 */
		public function Main():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// событие деактивации приложения. то есть выхода из него или сворачивания
			// (нажитии кнопки "домой" или "назад")
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			// тип ввода. TOUCH_POINT выставлен по умолчанию и нам он подходит
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			StorageManager.init(); // запускаем инициализацию менеджера локального хранилища
			Settings.controlType = StorageManager.controlType; // на основе данных из локального хранилища применяем тип управления
			Settings.vibroType = StorageManager.vibroType; // на основе данных из локального хранилища применяем тип вибрации
			
			showMenu(); // показываем главное меню.
		}
		/**
		 * @private показ главное меню
		 */
		private function showMenu():void {
			currentScreen = ScreenType.MAIN_MENU; // применяем тип экрана
			menuScreen = new MainMenu(); // создаём меню и добавляем его на сцену
			addChild(menuScreen);
			
			menuScreen.playButton.addEventListener(TouchEvent.TOUCH_TAP, startGame); // добавляем слушатели к кнопкам меню
			menuScreen.exitButton.addEventListener(TouchEvent.TOUCH_TAP, deactivate);
			menuScreen.settingButton.addEventListener(TouchEvent.TOUCH_TAP, showSettings);
			menuScreen.scoresButton.addEventListener(TouchEvent.TOUCH_TAP, showLastScoresScreen);
		}
		/**
		 * @private показываем игровой экран
		 * 
		 * @param	e событие прикосновения к кнопке playButton главного меню
		 */
		private function startGame(e:TouchEvent):void {
			clear(); // очищаем
			currentScreen = ScreenType.GAME_SCREEN; // применяем тип экрана
			
			gameScreen = new GameScreen(); // создаём игровой экран и добавляем на сцену
			addChild(gameScreen);
			gameScreen.addEventListener(GameEvent.EXIT_GAME, exitGame); // событие выхода из игры по кнопке
			gameScreen.addEventListener(GameEvent.GAME_OVER, gameOver); // событие проигрыша
		}
		/**
		 * @private выход из игры по нажатию кнопки
		 * 
		 * @param	e событие выхода из игры
		 */
		private function exitGame(e:GameEvent):void {
			clear(); // очищаем
			showMenu(); // показываем главное меню
		}
		/**
		 * @private игра проиграна, показ результата
		 * 
		 * @param	e событие проигрыша
		 */
		private function gameOver(e:GameEvent):void {
			var score:uint = gameScreen.maxScore; // количество очков. берётся из игрового экрана из переменной maxScore
			StorageManager.newScore = score; // добавляем новый результат в менеджер локального хранилища
			clear(); // очищаем
			currentScreen = ScreenType.SCORE_SCREEN; // применяем тип экрана
			scoreScreen = new ScoreScreen(score); // создаём и показываем экран результатов
			addChild(scoreScreen);
			scoreScreen.menuButton.addEventListener(TouchEvent.TOUCH_TAP, exitScore); // слушатели кнопок экрана результатов
			scoreScreen.againButton.addEventListener(TouchEvent.TOUCH_TAP, startGame); 
		}
		/**
		 * @private выход из экрана результатов по кнопке.
		 * нужно сделать то же самое, что и при нажатии кнопки выхода из игры, поэтому просто вызываем exitGame()
		 * 
		 * @param	e событие прикосновения к кнопке выхода из экрана результатов
		 */
		private function exitScore(e:TouchEvent):void {
			exitGame(null);
		}
		/**
		 * @private Показ экрана настроек после нажатия на кнопку "SETTINGS"
		 * 
		 * @param	e событие прикосновения к кнопке "SETTINGS"
		 */
		private function showSettings(e:TouchEvent):void {
			clear(); // очищаем
			currentScreen = ScreenType.SETTINGS_SCREEN; // применяем тип экрана
			settingsScreen = new SettingsScreen(); // создаём и показываем экран настроек
			addChild(settingsScreen);
			settingsScreen.saveButton.addEventListener(TouchEvent.TOUCH_TAP, saveSettings);
		}
		/**
		 * @private Выход из экрана настроек по нажитию на кнопку "SAVE"
		 * нужно сделать то же самое, что и при нажатии кнопки выхода из игры, поэтому просто вызываем exitGame()
		 * 
		 * @param	e прикосновение к кнопке "SAVE" экрана настроек
		 */
		private function saveSettings(e:TouchEvent):void {
			// отдаём значения типа управления и типа вибрации в StorageManager
			StorageManager.controlType = Settings.controlType;
			StorageManager.vibroType = Settings.vibroType;
			exitGame(null);
		}
		/**
		 * @private Показ экрана с последними рзультатами
		 * 
		 * @param	e событие прикосновения к кнопке menuScreen.scoresButton
		 */
		private function showLastScoresScreen(e:TouchEvent):void {
			clear(); // очищаем
			currentScreen = ScreenType.LAST_SCORES_SCREEN; // применяем тип экрана
			lastScoreScreen = new LastScoresScreen(); // создаём экран и добавленяем на сцену
			addChild(lastScoreScreen);
			lastScoreScreen.backButton.addEventListener(TouchEvent.TOUCH_TAP, exitLastScores);
		}
		/**
		 * @private Выход из экрана с последними результатами
		 * нужно сделать то же самое, что и при нажатии кнопки выхода из игры, поэтому просто вызываем exitGame()
		 * 
		 * @param	e событие прикосновения к кнопке lastScoreScreen.backButton
		 */
		private function exitLastScores(e:TouchEvent):void {
			exitGame(null);
		}
		/**
		 * @private очистка от ненужных слушателей и экранных объектов
		 * в зависимости от значения переменной текущего экрана (currentScreen).
		 */
		private function clear():void {
			switch (currentScreen) {
				case ScreenType.MAIN_MENU:
					menuScreen.playButton.removeEventListener(TouchEvent.TOUCH_TAP, startGame);
					menuScreen.exitButton.removeEventListener(TouchEvent.TOUCH_TAP, deactivate);
					menuScreen.settingButton.removeEventListener(TouchEvent.TOUCH_TAP, showSettings);
					menuScreen.scoresButton.removeEventListener(TouchEvent.TOUCH_TAP, showLastScoresScreen);
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
		 * @private выход из приложения через NativeApplication
		 * при нажатии кнопки "домой" или "назад" приложение закрывается
		 * 
		 * @param	e событие деактивации приложения
		 */
		private function deactivate(e:Event):void {
			NativeApplication.nativeApplication.exit();
		}
		
	}
}