require 'TEsounds/TEsound'
track = {}
switcher = {}
switcher.switch = nil

function switch(d)
	switcher.switch()
end
 
function play()
	if trac ~= {} then
		switch()
	end
end
function pause()
	TEsound.pause("music")
end
switcher.switch = function()
	local t = track
	
	track = track.next
	local func = function(d) 
	switcher.switch() end
    TEsound.play(t.track, "music", 1, 1, func)
end
function queue(url)
	local c = {}
	c.track = url
	track.next = c
end