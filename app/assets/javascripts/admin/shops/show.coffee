$('.admin_shop_show').ready ->
  $._deleteOrRevivalButton = $('#deleteOrRevivalButton')
  $._deletedMessage = $('.deleted_message')
  $._userId = $('.admin_shop_show_userId')
  $._OnClickDeleteOrRevivalButton()

$._OnClickDeleteOrRevivalButton = () ->
  swalDeleteButton = Swal.mixin({
      customClass: {
        confirmButton: 'btn btn-success',
        cancelButton: 'btn btn-danger'
    },
    buttonsStyling: false
  })

  $._deleteOrRevivalButton.click ->
    base_url = "/admin/shops/" + $._userId.val()
    if $(this).hasClass("delete") 
      text = "削除"
      url = base_url
      type = "DELETE"
      changeText = "復元"
      changeClass = "btn btn-success revival"
    else
      text = "復活"
      url = base_url + "/revival"
      type = "PATCH"
      changeText = "削除"
      changeClass = "btn btn-danger delete"
  
    swalDeleteButton.fire({
      title: "確認してください",
      text: "本当に" + text + "しますか？",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: text + "する",
      cancelButtonText: "キャンセル",
      reverseButtons: true
    })
    .then (result) ->
      if result.isConfirmed
        $.ajax
          url: url,
          type: type,
          dataType: "json"
        .done (data) ->
          # ボタンのテキストを変更
          $._deleteOrRevivalButton.text(changeText)
          # ボタンのデザインを変更
          $._deleteOrRevivalButton.removeClass()
          $._deleteOrRevivalButton.addClass(changeClass)
          # 「削除済み」メッセージの制御
          if $._deletedMessage.is(':visible') then $._deletedMessage.hide() else $._deletedMessage.show()
          Swal.fire(
            text + "しました!",
            '正常に' + text + 'されました！',
            'success'
          )
        .fail (data) ->
          Swal.fire(
            text + 'に失敗しました...',
            '再度実行してください',
            'error'
          )
