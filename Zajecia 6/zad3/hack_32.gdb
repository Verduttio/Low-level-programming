set verbose off

break *0x8049f44
commands 1
	set $eax=1
	continue
end
run
quit
