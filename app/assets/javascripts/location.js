$(function(){


  var getLocation = function(){
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(setPosition, askPosition);
    }
  }

  var setPosition = function(position){
    console.log(position)
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;
    lat += Math.random() / 100;
    lng += Math.random() / 100;
    getAddress(lat.toFixed(5), lng.toFixed(5))
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
        var city = 'not found';
        var address = 'not found';

        if(response['results'].length == 0) {
          console.log("No geocode results");
        } else {
          // console.log(response);
          city = response["results"][0]["address_components"][3]["long_name"];
          address = response["results"][0]["formatted_address"];
          //console.log(city);
          //console.log(address);
        }
//
displayLocation(lat, lng, city, address)
}
});
  }

  var displayLocation = function(lat, lng, city, address)
  {
    la = '<li id="city">'+city+'</li>'
    $('#location').append(la);
    $('#location').append('<li id="lat">'+lat+'</li>');
    $('#location').append('<li id="lng">'+lng+'</li>');
    $('#location').append('<li id="address">'+address+'</li>');
    console.log(city)

    postRequest(city, lat, lng, address)
  }

  var postRequest = function(city, lat, lng, address){
    $.ajax({
      type: "POST",
      url:  "/locations",
      data: { location: {
        latitude: lat,
        longitude: lng,
        address: address,
        city: city
      }
    }
  }).done(function(data){
    $.ajax({
      type: "GET",
      url: "/locations/"+data.id+"/forecasts",
    }).done(function(response){
      console.log(this);
      console.log(response);
      for(var i= 0; i < Object.keys(response).length; i++){
        console.log(response[i]);
        $('#weather').append('<li>' + response[i].forecast_day + ': ' + response[i].weather + '</li>');
        if (response[i].inspection == true) {
          $('#weather').append('<li> Inspection required on :'+ response[i].forecast_day + '</li>');
        }
      };
    })
  })

}

getLocation();
setTimeout(function(){console.log(this)}, 2000);
});


