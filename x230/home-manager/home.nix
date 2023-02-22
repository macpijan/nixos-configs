{ config, lib, pkgs, ... }:

# dotfiles to be migrated into nix at some point
let
  myusername = "macpijan";
  dotfiles-repo = "/home/${myusername}/nixos-configs/dotfiles";
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "myusername";
  home.homeDirectory = "/home/${myusername}";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      update = "sudo nixos-rebuild switch";
      hash = "nix-hash --flat --base32 --type sha256";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "vi-mode" "zsh-256color" "zsh-completions" ];
      theme = "half-life";
    };
    plugins = [
      {
        name = "zsh-256color";
        src = pkgs.fetchFromGitHub {
          owner = "chrissicool";
          repo = "zsh-256color";
          rev = "9d8fa1015dfa895f2258c2efc668bc7012f06da6";
	  sha256 = "14pfg49mzl32ia9i9msw9412301kbdjqrm7gzcryk4wh6j66kps1";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.33.0";
	  sha256 = "0vs14n29wvkai84fvz3dz2kqznwsq2i5fzbwpv8nsfk1126ql13i";
        };
      }
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      ack-vim
      auto-pairs
      ctrlp
      nerdcommenter
      nerdtree
      {
        plugin = lightline-vim;
        config = ''
          let g:lightline = {}
          let g:lightline.colorscheme = 'gruvbox'
        '';
      }
      tagbar
      vim-addon-mw-utils
      easymotion
      fugitive
      gitgutter
      vim-move
      vim-over
      repeat
      vim-signify
      sleuth
      surround
      wildfire-vim
      tlib
      syntastic
      vim-indent-guides
      gruvbox
      # {
      #   plugin = gruvbox-nvim;
      #   config = ''
      #     packadd! gruvbox-nvim.lua
      #     lua require 'gruvbox'.setup()
      #   ''
      #   ;
      # }
    ];
    extraConfig = ''
      " Better copy & paste
      set pastetoggle=<F2>
      set clipboard=unnamedplus

      " Mouse and backspace
      set bs=2     " make backspace behave like normal again
      set mouse=a " enable mouse

      " Rebind <Leader> key
      let mapleader = ","

      " Bind nohl
      " Removes highlight of your last search
      " ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
      noremap <C-n> :nohl<CR>
      vnoremap <C-n> :nohl<CR>
      inoremap <C-n> :nohl<CR>

      " Quicksave command
      noremap <C-Z> :update<CR>
      vnoremap <C-Z> <C-C>:update<CR>
      inoremap <C-Z> <C-O>:update<CR>

      " Quick quit command
      noremap <Leader>e :quit<CR>  " Quit current window
      noremap <Leader>E :qa!<CR>   " Quit all windows

      " bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
      " Every unnecessary keystroke that can be saved is good for your health :)
      map <c-j> <c-w>j
      map <c-k> <c-w>k
      map <c-l> <c-w>l
      map <c-h> <c-w>h

      " easier moving between tabs
      map <Leader>n <esc>:tabprevious<CR>
      map <Leader>m <esc>:tabnext<CR>

      " easier moving of code blocks
      " Try to go into visual mode (v), then select several lines of code here and
      " then press ``>`` several times.
      vnoremap < <gv  " better indentation
      vnoremap > >gv  " better indentation

      " Show whitespace
      " MUST be inserted BEFORE the colorscheme command
      autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
      au InsertLeave * match ExtraWhitespace /\s\+$/

      " Disable syntax highlight for files larger than 50 MB
      autocmd BufWinEnter * if line2byte(line("$") + 1) > 50000000 | syntax clear | endif

      " Enable syntax highlighting
      filetype off
      filetype plugin indent on
      syntax on

      " Showing line numbers and length
      set number  " show line numbers
      set tw=79   " width of document (used by gd)
      set nowrap  " don't automatically wrap on load
      set fo-=t   " don't automatically wrap text when typing
      set colorcolumn=80
      highlight ColorColumn ctermbg=233

      " Useful settings
      set history=700
      set undolevels=700
      set cursorline
      set scrolloff=3

      " spellchecking
      set spell spelllang=en_us

      " map to upper case as well
      cmap WQ wq
      cmap Wq wq
      cmap W w
      cmap Q q

      " let vim-sleuth to adjust it
      "
      " use spaces
      "set tabstop=4
      "set softtabstop=4
      "set shiftwidth=4
      "set shiftround
      " use tabs
      "set noexpandtab
      "set copyindent
      "set preserveindent
      "set softtabstop=0
      "set shiftwidth=8
      "set tabstop=8
      "
      " use vim-indent-guides instead
      "set list
      "set listchars=tab:>-

      " Make search case insensitive
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase

      " Disable stupid backup and swap files - they trigger too many events
      " for file system watchers
      set nobackup
      set nowritebackup
      set noswapfile

      " Color scheme
      colorscheme gruvbox

      " vim-indent-guides color
      let g:indent_guides_enable_on_vim_startup = 1
      let g:indent_guides_start_level = 1
      let g:indent_guides_guide_size = 1

      let g:indent_guides_auto_colors = 0
      autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=0
      autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=8

      " Settings for ctrlp
      let g:ctrlp_max_height = 30
      set wildignore+=*.pyc
      set wildignore+=*build/*
      set wildignore+=*dist/*
      set wildignore+=*.egg-info/*
      set wildignore+=*/coverage/*

      " Better navigating through omnicomplete option list
      " See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
      set completeopt=longest,menuone
      function! OmniPopup(action)
          if pumvisible()
              if a:action == 'j'
                  return "\<C-N>"
              elseif a:action == 'k'
                  return "\<C-P>"
              endif
          endif
          return a:action
      endfunction

      inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
      inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

      " NERDTree
      " cd ~/.vim/bundle
      " git clone https://github.com/scrooloose/nerdtree.git
      nmap <leader>t :NERDTree<CR>

      " Display hidden files
      let NERDTreeShowHidden=1

      " Close vim if the only window left open is NERDTree
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

      " Ack for vim
      nmap <leader>a <Esc>:Ack!

      " Vim Git Gutter
      let g:gitgutter_enabled = 0
      nmap <leader>gr :GitGutterToggle<CR>
      nmap <leader>s :GitGutterPrevHunk<CR>
      nmap <leader>d :GitGutterNextHunk<CR>

      " Tagbar
      nmap <F8> :TagbarToggle<CR>

      " Sorted according to their order in the source file
      let g:tagbar_sort = 0

      " Vim Move
      " let g:move_key_modifier = 'C'

      " ============================================================================
      " Filetype detection
      " ============================================================================
      au BufNewFile,BufRead *.tac setl ft=python " .tac files are used in twisted
      au BufNewFile,BufRead *.json setl ft=javascript
      au BufNewFile,BufRead *.txt setl ft=text
      au BufNewFile,BufRead *.c setl ft=c

      set statusline+=%#warningmsg#
      set statusline+=%{SyntasticStatuslineFlag()}
      set statusline+=%*

      let g:syntastic_always_populate_loc_list = 1
      let g:syntastic_auto_loc_list = 1
      let g:syntastic_check_on_open = 1
      let g:syntastic_check_on_wq = 0

      " Remove whitespaces
      nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR> :nohl <Bar> :unlet _s <CR>

    '';
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
  };

  home.file = {
    ".gitconfig".source = "${dotfiles-repo}/gitconfig";
  };
}
