package gameObjects.transitions;

import flixel.addons.transition.FlxTransitionableState;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);
		//transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.BLACK] : [FlxColor.BLACK, 0x0]));
		//transGradient.scrollFactor.set();
		//add(transGradient);

		transBlack = new FlxSprite().makeGraphic(width, height + 400, FlxColor.BLACK);
		transBlack.scrollFactor.set(0, 0);
		transBlack.screenCenter();
		if(!isTransIn)
			transBlack.alpha = 0.001;
		add(transBlack);

		//transGradient.x -= (width - FlxG.width) / 2;
		//transBlack.x = transGradient.x;

		if(isTransIn) {
			FlxTween.tween(transBlack, {alpha: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.linear});
		} else {
			FlxTween.tween(transBlack, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.linear});
		}

		if(nextCamera != null) {
			transBlack.cameras = [nextCamera];
			//transGradient.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		/*if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}*/
		super.update(elapsed);
		/*if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}*/
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}