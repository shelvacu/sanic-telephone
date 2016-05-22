$(function(){
    console.log("javascript has run");
    window.sanic_lc = LC.init($("#destimg").get(0),{imageURLPrefix: 'literallycanvas/img'});//$("#destimg").literallycanvas({imageURLPrefix: 'literallycanvas/img'});
    setInterval(function(){
	$.ajax({
	    url: '/poll',
	    dataType: "json",
	    success: function(data){
		if(data.newevent){
		    console.log("There is a new event!");
		    $("#srcimg").attr('src', 'data:image/png;base64,'+data.img);
		}
	    }
	});
    },10000);
    $("#donebutton").click(function(){
	var img_data = window.sanic_lc.getImage().toDataURL("image/png");
	img_data = img_data.replace(/^data:image\/(png|jpg);base64,/, "");
	var desc = $("#imgdesc").val()
	$.ajax({
	    url: '/done_img',
	    method: 'POST',
	    data: JSON.stringify({img: img_data, desc: desc})
	});
    });
})
