$(document).on('turbolinks:load', function(){
  function buildHTML(img, number){ 
  html = `<div class="exhibit-wrapper__main__image__cards__card">
            <div class="exhibit-wrapper__main__image__cards__card__image">
              <img src= '${img}' class: 'exhibit-image'>
            </div>
            <div class="exhibit-wrapper__main__image__cards__card__button">
              <p class="item-image__delete-button__append" data-image=${number}>削除</p>
            </div>
          </div>`;
  return html;
  }
  var drag_space = $(".exhibit-wrapper__main__image__drag")
  var drag_space_form = $(".exhibit-wrapper__main__image__drag__form")
  var counter = $(".exhibit-wrapper__main__image__cards")
  // ドラッグイベントは未実装です
  drag_space.on('dragenter', function(e){
    e.preventDefault();
    $(this).css("border", "2px solid rgba(204,204,204,0.9)");
  });
  drag_space.on('dragover', function(e){
    e.preventDefault();
  });
  drag_space.on('drop', function(e){
    $(this).css('border', '2px dotted rgba(204,204,204,0.9)');
    e.preventDefault();
    document.getElementById(".exhibit-wrapper__main__image__drag__form").files = e.originalEvent.dataTransfer.files;
  });
  drag_space_form.on("change", function(e){
    var number = counter.attr("data-exhibitid");
    var new_number =  Number(number) + 1;
    counter.attr("data-exhibitid", new_number);
    // 発動したformの番号を取得する
    var id_str = $(this).attr('id');
    var id_int = id_str.replace(/[^0-9]/g, '');
    // formの順番を入れ替え、次の画像登録に備える
    $(this).prop('readonly', true);
    $(this).next().prop('readonly', false);
    $(".exhibit-wrapper__main__image__cards_anchor").before(this);
    $(this).after($(`#item_images_attributes_${id_int}__destroy`));
    // 5枚以上の時、二段目に移行する処理
    if (counter.attr("data-exhibitid") == 5) {
      $(".exhibit-wrapper__main__image__cards").css("height", "320px");
    }
    // 画像の読み込みと同時にイベントを発生させ、プレビューを表示する
    var reader = new FileReader();
    reader.onload = function(e){
      addCard = buildHTML(e.target.result, id_int);
      $(".exhibit-wrapper__main__image__cards").prepend(addCard);
      if (counter.attr("data-exhibitid") == 10) {
        $(".exhibit-wrapper__main__image__drag-wrapper").css("display", "none");
      }
    }
    reader.readAsDataURL(e.target.files[0]);
  })
  // 画像削除処理
  $(document).on("click", ".item-image__delete-button__append", function() {
    if (counter.attr("data-exhibitid") == 10) {
      $(".exhibit-wrapper__main__image__drag-wrapper").css("display", "block");
    }
    var number = counter.attr("data-exhibitid");
    var new_number = Number(number) - 1;
    counter.attr("data-exhibitid", new_number);
    var id = $(this).data("image");
    var form = $(`#item_images_attributes_${id}_image`);
    var checkbox = $(`#item_images_attributes_${id}__destroy`);
    // edit時、DBに登録済みの画像削除
    if (document.getElementById(`item_images_attributes_${id}_id`) != null) {
      checkbox.prop('disabled', false);
      checkbox.prop('checked',true);
    }
    // 動的に追加し、DBには登録されていない画像の削除 
    else {
    form.val("");
    // 再利用できるように前に移動
    form.prop('readonly', false);
    $('.item-edit__image-9').after(form);
    form.after(checkbox);
    }
    $(this).parent().parent().remove();
    // もし削除した結果、4枚以下になったら縦幅を縮める
    if (counter.attr("data-exhibitid") == 4) {
      $(".exhibit-wrapper__main__image__cards").css("height", "160px");
    }
  });
  // 配送料負担が選択されたら、続けて配送方法を表示する
  $(".exhibit__shipping-charges").on("change", function(e){
    $(".exhibit__delivery-method").css("display", "block")
  })
  // もしすでに選択されていたら、表示
  if ($(".exhibit__shipping-charges").val() != "") {
    $(".exhibit__delivery-method").css("display", "block")
  }
  // カテゴリーが選択されたら、ブランドを表示
  $(".exhibit-category-l").on("change", function(e){
    $(".exhibit-brand").css("display", "block")
  })
  // もしすでに選択されていたら、表示
  if ($(".exhibit-category-l").val() != "") {
    $(".exhibit-brand").css("display", "block")
  }
})
