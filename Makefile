VERSION=$(shell head -1 VERSION)
CM=$(shell dirname `pwd`)

######################################################################
# DOCKER
######################################################################

#--no-cache=true

image:
	time docker build  -t cyberaide/text:${VERSION} -t cyberaide/text:latest .

#
# cm munts all parent directories into the container
#
cm:
	docker run -v $(CM):/cm -w /cm --rm -it cyberaide/text:${VERSION}  /bin/bash

wincm:
	winpty docker run -v $(CM):/cm -w /cm --rm -it cyberaide/text:${VERSION}  /bin/bash

shell:
	docker run --rm -it cyberaide/text:${VERSION}  /bin/bash

cms:
	docker run --rm -it cyberaide/text:${VERSION}

dockerclean:
	-docker kill $$(docker ps -q) --force
	-docker rm $$(docker ps -a -q) --force
	-docker rmi $$(docker images -q) --force

push:
	docker push cyberaide/text:${VERSION}
	docker push cyberaide/text:latest

run:
	docker run cyberaide/text:${VERSION} /bin/sh -c "pwd"

hugo:
	docker run cyberaide/text:${VERSION} /bin/sh -c "hugo --minify" 


clean:
	echo "TBD"
