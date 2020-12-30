{ config, pkgs, ... }:

{
  imports = [ # {{{
    ./hardware-configuration.nix
  ]; # }}}

  boot.extraModulePackages = with pkgs; [ linuxPackages.acpi_call ];

  boot.loader = { # {{{
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  }; # }}}

  environment.etc = { # {{{
    "firefox/policies/policies.json" = { # {{{
      text = ''
        {
          "policies": {
            "DisableSetDesktopBackground": true
          }
        }
      '';
    }; # }}}
    "proxychains.conf" = { # {{{
      text = ''
        strict_chain
        proxy_dns
        remote_dns_subnet 224
        tcp_read_time_out 15000
        tcp_connect_time_out 8000
        localnet 127.0.0.0/255.0.0.0
        quiet_mode

        [ProxyList]
        socks5 127.0.0.1 1080
      '';
    }; # }}}
    termiterc = { # {{{
      text = ''
        [options]
        #font = DejaVu Sans Mono 10
        font = DejaVuSansMono Nerd Font 10
        [colors]
        foreground = #00ab72
        foreground_bold = #812990
        cursor = #e4e4e4
        cursor_foreground = #303030
        background = #292929
      '';
    }; # }}}
    xmobarrc = { # {{{
      text = ''
        Config {
          font         = "xft:DejaVuSansMono Nerd Font-11,WenQuanYi Micro Hei-11",
          bgColor      = "#000000",
          fgColor      = "#d0d0d0",
          border       = BottomB,
          position     = Top,
          lowerOnStart = False,
          allDesktops  = True,
          persistent   = True,
          sepChar      = "%",
          alignSep     = "}{",
          template     = " <fc=#ffffff>%StdinReader%</fc>}{ %battery% | %cpu% | %memory% | %dynnetwork% | %date% ",
          commands = [
            Run StdinReader,
            Run Battery [
              "--template", "<acstatus>",
              "--Low",      "15",
              "--High",     "80",
              "--low",      "#d70000",
              "--normal",   "#d78700",
              "--high",     "#005fd7",
              "--",
              "-o",         "<fc=#ffd700></fc> <left>% <fc=#ffd700><timeleft></fc>",
              "-O",         "<fc=#ffd700> <timeleft></fc>",
              "-i",         "<fc=#ffd700></fc>"
            ] 50,
            Run Cpu [
              "--template", "<fc=#ff8787></fc> <total>%",
              "--Low",      "40",
              "--High",     "85",
              "--low",      "#005fd7",
              "--normal",   "#d78700",
              "--high",     "#d70000"
            ] 10,
            Run Memory [
              "--template", "<fc=#5f875f></fc> <usedratio>%",
              "--Low",      "30",
              "--High",     "85",
              "--low",      "#005fd7",
              "--normal",   "#d78700",
              "--high",     "#d70000"
            ] 10,
            Run DynNetwork [
              "--template", "<fc=#00afff>龍</fc> <rx>kB/s",
              "--Low",      "204800",
              "--High",     "2097152",
              "--low",      "#d70000",
              "--normal",   "#d78700",
              "--high",     "#005fd7"
            ] 10,
            Run Date "<fc=#ff0000>%b %d %H:%M:%S</fc>" "date" 10
          ]
        }
      '';
    }; # }}}
  }; # }}}

  environment.systemPackages = with pkgs; [ # {{{
    binutils
    ctags
    dmenu
    exercism
    fcitx-configtool
    feh
    firefox-esr
    gcc
    gimp
    git
    haskellPackages.brittany
    haskellPackages.ghc
    haskellPackages.stack
    haskellPackages.xmobar
    libreoffice
    patchelf
    ponyc
    proxychains
    rubocop
    ruby
    rustup
    scrot
    termite
    tpacpi-bat
    typora
    usbutils
    usermount
    wget
    wmname
    (python3.withPackages (ps: with ps; [ # {{{
      autopep8
      ptpython
      pytest
    ])) # }}}
    ((vim_configurable.override { python = python3; }).customize { # {{{
      name = "vim";
      vimrcConfig.plug.plugins = with pkgs.vimPlugins; [ # {{{
        auto-pairs
        ctrlp-vim
        haskell-vim
        indentLine
        nerdtree
        rust-vim
        syntastic
        tagbar
        vim-airline
        vim-airline-themes
        vim-autoformat
        vim-devicons
        vim-fugitive
        vim-nix
        vim-nong-theme
        vim-pony
        YouCompleteMe
      ]; # }}}
      vimrcConfig.customRC = '' " {{{
        " vim-airline & vim-airline-theme settings
        let g:airline_theme = 'minimalist'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline_powerline_fonts = 1
        nnoremap <leader>h :bp<CR>
        nnoremap <leader>l :bn<CR>
        nnoremap <leader>1 :b 1<CR>
        nnoremap <leader>2 :b 2<CR>
        nnoremap <leader>3 :b 3<CR>
        nnoremap <leader>4 :b 4<CR>
        nnoremap <leader>5 :b 5<CR>
        nnoremap <leader>6 :b 6<CR>
        nnoremap <leader>7 :b 7<CR>
        nnoremap <leader>8 :b 8<CR>
        nnoremap <leader>9 :b 9<CR>
        nnoremap <leader>0 :b 10<CR>
        nnoremap <leader>d1 :bd 1<CR>
        nnoremap <leader>d2 :bd 2<CR>
        nnoremap <leader>d3 :bd 3<CR>
        nnoremap <leader>d4 :bd 4<CR>
        nnoremap <leader>d5 :bd 5<CR>
        nnoremap <leader>d6 :bd 6<CR>
        nnoremap <leader>d7 :bd 7<CR>
        nnoremap <leader>d8 :bd 8<CR>
        nnoremap <leader>d9 :bd 9<CR>
        nnoremap <leader>d0 :bd 10<CR>

        " vim-autoformat settings
        let g:autoformat_autoindent = 0
        let g:formatdef_brittany = '"brittany"'
        let g:formatters_haskell = ['brittany']
        autocmd BufWrite * :Autoformat

        " nerdtree settings
        let g:NERDTreeWinSize = 30
        nnoremap <leader>nt :NERDTreeToggle<CR>

        " synastic settings
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
        let g:syntastic_loc_list_height = 7
        let g:ycm_show_diagnostics_ui = 0
        let g:syntastic_error_symbol = '_'
        let g:syntastic_warning_symbol = '_'
        nnoremap <leader>so :Errors<CR>
        nnoremap <leader>sc :lclose<CR>
        nnoremap <leader>sj :lnext<CR>
        nnoremap <leader>sk :lprevious<CR>

        " tarbar settings
        let g:tagbar_width = 30
        nnoremap <leader>ct :!ctags -R<CR><CR>
        nnoremap <leader>tb :TagbarToggle<CR>

        " youcompleteme settings
        set completeopt=menu,menuone
        let g:ycm_seed_identifiers_with_syntax = 1
        let g:ycm_add_preview_to_completeopt = 0

        " other settings
        set nocompatible
        colorscheme nong
        syntax on
        set encoding=UTF-8
        set ruler
        set number
        set backspace=2
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set foldenable
        set foldmethod=marker
        set showcmd
        set autoindent
        set showmatch
        set mouse=a
        set cursorline

        autocmd Filetype haskell,html,javascript,vim setlocal shiftwidth=2 tabstop=2
      ''; # }}}
    }) # }}}
  ]; # }}}

  environment.variables = { # {{{
    EDITOR = "vim";
  }; # }}}

  fonts = { # {{{
    fontDir.enable = true;
    fonts = with pkgs; [ wqy_microhei ];
  }; # }}}

  hardware.opengl.driSupport32Bit = true;

  hardware.trackpoint = { # {{{
    enable = true;
    emulateWheel = true;
    sensitivity = 127;
    speed = 180;
  }; # }}}

  hardware.pulseaudio = { # {{{
    enable = true;
    support32Bit = true;
  }; # }}}

  i18n.inputMethod.enabled = "fcitx";

  location.provider = "geoclue2";

  networking = { # {{{
    extraHosts = ''
      151.101.184.133 assets-cdn.github.com
      151.101.184.133 gist.githubusercontent.com
      151.101.184.133 cloud.githubusercontent.com
      151.101.184.133 camo.githubusercontent.com
      151.101.184.133 raw.githubusercontent.com
      151.101.184.133 user-images.githubusercontent.com
      151.101.184.133 avatars0.githubusercontent.com
      151.101.184.133 avatars1.githubusercontent.com
      151.101.184.133 avatars2.githubusercontent.com
      151.101.184.133 avatars3.githubusercontent.com
      151.101.184.133 avatars4.githubusercontent.com
      151.101.184.133 avatars5.githubusercontent.com
      151.101.184.133 avatars6.githubusercontent.com
      151.101.184.133 avatars7.githubusercontent.com
      151.101.184.133 avatars8.githubusercontent.com
    '';
    hostName = "in";
    networkmanager.enable = true;
  }; # }}}

  nix.binaryCaches = [ # {{{
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ]; # }}}

  nixpkgs.config.allowUnfree = true;

  programs.java.enable = true;

  programs.zsh = { # {{{
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "lambda";
    };
  }; # }}}

  services.illum.enable = true;

  services.logind.lidSwitch = "lock";

  services.redshift.enable = true;

  services.tlp = { # {{{
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT1 = 100;
      STOP_CHARGE_THRESH_BAT1 = 100;
    };
  }; # }}}

  services.v2ray = { # {{{
    enable = true;
  }; # }}}

  services.xserver = { # {{{
    enable = true;
    displayManager.sessionCommands = '' # {{{
      ${pkgs.usermount}/bin/usermount &
      ${pkgs.wmname}/bin/wmname LG3D &
      ${pkgs.xorg.xinput}/bin/xinput disable 'SynPS/2 Synaptics TouchPad'
    ''; # }}}
    displayManager.gdm.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = '' -- {{{
        import           XMonad
        import           XMonad.Hooks.DynamicLog
        import           XMonad.Hooks.ManageDocks
        import           XMonad.Util.Run
        import           Graphics.X11.ExtraTypes.XF86
        import           Data.Monoid
        import           System.IO
        import           System.Exit
        import qualified XMonad.StackSet               as W
        import qualified Data.Map                      as M

        myTerminal = "termite --config=/etc/termiterc"
        myFocusFollowsMouse = True
        myClickJustFocuses = False
        myBorderWidth = 1
        myModMask = mod4Mask
        myWorkspaces = ["1-Gen", "2-Ter", "3-Web", "4-Cod", "5-Oth", "6-Bac"]
        myNormalBorderColor = "black"
        myFocusedBorderColor = "black"

        myKeys conf@(XConfig { XMonad.modMask = modm }) = -- {{{
          M.fromList
            $
               -- launch a terminal
               [ ( (modm .|. shiftMask, xK_Return)
                 , spawn $ XMonad.terminal conf
                 )

               -- launch dmenu
               , ( (modm, xK_p)
                 , spawn "dmenu_run"
                 )

               -- launch gmrun
               , ( (modm .|. shiftMask, xK_p)
                 , spawn "gmrun"
                 )

               -- close focused window
               , ( (modm .|. shiftMask, xK_c)
                 , kill
                 )

               -- Rotate through the available layout algorithms
               , ( (modm, xK_space)
                 , sendMessage NextLayout
                 )

               --  Reset the layouts on the current workspace to default
               , ( (modm .|. shiftMask, xK_space)
                 , setLayout $ XMonad.layoutHook conf
                 )

               -- Resize viewed windows to the correct size
               , ( (modm, xK_n)
                 , refresh
                 )

               -- Move focus to the next window
               , ( (modm, xK_Tab)
                 , windows W.focusDown
                 )

               -- Move focus to the next window
               , ( (modm, xK_j)
                 , windows W.focusDown
                 )

               -- Move focus to the previous window
               , ( (modm, xK_k)
                 , windows W.focusUp
                 )

               -- Move focus to the master window
               , ( (modm, xK_m)
                 , windows W.focusMaster
                 )

               -- Swap the focused window and the master window
               , ( (modm, xK_Return)
                 , windows W.swapMaster
                 )

               -- Swap the focused window with the next window
               , ( (modm .|. shiftMask, xK_j)
                 , windows W.swapDown
                 )

               -- Swap the focused window with the previous window
               , ( (modm .|. shiftMask, xK_k)
                 , windows W.swapUp
                 )

               -- Shrink the master area
               , ( (modm, xK_h)
                 , sendMessage Shrink
                 )

               -- Expand the master area
               , ( (modm, xK_l)
                 , sendMessage Expand
                 )

               -- Push window back into tiling
               , ( (modm, xK_t)
                 , withFocused $ windows . W.sink
                 )

               -- Increment the number of windows in the master area
               , ( (modm, xK_comma)
                 , sendMessage (IncMasterN 1)
                 )

               -- Deincrement the number of windows in the master area
               , ( (modm, xK_period)
                 , sendMessage (IncMasterN (-1))
                 )

               -- Toggle the status bar gap
               -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

               -- Quit xmonad
               , ( (modm .|. shiftMask, xK_q)
                 , io (exitWith ExitSuccess)
                 )

               -- Restart xmonad
               , ( (modm, xK_q)
                 , spawn "xmonad --recompile; xmonad --restart"
                 )

               -- Custom
               , ((0, xK_Print), spawn "scrot ~/Pictures/Screenshot-%Y%m%d-%H%M%S.png")
               , ( (modm, xK_Print)
                 , spawn "scrot -u ~/Pictures/Screenshot-%Y%m%d-%H%M%S.png"
                 )
               ]
            ++

               -- mod-[1..9], Switch to workspace N
               -- mod-shift-[1..9], Move client to workspace N
               [ ((m .|. modm, k), windows $ f i)
               | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
               , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
               ]
            ++

               -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
               -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
               [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
               | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..]
               , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
               ] -- }}}

        myMouseBindings (XConfig { XMonad.modMask = modm }) = -- {{{
          M.fromList
            $
              -- mod-button1, Set the window to floating mode and move by dragging
              [ ( (modm, button1)
                , (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
                )

              -- mod-button2, Raise the window to the top of the stack
              , ( (modm, button2)
                , (\w -> focus w >> windows W.shiftMaster)
                )

              -- mod-button3, Set the window to floating mode and resize by dragging
              , ( (modm, button3)
                , (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
                )

              -- you may also bind events to the mouse scroll wheel (button4 and button5)
              ] -- }}}

        -- You can specify and transform your layouts by modifying these values.
        -- If you change layout bindings be sure to use 'mod-shift-space' to reset your layout state.
        -- Each layout is separated by |||, which denotes layout choice.
        myLayout = tiled ||| Mirror tiled ||| Full
         where
          -- default tiling algorithm partitions the screen into two panes
          tiled   = Tall nmaster delta ratio

          -- The default number of windows in the master pane
          nmaster = 1

          -- Default proportion of screen occupied by master pane
          ratio   = 1 / 2

          -- Percent of screen to increment by when resizing panes
          delta   = 3 / 100

        -- Execute arbitrary actions and WindowSet manipulations when managing a new window.
        -- You can use this to always float a particular program
        -- Or have a client always appear on a particular workspace.
        -- To find the property name associated with a program
        -- Use > xprop | grep WM_CLASS and click on the client you're interested in.
        -- You can use 'title' in the same way that 'className' and 'resource' are used below.
        myManageHook = composeAll [className =? "Gimp" --> doFloat]

        -- EwmhDesktops users should change this to ewmhDesktopsEventHook
        -- Defines a custom handler function for X Events.
        -- The function should return (All True) if the default handler is to be run afterwards.
        -- To combine event hooks use mappend or mconcat from Data.Monoid.
        myEventHook = mempty

        -- Status bars and logging Perform an arbitrary action on each internal state change or X event.
        -- See the 'XMonad.Hooks.DynamicLog' extension for examples.
        myLogHook h = dynamicLogWithPP $ def
          { ppOutput = hPutStrLn h
          , ppTitle  = xmobarColor "#00ab72" "" . shorten 50
          }

        -- Perform an arbitrary action each time xmonad starts or is restarted with mod-q.
        -- Used by, e.g., XMonad.Layout.PerWorkspace to initialize per-workspace layout choices.
        myStartupHook = return ()

        main = do
          xmproc <- spawnPipe "xmobar /etc/xmobarrc"
          xmonad $ docks def {
                             -- simple stuff
                               terminal           = myTerminal
                             , focusFollowsMouse  = myFocusFollowsMouse
                             , clickJustFocuses   = myClickJustFocuses
                             , borderWidth        = myBorderWidth
                             , modMask            = myModMask
                             , workspaces         = myWorkspaces
                             , normalBorderColor  = myNormalBorderColor
                             , focusedBorderColor = myFocusedBorderColor

                             -- key bindings
                             , keys               = myKeys
                             , mouseBindings      = myMouseBindings

                             -- hooks, layouts
                             , layoutHook         = avoidStruts $ myLayout
                             , manageHook         = manageDocks <+> myManageHook
                             , handleEventHook    = myEventHook
                             , logHook            = myLogHook xmproc
                             , startupHook        = myStartupHook
                             }
      ''; # }}}
    };
  }; # }}}

  sound.enable = true;

  system.stateVersion = "21.03";

  time.timeZone = "Etc/GMT-8";

  users.defaultUserShell = pkgs.zsh;

  users.users.indium = { # {{{
    isNormalUser = true;
    home = "/home/indium";
    description = "in";
    extraGroups = [ "adbusers" "docker" "wheel" ];
  }; # }}}

  virtualisation.docker = { # {{{
    enable = true;
  }; # }}}
}
