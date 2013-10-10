//后台左侧导航
$(function(){

    //全选
    $("#select_all").bind('click',function(){
        $("input:checkbox[name]").each(function(){
            $(this).prop("checked", true);
        });
    });
	
    //反选
    $("#select_un").bind('click',function(){
        $("input:checkbox[name]").each(function(){
            $(this).prop("checked",!this.checked);
        });
    });
	
    //取消
    $("#select_cancel").bind('click',function(){
        $("input:checkbox[name]").each(function(){
            $(this).prop("checked", false);
        });
    });
	
    //具体操作,传递数组ids
    $(".select_post").bind('click',function(){
        var arrChk = new Array()
        $("input:checkbox[name]").each(function(){
            if($(this).is(':checked')){
                arrChk+=this.value + ',';
            }
        });

        if(arrChk != ''){
            if(!confirm("确定要执行此操作？")){
                return false
            }
            var to_url=$(this).attr("href")
            $.ajax({
                url: to_url,
                type: 'post',
                data: {
                    'ids' : arrChk
                }
            });
        }
        else{
            alert("请至少选择一项");
        }
        //禁止本身的href事件
        return false;
    });


})
