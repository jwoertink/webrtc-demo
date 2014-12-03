var ua, server, callOptions, session;
var localVideo = document.getElementById('local');
var remoteVideo = document.getElementById('remote');

var login = function(e) {
  e.preventDefault();

  var username = document.querySelector('#username').value,
      password = document.querySelector('#password').value;
  server = document.querySelector('#server').value;

  var configuration = {
    register: true,
    registerExpires: 90,
    registrarServer: ('sip:' + server),
    wsServers: ('ws://' + server + ':8088/ws'),
    uri: ('sip:' + username + '@' + server),
    authorizationUser: username,
    password: password,
    displayName: username,
    hackIpInContact: true,
    traceSip: true,
    log: { level: 'debug' },
    stunServers: 'stun:stun.l.google.com:19302'
  };
  callOptions = {
    media: {
      constraints: { audio: true, video: true } ,
      render: {
        local: { video: localVideo },
        remote: { video: remoteVideo }
      }
    }
  };

  ua = new SIP.UA(configuration);
  ua.on('invite', function(incomingCall){
    session = incomingCall;
    session.accept(callOptions);
    session.on('bye', function() {
      session = null;
    });
  });
  ua.on('connected', function() {
    console.log('connected');
  });
  ua.on('unregistered', function(cause) {
    console.log('unregistered', cause);
  });
  ua.on('registrationFailed', function(cause) {
    console.log('registrationFailed', cause);
  });
  ua.on('disconnected', function(cause) {
    console.log('disconnected', cause);
  });
};

var makeCall = function(e) {
  e.preventDefault();

  if(!ua) {
    alert('You must be logged in first');
    return false;
  } else {
    var extension = document.querySelector('#extension').value;
    var target = 'sip:'+extension+'@'+server;
    session = ua.invite(target, callOptions);
  }
};

window.onload = function() {
  document.querySelector('#login').addEventListener('click', login, false);
  document.querySelector('#call').addEventListener('click', makeCall, false);
};
