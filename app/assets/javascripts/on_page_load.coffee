#
# Call the given callback function when the indicated page is loaded
#
# Usage:
#
# onPageLoad 'posts#index', ->
#   # Do something when controller is 'posts' and action is 'index'.
#
# onPageLoad 'posts', ->
#   # Do something when controller is 'posts' (in any action).
#
# # Accepts multiple conditions
# onPageLoad ['posts#index', 'comments'], ->
#   # Do something
#
@onPageLoad = (controller_and_actions, callback) ->
  $(document).on 'turbolinks:load', ->
    conditions = regularize(controller_and_actions)
    unless conditions
      console.error '[onPageLoad] Unexpected arguments!'
      return
 
    conditions.forEach (a_controller_and_action) ->
      [controller, action] = a_controller_and_action.split('#')
      callback() if isOnPage(controller, action)
 
regularize = (controller_and_actions) ->
  if typeof(controller_and_actions) == 'string'
    [controller_and_actions]
  else if Object.prototype.toString.call(controller_and_actions).includes('Array')
    controller_and_actions
  else
    null
 
isOnPage = (controller, action) ->
  selector = "body[data-controller='#{controller}']"
  selector += "[data-action='#{action}']" if action
  $(selector).length > 0