part of tictactoegame;

class StatusText
{
	
	static const String YOUR_TURN = "Your Turn";
	static const String AIS_TURN = "AI's Turn";
	static const String YOU_WIN = "You Win!";
	static const String YOU_LOSE = "You Lose.";
	static const String TIE = "Tie";
	

	ImageElement currentImage;
	ImageElement yourTurnImage = new ImageElement();
	ImageElement aiTurnImage = new ImageElement();
	ImageElement youWinImage= new ImageElement();
	ImageElement youLoseImage = new ImageElement();
	ImageElement tieImage = new ImageElement();
	
	CanvasElement canvas; // we give him his own for now; no time to implement CreateJS
	Point drawPoint;
	CanvasRenderingContext2D context;
	
	StatusText(CanvasElement canvas)
	{
		this.canvas = canvas;
		context = canvas.context2D;
		drawPoint = new Point(131, 374);
	}
  
	void redraw()
	{
		context.clearRect(0, 0, canvas.width, canvas.height);
		context.fillStyle = "#000000";
//		context.fillRect(0, 0, canvas.width, canvas.height);
		context.fillRect(0, 0, 1, 1);
		context.drawImage(currentImage, drawPoint.x, drawPoint.y);
	}
	
	List<Future> loadImages()
	{
		List<Future> loaders = [];
		yourTurnImage.src = "images/text-your-turn.png";
		aiTurnImage.src = "images/text-ai-turn.png";
		youWinImage.src = "images/text-you-win.png";
		youLoseImage.src = "images/text-you-lose.png";
		tieImage.src = "images/text-a-tie.png";
		
		loaders.add(yourTurnImage.onLoad.first);
		loaders.add(aiTurnImage.onLoad.first);
		loaders.add(youWinImage.onLoad.first);
		loaders.add(youLoseImage.onLoad.first);
		loaders.add(tieImage.onLoad.first);
		return loaders;
	}
	
	void showText(String textType)
	{
		switch(textType)
		{
			case YOUR_TURN:
				currentImage = yourTurnImage;
				break;
			
			case AIS_TURN:
				currentImage = aiTurnImage;
				break;
			
			case YOU_WIN:
				currentImage = youWinImage;
				break;
			
			case YOU_LOSE:
				currentImage = youLoseImage;
				break;
			
			case TIE:
				currentImage = tieImage;
				break;
		}
		redraw();
	}
  
  
}