$(function(){


  var getLocation = function(){
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(setPosition, askPosition);
    }
  }

  var setPosition = function(position){
    console.log(position)
    lat = position.coords.latitude;
    lng = position.coords.longitude;
    getAddress(lat, lng)
    // console.log("The position is ", position)
  }

  var askPosition = function(position){
    address = prompt("Please enter your location.")
  }

  var getAddress = function(lat, lng) {
    var latlng = lat + "," + lng;

    var request = $.ajax({
      type: "GET",
      url: "http://maps.googleapis.com/maps/api/geocode/json",
      data: {latlng: latlng, sensor: true},
      dataType: 'json',
      success: function (response) {
        // console.log(response);
         var city = response["results"][0]["address_components"][3]["long_name"];
         var address = response["results"][0]["formatted_address"];
        // console.log(city);
        // console.log(address);
//
        doStuff(city,address)
      }
    });
  }

  var doStuff = function(city, address)
  {
    la = '<li id="city">'+city+'</li>'
    $('#location').append(la);
    $('#location').append('<li id="address">'+address+'</li>');
    $('#location').append('<li id="blah">blah</li>');
    console.log(city)
  }

  getLocation();
  setTimeout(function(){console.log(this)}, 2000);
});


