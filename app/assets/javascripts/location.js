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

    var latlng = lat.toFixed(5) + "," + lng.toFixed(5);
    $.cookie("location", latlng, {expires: 20/(24*60)})
    getAddress(lat.toFixed(5), lng.toFixed(5)) //toFixed(5) up to 5 sigfigs
  }

  var askPosition = function(position){
    address = prompt("Please enter your location.")
  }

  // using lat/lng from navigator.getCurrentPosition, then passing to google map api
  // get address & city

  var getAddress = function(lat, lng) {

    var latlng = lat + "," + lng;

    // if($.cookie("address") === undefined && $.cookie("city") === undefined){
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
          console.log("address", address)

          $.cookie("city", city, {expires: 20/(24*60)} )  //20 minutes
          $.cookie("address", address, {expires: 20/(24*60)} )  //20 minutes


          displayLocation(lat, lng, city, address);  //perform callback

          }
        }); //end ajax request to google map api
    // } else {
    //       var city =  $.cookie("city")
    //       var address = $.cookie("address")
    //       displayLocation(lat, lng, city, address);
    // }


  } // end getAddress function

  var displayLocation = function(lat, lng, city, address) {
    console.log("the address is ", address)
    la = '<li id="city">'+city+'</li>'
    $('#location').append(la);
    $('#location').append('<li id="lat">'+lat+'</li>');
    $('#location').append('<li id="lng">'+lng+'</li>');
    $('#location').append('<li id="address">'+address+'</li>');
    $('#current_location').append(address);
    $('#current_lat').append(lat);
    $('#current_lng').append(lng);

    //console.log(city)

    postRequest(lat, lng, city, address); // POST these params to my backend locations table
  }

  var postRequest = function(lat, lng, city, address){
    console.log(lat);
    console.log(lng);
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




// check to see if user is logged in before calling any location functions:

if(gon.current_user){

  // if cookie is empty perform the getLocation() function
  if($.cookie("location") === undefined){
    console.log(gon.current_user);
    getLocation();

  }else{
    console.log("ther loc is ", $.cookie("location"));
    // otherwise, present a dialog box asking the user whether the current location
    // is something they want to use, if "ok" -> uses getAddress(loc) is passed with the location data stored in the cookie
    // if "cancel" is pressed, call getLocation() again to get new
    var dialog = confirm("Use this location? "+ $.cookie("address"));
    if (dialog == true){
      var loc = $.cookie("location");
       loc = loc.split(",");
       getAddress(loc[0],loc[1]);
    } else {
      getLocation();
    };
  }; //end if cookie is empty
}else{
  console.log("not logged in")
}; // end gon.current_user




// setTimeout(function(){console.log(this)}, 2000);
}); //end document.ready()


