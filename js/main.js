
$(document).ready(function() {
  var navpos = $('.header').offset();
  $(window).bind('scroll', function() {
    if ($(window).scrollTop() > navpos.top) {
      $('.header').addClass('fixed');
     }
     else {
       $('.header').removeClass('fixed');
     }
  });
  var wxpos = $('#weixin-btn').offset();
  $('#weixin-qr').css({
    top: wxpos.top + 45,
    left: wxpos.left - 40,
  });
  $('#weixin-btn').hover(function() {
    console.log('mouseover!');
    $('#weixin-qr').css('display', 'block');
  }, function() {
    $('#weixin-qr').css('display', 'none');
  });
});
