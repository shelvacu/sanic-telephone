url

GET / - send static html page
GET /$ROOMID/poll - respond with json immediately in this format:
    {success: true //true if everything went well with no errors
     newevent:true //true if something has happened since the last poll
     img: "VGhpcyBpcyBzb21lIGV4YW1wbGUgZGF0YS4=" //A base64 string representation of the image related to the event in PNG format. Blank or missing if newevent is false
     newusers: ["user1", "user2", ...] //username of newly connected user
     curuser: ... //username of user currently drawing
     curimg:  ... //last fully complete image; only for done players
     ended: true //True if the event represents the end of the game. missing or false if newevent is false
     }
POST /$ROOMID/done_img - this is the client notifying the server that it has finished making the image. In the POST data of the request is json:
    {img: "VGhpcyBpcyBzb21lIGV4YW1wbGUgZGF0YS4=" //A base64 string representation of the finished image in PNG format
    desc: ... //description of image being sent
    }



ending images stuff

{...
 newevent:true,
 ended: true,
 ending_images:[
   {img: "VGhpcyBpcyBzb21lIGV4YW1wbGUgZGF0YS4=",
    description: "This is a pretty cool image"}
   ... //more images
 ]
}
 