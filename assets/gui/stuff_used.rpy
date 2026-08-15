############################################################
### TRANSFORMS ###
############################################################
transform ts_waterYBob(yoff, yoff2=0, position=(0.5, 1.0),ts_speed1=2.0, ts_speed2=5.0):
    pos position
    yoffset yoff
    linear ts_speed1 yoffset yoff2
    linear ts_speed2 yoffset yoff
    repeat


transform ts_waterAlpha(position=(0.5, 1.0), p=2.0, ts_speed=5.0):
    pos position
    alpha 0.0
    pause p
    alpha 1.0
    linear ts_speed alpha 0.0
    repeat

transform ts_waterYoff(yoff=-160, ts_speed=2.0):
    xoffset -40
    yoffset 100
    linear ts_speed yoffset yoff
    linear ts_speed*4 yoffset 100
    pause 4.0
    repeat

############################################################
### IMAGES ###
############################################################
## Note, you neeed Fenik's LayerdImageMask for this to work

image choice_idle = "gui/button/choice_idle_background.png"
image choice_hover_static = "gui/button/choice_hover_static_background.png"

image choice_hover_background = "gui/button/choice_hover_background.png"
image choice_hover_midground = "gui/button/choice_hover_midground.png"
image choice_hover_foreground = "gui/button/choice_hover_foreground.png"


layeredimage choice_hover:
    align (0.5, 1.0)
    always "choice_hover_background"
    always At("choice_hover_midground", ts_waterYoff)

# Use this for the animated hover, else use choice_hover_static
image choice_hover_anim = LayeredImageMask("choice_hover", mask="choice_hover_background", foreground="choice_hover_foreground")

# CTC
image ctc:
    "gui/ctc.png"
    linear 1.0 yoffset 20
    linear 1.0 yoffset 0
    repeat

### MAIN MENU ###
image main_menu_background = "gui/main_menu_background.png"
image main_menu_midground = Transform("gui/main_menu_midground.png", anchor=(0.5, 1.0), yoffset=100)
image main_menu_foreground = Transform("gui/main_menu_foreground.png", anchor=(0.5, 1.0))


layeredimage main_menu_anim:
    always "main_menu_background"

    always "main_menu_midground" at ts_waterAlpha()
    always "main_menu_foreground" at ts_waterYBob(700)


image main_menu_static = Composite(
    (1920, 1080),
    (0, 0), "main_menu_background",
    (0, 700), "main_menu_midground",
    (0, 250), "main_menu_foreground"
)

### For the radio.check button starfish to correctly appear on the side use:
## 
## Adjust these based on ur pref

#foreground Transform("gui/button/radio_[prefix_]foreground.png", xoffset=-30)
#foreground Transform("gui/button/radio_[prefix_]foreground.png", xoffset=-30)

# VSCROLLBAR - change default style vscrollbar to this
style vscrollbar:
    xsize 99
    idle_base_bar Frame("gui/scrollbar/vertical_idle_bar.png", 6, 6, 6, 6, tile=False)
    hover_base_bar Frame("gui/scrollbar/vertical_idle_bar.png", 6, 6, 6, 6, tile=False)
    thumb "gui/scrollbar/vertical_[prefix_]thumb.png"
    unscrollable 'hide'
    thumb_offset 50

### FOR FRAME
style confirm_frame:
    background Frame("gui/frame.png", 191, 193, 199, 201)
    padding (159, 163, 118, 123)
    xalign 0.5
    yalign 0.5