FROM turchinc/xenial-mupdf 

LABEL tag="turchinc/xenial-swftools" vendor="Bertsch Innovation GmbH"
MAINTAINER Chris Turchin <chris.turchin@bertschinnovation.com>
ENV DEBIAN_FRONTEND noninteractive

# swftools build from source, I cannot find a package for this anywhere
# starting point https://hub.docker.com/r/liubin/swftools/~/dockerfile/

# we use a (patched) copy of the swftools repo at
# git clone https://github.com/turchinc/swftools  
ADD swftools/ /tmp/swftools

#download and decompress deps
RUN cd /tmp && \
wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.0.tar.gz && \
wget http://www.ijg.org/files/jpegsrc.v9a.tar.gz
RUN cd /tmp && tar zxf freetype-2.4.0.tar.gz && tar zxf jpegsrc.v9a.tar.gz 

# additional deps per info here 
# http://permalink.gmane.org/gmane.comp.tools.swftools.general/2259
RUN apt-get update && apt-get install -y wget make g++ patch zlib1g-dev libgif-dev libpoppler-dev

RUN cd /tmp/jpeg-9a && ./configure && make && make install
RUN cd /tmp/freetype-2.4.0 && ./configure && make && make install
# patched the git repo externally! the double make works around an error in the autoconfigure...
# only works on second run...
RUN cd /tmp/swftools \ 
	&& chmod 777 ./configure \
	&& ./configure && make -i && make && make install && \
	ldconfig /usr/local/lib

RUN cd /tmp && rm -rf swftools* && rm -rf jpeg* && rm -rf freetype*
