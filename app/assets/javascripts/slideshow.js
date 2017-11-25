////////////////////////////////////////
//　SCRIPT
////////////////////////////////////////

$(window).on('turbolinks:load', function() {
	var setElm = $('.slideShow'),
	fadeSpeed = 1000,
	switchDelay = 2000;

	setElm.each(function(){
		var self = $(this),
		findUl = self.find('ul'),
		findLi = findUl.find('li'),
		findLiFirst = findUl.find('li:first'),
		findImg = findLi.find('img');

		findLi.css({display:'block',opacity:'0',zIndex:'99'});

		function areaHeight(){
			var imgHeight = findImg.height();

			self.css({height:imgHeight});
			findUl.css({height:imgHeight});
			findLi.css({height:imgHeight});
			console.log(imgHeight);
		}
		$(window).on('resize', function(){areaHeight(); console.log('Debug')});
		areaHeight();

		findLiFirst.css({zIndex:'100'}).stop().animate({opacity:'1'},fadeSpeed);

		setInterval(function(){
			findUl.find('li:first').animate({opacity:'0'},
				fadeSpeed).next('li').css({zIndex:'100'}).animate({opacity:'1'},fadeSpeed).end().appendTo(findUl).css({zIndex:'99'});
		},switchDelay);

	});
});