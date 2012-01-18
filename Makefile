# -*- makefile-gmake -*-

# Use play the movie in 15 minutes (regardless of original movie length):
#
#   make MOVIE_NAME=NO_Bjodnabu T=15
#
# To prepare subtitles (do once before playing the movie:
#
#   make sub MOVIE_NAME=NO_Bjodnabu > NO_Bjodnabu.srt

MOVIE_NAME:=NO_Bjodnabu

# From http://stackoverflow.com/questions/497681/using-mplayer-to-determine-length-of-audio-video-file
# (MOVIE_LENGTH is in seconds):
MOVIE_LENGTH:=$(shell mplayer -vo null -ao null -frames 0 -identify $(MOVIE_NAME).avi 2>/dev/null | grep "ID_LENGTH" | cut -d= -f 2 || true)

# You can use the variable T to stretch (speed up) the movie to a pre-determined length (in minutes).
# This will only look okay if the original movie length is not too far off.
# Default is the original movie length:
T:=$(MOVIE_LENGTH)/60

MPLAYER_OPTS += -fs
MPLAYER_OPTS += -loop 0
MPLAYER_OPTS += -menu
MPLAYER_OPTS += -osdlevel 3
MPLAYER_OPTS += -subfont-osd-scale 2
MPLAYER_OPTS += -subfont-text-scale 2

# mplayer identifies the movie length in seconds, thus we need the "60":
SPEEDFACTOR:=$(shell echo $(MOVIE_LENGTH)/\($(T)*60\) | bc -l)

all:
	@echo "movie length=$(MOVIE_LENGTH) sec"
	@echo "speed factor=$(SPEEDFACTOR)"
	mplayer $(MPLAYER_OPTS) -speed $(SPEEDFACTOR) $(MOVIE_NAME).avi

# Calculate percentages of a given total movie length in "hh:mm:ss,sss" format.
#
# $1=movie length
# $2=factor
# $3=duration (==offset)
#
# See also http://superuser.com/questions/31445/gnu-bc-modulo-with-scale-other-than-0
SHELL=/bin/bash
LANG=C
define TIME_template
	$(eval rawtime:=$(shell bc -l <<< "$1*$2+$3"))
	$(eval hours  :=$(shell bc <<< "scale=0;($(rawtime) / 3600)"))
	$(eval mins   :=$(shell bc <<< "scale=0;($(rawtime) % 3600)/60"))
	$(eval secs   :=$(shell bc <<< "scale=0;($(rawtime) % 3600) % 60"))
endef

# Duration for displaying the subtitles (in seconds):
TEXT_DURATION:=10

# We are using the SubRip (SRT) format:
sub $(MOVIE_NAME).srt:
	@printf "00:00:01.000 --> 00:00:10.000\n"
	@printf "Title: $(MOVIE_NAME)\n"
	$(call TIME_template,$(MOVIE_LENGTH),1,0)
	@printf "Original running time: "
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf "\n"

	@printf "\n"
	$(call TIME_template,$(MOVIE_LENGTH),0.25,0)
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf " --> "
	$(call TIME_template,$(MOVIE_LENGTH),0.25,$(TEXT_DURATION))
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf "\n"
	@printf "You have reached a quarter of the total time.\n"

	@printf "\n"
	$(call TIME_template,$(MOVIE_LENGTH),0.333,0)
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf " --> "
	$(call TIME_template,$(MOVIE_LENGTH),0.333,$(TEXT_DURATION))
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf "\n"
	@printf "You have reached a third of the total time.\n"

	@printf "\n"
	$(call TIME_template,$(MOVIE_LENGTH),0.5,0)
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf " --> "
	$(call TIME_template,$(MOVIE_LENGTH),0.5,$(TEXT_DURATION))
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf "\n"
	@printf "You have reached half of the total time.\n"

	@printf "\n"
	$(call TIME_template,$(MOVIE_LENGTH),0.667,0)
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf " --> "
	$(call TIME_template,$(MOVIE_LENGTH),0.667,$(TEXT_DURATION))
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf "\n"
	@printf "You have reached two thirds of the total time.\n"

	@printf "\n"
	$(call TIME_template,$(MOVIE_LENGTH),0.75,0)
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf " --> "
	$(call TIME_template,$(MOVIE_LENGTH),0.75,$(TEXT_DURATION))
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf "\n"
	@printf "You have reached 3/4th of the total time.\n"

	@printf "\n"
	$(call TIME_template,$(MOVIE_LENGTH),0.9,0)
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf " --> "
	$(call TIME_template,$(MOVIE_LENGTH),0.9,$(TEXT_DURATION))
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf "\n"
	@printf "10 percent to go!\n"

	@printf "\n"
	$(call TIME_template,$(MOVIE_LENGTH),0.95,0)
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf " --> "
	$(call TIME_template,$(MOVIE_LENGTH),0.95,$(TEXT_DURATION))
	@printf "%02d:%02d:%06.3f" $(hours) $(mins) $(secs)
	@printf "\n"
	@printf "Only 5 percent to go!\n"

.PHONY: debug
debug:
	@echo length=$(MOVIE_LENGTH)

	@echo "START:"
	$(call TIME_template,$(MOVIE_LENGTH),1,0)
	@printf "full time: "
	@printf "%5.2f secs is %02d:%02d:%06.3f\n" $(rawtime) $(hours) $(mins) $(secs)
	$(call TIME_template,$(MOVIE_LENGTH),0.5,0)
	@printf "half time: "
	@printf "%5.2f secs is %02d:%02d:%06.3f\n" $(rawtime) $(hours) $(mins) $(secs)
	$(call TIME_template,$(MOVIE_LENGTH),0.1,0)
	@printf "1/10th:    "
	@printf "%5.2f secs is %02d:%02d:%06.3f\n" $(rawtime) $(hours) $(mins) $(secs)

	@echo "END:"
	$(call TIME_template,$(MOVIE_LENGTH),1,$(TEXT_DURATION))
	@printf "full time: "
	@printf "%5.2f secs is %02d:%02d:%06.3f\n" $(rawtime) $(hours) $(mins) $(secs)
	$(call TIME_template,$(MOVIE_LENGTH),0.5,$(TEXT_DURATION))
	@printf "half time: "
	@printf "%5.2f secs is %02d:%02d:%06.3f\n" $(rawtime) $(hours) $(mins) $(secs)
	$(call TIME_template,$(MOVIE_LENGTH),0.1,$(TEXT_DURATION))
	@printf "1/10th:    "
	@printf "%5.2f secs is %02d:%02d:%06.3f\n" $(rawtime) $(hours) $(mins) $(secs)

# Note: bottommost line in the subtitles is reserved for metadata of the ride

# Text that could be put into the subtitles to make them more interesting:
#
# rear mirror
# sharp bend ahead (don't try lean your bike unless you are on a free roll :)
# car passing soon
# drink something!
# climb ahead (5 mins)
# last chance to relax
# crotch still okay? :)
# zippy quotes? (fillers)
#
# send in time stamps with interesting things to see


# Using gpsdings from http://gpstools.sourceforge.net/ to get a graph of elevation vs time from a GPX file:
#
# java -jar gpsdings.jar trackanalyzer --smoothing=7  --plot "TimeTravelled|Elevation|time_ele7.svg|Ele" *.gpx
#
# java -jar gpsdings.jar trackanalyzer --smoothing=7 -t data7.log *.gpx
#
# java -jar gpsdings.jar trackanalyzer --smoothing=7  --plot "DistanceTravelled|Slope|dist_slope7.svg|Slope" -t data7.log *.gpx
# java -jar gpsdings.jar trackanalyzer --smoothing=7  --plot "TimeTravelled|Slope|time_slope7.svg|Slope" *.gpx
# java -jar gpsdings.jar trackanalyzer --smoothing=7  --plot "DistanceTravelled|Elevation|dist_ele7.svg|Ele" *.gpx


# Debugging help
#
# # http://www.cmcrossroads.com/ask-mr-make/7382-makefile-optimization-eval-and-macro-caching
# # http://www.gnu.org/software/make/manual/make.html#Eval-Function
# PROGRAMS    = server client
# 
# server_OBJS = server.o server_priv.o server_access.o
# server_LIBS = priv protocol
# 
# client_OBJS = client.o client_api.o client_mem.o
# client_LIBS = protocol
# 
# # Everything after this is generic
# 
# .PHONY: all
# all: $(PROGRAMS)
# 
# define PROGRAM_template =
# 	$(1): $$($(1)_OBJS) $$($(1)_LIBS:%=-l%)
# 	ALL_OBJS   += $$($(1)_OBJS)
# endef
# 
# $(foreach program,$(PROGRAMS),$(eval $(call PROGRAM_template,$(program))))
# $(PROGRAMS):
# 	$(LINK.o) $^ $(LDLIBS) -o $@
# 
# clean:
# 	rm -f $(ALL_OBJS) $(PROGRAMS)
