class Dashing.Status extends Dashing.Widget

  @accessor 'status', ->
    if @get('data')
      group = (item for item in @get('data').groups when item.id == @group)
      group[0].status_name

  @accessor 'bgColor', ->
    if @get('status') == "Up"
      "#96bf48"
    else if @get('status') == "Partial"
      "#d9a318"
    else if @get('status') == "Down"
      "#d26771"
    else
      "#999"

  onData: (data) ->
    # Cache the status inside the widget
    if @lastStatus isnt @get('status')
      $(@node).fadeOut().css('background-color', @get('bgColor')).fadeIn();
    @lastStatus = @get('status')
