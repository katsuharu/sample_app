onPageLoad 'users#index', ->
	entire_contents = document.getElementById('entire_contents')
	entire_contents.classList.remove 'container'
	entire_contents.classList.add 'Rectangle-7'