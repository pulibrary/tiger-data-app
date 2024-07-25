// eslint-disable-next-line import/prefer-default-export
export function displayMediafluxVersion(url, authenticated) {
  const placeholderInPage = $('#mediaflux_version').length === 1;
  if (placeholderInPage === true && authenticated) {
    $.ajax({
      type: 'GET',
      url,
      success(data) {
        $('#mediaflux_version').text(`| Mediaflux: ${data.version}`);
      },
      error(_jqXHR, _textStatus, errorThrown) {
        console.error(errorThrown);
      },
    });
  }
}

// eslint-disable-next-line import/prefer-default-export
export function displayMediafluxStatus(url) {
  const placeholderInPage = $('.mediaflux-status').length === 1;
  if (placeholderInPage === false) {
    return;
  }

  // Intervals in milliseconds
  const TIME_SHORT = 2000;
  const TIME_NORMAL = 10000;
  const TIME_LONG = 30000;

  let checkCount = 0;
  const checkStatus = function checkStatus() {
    let waitTime;
    checkCount += 1;
    if (checkCount < 10) {
      // page has just been loaded: check often
      waitTime = TIME_SHORT;
    } else if (checkCount < 20) {
      // page has been loaded for a while: check less often
      waitTime = TIME_NORMAL;
    } else {
      // page has been loaded for a long time: check even less often
      waitTime = TIME_LONG;
    }
    $.ajax({
      type: 'GET',
      url,
      success() {
        $('.mediaflux-status').addClass('active');
        $('.mediaflux-status').removeClass('inactive');
        setTimeout(checkStatus, waitTime);
      },
      error() {
        $('.mediaflux-status').removeClass('active');
        $('.mediaflux-status').addClass('inactive');
        setTimeout(checkStatus, TIME_SHORT);
      },
    });
  };

  checkStatus();
}
