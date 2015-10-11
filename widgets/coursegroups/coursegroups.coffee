class Dashing.Coursegroups extends Dashing.Widget

  @accessor 'responseCode', ->
    @get('respCode')

  @accessor 'coursegroups', ->
    if @get('responseCode') == "200"
      "Up"
    else
      "Down"

  @accessor 'bgColor', ->
    if @get('responseCode') == "200"
      "#96bf48"
    else
      "#d26771"

  onData: (data) ->
    # Cache the status inside the widget
    if @lastStatus isnt @get('coursegroups')
      $(@node).fadeOut().css('background-color', @get('bgColor')).fadeIn();
    @lastStatus = @get('coursegroups')
