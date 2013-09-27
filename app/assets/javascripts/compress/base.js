/*
 *
 * ==========================================================================================================
*/
var tian = {
    redirect: function(url,delay) {
        setTimeout(function(){
            window.location = url;
        },delay);
    },
    show_error_note: function(msg,delay) {
        if(!delay){
            delay=3000;
        }
        var icon = '<img src="/assets/jbar_error_new.gif" width="31" height="31" />';
        tian.show_notify_bar(icon+msg,'error',delay,"bar_error");
    },
    show_ok_note:function(msg,delay) {
        if(!delay){
            delay=2000;
        }
        var icon = '<img src="/assets/jbar_ok_new.gif" width="31" height="31" />';
        tian.show_notify_bar(icon+msg,'ok',delay,"bar_ok");
    },
    show_notice_note:function(msg,delay) {
        if(!delay){
            delay=3000;
        }
        var icon = '<img src="/assets/jbar_notice_new.gif" width="31" height="31" />';
        tian.show_notify_bar(icon+msg,'notice',delay,"bar_notice");
    },
    show_notify_bar: function(msg,type,delay) {
        var bgcolor ,fntcolor;
        if(!type || type == 'ok'){
            type = 'ok';
            bgcolor =  '#fff' ;
            fntcolor = '#222';
            className = 'jbar-ok';
        }else if(!type || type == 'error'){
            type = 'error';
            bgcolor =  '#fff';
            fntcolor = '#222';
            className = 'jbar-error';
        }else{
            type = 'notice';
            bgcolor =  '#fff';
            fntcolor = '#222';
            className = 'jbar-notice';
        }
        $.show_notify_bar({
            color 			 : fntcolor,
            background_color : bgcolor,
            position		 : 'top',
            removebutton     : true,
            message			 : msg,
            time			 : delay,
            container: '#doc',
            className : className
        });
    }
};

//初始化常用功能
tian.initial = function()
{
    /* 此类为hash链接 */
    $('a.ajax-hash').on('click',function(){
        var hash = this.hash && this.hash.substr(1);
        if (hash != ""){
            eval(hash + '.call(this);');
        }
        return false;
    });

    /* 此类为确认后执行的ajax操作 */
    $('a.confirm-request').on('click',function(){
        if(confirm('确认执行这个操作吗?')){
            $.get($(this).attr('href'));
        }
        return false;
    });


};


/**
 * 允许多附件上传
 */
tian.record_asset_ids = function(id,block_id){
    var ids = $(block_id).val();
    if (ids.length == 0){
        ids = id;
    }else{
        if (ids.indexOf(id) == -1){
            ids += ','+id;
        }
    }
    $(block_id).val(ids);
};

//移除附件id
tian.remove_asset_id = function(id,block_id){
    var ids = $(block_id).val();
    var ids_arr = ids.split(',');
    var is_index_key = tian.in_array(ids_arr,id);
    ids_arr.splice(is_index_key,1);
    ids = ids_arr.join(',');
    $(block_id).val(ids);
};

//查看字符串是否在数组中存在
tian.in_array = function(arr, val) {
    var i;
    for (i = 0; i < arr.length; i++) {
        if (val === arr[i]) {
            return i;
        }
    }
    return -1;
}; // 返回-1表示没找到，返回其他值表示找到的索引

//返回顶部
tian.go_top = function(){
	$('#goTopButton').click(function(event){
		$('html, body').animate({scrollTop:0}, 800);
	});
	$(window).scroll(function(event){
		if($(this).scrollTop() > 0){
			if($.browser.ie6){
				$('#goTopButton').css('top', $(this).scrollTop() + $(this).height() - 170);
			}
			if($('#goTopButton').css('display') == 'none'){
				$('#goTopButton').fadeIn();
			}
		}else{
			$('#goTopButton').fadeOut();
		}

		//顶部消息框位置
		var dis = 10 - $(this).scrollTop();
		if( 0<dis && dis<=10 ){
			$("#header-noti").css("top",dis+"px");
		}else{
			$("#header-noti").css("top","0");
		}
	});
}

/*邮箱地址跳转*/
tian.open_email=function(){
	var email = $(this).attr('email');
    var domain = email.substr(email.indexOf('@') + 1);
    var url = '';
    switch(domain){
        case "gmail.com":{
            url = "http://mail.google.com";
            break;
        }
        case "hotmail.com":{
            url = "http://www.hotmail.com";
            break;
        }
        default:{
            url = 'http://mail.' + domain + '/';
        }
    }
    //新窗口
    window.open(url);
};
