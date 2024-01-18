FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

#install java
COPY jdk-8u191-linux-x64.tar.gz  .
RUN  mkdir /usr/lib/jvm
RUN  tar -zxvf jdk-8u191-linux-x64.tar.gz -C /usr/lib/jvm

ENV JAVA_HOME=/usr/lib/jvm/jdk1.8.0_191
RUN export JAVA_HOME

ENV JRE_HOME=${JAVA_HOME}/jre  
RUN export JRE_HOME

ENV CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
RUN export CLASSPATH

ENV PATH=${JAVA_HOME}/bin:$PATH 
RUN export PATH

RUN apt-get update -y && \ 
	apt-get install build-essential autoconf automake libtool autoconf-archive pkg-config libpng-dev libjpeg8-dev libtiff5-dev zlib1g-dev wget ant cmake x11-xserver-utils libgtk-3-0 openjfx -y 

# RUN xhost +

# install leptonica
RUN	wget https://github.com/DanBloomberg/leptonica/releases/download/1.79.0/leptonica-1.79.0.tar.gz  && \
	mkdir  /usr/local/leptonica && \ 
	tar -xzvf leptonica-1.79.0.tar.gz && \ 
	cd leptonica-1.79.0 && \
	./configure && make && make install 

# COPY leptonica-1.79.0.tar.gz .
# RUN  mkdir  /usr/local/leptonica 
# RUN  tar -xzvf leptonica-1.79.0.tar.gz  -C /usr/local/leptonica
# RUN  cd /usr/local/leptonica/leptonica-1.79.0 && \
# 	 ./configure && make && make install 


ENV LD_LIBRARY_PATH=$LD_LIBRARY_PAYT:/usr/local/lib
RUN export LD_LIBRARY_PATH

ENV LIBLEPT_HEADERSDIR=/usr/local/include
RUN export LIBLEPT_HEADERSDIR

ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
RUN export PKG_CONFIG_PATH

# install tesseract
RUN	wget https://github.com/tesseract-ocr/tesseract/archive/refs/tags/4.1.1.tar.gz && \
	mkdir /usr/local/tesseract && \ 
	tar -xzvf 4.1.1.tar.gz

RUN	cd tesseract-4.1.1 && \
	./autogen.sh && \
	./configure && \
	make && make install && \
	cp /usr/local/lib/*.so.* /usr/lib/

# RUN	 wget -P /usr/local/share/tessdata  https://raw.github.com/tesseract-ocr/tessdata/main/chi_sim.traineddata && \
# 	 wget -P /usr/local/share/tessdata  https://raw.github.com/tesseract-ocr/tessdata/main/eng.traineddata && \
# 	 wget -P /usr/local/share/tessdata  https://raw.github.com/tesseract-ocr/tessdata/main/chi_tra.traineddata 

#COPY /lib/*.so.* /usr/lib/
COPY /tessdata /usr/local/share/tessdata

ENV TESSDATA_PREFIX=/usr/local/share/tessdata 
RUN export TESSDATA_PREFIX

ENV PATH=$PATH:$TESSDATA_PREFIX
RUN export PATH

#install opencv
# RUN wget  https://github.com/opencv/opencv/archive/refs/tags/4.6.0.tar.gz && \
#     tar -xzvf 4.6.0.tar.gz

# RUN cd opencv-4.6.0/ && \
#     mkdir build && \
#     cd build  && \
#     cmake -D CMAKE_BUILD_TYPE=Release -D BUILD_opencv_java=ON -D BUILD_SHARED_LIBS=OFF -D BUILD_TESTS=OFF -D CMAKE_INSTALL_PREFIX=/usr/local ..  && \
#     make -j4 && \   
#     make install && \
#     cp /usr/local/share/java/opencv4/libopencv_java460.so /usr/lib/

COPY /lib/libopencv_java460.so /usr/lib/

VOLUME /hostData
COPY /hostData /hostData

#install mysql
RUN sudo apt-get update -y && \ 
	sudo DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y
COPY *.sh setup.sh
COPY *.sql ocr.sql


# copy jar, run springboot app
VOLUME /tmp
COPY prd007.jar app.jar
COPY *.yml application.yml

ENV DISPLAY=:0.0
RUN export DISPLAY

#ENTRYPOINT ["java","-jar","/app.jar"]
#CMD java -version

CMD ["/bin/bash"]

EXPOSE 8083