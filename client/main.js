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

function addToTimeline(imgData, desc){
    $('body').append('<img class="timelineimg" src="data:image/png;base64,'+imgData+'"/>');
    $('body').append('<p>'+desc+'</p>');
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
		if('users' in data) {
		    $(".playerlist-elem").remove();
		    $.each(data.users,function(){
			addUser(this);
		    })
		}
		if('curuser' in data) {
		    setCurUser(data.curuser);
		}
		if(data.ended){
		    $.each(data.ending_images, function(){
			var imgData = this.img;
			var desc = this.description;
			addToTimeline(imgData, desc);
		    });
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
	    data: JSON.stringify({img: img_data, description: desc})
	});
    })
});
