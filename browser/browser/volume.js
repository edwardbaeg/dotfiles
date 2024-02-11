function amplifyMedia(mediaElem, multiplier) {
  var context = new (window.AudioContext || window.webkitAudioContext)(),
    result = {
      context: context,
      source: context.createMediaElementSource(mediaElem),
      gain: context.createGain(),
      media: mediaElem,
      amplify: function (multiplier) {
        result.gain.gain.value = multiplier;
      },
      getAmpLevel: function () {
        return result.gain.gain.value;
      },
    };
  result.source.connect(result.gain);
  result.gain.connect(context.destination);
  result.amplify(multiplier);

  return result;
}

const vid = document.querySelector("video");
amplifyMedia(vid, 4);