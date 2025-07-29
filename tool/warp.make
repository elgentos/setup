$(WARP):
	sudo apt install warp-terminal -y
warp: | $(WARP)

optional:: | warp
