import XMonad
import Data.Monoid
import Data.Ratio
import System.Exit
import Graphics.X11.ExtraTypes.XF86

import XMonad.Operations

import XMonad.Actions.GroupNavigation

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.BinarySpacePartition

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.SpawnOnce (spawnOnce)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Function to, well, toggle the Full layout on a workspace
--
toggleFull :: XConfig Layout -> X()
toggleFull conf@(XConfig {XMonad.layoutHook = defaultLayoutHook}) = do
    winset <- gets windowset
    let ld = description . W.layout . W.workspace . W.current $ winset
    if ld /= "Full"
        then do 
            sendMessage $ JumpToLayout "Full"
            sendMessage $ SetStruts [] [U,D,L,R]
        else setLayout defaultLayoutHook

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "WINIT_X11_SCALE_FACTOR=1 alacritty"


-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
myBorderWidth = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces = map show [1..9]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#928374"
myFocusedBorderColor = "#fbf1c7"
--myFocusedBorderColor = "#ebdbb2"
--myFocusedBorderColor = "#8a2be2"
--myFocusedBorderColor = "#d3869b"
--myFocusedBorderColor = "#fbec3b"
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

        -- close focused window
        , ((modm,               xK_q     ), kill)

        -- Rotate through the available layout algorithms
        , ((modm,               xK_space ), sendMessage NextLayout)

        --  Reset the layouts on the current workspace to default
        , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

        -- toggle fullscreen layout
        , ((modm,               xK_f     ), toggleFull conf)

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
        , ((modm .|. shiftMask, xK_b     ), sendMessage ToggleStruts       )

        -- display logout menu
        , ((modm .|. shiftMask, xK_q     ), spawn "rofi -show p -modi p:~/.config/rofi/rofi-power-menu")

        -- Quit xmonad
        -- , ((modm .|. shiftMask, xK_e     ), io (exitWith ExitSuccess))

        -- Restart xmonad
        , ((modm,               xK_grave ), spawn "xmonad --recompile; xmonad --restart")

        -- Start Chromium
        , ((modm,               xK_b     ), spawn "chromium")

        -- Take a screenshot and save to file in ~/Pictures/Screenshots/
        , ((0   .|. shiftMask,  xK_Print ), spawn "shotgun -g `hacksaw -c 'ebdbb2'` \"/home/furokku/Pictures/Screenshots/ss_`date +%Y%m%d' '%H%M%S`.png\" && notify-send \"screenshot saved to ~/Pictures/Screenshots\"")
        -- take a screenshot and copy to clipboard
        , ((0   ,               xK_Print ), spawn "shotgun -g `hacksaw -c 'ebdbb2'` - | xclip -t image/png -sel clip")
        -- take a screenshot of the current window and copy it to the clipboard
        , ((0   .|. controlMask, xK_Print), spawn "shotgun -i `xdotool getactivewindow` - | xclip -t image/png -sel clip")

        -- pick color from monitor and copy hex value to clipboard
        , ((modm .|. controlMask,  xK_p  ), spawn "xcolor | xclip -sel clip")

        -- lock screen
        , ((modm .|. controlMask, xK_l   ), spawn "loginctl lock-session")
    
        -- enable/disable redshift
        , ((modm,               xK_z     ), spawn "redshift -O 5000K")
        , ((modm .|. shiftMask, xK_z     ), spawn "redshift -x")
    
        -- start file manager
        , ((modm,               xK_n     ), spawn "pcmanfm")
  
        -- close all dunst notifications
        , ((modm,               xK_c     ), spawn "dunstctl close-all")

        -- mpc controls, volume adjustment
        , ((modm .|. shiftMask, xK_d     ), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ((modm,               xK_minus ), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%" )
        , ((modm,               xK_equal ), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%" )
        , ((modm .|. shiftMask, xK_m     ), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
        , ((0   ,          xK_Scroll_Lock), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")

        , ((modm,               xK_p     ), spawn "mpc toggle")
        , ((modm,               xK_bracketleft), spawn "mpc prev")
        , ((modm,               xK_bracketright), spawn "mpc next")
        , ((modm .|. shiftMask, xK_bracketleft), spawn "mpc seek -00:00:10")
        , ((modm .|. shiftMask, xK_bracketright), spawn "mpc seek +00:00:10")
        , ((modm .|. shiftMask, xK_minus ), spawn "mpc volume -5")
        , ((modm .|. shiftMask, xK_equal ), spawn "mpc volume +5")
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
       -- focus adjacent windows
          ((modm,               xK_k     ), windows W.focusUp   )
        , ((modm,               xK_j     ), windows W.focusDown )
       -- Swap adjacent windows
        , ((modm,               xK_h     ), windows W.swapUp   )
        , ((modm,               xK_l     ), windows W.swapDown )
        
       -- tab between windows, Windows-style
       -- kinda meh
--      , ((modm,               xK_Tab   ), nextMatch Forward  (return True))
--      , ((modm .|. shiftMask, xK_Tab   ), nextMatch Backward (return True))
    ]

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

myTabConfig = def {
    activeTextColor     = "#ebdbb2",
    activeColor         = "#282828",
    activeBorderColor   = "#b8bb26",
    inactiveTextColor   = "#3c3836",
    inactiveColor       = "#1d2021",
    inactiveBorderColor = "#fb4934",
    fontName            = "xft:Terminus:size=12"
}

myLayout = avoidStruts (tiled ||| noBorders Full)
  where
     tiled   = spacing 6 $ Tall nmaster delta ratio
--   cTabbed = gaps (zip [U,D,L,R] (repeat 6)) $ tabbedBottom shrinkText myTabConfig
--   bsp     = spacing 6 $ emptyBSP
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules

myManageHook = composeAll
    [ className =? "mpv"                --> doFloat
    , className =? "Pavucontrol"        --> doFloat
    , className =? "Songrec"            --> doFloat
    , stringProperty "WM_NAME" =? "Profile error occurred" --> doFloat

    , resource  =? "nsxiv"              --> doFloat
    , resource  =? "pcmanfm"            --> doFloat
    , resource  =? "file-roller"        --> doFloat
    , className =? "Gedit"              --> doFloat
    , className =? "PrismLauncher"      --> doFloat

    , resource  =? "desktop_window"     --> doIgnore
    , resource  =? "kdesktop"           --> doIgnore ]


-- ok?
myLogHook = return ()

-- event hook
myEventHook = mconcat []

-- startup
myStartupHook = do

              spawn "/home/furokku/.config/polybar/launch.sh"
              spawn "/home/furokku/.config/dunst/launch.sh"

              spawn "pkill xss-lock; xss-lock -- betterlockscreen -l"
--            spawn "picom --use-ewmh-active-win --experimental-backends --glx-no-stencil --xrender-sync-fence"
              spawn "feh --no-fehbg --bg-fill /home/furokku/.local/wallpaper/flowersbm.png"
              spawn "xrdb ~/.Xresources"
--            spawn "pkill imwheel; imwheel -b \"45\""

--            spawnOnce "steam -silent"
--            spawnOnce "discord-canary"
--            spawnOnce "flameshot"

              spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
              spawnOnce "xsetroot -cursor_name left_ptr"
              spawnOnce "numlockx on"
              spawnOnce "xrandr --output DisplayPort-1 --primary --mode 1920x1080 --output DVI-D-0 --mode 1600x1200 --left-of DisplayPort-1"
              spawnOnce "dbus-update-activation-environment --all"
--            spawnOnce "oneko"

main = xmonad $ docks . ewmhFullscreen . ewmh $ defaults

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
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
}

