set verbose off

break *0x401017
commands 1
	set $rdi=1
	set $rdx=13
	set $rsi=0x402000
	continue
end
run
quit
