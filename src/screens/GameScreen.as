package screens {
	
	import com.adobe.nativeExtensions.Vibration;
	import constants.ItemType;
	import constants.VibroType;
	import elements.Button;
	import elements.Item;
	import elements.Platform;
	import events.GameEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import tools.GameControl;
	import tools.Tools;
	
	/**
	 * Основной класс игры. Что представляет собой игровой процесс:
	 * Внизу экрана находится платформа, которую можно двигать влево/вправо движением пальца по дисплею в любой части экрана или наклоном устройства.
	 * Сверху падают так называемые айтемы, которые могут быть трёх видов:
	 * - ItemType.GOOD - обычный айтем. При собирании прибавляет единицу к очками, при пропускании(уход за нижнюю границу экрана)
	 *   отнимает единицу от очков
	 * - ItemType.VERY_GOOD - "усиленный" айтем. При собирании прибавляет 5 к очками. При пропускании ничего не происходит.
	 * - ItemType.EVIL - "злой" айтем. При собирании отнимает единицу от очков. При пропускании ничего не происходит.
	 * 
	 * При значении очков меньше пяти засчитывается проигрыш, а результатом игры считается максимальное набранное количество очков.
	 * С каждым новым уровнем айтемы движутся быстрей, чем в предыдущем и интервал их появления становится меньше.
	 * 
	 * Сверху слева находится индикатор набранных очков, справа сверху кнопка выхода в главное меню.
	 * Снизу в центре под платформой находится индикатор текущего уровня.
	 * 
	 * 
	 * @author illuzor
	 */
	
	[Event(name = "gameOver", type = "events.GameEvent")]
	[Event(name = "exitGame", type = "events.GameEvent")]
	
	public class GameScreen extends Sprite {
		/** @private контейнер для платформы и айтемов */
		private var gameContainer:Sprite;
		/** @private кнопка для выхода в главное меню */
		private var menuButton:Button;
		/** @private платформа */
		private var platform:Platform;
		/** @private игровой таймер. нужен для добавления нового айтема */
		private var gameTimer:Timer;
		/** @private номер текущего уровня */
		private var currentLevel:uint;
		/** @private текущее количество очков */
		private var currentScore:int;
		/** @private текстовое поле для отображения уровня */
		private var levelText:TextField;
		/** @private текстовое поле для отображения очков */
		private var scoreText:TextField;
		/** @private переменная класса вибрации */
		private var vibration:Vibration;
		/** @private менеджер управления */
		private var control:GameControl;
		/** максимальное количество очков */
		public var maxScore:uint;
		/**
		 * В конструкторе слушаем добавление на сцену.
		 */
		public function GameScreen() {
			// если вибрация не выключена создаём объект вибрации
			if (Settings.vibroType != VibroType.VIBRO_OFF) {
				vibration = new Vibration();
			}
			addEventListener(Event.ADDED_TO_STAGE, addedtToStage);
		}
		/**
		 * @private создаём элементы экрана
		 * 
		 * @param	e событие добавления на сцену
		 */
		private function addedtToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedtToStage);
			
			gameContainer = new Sprite(); // контейнер для платформы и айтемов. всё остальное поверх него.
			addChild(gameContainer);
			
			platform = new Platform(); // создаём платформу, подгоняем её размер и положение и добавляем на сцену
			platform.width = stage.stageWidth * .18;
			platform.scaleY = platform.scaleX;
			platform.x = (stage.stageWidth - platform.width) / 2;
			platform.y = stage.stageHeight * .88;
			addChild(platform);
			
			scoreText = Tools.generateTextField(30, "SCORE: 0"); // текстовое поле очков
			scoreText.width = stage.stageWidth / 2;
			scoreText.x = scoreText.y = 10;
			addChild(scoreText);
			
			levelText = Tools.generateTextField(30, "LEVEL: 1"); // текстовое поле уровня
			levelText.width = levelText.textWidth + 4;
			levelText.x = (stage.stageWidth - levelText.width) / 2;
			levelText.y = stage.stageHeight - levelText.height - 20;
			addChild(levelText);
			
			menuButton = new Button("MENU");// кнопка для выхода в главное меню.
			addChild(menuButton);
			menuButton.width = stage.stageWidth / 3.2;
			menuButton.scaleY = menuButton.scaleX;
			menuButton.x = stage.stageWidth - menuButton.width - 10;
			menuButton.y = 10;
			
			// создаём менеджер управления и отдаём ему ссылки на платформу и сцену
			control = new GameControl(platform, stage);
			
			startNewLevel(); // запускаем новый уровень
			
			menuButton.addEventListener(TouchEvent.TOUCH_TAP, exitGame); // событие нажатия на кнопку выхода в меню
			addEventListener(Event.ENTER_FRAME, updateGame); // обновление состояния игры (по сути, это игровой цикл)
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		/**
		 * @private запуск нового уровня. каждый уровень состоит из 20 айтемов
		 */
		private function startNewLevel():void {
			var interval:uint = 2300; // интервал вызова таймера
			if (2300 - currentLevel * 350 < 250) { // чем выше уровень, тем меньше интервал...
				interval = 350; // ... но не меньше этого значение, чтоб было играбельно.
			} else {
				interval = 2300 - currentLevel * 350;
			}
			gameTimer = new Timer(interval, 20); // создаём и запускаем таймер.
			gameTimer.start();
			gameTimer.addEventListener(TimerEvent.TIMER, addItem);
			gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, cicleEnd);
		}
		/**
		 * @private Создаём новый айтем по таймеру
		 * 
		 * @param	e событие тика таймера
		 */
		private function addItem(e:TimerEvent):void {
			var randomRange:Number = Math.random(); // случайное значене
			var itemType:String = ItemType.GOOD; // тип нового айтема. по умолчнанию все айтемы обычные
			if (randomRange > 0.65 && randomRange < .95) { // если случайное значение в заданном диапазоне (30%)...
				itemType = ItemType.EVIL; // ... айтем злой
			} else if (randomRange >= .95 ){ // 5% айтемов пусть будут "усиленными"
				itemType = ItemType.VERY_GOOD;
			}
			var item:Item = new Item(itemType); // создаём новый айтем со сгенерированным типом
			item.x = (stage.stageWidth-14) * Math.random(); // помещаем на случайную координату по .x с учётом ширины айтема(14px)
			item.y = -item.height; // а по .y убираем вверх за пределы сцены
			item.speed = currentLevel+1; // скорость айтема
			gameContainer.addChild(item); // и добавлеем его на сцену
		}
		/**
		 * @private когда таймер закончил работу, очищаем, что не нужно и запускаем новый уровень
		 * 
		 * @param	e событие окончания работы таймера
		 */
		private function cicleEnd(e:TimerEvent):void {
			gameTimer.removeEventListener(TimerEvent.TIMER, addItem);
			gameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, cicleEnd);
			gameTimer = null; // удаляем слушатели с таймера и ссылку на таймер
			currentLevel++; // увеличиваем уровень на единицу
			levelText.text = "LEVEL: " + String(currentLevel + 1); // обновляем текст уровня
			levelText.width = levelText.textWidth +4;
			startNewLevel();// запускаем новый уровень
		}
		/**
		 * @private Игровой цикл
		 * Обновляем положение айтемов. если они ушли за пределы сцены, удаляем.
		 * Обратываем их столкновения с платформой
		 * 
		 * @param	e enterFrame событие
		 */
		private function updateGame(e:Event):void {
			// в цикле проходимся по всему содержимому игрового контейнера, кроме платформы (i = 1)
			for (var i:int = 1; i < gameContainer.numChildren; i++) { 
				var tempItem:Item = gameContainer.getChildAt(i) as Item; // берём айтем
				tempItem.y += (tempItem.speed * 3) * .8; // увеличиваем его .y координату в зависимости от его скорости.
				if (tempItem.y > stage.stageHeight) { // если он ушёл вниз за сцену ...
					gameContainer.removeChild(tempItem); //... удаляем его ...
					if (tempItem.type == ItemType.GOOD) currentScore--; // .. а если его тип при этом оказался обычным, отнимаем единицу от очков.
				}
				if (tempItem.hitTestObject(platform)) { // если айтем пойман платформой
					// в зависимости от его типа, производим действие.
					// думаю, тут ничего не надо объяснять
					switch (tempItem.type) {
						case ItemType.GOOD:
							currentScore++;
						break;
						
						case ItemType.VERY_GOOD:
							currentScore +=5;
						break;
						
						case ItemType.EVIL:
							currentScore--;
							// вибрируем 150  или 600 миллисекунд в зависимости от типа вибрации в настройках
							if (Settings.vibroType == VibroType.VIBRO_SHORT) {
								vibration.vibrate(150);
							} else if (Settings.vibroType == VibroType.VIBRO_LONG) {
								vibration.vibrate(600);
							}
						break;
					}
					// также при попадании на платформу айтем больше не нужен, удаляем его со сцены
					gameContainer.removeChild(tempItem);
				}
			}
			scoreText.text = "SCORE: " + currentScore; // обновляем текстовое поле с очками
			if (maxScore < currentScore) maxScore = currentScore; // записываем максимальное количество очков
			if (currentScore < -5) { // если количество очков меньше, чем -5..
				dispatchEvent(new GameEvent(GameEvent.GAME_OVER)); //...  генерируем событие проигрыша
			}
		}
		/**
		 * @private генерируем событие выхода из игры
		 * 
		 * @param	e событие прикосновения к кнопке выхода в меню
		 */
		private function exitGame(e:TouchEvent):void {
			dispatchEvent(new GameEvent(GameEvent.EXIT_GAME));
		}
		/**
		 * @private удаляем все ненужные больше слушатели и ссылки
		 * 
		 * @param	e событие удаления со сцены
		 */
		private function removedFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			removeEventListener(Event.ENTER_FRAME, updateGame);
			menuButton.removeEventListener(TouchEvent.TOUCH_TAP, exitGame);
			gameTimer.stop();
			gameTimer.removeEventListener(TimerEvent.TIMER, addItem);
			gameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, cicleEnd);
			control.clear(); // очишаем менеджер управления
			gameTimer = null;
			control = null;
			platform = null;
			menuButton = null;
			gameContainer = null;
			levelText = null;
			scoreText = null;
		}
		
	}
}