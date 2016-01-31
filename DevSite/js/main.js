$('document').ready(function(){
    $('.flexslider').flexslider({
        animation: "slide", // Set "fade" or "slide" for your desire effect
        directionNav: false,
        animationLoop: true,
        controlNav: false, 
        slideshow: true,
        animationDuration: 600
    }); 
    
    $('.flexslider_port').flexslider({
        animation: "slide", // Set "fade" or "slide" for your desire effect
        directionNav: false,
        animationLoop: true,
        controlNav: true, 
        slideshow: true,
        animationDuration: 600
    }); 
    
    
    
    /*****************************
****    DROPDOWN MENU     ****
******************************/
    
    $("<select />").appendTo("#MobileNavigation");
      
    $("nav a").each(function() {
        var el = $(this);
        if(el.attr("class") == "current_page"){
            $("<option />", {
                "value"   : el.attr("href"),
                "selected": "selected",
                "text"    : el.text()
            }).appendTo("nav select");
        }else{
            $("<option />", {
                "value"   : el.attr("href"),
                "text"    : el.text()
            }).appendTo("nav select");
        }
    });
    
    $("nav select").change(function() {
        window.location = $(this).find("option:selected").val();
    });
    
    $('#MobileNavTrigger').text($(".MainNavigation").find(".current_page").text());
    
    /*****************************
****   =DROPDOWN MENU     ****
******************************/
    
    
    
    
    
    /*****************************
****   RESPONSIVE VIDEOS  ****
******************************/
    
    var $allVideos = $("iframe[src^='http://player.vimeo.com'], iframe[src^='http://www.youtube.com'], object, embed"),
    $fluidEl = $("figure");
	    	
    $allVideos.each(function() {
	
        $(this)
        // jQuery .data does not work on object/embed elements
        .attr('data-aspectRatio', this.height / this.width)
        .removeAttr('height')
        .removeAttr('width');
	
    });
	
    $(window).resize(function() {
	
        var newWidth = $fluidEl.width();
        $allVideos.each(function() {
	  
            var $el = $(this);
            $el
            .width(newWidth)
            .height(newWidth * $el.attr('data-aspectRatio'));
	  
        });
	
    }).resize();
    
    
    /*****************************
****  =RESPONSIVE VIDEOS  ****
******************************/
    
    
    
    
    /* Contact Form */    
    $('#contactform').submit(function(){

        var action = $(this).attr('action');

        $('#submit').attr('disabled','disabled').after('<img src="assets/ajax-loader.gif" class="loader" />');

        $("#message").slideUp(750,function() {
            $('#message').hide();

            $.post(action, {
                name: $('#name').val(),
                email: $('#email').val(),
                phone: $('#phone').val(),
                subject: $('#subject').val(),
                comments: $('#comments').val(),
                verify: $('#verify').val()
            },
            function(data){
                document.getElementById('message').innerHTML = data;
                $('#message').slideDown('slow');
                $('#contactform img.loader').fadeOut('fast',function(){
                    $(this).remove()
                    });
                $('#submit').removeAttr('disabled');
                if(data.match('success') != null) $('#contactform').slideUp('slow');

            }
            );

        });

        return false;

    });

    
    
    
    
    /* Photoswipe */
    $('.PhotoSwipe').photoSwipe();
});