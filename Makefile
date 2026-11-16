IMAGE  ?= sudoku
VOLUME ?= sudoku-data

.PHONY: build run clean

build:
	docker build -t $(IMAGE) .

# Needs a terminal of at least 80x24. Best times persist in the $(VOLUME) volume.
run: build
	docker run --rm -it -v $(VOLUME):/data $(IMAGE)

# Remove the image and the saved best times.
clean:
	-docker rmi $(IMAGE)
	-docker volume rm $(VOLUME)
