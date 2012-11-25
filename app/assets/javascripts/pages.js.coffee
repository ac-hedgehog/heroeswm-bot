cool_ajax_request = () ->
    $.ajax
        type: "POST"
        url: "pages/cool_ajax"
        success: (data) ->
            $("#cool-results").html data['html']

$("#cool-button").live "click", cool_ajax_request
