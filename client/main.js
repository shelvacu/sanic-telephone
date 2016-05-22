function addUser(uname){
    $('#playerlist-list').append('<div class="playerlist-elem">' + uname + '</div>');
}

function setCurUser(uname){
    $('#playerlist-list>div').each(function(){
	if ($(this).attr('class') === 'playerlist-elem-cur'){
	    $(this).removeClass('playerlist-elem-cur');
	    $(this).addClass('playerlist-elem');
	}
    });
    found = false;
    $('#playerlist-list>div').each(function(){
	if ($(this).html() === uname){
	    $(this).removeClass('playerlist-elem');
	    $(this).addClass('playerlist-elem-cur');
	    return false;
	}
    });
}

$(function(){
    console.log("javascript has run");
    window.sanic_lc = LC.init($("#destimg").get(0),{imageURLPrefix: '/literallycanvas/img'});
    setInterval(function(){
	$.ajax({
	    url: 'poll',
	    dataType: "json",
	    success: function(data){
		if(data.newevent){
		    console.log("There is a new event!");
		    $("#srcimg").attr('src', 'data:image/png;base64,'+data.img);
		}
		if('newusers' in data) {
		    for(var nu in data.newusers){
			addUser(nu);
		    }
		}
		if('curuser' in data) {
		    setCurUser(data.curuser);
		}
	    }
	});
    },10000);
    $("#donebutton").click(function(){
	var img_data = window.sanic_lc.getImage().toDataURL("image/png");
	img_data = img_data.replace(/^data:image\/(png|jpg);base64,/, "");
	var desc = $("#imgdesc").val()
	$.ajax({
	    url: 'done_img',
	    method: 'POST',
	    data: JSON.stringify({img: img_data})
	});
<<<<<<< HEAD
})
=======
    })
});
>>>>>>> 3fb8b5d0584b2c76a1b185b5cb6392a9a7571ca0
