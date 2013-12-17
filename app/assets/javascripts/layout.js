$(function(){

  // only use this for web splash page exclusively
  if (window.navigator.standalone===true) {
    $('.splash').hide();
    $('.add-to-home').hide();
  }

  $('.signin').fadeIn();

  // stop bounce effect
  $('.splash').on("touchmove", function(evt) { evt.preventDefault() });
  $('.menu').on("touchmove", function(evt) { evt.preventDefault() });
  $('.fixed-container').on("touchmove", function(evt) { evt.preventDefault() });
  $('.track-job-container').on("touchmove", function(evt) { evt.preventDefault() });
  // $(document).on("touchmove", ".scrollable", function(evt) { evt.stopPropagation() });

  var $itemContent = $(".menu");
  var $bodyContent = $(".container");

  $(".menu-button").click(function(e){
    e.preventDefault();
    $(".menu").removeClass('slideout-left');
    $(".menu").addClass('slidein-left');
    $(".container").removeClass('slidein-right');
    $(".container").addClass('slideout-right');
  });

  $(".menu").click(function(){
    $(".menu").removeClass('slidein-left');
    $(".menu").addClass('slideout-left');
    $(".container").removeClass('slideout-right');
    $(".container").addClass('slidein-right');
  });

  $(".start .entypo-up-open-big").click(function(e){
    e.preventDefault();
    $(".splash").addClass('slideup');
  });

  $(".splash").hammer().on("swipeup", function(){
    $(".splash").addClass('slideup');
  });

  $(".alert button").click(function(e){
    e.preventDefault();
    $('.alert').hide();
  });

  $(".menu").hammer().on("swipeleft", function(){
    $(".menu").removeClass('slidein-left');
    $(".menu").addClass('slideout-left');
    $(".container").removeClass('slideout-right');
    $(".container").addClass('slidein-right');
  });

  $(".menu").hammer().on("swipedown", function(evt){
    evt.preventDefault();
  });

  // $('.track-job-container').hammer().on('dragdown', function(){
  //   if ($('.track-job-container').scrollTop() ===0) {
  //     $('.refresh').slideDown('fast');
  //     $('.track-job-container').hammer().on('dragend', function(){
  //       $('.refresh').hide();
  //       location.reload();
  //     });
  //   };
  // });

  // $('.track-job-container').hammer().on('swipeup', function(){
  //   $('.track-job-container').animate({
  //     scrollTop: $('.track-job-container').scrollTop()+140
  //   }, 'fast');
  // });

  // $('.track-job-container').hammer().on('swipedown', function(){
  //   $('.track-job-container').animate({
  //     scrollTop: $('.track-job-container').scrollTop()-140
  //   }, 'fast');
  // });

  // $('input[type=text]').focus(function() {
  //   $(this).val('');
  // });

  // $('input[type=email]').focus(function() {
  //   $(this).val('');
  // });

  // $('input[type=password]').focus(function() {
  //   $(this).val('');
  // });

  // $('input[type=number]').focus(function() {
  //   $(this).val('');
  // });

  // $('input').on('change', function(){
  //   $('body,html').animate({
  //     scrollTop: '1px'
  //   });
  // });

  $('body,html').animate({
    scrollTop: '1px'
  });


})