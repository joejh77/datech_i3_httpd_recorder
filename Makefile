#soft-fp version
CXX=/home/${USER}/workspace/project/oasis/buildroot-oasis/output/firstview_nor/host/bin/arm-linux-gnueabi-g++
STRIP=/home/${USER}/workspace/project/oasis/buildroot-oasis/output/firstview_nor/host/bin/arm-linux-gnueabi-strip
#CXX=/home/${USER}/workspace/project/Oasis/tools/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-g++
#STRIP=/home/${USER}/workspace/Oasis/tools/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-strip
CXXFLAGS=-g -Wall -std=c++11 -march=armv7-a -mfloat-abi=softfp -mfpu=neon -fPIC -DHTTPD_EMBEDDED -DZIP_STD
CXXFLAGS+=-DNDEBUG

#hard-fp version
#CXX=/home/${USER}/workspace/Oasis/tools/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++
#STRIP=CXX=/home/${USER}/workspace/Oasis/tools/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-strip
#CXXFLAGS=-g -Wall -std=c++11 -march=armv7-a -mfloat-abi=hard -mfpu=neon -DNDEBUG -fPIC

CXXFLAGS+=-O0 -fstack-protector-strong
#CXXFLAGS+=-O3

APP_SRC=../datech_i3_app/

HTTPD_SRC=../datech_i3_pai_r_httpd/

INCLUDES=-I$(HTTPD_SRC)include -I$(APP_SRC)arm/include -I$(APP_SRC)include -I$(APP_SRC)include/iio -I$(APP_SRC)/lib/tinyxml -I$(HTTPD_SRC)lib/libhttp-1.8/include -I$(HTTPD_SRC)lib/zip_utils
LDFLAGS=-L$(APP_SRC)arm/lib -L$(APP_SRC)lib/tinyxml -L$(HTTPD_SRC)lib/libhttp-1.8

LDLIBS=-lpthread -lcdc_base -lcdc_vencoder -lcdc_ve -lcdc_memory -lcdc_vdecoder -ljsoncpp -lfreetype -lpng16 -lz -levdev -ltixml -ldl -lcivetweb

#non-gprof
LDLIBS+=-loasis

#gprof
#LDLIBS+=-loasis-static -loffs-direct
#CXXFLAGS+=-pg

#LDLIBS += -lAdas
#LDLIBS += -Wl,--no-as-needed -ltcmalloc_debug

#CXXFLAGS+=-fno-omit-frame-pointer -fsanitize=address
#CXXFLAGS+=-static-libasan  -static-libstdc++
#LDLIBS += -lasan

#CXXFLAGS+=-fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free
#CXXFLAGS+=-fno-omit-frame-pointer
#LDLIBS += -Wl,--no-as-needed -ltcmalloc

#LDLIBS += libtcmalloc.a

#LDLIBS += -lprofiler

BUILD_DIR=./build/

.PHONY: clean
all: recorder_ex

stripped: recorder_ex
	$(STRIP) --strip-unneeded recorder_ex

recorder_ex: recorder_ex.cpp Makefile
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c recorder_ex.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)recorder.cpp

	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(HTTPD_SRC)pai_r_updatelog.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(HTTPD_SRC)http.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(HTTPD_SRC)httpd_pai_r.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(HTTPD_SRC)http_multipart.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(HTTPD_SRC)multipart_parser.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(HTTPD_SRC)base64.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(HTTPD_SRC)lib/zip_utils/zip.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)bb_micom.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)system_log.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)pai_r_data.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)pai_r_datasaver.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)SB_Network.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)SB_System.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)led_process.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)serial.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)evdev_input.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)user_data.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)wavplay.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)daSystemSetup.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)ConfigTextFile.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)gsensor.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)mixwav.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)DaUpStreamDelegate.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)ttyraw.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)datools.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)sysfs.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(APP_SRC)dagpio.cpp
	
	
	$(CXX) $(CXXFLAGS) $(INCLUDES) *.o $(LDFLAGS) $(LDLIBS) -o $@

	#../../etc/file_extend recorder_ex
	#cp recorder_ex ../buildroot-oasis/board/datech/oasis_nor/userfs/bin/recorder
	
	#date > ../buildroot-oasis/board/datech/oasis_nor/userfs/reboot.txt
clean:
	$(RM) *.o recorder_ex
 
