onPageLoad 'users#index', ->
  entire_contents = document.getElementById('entire_contents')
  entire_contents.classList.remove 'container'
  $('body').addClass('bg_color')

onPageLoad 'users#check', ->
  entire_contents = document.getElementById('entire_contents')
  entire_contents.classList.remove 'container'
  $('body').addClass('bg_color')