//ここに追加したいJavaScript、jQueryを記入してください。
//このJavaScriptファイルは、親テーマのJavaScriptファイルのあとに呼び出されます。
//JavaScriptやjQueryで親テーマのjavascript.jsに加えて関数を記入したい時に使用します。


(function($){
	$(function(){
  	var explode = 8; /*省略したい文字数パンクズ*/
  	var bc = $("#breadcrumb").find("div").not(":first");
    bc.find("a span").each(function(){
    	var str = $(this).text(),
      		reStr = str.substr(0,explode) + "…";
      $(this).text(reStr).closest("a").attr("title", str);
    });
  });
})(jQuery);




// 固定blink-pageの点滅
jQuery(function($) {
    setInterval(function() {
        $('.blink-page').css('visibility', $('.blink-page').css('visibility') == 'hidden' ? 'visible' : 'hidden');
    }, 800);
});


// クリックで開くボタン
jQuery(function($) {
        $(".toggle-more-button").on("click", function() {
            $(this).next().slideToggle();
        });
    });



