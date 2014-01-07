$(function(){

  //UPDATE LOC BUTTON!!
  $("#updateLoc").click(function(){
    $.cookie("location", undefined);
    $.cookie("city",undefined);  //20 minutes
    $.cookie("address", undefined);
    $('#current_location').empty();
    $('#current_lat').empty();
    $('#current_lng').empty();
    $('#current_weather').empty();
    $('#current_inspection').empty();
    getLocation();
  })


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

    var latlng = lat + "," + lng;
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
            address = response["results"][0]["formatted_address"];
            street = response["results"][0]["address_components"][0]["long_name"] + ' ' + response["results"][0]["address_components"][1]["long_name"];
            city = response["results"][0]["address_components"][3]["long_name"];
            state = response["results"][0]["address_components"][5]["long_name"];
            zip = response["results"][0]["address_components"][7]["long_name"];
          };
          console.log("address", address)

          $.cookie("city", city, {expires: 20/(24*60)} )  //20 minutes
          $.cookie("address", address, {expires: 20/(24*60)} )  //20 minutes
          $.cookie("state", state, {expires: 20/(24*60)} )  //20 minutes
          $.cookie("zip", zip, {expires: 20/(24*60)} )  //20 minutes


          displayLocation(lat, lng, address, street, city, state, zip);  //perform callback
          }
        }); //end ajax request to google map api

    //  the conditional with the cookie here is now taken cared of in the backend "locations_user" model validations
    // } else {
    //       var city =  $.cookie("city")
    //       var address = $.cookie("address")
    //       displayLocation(lat, lng, city, address);
    // }


  } // end getAddress function

  var displayLocation = function(lat, lng, address, street, city, state, zip) {
    console.log("the address is ", address)
    la = '<li id="city">'+city+'</li>'
    $('#location').append(la);
    $('#location').append('<li id="lat">'+lat+'</li>');
    $('#location').append('<li id="lng">'+lng+'</li>');
    $('#location').append('<li id="address">'+address+'</li>');
    $('#current_location').append('Your device indicates that you are currently located at: ' + address);
    // $('#current_lat').append(typeof(lat));
    $('#current_lat').append('Latitude: ' + parseFloat(lat).toFixed(5));
    $('#current_lng').append('Longitude: ' + parseFloat(lng).toFixed(5));

    //Creates a new project if the OK button is clicked
    $('#create_new_loc').click(function(){
      postRequest(lat, lng, address, street, city, state, zip); // POST these params to my backend locations table
      $('#create_new_loc').hide();
      $('#get_forecast').hide();
      $('#current_location').append('<p>Please refresh your page to see your most current active jobs</p>');
    });

    //get forecaset
    $('#get_forecast').click(function(){
      $.ajax({
        type: "GET",
        url: "/locations/forecast_json",
        data: {
          lat: lat,
          lng: lng
        }
      }).done(function(response){
        // console.log(this);
        console.log(response);
        // debugger
        $('#current_weather').append('Local Forecast: '+ response[0].weather);
        $('#current_inspection').append('Site Inspection Required? '+ response[0].inspection.toString());
        $('#get_forecast').hide();
        for(var i= 0; i < Object.keys(response).length; i++){
          console.log(response[i]);
          $('#weather').append('<li>' + response[i].forecast_day + ': ' + response[i].weather + '</li>');
          if (response[i].inspection == true) {
            $('#weather').append('<li> Inspection required on :'+ response[i].forecast_day + '</li>');
          };
        };
    }) // end .done function
    }) // end GET get_forecast ajax call
  }

  var postRequest = function(lat, lng, address, street, city, state, zip){
    console.log(lat);
    console.log(lng);
    $.ajax({
      type: "POST",
      url:  "/locations", //locations controller
      data: { location: {
        latitude: lat,
        longitude: lng,
        address: address,
        street: street,
        city: city,
        state: state,
        zip: zip
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
        $('#current_weather').append('Local Forecast: '+ response[0].weather);
        $('#current_inspection').append('Site Inspection Required? '+ response[0].inspection.toString());

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

if(gon.current_user && window.location.href.match(/\/users\/\d*/)){
  console.log( "the coookie address is ", $.cookie("location"))
  // if cookie is empty perform the getLocation() function
  if($.cookie("location") === undefined){
    console.log(gon.current_user);
    getLocation();

  }else{
    // otherwise, present a dialog box asking the user whether the current location
    // is something they want to use, if "ok" -> uses getAddress(loc) is passed with the location data stored in the cookie
    // if "cancel" is pressed, call getLocation() again to get new

      var loc = $.cookie("location");
      loc = loc.split(",");
      getAddress(loc[0],loc[1]);

  }; //end if cookie is empty
}else{
  // $.cookie("address", undefined)
  console.log("not logged in")
}; // end gon.current_user




// setTimeout(function(){console.log(this)}, 2000);
}); //end document.ready()


