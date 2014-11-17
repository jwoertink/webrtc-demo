var ua, server;
var login = function(e) {
  e.preventDefault();

  var username = document.querySelector('#username').value,
      password = document.querySelector('#password').value;
  server = document.querySelector('#server').value;

  var configuration = {
    'ws_servers': ('ws://' + server + ':8088/ws'),
    'uri': ('sip:' + username + '@' + server),
    'password': password
  };
  ua = new JsSIP.UA(configuration);
  ua.start();
};

var makeCall = function(e) {
  e.preventDefault();

  if(!ua) {
    alert('You must be logged in first');
    return false;
  } else {
    var localVideo = document.getElementById('local');
    var remoteVideo = document.getElementById('remote');
    var eventHandlers = {
      'progress': function(e) {
        console.log('call is in progress');
      },
      'failed': function(e) {
        console.log('call failed with cause: '+ e.data.cause);
      },
      'ended': function(e) {
        console.log('call ended with cause: '+ e.data.cause);
      },
      'confirmed': function(e) {
        var rtcSession = e.sender;
        console.log('call confirmed');

        // Attach local stream to selfView
        if (rtcSession.getLocalStreams().length > 0) {
          localVideo.src = window.URL.createObjectURL(rtcSession.getLocalStreams()[0]);
        }
        // Attach remote stream to remoteView
        if (rtcSession.getRemoteStreams().length > 0) {
          remoteVideo.src = window.URL.createObjectURL(rtcSession.getRemoteStreams()[0]);
        }
      }
    };
    var options = {
      'eventHandlers': eventHandlers,
      'mediaConstraints': {'audio': true, 'video': true}
    };
    var extension = document.querySelector('#extension').value;
    var target = 'sip:'+extension+'@'+server;
    ua.call(target, options);
  }
};

window.onload = function() {
  document.querySelector('#login').addEventListener('click', login, false);
  document.querySelector('#call').addEventListener('click', makeCall, false);
};
