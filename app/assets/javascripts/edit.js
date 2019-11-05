$(document).on('turbolinks:load', function(){
  var controller = $('body').data("controller");
  var action = $('body').data("action");
  var counter = $(".exhibit-wrapper__main__image__cards").data("exhibitid");
  try {
    if (controller != "items" || action != "edit"){throw new Error(e)}
  function buildHTML(img){ 
  html = `<div class="exhibit-wrapper__main__image__cards__card">
            <div class="exhibit-wrapper__main__image__cards__card__image">
              <img src= ${img} class: 'exhibit-image'>
            <div class="exhibit-wrapper__main__image__cards__card__button">
              <a href="#">編集</a> 
              <a href="#">削除</a>
            </div>
          </div>`;
  return html;
  }
  window.onload = function() {
    for (var i=0; i<10; i++) {
      if (document.getElementById(`item_images_attributes_${i}_id`) != null) {
        counter += 1;
        $(`#item_images_attributes_${i}_image`).prop('readonly', true);
        $(`#item_images_attributes_${i}_image`).next().prop('readonly', false);
        $("#item_images_attributes_9_image").after($(`#item_images_attributes_${i}_image`));
        // 二段目に移行する処理
        if ($(`#item_images_attributes_${i}_image`).get(0) == $("#item_images_attributes_4_image").get(0)) {
          $(".exhibit-wrapper__main__image__cards").css("height", "320px");
        }
        var imgUrl = $(`.item-edit__image-${i}`).attr("src");
        addCard = buildHTML(imgUrl);
        $(".exhibit-wrapper__main__image__cards").prepend(addCard);
        if (counter == 10) {
          $(".exhibit-wrapper__main__image__drag-wrapper").css("display", "none");
        }
      }
    }
  }
  }catch(e){}
})