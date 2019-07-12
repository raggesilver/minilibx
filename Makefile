
NAME := libminilibx.a
CC := gcc

CFLAGS := -Ofast -I/usr/include

OBJDIR := build
SRCDIR := src
HEADIR := includes

SRCS :=	$(SRCDIR)/mlx_init.c \
		$(SRCDIR)/mlx_new_window.c \
		$(SRCDIR)/mlx_pixel_put.c \
		$(SRCDIR)/mlx_loop.c \
		$(SRCDIR)/mlx_mouse_hook.c \
		$(SRCDIR)/mlx_key_hook.c \
		$(SRCDIR)/mlx_expose_hook.c \
		$(SRCDIR)/mlx_loop_hook.c \
		$(SRCDIR)/mlx_int_anti_resize_win.c \
		$(SRCDIR)/mlx_int_do_nothing.c \
		$(SRCDIR)/mlx_int_wait_first_expose.c \
		$(SRCDIR)/mlx_int_get_visual.c \
		$(SRCDIR)/mlx_flush_event.c \
		$(SRCDIR)/mlx_string_put.c \
		$(SRCDIR)/mlx_new_image.c \
		$(SRCDIR)/mlx_get_data_addr.c \
		$(SRCDIR)/mlx_put_image_to_window.c \
		$(SRCDIR)/mlx_get_color_value.c \
		$(SRCDIR)/mlx_clear_window.c \
		$(SRCDIR)/mlx_xpm.c \
		$(SRCDIR)/mlx_int_str_to_wordtab.c \
		$(SRCDIR)/mlx_destroy_window.c \
		$(SRCDIR)/mlx_int_param_event.c \
		$(SRCDIR)/mlx_int_set_win_event_mask.c \
		$(SRCDIR)/mlx_hook.c \
		$(SRCDIR)/mlx_rgb.c \
		$(SRCDIR)/mlx_destroy_image.c

OBJS := $(SRCS:%=$(OBJDIR)/%.o)
DEPS := $(SRCS:%=$(OBJDIR)/%.d)

HEAD := $(shell find $(SRCDIR) -name "*.h" -and ! -name "*_priv.h")
HEAD := $(subst $(SRCDIR),$(HEADIR),$(HEAD))

LIBS :=
LIBINCS := $(foreach lib,$(LIBS),-I$(dir $(lib))includes)

# This might not be necessary
# _INC := $(shell find $(SRCDIR) -type d)
# INCS := $(addprefix -I,$(_INC))

.PHONY: all re clean fclean debug $(LIBS) _$(NAME)

all: _$(NAME)

_$(NAME): $(LIBS)
	@$(MAKE) $(NAME)

$(NAME): $(HEAD) $(OBJS)
	ar rc $@ $(OBJS) $(LIBS)
	ranlib $@

$(OBJDIR) $(HEADIR):
	@mkdir -p $@

# -include $(DEPS)

$(OBJDIR)/%.c.o: %.c Makefile
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $< $(LIBINCS)

$(HEADIR)/%.h:
	@mkdir -p $(dir $@)
	cp $(subst $(HEADIR),$(SRCDIR),$@) $@

$(LIBS):
	@$(MAKE) -C $(dir $@) $(MAKECMDGOALS)

clean:
	@$(foreach dep, $(LIBS), $(MAKE) -C $(dir $(dep)) clean)
	rm -f $(OBJS)
	rm -f $(DEPS)
	rm -rf $(OBJDIR)

fclean: clean
	@$(foreach dep, $(LIBS), $(MAKE) -C $(dir $(dep)) fclean)
	rm -f $(NAME)
	rm -rf $(HEADIR)

re: fclean
	@$(MAKE) all

debug: fclean
	@$(MAKE) all CFLAGS="$(CFLAGS) -g"

# ci: MAKECMDGOALS=
# ci: all
# 	sh ./tests/test.sh
