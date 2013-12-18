$(function(){

  // JS:  gets currentPosition from user device.
  // If navigator.geolocation exist, sePosition function gets called
  // otherwise, askPosition function is executed

  var getLocation = function(){
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(setPosition, askPosition);
    }
  }

  var setPosition = function(position){
    console.log(position)
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;
    //randomize lat, lng for development only
    lat += Math.random() / 100;
    lng += Math.random() / 100;
    getAddress(lat.toFixed(5), lng.toFixed(5)) //toFixed(5) up to 5 sigfigs
  }

  var askPosition = function(position){
    address = prompt("Please enter your location.")
  }

  // using lat/lng from navigator.getCurrentPosition, then passing to google map api
  // get address & city

  var getAddress = function(lat, lng) {
    var latlng = lat + "," + lng;

    var request = $.ajax({
      type: "GET",
      url: "http://maps.googleapis.com/maps/api/geocode/json",
      data: {latlng: latlng, sensor: true},
      dataType: 'json',
      success: function (response) {
        var city = 'not found';
        var address = 'not found';

        if(response['results'].length == 0) {
          console.log("No geocode results");
        } else {
          // console.log(response);
          city = response["results"][0]["address_components"][3]["long_name"];
          address = response["results"][0]["formatted_address"];
        };

      displayLocation(lat, lng, city, address);  //perform callback

      }
    }); //end ajax request to google map api
  } // end getAddress function

  var displayLocation = function(lat, lng, city, address) {
    la = '<li id="city">'+city+'</li>'
    $('#location').append(la);
    $('#location').append('<li id="lat">'+lat+'</li>');
    $('#location').append('<li id="lng">'+lng+'</li>');
    $('#location').append('<li id="address">'+address+'</li>');
    $('#current_location').append(address);
    $('#current_lat').append(lat);
    $('#current_lng').append(lng);

    //console.log(city)

    postRequest(lat, lng, city, address) // POST these params to my backend locations table
  }

  var postRequest = function(lat, lng, city, address){
    $.ajax({
      type: "POST",
      url:  "/locations", //locations controller
      data: { location: {
        latitude: lat,
        longitude: lng,
        address: address,
        city: city
        }
      }
    }).done(function(data){
    // once these locations attr are saved in backend,
    // grab the json returned from the forecasts controller

      $.ajax({
        type: "GET",
        url: "/locations/"+data.id+"/forecasts",
      }).done(function(response){
        // console.log(this);
        console.log(response);
        // debugger
        $('#current_weather').append(response[0].weather);
        $('#current_inspection').append(response[0].inspection.toString());

        for(var i= 0; i < Object.keys(response).length; i++){
          console.log(response[i]);
          $('#weather').append('<li>' + response[i].forecast_day + ': ' + response[i].weather + '</li>');
          if (response[i].inspection == true) {
            $('#weather').append('<li> Inspection required on :'+ response[i].forecast_day + '</li>');
          };
        };
    }) // end .done function
    }) // end POST ajax call
  } // end postRequest

if(gon.current_user){
  console.log(gon.current_user);
  getLocation();
}else{
  console.log("not logged in.");
}

// setTimeout(function(){console.log(this)}, 2000);
});


