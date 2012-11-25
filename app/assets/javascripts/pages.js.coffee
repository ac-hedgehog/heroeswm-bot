cool_ajax_request = () ->
    $.ajax
        type: "POST"
        url: "pages/cool_ajax"
        success: (data) ->
            if data['status'] == 'connected'
                result = "Процесс пошёл"
            else
                result = "Что-то не так"
            $("#cool-results").html result

$("#cool-button").live "click", cool_ajax_request
