import XMonad
import Data.Monoid
import Data.Ratio
import System.Exit
import Graphics.X11.ExtraTypes.XF86

import XMonad.Operations

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Actions.SpawnOn (spawnOn)

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
myNormalBorderColor  = "#928374"
myFocusedBorderColor = "#ebdbb2"
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

        -- DEPRECATED: see xorg config file to change the layout now
        -- change kb layout
        -- , ((modm,               xK_Home  ), spawn "i3-keyboard-layout cycle us ua ru")

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

        -- add later to flags:  --use-fake-device-for-media-stream
        -- Start Chromium(!)
        , ((modm,               xK_b     ), spawn "chromium --block-new-web-contents --disable-background-networking --disable-breakpad --disable-composited-antialiasing --disable-crash-reporter --disable-default-apps --disable-domain-reliability --disable-external-intent-requests --disable-file-system --disable-webgl --gpu-rasterization-msaa-sample-count=0 --lite-video-force-override-decision --no-pings --num-raster-threads=4 --process-per-site --site-per-process --time-zone-for-testing=UTC --enable-features=\"VaapiVideoEncoder,VaapiVideoDecoder,BlockInsecurePrivateNetworkRequests,BlockInsecurePrivateNetworkRequestsForNavigations,BrowserDynamicCodeDisabled,DesktopScreenshots,DisableProcessReuse,ElementSuperRareData,EnableCsrssLockdown,EncryptedClientHello,ForceIsolationInfoFrameOriginToTopLevelFrame,GpuAppContainer,ImprovedCookieControls,IntensiveWakeUpThrottling:grace_period_seconds/10,IsolateOrigins,IsolatePrerenders,IsolateSandboxedIframes,MinimizeAudioProcessingForUnusedOutput,NetworkServiceSandbox,NetworkServiceCodeIntegrity,OpaqueResponseBlockingV01,OriginIsolationHeader,PartitionConnectionsByNetworkIsolationKey,PartitionDomainReliabilityByNetworkIsolationKey,PartitionExpectCTStateByNetworkIsolationKey,PartitionHttpServerPropertiesByNetworkIsolationKey,PartitionNelAndReportingByNetworkIsolationKey,PartitionSSLSessionsByNetworkIsolationKey,PartitionedCookies,PostQuantumCECPQ2,PrefetchPrivacyChanges,ReducedReferrerGranularity,RendererAppContainer,RestrictGamepadAccess,SandboxExternalProtocolBlocked,SandboxHttpCache,ScopeMemoryCachePerContext,SplitAuthCacheByNetworkIsolationKey,SplitCacheByIncludeCredentials,SplitCacheByNetworkIsolationKey,SplitHostCacheByNetworkIsolationKey,StrictOriginIsolation,SuppressDifferentOriginSubframeJSDialogs,ThirdPartyStoragePartitioning,ThrottleForegroundTimers,TurnOffStreamingMediaCachingAlways,TurnOffStreamingMediaCachingOnBattery,UseRegistrableDomainInNetworkIsolationKey,WinSboxDisableExtensionPoint,WinSboxDisableKtmComponent\" --disable-features=\"AcceptCHFrame,AdInterestGroupAPI,AllowClientHintsToThirdParty,AllowURNsInIframes,AppActivityReporting,AppDiscoveryRemoteUrlSearch,AutofillEnableAccountWalletStorage,AutofillServerCommunication,AutoupgradeMixedContent,BrowsingTopics,ClearCrossSiteCrossBrowsingContextGroupWindowName,ClientHintThirdPartyDelegation,ClientHintsDPR,ClientHintsDPR_DEPRECATED,ClientHintsDeviceMemory,ClientHintsDeviceMemory_DEPRECATED,ClientHintsMetaHTTPEquivAcceptCH,ClientHintsMetaNameAcceptCH,ClientHintsResourceWidth,ClientHintsResourceWidth_DEPRECATED,ClientHintsViewportWidth,ClientHintsViewportWidth_DEPRECATED,ComputePressure,ContextMenuPerformanceInfoAndRemoteHintFetching,ConversionMeasurement,CopyLinkToText,CrashReporting,CriticalClientHint,CrossOriginOpenerPolicyAccessReporting,CrossOriginOpenerPolicyReporting,CrossOriginOpenerPolicyReportingOriginTrial,CrostiniAdditionalEnterpriseReporting,CssSelectorFragmentAnchor,DirectSockets,DocumentReporting,EnableSignedExchangePrefetchCacheForNavigations,EnableSignedExchangeSubresourcePrefetch,EnableStructuredMetrics,EnableSubresourceWebBundles,EnterpriseRealtimeExtensionRequest,EventBasedStatusReporting,ExpectCTReporting,ExperimentalJSProfiler,EnableTLS13EarlyData,FedCm,Fledge,FontAccess,FontAccessPersistent,GreaseUACH,HandwritingRecognitionWebPlatformApiFinch,IdleDetection,InterestGroupStorage,Journeys,LensStandalone,MediaDrmPreprovisioning,MediaEngagementBypassAutoplayPolicies,NTPArticleSuggestions,NetworkTimeServiceQuerying,NotificationTriggers,OmniboxTriggerForNoStatePrefetch,OptimizationHints,OptimizationHintsFetching,OptimizationHintsFetchingAnonymousDataConsent,OptimizationHintsFieldTrials,Parakeet,Prerender2,PrefersColorSchemeClientHintHeader,PreloadMediaEngagementData,ReportAllJavaScriptFrameworks,Reporting,RetailCoupons,SegmentationPlatform,SignedExchangeReportingForDistributors,SpeculationRulesPrefetchProxy,SubresourceWebBundles,TabMetricsLogging,TFLiteLanguageDetectionEnabled,TextFragmentAnchor,SafeBrowsingBetterTelemetryAcrossReports,UACHPlatformEnabledByDefault,UserAgentClientHint,UserAgentClientHintFullVersionList,UsernameFirstFlow,UsernameFirstFlowFilling,UsernameFirstFlowFallbackCrowdsourcing,ViewportHeightClientHintHeader,WebNFC,WebOTP,WebSQLInThirdPartyContextEnabled,WebXR,WinrtGeolocationImplementation,WinrtSensorsImplementation\" --connectivity-check-url=0.0.0.0 --crash-server-url=0.0.0.0 --gaia-url=0.0.0.0 --gcm-checkin-url=0.0.0.0 --gcm-mcs-endpoint=0.0.0.0 --gcm-registration-url=0.0.0.0 --google-apis-url=0.0.0.0 --google-base-url=0.0.0.0 --google-doodle-url=0.0.0.0 --lso-url=0.0.0.0 --oauth-account-manager-url=0.0.0.0 --override-metrics-upload-url=0.0.0.0 --realtime-reporting-url=0.0.0.0 --reporting-connector-url=0.0.0.0 --sync-url=0.0.0.0 --url=0.0.0.0 --variations-server-url=0.0.0.0 --variations-insecure-server-url=0.0.0.0 --cipher-suite-blacklist=\"0xc013,0xc014,0x009c,0x009d,0x002f,0x0035\" --enable-strict-mixed-content-checking --js-flags=--jitless --blink-settings=\"dnsPrefetchingEnabled=false,preferredColorScheme=1,strictMixedContentChecking=true,strictMixedContentCheckingForPlugin=true,strictlyBlockBlockableMixedContent=true\" --disable-blink-features=\"PrefersContrast,GravitySensor\" --test-type")

        -- Take a screenshot and save to file in ~/Pictures/Screenshots/
        , ((0   .|. shiftMask,  xK_Print ), spawn "shotgun -g `hacksaw -c 'ebdbb2'` \"/home/furokku/Pictures/Screenshots/ss_`date +%Y%m%d' '%H%M%S`.png\"")

        -- take a screenshot but copy to clipboard
        , ((0   ,               xK_Print ), spawn "shotgun -g `hacksaw -c 'ebdbb2'` - | xclip -t 'image/png' -sel clip")

        -- lock screen
        , ((modm,               xK_y     ), spawn "loginctl lock-session")
    
        -- redshift
        , ((modm,               xK_z     ), spawn "redshift -O 4500K")
        , ((modm,               xK_x     ), spawn "redshift -x")
    
        -- start file manager
        , ((modm,               xK_n     ), spawn "pcmanfm")
  
        -- close all dunst notifs
        , ((modm,               xK_c     ), spawn "dunstctl close-all")

        -- kill picom
--      , ((modm,               xK_s     ), spawn "pkill picom")
--      , ((modm .|. shiftMask, xK_s     ), spawn "picom --use-ewmh-active-win --experimental-backends --glx-no-stencil --xrender-sync-fence")

        -- mpc controls, volume adjustment
    
        , ((modm .|. shiftMask, xK_d     ), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ((modm,               xK_minus ), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%" )
        , ((modm,               xK_equal ), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%" )
        , ((modm .|. shiftMask, xK_m     ), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")

        , ((modm,               xK_o     ), spawn "mpc toggle")
        , ((modm,               xK_i     ), spawn "mpc prev")
        , ((modm,               xK_p     ), spawn "mpc next")
        , ((modm .|. shiftMask, xK_i     ), spawn "mpc seek -00:00:10")
        , ((modm .|. shiftMask, xK_p     ), spawn "mpc seek +00:00:10")
        , ((modm,               xK_bracketleft ), spawn "mpc volume -5")
        , ((modm,               xK_bracketright), spawn "mpc volume +5")
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


myLayout = avoidStruts (tiled ||| noBorders Full)
  where
     tiled   = spacing 6 $ Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules

myManageHook = composeAll
    [ className =? "mpv"                --> doFloat
    , className =? "Pavucontrol"        --> doFloat

    , resource  =? "vimiv"              --> doRectFloat (W.RationalRect (1%4) (1%4) (1%2) (1%2))
    , resource  =? "pcmanfm"            --> doFloat
    , resource  =? "file-roller"        --> doFloat
    , className =? "Gedit"              --> doFloat

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

--            spawnOnce "steam -silent"
--            spawnOnce "discord-canary"
--            spawnOnce "flameshot"

              spawnOnce "xsetroot -cursor_name left_ptr"
              spawnOnce "numlockx on"
              spawnOnce "xrandr --output DisplayPort-1 --primary --mode 1920x1080 --output HDMI-A-0 --right-of DisplayPort-1 --mode 1280x1024 --output DVI-D-0 --left-of DisplayPort-1 --mode 1280x1024"

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
