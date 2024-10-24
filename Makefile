# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: drenassi <@student.42perpignan.fr>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/11/09 18:01:57 by drenassi          #+#    #+#              #
#    Updated: 2024/10/22 16:32:06 by drenassi         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

################################################################################
#                                     CONFIG                                   #
################################################################################


NAME	= pipex
CC 		= gcc
CFLAGS	= -Wall -Werror -Wextra
AUTHOR	= drenassi
DATE	= 09/11/2023
NOVISU 	= 0 # 1 = no progress bar usefull when tty is not available

################################################################################
#                                 PROGRAM'S SRCS                               #
################################################################################

FILE_EXTENSION	= .c

SRCS_PATH		= ./src

INCLUDE_PATH	= ./includes

SRCS			= ft_pipex.c ft_utils.c ft_utils2.c ft_split.c

MAIN			= main.c

SRCS_BONUS		= bonus.c ft_bonus.c get_next_line.c get_next_line_utils.c

################################################################################
#                                  MAKEFILE  OBJS                              #
################################################################################

SHELL := /bin/bash

OBJS_PATH			= ./objs

OBJS				= $(addprefix objs/, ${SRCS:$(FILE_EXTENSION)=.o})
OBJ_MAIN			= $(addprefix objs/, ${MAIN:$(FILE_EXTENSION)=.o})
OBJS_BONUS			= $(addprefix objs/, ${SRCS_BONUS:$(FILE_EXTENSION)=.o})

################################################################################
#                                 MAKEFILE LOGIC                               #
################################################################################

COM_COLOR   = \033[0;34m
OBJ_COLOR   = \033[0;36m
OK_COLOR    = \033[0;32m
ERROR_COLOR = \033[0;31m
WARN_COLOR  = \033[0;33m
NO_COLOR    = \033[m

COM_STRING   = "Compiling"

HASH	= 

ifeq ($(OS),Windows_NT) 
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

ifeq ($(detected_OS),Darwin) 
	RUN_CMD = script -q $@.log $1 > /dev/null; \
				RESULT=$$?
else ifeq ($(detected_OS),Linux)
	RUN_CMD = script -q -e -c "$(1)" $@.log > /dev/null; \
				RESULT=$$?; \
				sed -i '1d' $@.log; \
				sed -i "$$(($$(wc -l < $@.log)-1)),\$$d" $@.log
else
	RUN_CMD = $(1) 2> $@.log; \
				RESULT=$$?
endif

ifeq ($(shell git rev-parse HEAD &>/dev/null; echo $$?),0)
	AUTHOR	:= $(shell git log --format='%aN' | sort -u | awk '{printf "%s, ", $$0}' | rev | cut -c 3- | rev)
	DATE	:= $(shell git log -1 --date=format:"%Y/%m/%d %T" --format="%ad")
	HASH	:= $(shell git rev-parse --short HEAD)
endif

define run_and_test
printf "%b%-46b" "$(COM_COLOR)$(COM_STRING) " "$(OBJ_COLOR)$(@F)$(NO_COLOR)"; \
$(RUN_CMD); \
if [ $$RESULT -ne 0 ]; then \
	printf "%b\n" "$(ERROR_COLOR)[✖]$(NO_COLOR)"; \
	rm -rf .files_changed; \
	if [ $(NOVISU) -eq 0 ]; then \
		echo; \
	fi; \
elif [ -s $@.log ]; then \
	printf "%b\n" "$(WARN_COLOR)[⚠]$(NO_COLOR)"; \
else  \
	printf "%b\n" "$(OK_COLOR)[✓]$(NO_COLOR)"; \
fi; \
cat $@.log; \
rm -f $@.log; \
exit $$RESULT
endef

define save_files_changed
	FILE_CPP=`echo $(SRCS) $(MAIN)`; \
	FILE_OBJ=`find objs -type f -name '*.o' 2>/dev/null | sed 's/objs\///'`; \
	TO_COMPILE=`echo $$FILE_CPP | wc -w`; \
	for FILE in $$FILE_CPP; do \
		for OBJ in $$FILE_OBJ; do \
			if [ $${FILE%$(FILE_EXTENSION)} = $${OBJ%.o} ]; then \
				if [ $(SRCS_PATH)/$$FILE -ot objs/$$OBJ ]; then \
					RECOMPILE=0; \
					if [ $$RECOMPILE -eq 0 ]; then \
						((TO_COMPILE=$$TO_COMPILE-1)); \
					fi;\
				fi; \
			fi; \
		done; \
	done; \
	echo 0/$$TO_COMPILE > .files_changed
endef

define save_files_changed_bonus
	FILE_CPP=`echo $(SRCS) $(SRCS_BONUS)`; \
	FILE_OBJ=`find objs -type f -name '*.o' 2>/dev/null | sed 's/objs\///'`; \
	TO_COMPILE=`echo $$FILE_CPP | wc -w`; \
	for FILE in $$FILE_CPP; do \
		for OBJ in $$FILE_OBJ; do \
			if [ $${FILE%$(FILE_EXTENSION)} = $${OBJ%.o} ]; then \
				if [ $(SRCS_PATH)/$$FILE -ot objs/$$OBJ ]; then \
					RECOMPILE=0; \
					if [ $$RECOMPILE -eq 0 ]; then \
						((TO_COMPILE=$$TO_COMPILE-1)); \
					fi;\
				fi; \
			fi; \
		done; \
	done; \
	echo 0/$$TO_COMPILE > .files_changed
endef

define draw_bar
	FILE_TOTAL=`bash -c 'cat .files_changed | cut -d"/" -f2'`; \
	FILE_DONE=`bash -c 'cat .files_changed | cut -d"/" -f1'`; \
	if [ $$FILE_TOTAL -eq 0 ]; then \
		FILE_TOTAL=1; \
		FILE_DONE=1; \
	fi; \
	RES=`echo "scale=2; $$FILE_DONE/$$FILE_TOTAL*48" | bc`; \
	RES=`echo $${RES%%.*}`; \
	printf "$(OBJ_COLOR)[$(NO_COLOR)"; \
	i=0; \
	while [ $$i -lt 48 ]; do \
		if [ $$i -lt $$RES ]; then \
			printf "$(OK_COLOR)█$(NO_COLOR)"; \
		else \
			printf "$(COM_COLOR)▒$(NO_COLOR)"; \
		fi; \
		((i=$$i+1)); \
	done; \
	printf "$(OBJ_COLOR)]$(NO_COLOR)"; \
	printf " ($(COM_COLOR)$$FILE_DONE$(NO_COLOR)/$(COM_COLOR)$$FILE_TOTAL$(NO_COLOR))"; \
	printf " "; \
	((FILE_DONE=$$FILE_DONE+1)); \
	echo $$FILE_DONE/$$FILE_TOTAL > .files_changed;
endef

define display_progress_bar
	if [ $(NOVISU) -eq 0 ]; then \
		line=`bash -c 'oldstty=$$(stty -g); \
		stty raw -echo min 0; tput u7 > /dev/tty; IFS=";" \
		read -r -d R -a pos; stty $$oldstty; \
		row=$$(($${pos[0]:2} - 1)); echo $$row'`; \
		max_line=`tput lines`; \
		((max_line=$$max_line-2));\
		new_line=0; \
		tput sc; \
		i=0; \
		while [ $$i -lt 60 ]; do \
			printf " "; \
			((i=$$i+1)); \
		done; \
		tput rc; \
		if [ $$line -gt $$max_line ]; then \
			new_line=1; \
			echo ; \
		else \
			((line=$$line+1));\
		fi; \
		tput sc; \
		tput cup $$line; \
		$(draw_bar) \
		if [ $$new_line -eq 1 ]; then \
			((line=$$line-1));\
			tput cup $$line; \
		else \
			tput rc; \
		fi; \
	fi
endef

################################################################################
#                                 MAKEFILE RULES                               #
################################################################################

###################################### ALL #####################################
.PHONY:																		all
all: header setup $(NAME)
	@rm -rf .files_changed
	@echo ""

.PHONY:																		bonus
bonus: fclean header bonus_setup do_bonus
	@rm -rf .files_changed
	@echo ""

#################################### HEADER ####################################
.PHONY:																		header
header:
	@printf "%b" "$(OK_COLOR)"
	@echo "      _                              _ _"
	@echo "     | |                            (_| )"
	@echo "   __| |_ __ ___ _ __   __ _ ___ ___ _|/ ___"
	@echo "  / _  | '__/ _ \ '_ \ / _' / __/ __| | / __|"
	@echo " | (_| | | |  __/ | | | (_| \__ \__ \ | \__ \\"
	@echo "  \__,_|_|  \___|_| |_|\__,_|___/___/_| |___/"
	@echo "   __  __       _         __ _ _"
	@echo "  |  \/  |     | |       / _(_) |"
	@echo "  | \  / | __ _| | _____| |_ _| | ___"
	@echo "  | |\/| |/ _' | |/ / _ \  _| | |/ _ \\"
	@echo "  | |  | | (_| |   <  __/ | | | |  __/"
	@echo "  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|"
	@echo " "
	@echo
ifneq ($(HASH),)
	@printf "%b" "$(OBJ_COLOR)Name:   $(WARN_COLOR)$(NAME)@$(HASH)\n"
else
	@printf "%b" "$(OBJ_COLOR)Name:   $(WARN_COLOR)$(NAME)\n"
endif
	@printf "%b" "$(OBJ_COLOR)Author: $(WARN_COLOR)$(AUTHOR)\n"
	@printf "%b" "$(OBJ_COLOR)Date:   $(WARN_COLOR)$(DATE)\n\033[m"
	@printf "%b" "$(OBJ_COLOR)CC:     $(WARN_COLOR)$(CC)\n\033[m"
	@printf "%b" "$(OBJ_COLOR)Flags:  $(WARN_COLOR)$(CFLAGS)\n\033[m"
	@echo

##################################### SETUP ####################################
.PHONY:																		setup
setup:
			@$(call save_files_changed)

.PHONY:																		bonus_setup
bonus_setup:
			@$(call save_files_changed_bonus)

$(NAME):	${OBJS} ${OBJ_MAIN}
			@$(call display_progress_bar)
			@$(call run_and_test,$(CC) $(CFLAGS) -I$(INCLUDE_PATH) -o $@ ${OBJS} ${OBJ_MAIN})

do_bonus:	${OBJS} ${OBJS_BONUS}
			@$(call display_progress_bar)
			@$(call run_and_test,$(CC) $(CFLAGS) -I$(INCLUDE_PATH) -o $(NAME) ${OBJS} ${OBJS_BONUS})

$(OBJS_PATH)/%.o: 	$(SRCS_PATH)/%$(FILE_EXTENSION)
			@mkdir -p $(dir $@)
			@$(call display_progress_bar)
			@$(call run_and_test,$(CC) $(CFLAGS) -c $< -o $@ -I$(INCLUDE_PATH))

##################################### CLEAN ####################################
.PHONY:																		clean
clean:		header
			@rm -rf objs
			@printf "%-53b%b" "$(COM_COLOR)clean:" "$(OK_COLOR)[✓]$(NO_COLOR)\n"

##################################### FCLEAN ####################################
.PHONY:																		fclean
fclean:		header clean
			@rm -rf $(NAME)
			@printf "%-53b%b" "$(COM_COLOR)fclean:" "$(OK_COLOR)[✓]$(NO_COLOR)\n"

####################################### RE ######################################
.PHONY:																		re
re:			fclean all
