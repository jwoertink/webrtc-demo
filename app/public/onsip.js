var domain, aliceURI, bobURI, aliceUA, session;

// A shortcut function to construct the media options for an SIP session.
function mediaOptions(useAudio, useVideo) {
  return {
    media: {
      constraints: {
        audio: useAudio,
        video: useVideo
      },
      render: {
        remote: {
          video: document.getElementById('remote')
        },
        local: {
          video: document.getElementById('local')
        }
      }
    }
  };
}

// Makes a call from a user agent to a target URI
function makeCall(userAgent, target, useAudio, useVideo) {
  var options = mediaOptions(useAudio, useVideo);
  // makes the call
  var session = userAgent.invite('sip:' + target, options);
  return session;
}

function setUpVideoInterface(userAgent, target) {
  var onCall = false;

  // Handling invitations to calls.
  // Also, for each new call session, we need to add an event handler to set
  // the correct state when we receive a "bye" request.
  userAgent.on('invite', function (incomingSession) {
    onCall = true;
    session = incomingSession;
    var options = mediaOptions(true, true);

    session.accept(options);
    session.on('bye', function() {
      onCall = false;
      session = null;
    });
  });
  onCall = true;
}

var login = function(e) {
  e.preventDefault();

  domain = document.querySelector('#server').value;
  aliceURI = document.querySelector('#username').value + '@' + domain;
  bobURI = document.querySelector('#extension').value + '@' + domain;

  aliceUA = new SIP.UA({
    traceSip: true,
    uri: aliceURI
  });

  setUpVideoInterface(aliceUA, bobURI);
};

var setupCall = function(e) {
  e.preventDefault();

  session = makeCall(aliceUA, bobURI, true, true);

  session.on('bye', function () {
    onCall = false;
    session = null;
  });
};

var hangup = function(e) {
  e.preventDefault();
  session.bye();
};

window.onload = function() {
  document.querySelector('#login').addEventListener('click', login, false);
  document.querySelector('#call').addEventListener('click', setupCall, false);
  document.querySelector('#bye').addEventListener('click', hangup, false);
};
