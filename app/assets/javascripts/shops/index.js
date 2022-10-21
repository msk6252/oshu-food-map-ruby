const onClickCurrentPositionSearch = () => {
  $('.js-shopIndexCurrentPositionSearch').click(() => {
    // navigatorのオプション
    var options = {
      enableHighAccuracy: true,
      timeout: 5000,
      maximumAge: 0
    }

    if (navigator.geolocation) {
      getLocation()
    } else {
      alert('現在地の取得ができませんでした。設定を確認してください')
    }
  })
}

const getCurrentPosition = (options) => {
  return new Promise((resolve, reject) => {
    navigator.geolocation.getCurrentPosition(resolve, reject, options)
  })
}

const getLocation = async () => {
  $.LoadingOverlay("show")
  try {
    var position = await getCurrentPosition()
    var lat = position.coords.latitude
    var lng = position.coords.longitude
    if (lat && lng) {
      window.location.href = `/result?lat=${lat}&lng=${lng}`
    }
  } catch(err) {
    alert("現在地が取得できませんでした。設定を確認してください")
  } finally {
    $.LoadingOverlay("hide")
  }
}


$('.js-shopIndex').ready(() => {
  onClickCurrentPositionSearch()
})

