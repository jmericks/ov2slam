all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build              - build all images"
	# @echo "   1. make pull             - pull all images"
	@echo "   1. make clean              - remove all images"
	@echo ""

build:
	@docker build --tag agslam/ov2slam:V1 -f ./Dockerfile ..

clean:
	@docker rmi -f  agslam/ov2slam:V1
