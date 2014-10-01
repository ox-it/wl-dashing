class Dashing.JenkinsBuild extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue
  @accessor 'bgColor', ->
    if @get('currentResult') == "SUCCESS"
      "#96bf48"
    else if @get('currentResult') == "FAILURE"
      "#D26771"
    else if @get('currentResult') == "UNSTABLE"
      "#F9A318"
    else if @get('currentResult') == "PREBUILD"
      "#ff9618"
    else
      "#999"
  @accessor 'building', ->
    @get('currentResult') == "BUILDING"

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".jenkins-build").val(value).trigger('change')
    @observe 'duration', (time) ->
      $(@node).find(".jenkins-build").attr('data-duration', time)

  ready: ->
    meter = $(@node).find(".jenkins-build")
    $(@node).fadeOut().css('background-color', @get('bgColor')).fadeIn()
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    if @get('building')
      $(@node).find(".last-built").hide()
      meter.show()
      meter.knob
        format: (v) ->
          duration = meter.attr('data-duration')
          if duration
            duration + 's'
    else
      $(@node).find(".last-built").show()
      meter.hide()

      
  onData: (data) ->
    if data.currentResult isnt data.lastResult
      $(@node).fadeOut().css('background-color', @get('bgColor')).fadeIn()
