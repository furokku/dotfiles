import XMonad
import Data.Monoid
import System.Exit
import Graphics.X11.ExtraTypes.XF86

import XMonad.Actions.TagWindows

import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "WINIT_X11_SCALE_FACTOR=1 alacritty"


-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#bfbfbf"
myFocusedBorderColor = "#fbec3b"
--myFocusedBorderColor = "#ffacbc"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [
        -- launch a terminal
          ((modm,               xK_Return), spawn $ XMonad.terminal conf)

        -- launch rofi 
        , ((modm,               xK_d     ), spawn "rofi -show run")

        -- change kb layout
        , ((modm,               xK_Home  ), spawn "i3-keyboard-layout cycle us ua ru")

        -- close focused window
        , ((modm,               xK_q     ), kill)

        -- Rotate through the available layout algorithms
        , ((modm,               xK_space ), sendMessage NextLayout)

        --  Reset the layouts on the current workspace to default
        , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

        -- Resize viewed windows to the correct size
        -- i don[t even know what this does
        , ((modm,               xK_g     ), refresh)

        -- Shrink the master area
        , ((modm .|. shiftMask, xK_h     ), sendMessage Shrink)

        -- Expand the master area
        , ((modm .|. shiftMask, xK_l     ), sendMessage Expand)

        -- Push window back into tiling
        , ((modm,               xK_t     ), withFocused $ windows . W.sink)

        -- Increment the number of windows in the master area
        , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

        -- Deincrement the number of windows in the master area
        , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    
        -- Toggle the status bar gap
        -- Use this binding with avoidStruts from Hooks.ManageDocks.
        -- See also the statusBar function from Hooks.DynamicLog.
        --
        , ((modm .|. shiftMask, xK_b     ), sendMessage ToggleStruts       )
        , ((modm .|. controlMask, xK_b   ), spawn "polybar-msg cmd toggle" )        

        -- display logout menu
        , ((modm .|. shiftMask, xK_q     ), spawn "rofi -show p -modi p:~/.config/rofi/rofi-power-menu")

        -- Quit xmonad
        -- , ((modm .|. shiftMask, xK_e     ), io (exitWith ExitSuccess))

        -- Restart xmonad
        , ((modm .|. controlMask, xK_q   ), spawn "xmonad --recompile; xmonad --restart")

        -- Start Chrome
        , ((modm,               xK_b     ), spawn "chromium --wm-window-animations-disabled")

        -- Take a screenshot
        , ((0   ,               xK_Print ), spawn "flameshot gui")

        -- lock screen
        , ((modm,               xK_y     ), spawn "loginctl lock-session")
    
        -- redshift
        , ((modm,               xK_z     ), spawn "redshift -O 4500K")
        , ((modm,               xK_x     ), spawn "redshift -x")
    
        -- start file manager
        , ((modm,               xK_n     ), spawn "nautilus")
  
        -- close all dunst notifs
        , ((modm,               xK_c     ), spawn "dunstctl close-all")

        -- kill picom
        , ((modm,               xK_s     ), spawn "pkill picom")
        , ((modm .|. shiftMask, xK_s     ), spawn "picom --use-ewmh-active-win --experimental-backends --glx-no-stencil --xrender-sync-fence")

        -- playerctl controls, volume adjustment
    
        , ((modm,               xK_F1    ), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ((modm,               xK_F2    ), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%" )
        , ((modm,               xK_F3    ), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%" )
        , ((modm,               xK_F4    ), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")

        , ((modm,               xK_KP_Multiply), spawn "mpc toggle")
        , ((modm,               xK_KP_Divide  ), spawn "mpc prev")
        , ((modm,               xK_KP_Subtract), spawn "mpc next")
        , ((modm .|. shiftMask, xK_KP_Divide  ), spawn "mpc seek -00:00:10")
        , ((modm .|. shiftMask, xK_KP_Subtract), spawn "mpc seek +00:00:10")
        , ((modm .|. shiftMask, xK_F2         ), spawn "mpc volume -5")
        , ((modm .|. shiftMask, xK_F3         ), spawn "mpc volume +5")

--      , ((0,               xF86XK_AudioMute       ), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
--      , ((0,               xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%" )
--      , ((0,               xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%" )
--(broke) ((0,               xF86XK_MicMute         ), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
 
--      , ((0,               xF86XK_AudioPlay), spawn "playerctl play-pause"  )
--      , ((0,               xF86XK_AudioStop), spawn "playerctl stop"        )
--      , ((0,               xF86XK_AudioPrev), spawn "playerctl previous"    )
--      , ((0,               xF86XK_AudioNext), spawn "playerctl next"        )
--      , ((0 .|. shiftMask, xF86XK_AudioPrev), spawn "playerctl position 10-")
--      , ((0 .|. shiftMask, xF86XK_AudioNext), spawn "playerctl position 10+")
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [

--        ((modm,               xK_Right ), windows W.focusRight)
--      , ((modm,               xK_Left  ), windows W.focusLeft )
          ((modm,               xK_k     ), windows W.focusUp   )
        , ((modm,               xK_j     ), windows W.focusDown )

       -- Swap adjacent windows
--      , ((modm .|. shiftMask, xK_Right ), windows W.swapRight)
--      , ((modm .|. shiftMask, xK_Left  ), windows W.swapLeft )
        , ((modm,               xK_h     ), windows W.swapUp   )
        , ((modm,               xK_l     ), windows W.swapDown )
    ]
--  ++
--  [
--        ((modm,                 xK_u   ), windows copyToAll )
--      , ((modm .|. controlMask, xK_u   ), killAllOtherCopies)
--  ]
--  ++
--
--  [
--  
--  -- Tab current focused window with the window to the left
--      ((modm    .|. controlMask, xK_Left), sendMessage $ pullGroup L)
--  -- Tab current focused window with the window to the right
--    , ((modm    .|. controlMask, xK_Right), sendMessage $ pullGroup R)
--  -- Tab current focused window with the window above
--    , ((modm    .|. controlMask, xK_Up), sendMessage $ pullGroup U)
--  -- Tab current focused window with the window below
--    , ((modm    .|. controlMask, xK_Down), sendMessage $ pullGroup D)
--
--  -- Tab all windows in the current workspace with current window as the focus
--    , ((modm    .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
--  -- Group the current tabbed windows
--    , ((modm    .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
--
--  ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--


myLayout = avoidStruts (tiled ||| noBorders Full)
  where
     tiled   = spacing 6 $ Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules

myManageHook = composeAll
    [ className =? "MPlayer"            --> doFloat
    , className =? "mpv"                --> doFloat
    , className =? "Asunder"            --> doFloat
    , className =? "Pavucontrol"        --> doFloat
    , className =? "Minecraft Linux Launcher UI"-->doFloat
    , resource  =? "xmessage"           --> doFloat
    , className =? "Tk"                 --> doFloat

    , resource  =? "sxiv"               --> doFloat
    , resource  =? "org.gnome.Nautilus" --> doFloat
    , className =? "Evince"             --> doFloat
    , className =? "Gedit"              --> doFloat
    , resource  =? "gnome-disks"        --> doFloat

--  , resource  =? "polybar"            --> doIgnore
    , resource  =? "desktop_window"     --> doIgnore
    , resource  =? "kdesktop"           --> doIgnore
    , isFullscreen                      --> (doF W.focusDown <+> doFullFloat)]


------------------------------------------------------------------------
myEventHook = mconcat [ fullscreenEventHook ]
------------------------------------------------------------------------

myLogHook = return ()

------------------------------------------------------------------------

-- startup
myStartupHook = do

              spawn "/home/furokku/.config/polybar/launch.sh"
              spawn "/home/furokku/.config/dunst/launch.sh"

              spawn "pkill xss-lock; xss-lock ~/.local/bin/lock.sh"
              spawn "picom --use-ewmh-active-win --experimental-backends --glx-no-stencil --xrender-sync-fence"
              spawn "feh --no-fehbg --bg-fill /home/furokku/.local/wallpaper/94e5ituyretb45.png"

              spawnOnce "steam"
              spawnOnce "discord-canary"
              spawnOnce "flameshot"

              spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
              spawnOnce "numlockx"
              spawnOnce "xrandr --output HDMI-A-0 --right-of DisplayPort-1 --output DisplayPort-1 --primary --output DVI-D-0 --left-of DisplayPort-1"

main = xmonad $ docks . ewmh $ defaults

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- keybinds
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
--      handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
}
