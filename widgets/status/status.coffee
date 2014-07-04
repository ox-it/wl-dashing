class Dashing.Status extends Dashing.Widget

  @accessor 'status', ->
    group = (item for item in @get('data').groups when item.id == @group)
    group[0].status_name
