convert -delay 4 -loop 0 *.png gif.gif

convert gif.gif -coalesce -reverse -loop 0 reversed.gif

convert gif.gif reversed.gif gifcombine.gif

convert gifcombine.gif -colors 64 smaller.gif
