;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .emacs.d/init.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; $BJ8;z%3!<%I$O(BJIS$B$K$7$F$*$+$J$$$HF|K\8l$,$&$^$/I=<($5$l$J$$(B

;; $B%m!<%I%Q%9$r@_Dj(B
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/auto-install")

;;$B4D6-$K$h$k@Z$jJ,$1(B
(require 'platform-p)

;;--------------------------------------------------------------------------
;; package & MELPA
;;--------------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(require 'melpa)

;;--------------------------------------------------------------------------
;; $B<+:n4X?t(B
;;-------------------------------------------------------------------------
(require 'my-functions)

;;--------------------------------------------------------------------------
;; $B@_Dj(B
;;-------------------------------------------------------------------------

;; $B%3%^%s%I%a%b(B
;; M-l runs the command downcase-word   ;; $BC18l$r>.J8;z$KJQ49(B
;; M-k runs the command upcase-word     ;; $BC18l$rBgJ8;z$KJQ49(B($B%+%9%?%^%$%:$7$F$^$9!"85$N%3%^%s%I$O(B kill-sentence) 
;; M-c runs the command capitalize-word ;; $B8eB3$NC18l$N#1J8;zL\$@$1$rBgJ8;z$K$9$k!#(B
;; M-i runs the command tab-to-tab-stop ;; $B%?%V$rA^F~(B

(global-set-key "\M-k" 'upcase-word)

(ediff-toggle-multiframe)
;(setq initial-frame-alist '((top . 0) (left . 80) (width . 800) (height . 40)))

; $B%;!<%V8e$K%U%!%$%k=*C<$K2~9T$rDI2C(B
(setq require-final-newline nil)

; $B2<$r2!$7$F$b2~9T$r$$$l$J$$$?$a$NJ}K!(B
(setq next-line-add-newlines nil)

; $B%P%C%/%"%C%W%U%!%$%k$r:n$i$J$$(B (init.el~ $B$_$?$$$J$d$D(B)
(setq make-backup-files nil)

; $B2hLL$d!"%U%l!<%`$NI}$KK~$?$J$$%&%#%s%I%&$G$b!"%F%-%9%H$r@^$jJV$7$FI=<($9$k(B
;(setq truncate-partial-width-windows nil)
(setq truncate-partial-width-windows t)

;;; $B%D!<%k%P!<$rI=<($7$J$$(B
(tool-bar-mode 0)

;; set abbrev-mode $BCV49%b!<%I$N@_Dj(B
(setq-default abbrev-mode t)
(quietly-read-abbrev-file)

;; $B9THV9f$NI=<((B
(setq line-number-mode t)
(setq column-number-mode t)

;; $B%5!<%A(B/$B%j%W%l%$%9$J$I$GBgJ8;z$H>.J8;z$r6hJL$7$J$$(B
(setq-default case-fold-search t)

;; $BJT=8(B mode $B$NDI2C(B (prolog mode $B$O>C$($k(B)
(setq auto-mode-alist
      (append '(("\\.c$"           . c-mode)	
		("\\.pl$"          . cperl-mode)
		("\\.cpp$"         . c++-mode)
		("\\.h$"           . c++-mode)
		("[Mm]akefile"     . makefile-mode)
		("\\.dat$\\|.mch$" . hexl-mode))
	      auto-mode-alist))

;; $B%_%K%P%C%U%!$GA0$KBG$A9~$s$@J8;zNs$r:FMxMQ$7$?$$(B (C-x ESC) ($BJ8;zNs$N8!:w$K(BC-p,C-n$B$r3d$jEv$F$k(B) 
;(define-key repeat-complex-command-map "\C-p"  'previous-complex-command)
;(define-key repeat-complex-command-map "\C-n"  'next-complex-command)

;; $BBP1~$9$k3g8L$r!"6/D4I=<($9$k(B
(show-paren-mode t)

;; $B5/F0;~$N%+%l%s%H%G%#%l%/%H%j$N@_Dj(B
(cd "~")

;; $BF0E*Jd40$N$H$-!$%Q%?!<%s$r$=$N$^$^E83+$9$k(B default$B$G$O!$(B case-replace$B$NCM$,F~$C$F$$$k(B
(setq dabbrev-case-replace nil)

;; ffap
(ffap-bindings)

;; $B%J%m%$%s%0$rM-8z$K(B
(put 'narrow-to-region 'disabled nil)

;; transient-mark-mode
(setq transient-mark-mode t)

;;--------------------------------------------------------------------------
;; Emacs$B$KI,MW$J%Q%9$rDL$9(B 
;;-------------------------------------------------------------------------
;; http://sakito.jp/emacs/emacsshell.html#path
;; $B$h$j2<$K5-=R$7$?J*$,(B PATH $B$N@hF,$KDI2C$5$l$^$9(B
(when platform-darwin-p
  (dolist (dir (list
                "/usr/X11/bin"
                "/usr/local/bin"
                "/sbin"
                "/usr/sbin"
                "/bin"
                "/usr/bin"
                "/usr/local/mysql/bin"
                "/Developer/Tools"
                "/usr/local/sbin"
                "/opt/local/sbin"
                "/opt/local/bin" ;; $B$3$l$,(B/usr/bin$B$h$j$b2<$K=q$$$F$"$l$P$h$$(B
                "/usr/local/bin"
                (expand-file-name "~/bin")
                (expand-file-name "~/bin/gnuplot")
                ))
    ;; PATH $B$H(B exec-path $B$KF1$8J*$rDI2C$7$^$9(B
    (when ;; (and 
        (file-exists-p dir) ;; (not (member dir exec-path)))
      (setenv "PATH" (concat dir ":" (getenv "PATH")))
      (setq exec-path (append (list dir) exec-path))))
  )

;;--------------------------------------------------------------------------
;; shell-mode
;;-------------------------------------------------------------------------
; .bashrc$B$G(Bcd$B$d(Bpushd,popd$B$K%(%$%j%"%9$rE=$k>l9g$O!"(BEmacs$BB&$K$bEA$($F$*$/I,MW$,$"$k(B
; http://www.geocities.co.jp/SiliconValley-Bay/9285/EMACS-JA/emacs_412.html
;(setq shell-pushd-regexp "\\(cd\\|pushd\\)")
;(setq shell-popd-regexp "\\(bd\\|popd\\)")

;; shell-mode $B$G%(%9%1!<%W$re:No$KI=<((B
(when platform-darwin-p
  (autoload 'ansi-color-for-comint-mode-on "ansi-color"
    "Set `ansi-color-for-comint-mode' to t." t)
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on))

;;--------------------------------------------------------------------------
;; $B%-!<%P%$%s%I$N@_Dj(B
;;-------------------------------------------------------------------------
; $B%-!<%P%$%s%I(B
(global-unset-key "\C-h")
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\M-h" 'help-for-help)


; grep$B$r%-!<%P%$%s%I(B
(global-set-key "\M-g" 'grep)
(setq grep-command "gmilk ")
(setq grep-use-null-device nil)

; grep-find
(global-set-key "\C-x\C-g" 'grep-find)
(setq grep-find-command "gren ")

;$B85$N%-!<%P%$%s%I$O$J$$(B
(global-set-key "\C-cg" 'goto-line)

;$BCV49(B
(global-set-key "\C-q" 'query-replace)
;; (global-set-key "\M-q" 'query-replace-regexp)
(global-set-key "\M-q" 'replace-string)

;$B:G8e$N%-!<%\!<%I%^%/%m$r8F$S=P$9(B
(global-set-key "\C-t" 'call-last-kbd-macro)

;$B$J$<$+!"(BM-,$B$OH?1~$7$J$$!&!&!&(B
(global-set-key "\M-'" 'tags-loop-continue)

;;TAGS$B%U%!%$%kFb$N4X?t$d!"JQ?tL>$rJd40$9$k(B($B$J$<$+(B\M-,$B$OH?1~$7$J$$(B)
;;$B85$N%-!<$O(Bback-to-indentation $B$3$N%3%^%s%I$O7k9=;H$($k$+$b(B...
(global-set-key "\M-m" 'complete-symbol)

;grep$B8!:wEy$G<!$N8!:w7k2L$X0\F0(B
(global-set-key "\M-o" 'next-error)

;$BB>$N%&%#%s%I%&$K0\F0(B
(global-set-key (kbd "C-;") 'other-window)

; Shift + $BLp0u%-!<$G%&%#%s%I%&4V$r0\F0(B
(windmove-default-keybindings)

;$B%X%C%@$d%=!<%9%U%!%$%k$r3+$/(B
(global-set-key '[?\C-.] 'ff-find-other-file)

; $B%P%C%U%!$r3+$-D>$9(B
;; (global-set-key "\C-cb" 'revert-buffer)
(global-set-key "\C-cr" 'revert-buffer)

; $BD>A0$K<B9T$7$?%7%'%k%3%^%s%I$r<B9T(B
(defun shell-command-prev ()
  (interactive)
  (shell-command (car shell-command-history) nil nil))

(global-set-key (kbd "C-c C-c") 'shell-command-prev)

;;--------------------------------------------------------------------------
;; Info-mode
;;-------------------------------------------------------------------------
;; $B%-!<%P%$%s%I$NJQ99(B
(add-hook 'Info-mode-hook
	  '(lambda () (define-key Info-mode-map [M-n] 'scroll-next-10-line)) ;$B85$N%-!<$O!"(Bclone-buffer
	  )

;;--------------------------------------------------------------------------
;; $B%&%#%s%I%&%5%$%:(B
;;-------------------------------------------------------------------------
(setq default-frame-alist
      (append (list
	       '(top . 0)
	       '(left . 0)
	       '(width . 115)
	       '(height . 57)
	       )
               default-frame-alist))

;;--------------------------------------------------------------------------
;; Font & Color
;;-------------------------------------------------------------------------
(require 'color-setting)

; $B9T4V$r3+$1$kNL!"$3$l$rD4@0$9$k$3$H$G$+$J$j8+$(J}$,JQ$o$k(B
(setq-default line-spacing 1)

;;--------------------------------------------------------------------------
;; C, C++
;;-------------------------------------------------------------------------
;; $B%R%s%H(B
(defface hint-face '((t (:foreground "#c0c0c0"))) nil)

;; $B%R%s%H$NI=<((B($B%3%T%ZMQ(B:???)
 (defun display-hint ()
  (font-lock-add-keywords nil '(
    ("\n" 0 'hint-face prepend)
    ("\t" 0 'hint-face prepend)
    ("$B!!(B" 0 'hint-face prepend)
  ))
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\n (vconcat "?\n"))
  (aset buffer-display-table ?\t (vconcat "^\t"))
  (aset buffer-display-table ?$B!!(B (vconcat "$B""(B"))
)

;; $B%^%8%C%/%J%s%P!<(B
(defface danger-magic-number-face '((t (:foreground "#e00000"))) nil)

;; $B%^%8%C%/%J%s%P!<$NI=<((B
(defun font-lock-add-magic-number ()
  (font-lock-add-keywords nil '(
    ("[^]A-Za-z0-9_\)]\\([-\\+]?0x[0-9a-fA-F]+\\|[-\\+]?[0-9.]+[fF]?\\)" 1 'danger-magic-number-face append)
  ))
)

;;; C++$B%b!<%I$G$O%^%8%C%/%J%s%P!<$H%R%s%H$rI=<((B
(add-hook 'c++-mode-hook
	  '(lambda ()
             (display-hint)
             (font-lock-add-magic-number)
	     ))

;; c++-mode$B%-!<%P%$%s%G%#%s%0(B
(add-hook 'c++-mode-hook
	  (function (lambda () (setq comment-column 40))))

(add-hook 'c++-mode-hook
	  '(lambda ()
	     (local-set-key "\C-cc" 'c-insert-function-comment)
	     (local-set-key "\C-cn" 'c-insert-name-comment)
	     (local-set-key "\C-ci" 'c-insert-if0-region)
	     (local-set-key "\C-c\C-u" 'codegen-update) ; $B85$N%-!<$O!"(Bc-up-conditional @delete
	     ))

;;--------------------------------------------------------------------------
;; dired-x
;;-------------------------------------------------------------------------
(require 'dired-x)

;;--------------------------------------------------------------------------
;; RUBY
;;-------------------------------------------------------------------------
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$\\|\\.ru$\\|Rakefile$\\|Gemfile$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))

;; @delete
; Meadow3$B$K$J$C$F$+$i$N$h$&$J5$$,$9$k$,!"2?8N$+(Bautoload$B$N@_Dj$,8z$+$J$/$J$C$F$7$^$C$?(B
; require$B$9$l$PF0$/$h$&$K$J$C$?$N$G$H$j$"$($:$3$l$G$7$N$0(B
;
;(autoload 'run-ruby "inf-ruby"
;  "Run an inferior Ruby process")
;(autoload 'inf-ruby-keys "inf-ruby"
;  "Set local key defs for inf-ruby in ruby-mode")
;(require 'inf-ruby)

;;--------------------------------------------------------------------------
;; PHP
;;-------------------------------------------------------------------------
(autoload 'php-mode "php-mode" "PHP mode" t)

(defcustom php-file-patterns (list "\\.php[s34]?\\'" "\\.phtml\\'" "\\.inc\\'")
  "*List of file patterns for which to automatically invoke php-mode."
  :type '(repeat (regexp :tag "Pattern"))
  :group 'php)

(let ((php-file-patterns-temp php-file-patterns))
  (while php-file-patterns-temp
    (add-to-list 'auto-mode-alist
                 (cons (car php-file-patterns-temp) 'php-mode))
    (setq php-file-patterns-temp (cdr php-file-patterns-temp))))

;;--------------------------------------------------------------------------
;; sdic
;;-------------------------------------------------------------------------
(setq load-path (cons "~/.emacs.d/site-lisp/sdic" load-path))
(autoload 'sdic-describe-word "sdic" "$B1QC18l$N0UL#$rD4$Y$k(B" t nil)
(global-set-key "\C-cw" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "$B%+!<%=%k$N0LCV$N1QC18l$N0UL#$rD4$Y$k(B" t nil)
(global-set-key "\C-cW" 'sdic-describe-word-at-point)

;; $B<-=q%U%!%$%k$NCV$->l=j(B
(setq sdic-eiwa-dictionary-list '((sdicf-client "~/.emacs.d/site-lisp/sdic/gene.sdic")))
(setq sdic-waei-dictionary-list '((sdicf-client "~/.emacs.d/site-lisp/sdic/jedict.sdic")))

;;--------------------------------------------------------------------------
;; global @delete 
;;-------------------------------------------------------------------------
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-." 'gtags-find-tag)	;$B4X?t$NDj5A85$X(B
         (local-set-key "\M-," 'gtags-find-rtag) ;$B4X?t$N;2>H@h$X(B
         (local-set-key "\M-m" 'gtags-find-symbol) ;$BJQ?t$NDj5A85(B/$B;2>H@h$X(B
;         (local-set-key "\M-g" 'gtags-find-with-grep) ;$B%?%0$r;H$C$F(Bgrep <-- $B;H$$$G$,$J$$$N$G:o=|(B
	 (local-set-key "\M-]" 'gtags-next)
         ))

(add-hook 'c-mode-common-hook
          '(lambda()
             (gtags-mode 1) ;C$B$N%=!<%9$r3+$$$?$i<+F0E*$K(Bgtags-mode$B$r(Bon
             ))

; $B<!$N%7%s%\%k$K0\F0$9$k$?$a$N%-!<%\!<%I%^%/%m(B
(fset 'gtags-next
   "\252\C-n\C-m\C-l")

;;--------------------------------------------------------------------------
;; pukiwiki @delete
;;-------------------------------------------------------------------------
(setq pukiwiki-auto-insert nil)
;(setq pukiwiki-view-chip-away-bracket nil)
;(setq pukiwiki-auto-anchor nil)

;(setq http-proxy-server "proxy.co.jp")
;(setq http-proxy-port 8080)

(setq pukiwiki-no-proxy-domains-list '("localhost"))

(autoload 'pukiwiki-edit
  "pukiwiki-mode" "pukwiki-mode." t)

(autoload 'pukiwiki-index
  "pukiwiki-mode" "pukwiki-mode." t)

(autoload 'pukiwiki-edit-url
  "pukiwiki-mode" "pukwiki-mode." t)

(setq
 pukiwiki-site-list
 '(("pukiwiki"
    "http://pukiwiki.sourceforge.jp/"
    nil euc-jp-dos)
   ))

;(setq pukiwiki-edit-save-buffer-dir "~/tmp/pukiwiki")

;;--------------------------------------------------------------------------
;; vc-mode @delete
;;-------------------------------------------------------------------------
;vc-cvs-diff$B$N;~$KDI2C$9$k%*%W%7%g%s(B
(setq vc-cvs-diff-switches '"-c")

;;--------------------------------------------------------------------------
;; vc-svn @delete
;;-------------------------------------------------------------------------
(add-to-list 'vc-handled-backends 'SVN)

;;--------------------------------------------------------------------------
;; $BF10lL>%P%C%U%!$N%Q%9L>I=<((B
;;-------------------------------------------------------------------------
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;--------------------------------------------------------------------------
;; recentf$B@_Dj(B $B<+F0%;!<%VIU$-(B
;; (install-elisp-from-emacswiki "recentf-ext.el")
;;--------------------------------------------------------------------------
(setq recentf-max-saved-items 5000)
(when platform-windows-p (setq recentf-save-file "~/.recentf-win"))

(recentf-mode 1)

(when (require 'recentf-ext nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1))

;;--------------------------------------------------------------------------
;; color-moccur
;;-------------------------------------------------------------------------
(require 'color-moccur)

;; $BJ#?t$N8!:w8l$d!"FCDj$N%U%'%$%9$N$_%^%C%AEy$N5!G=$rM-8z$K$9$k(B
;; $B>\:Y$O(B http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)

;; migemo$B$,(Brequire$B$G$-$k4D6-$J$i(Bmigemo$B$r;H$&(B
(when (require 'migemo nil t) ;$BBh;00z?t$,(Bnon-nil$B$@$H(Bload$B$G$-$J$+$C$?>l9g$K%(%i!<$G$O$J$/(Bnil$B$rJV$9(B
  (setq moccur-use-migemo t))

;; dired$B;~$N(Bmoccur
(add-hook 'dired-mode-hook
          '(lambda ()
             (local-set-key "O" 'dired-do-moccur)))

;;--------------------------------------------------------------------------
;; anything
;;-------------------------------------------------------------------------
(require 'anything-startup)

; anything-for-files$B$NFbMF$r%+%9%?%^%$%:!"(Banything-c-source-locate$B$r=|30(B
(setq anything-for-files-prefered-list
  '(anything-c-source-ffap-line
    anything-c-source-ffap-guesser
    anything-c-source-buffers+
    anything-c-source-recentf
    anything-c-source-bookmarks
    anything-c-source-file-cache
    anything-c-source-files-in-current-dir+
    ;; anything-c-source-locate
    ))

(global-set-key (kbd "C-,") 'anything-for-files)
(global-set-key (kbd "C-:") 'anything-resume)
;(global-set-key "\M-q" 'anything-regexp)
;(global-set-key (kbd "M-y") 'anything-show-kill-ring)

;; $B>r7oIU$-5/F0(B
(anything-complete-shell-history-setup-key (kbd "M-r")) ; C-r $B$@$H(B shell-mode $B$N;~$K8eJ}8!:w$,=PMh$J$/$J$k(B

;; C-x a $B$r(Banyting$B$N%W%l%U%#%C%/%9$KCV$-49$($k!"$H$$$&$N$OLB$o$J$$$G$h$5$=$&(B
(global-set-key (kbd "C-x a a") 'anything-apropos)
(global-set-key (kbd "C-x a c") 'anything-colors)
(global-set-key (kbd "C-x a g") 'anything-google-suggest)
(global-set-key (kbd "C-x a y") 'anything-show-kill-ring)

;;--------------------------------------------------------------------------
;; anything-git-project
;;-------------------------------------------------------------------------
(defun anything-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All controlled files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) pwd))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files $(git rev-parse --show-cdup) %s"
                                   (cdr elt))))))))
          (candidates-in-buffer)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((pwd default-directory)
         (sources (anything-c-sources-git-project-for pwd)))
    (anything-other-buffer sources
     ;; (format "*Anything git project in %s*" pwd))))
     (format "*anything git project*"))))
;; (define-key global-map (kbd "C-;") 'anything-git-project)

;; 
(global-set-key [(control x) (a) (g)] 'anything-git-project)

;;--------------------------------------------------------------------------
;; $B%?%V$N$+$o$j$K%9%Z!<%9$r;HMQ(B
;;--------------------------------------------------------------------------
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)

;;--------------------------------------------------------------------------
;; emacsclient$B%5!<%P!<$N5/F0(B
;;-------------------------------------------------------------------------
(server-start)

;;--------------------------------------------------------------------------
;; oddmuse @delete
;;--------------------------------------------------------------------------
(require 'oddmuse)
;(setq url-proxy-services '(("http" . "proxy.co.jp:8080")))
(oddmuse-mode-initialize)

;;--------------------------------------------------------------------------
;;moccur-edit @delete
;;
;; * $B8!:w$9$k(B
;;   dmoccur $B$d(B moccur $B!$(B moccur-grep $B!$(B moccur-grep-find $B$J$I$G8!:w$7$F7k2L$rI=<($5$;$^$9!%(B
;;
;; * $BJT=8%b!<%I$KF~$k(B
;;   $B7k2L$,I=<($5$l$?$H$3$m$G!$(Br($B$"$k$$$O(BC-c C-i $B$+(B C-x C-q $B$G$b$$$$(B) $B$H$7$^$9!%$9$k$H!$%P%C%U%!$,JT=8$G$-$k$h$&$K$J$j$^$9!%(B
;;
;; * $BJT=8$9$k(B
;;   $B8e$OJT=8$9$k$@$1$G$9!%JT=8$9$k$H!$JT=8$7$?2U=j$K$O?'$,$D$-$^$9!%(B
;;
;; * $BJT=8$rE,MQ$9$k(B
;;   C-x C-s ($B$"$k$$$O(B C-c C-c $B$+(B C-c C-f $B$G$b2DG=(B) $B$H$9$k$H!$?'$,$D$$$F$$$kJQ99$N$_$,E,MQ$5$l$^$9!%(B
;;
;;   $B%P%C%U%!$NJ]B8$O$7$^$;$s$N$G!$3F%U%!%$%k$r3NG'$7$F$+$iJ]B8$7$F$/$@$5$$!%JQ99$7$?9T$K$O?'$,$D$-$^$9$N$G!$Hf3SE*H/8+$7$d$9$$$H;W$$$^$9!%(B
;;
;; * $B0lIt$NJQ99$N$_E,MQ$7$?$/$J$$(B
;;   $BE,MQ$7$?$/$J$$ItJ,$r%j!<%8%g%s$GA*Br$7!$(BC-c C-r $B$H$7$^$9!%$=$&$9$k$H!$?'$,>C$($F!$$3$NJQ99$OE,MQ$5$l$J$/$J$j$^$9!%(B
;;
;; * $B$9$Y$F$NJQ99$rGK4~$9$k(B
;;   $B$9$Y$F$NJQ99$rE,MQ$7$?$/$J$$;~$K$O!$(BC-x k($B$"$k$$$O(B C-c C-k $B$+(B C-c k $B$+(B C-c C-u $B$G$b2DG=(B) $B$H$7$^$9!%$3$l$G!$$9$Y$F$NJQ99$OL58z$K$J$j$^$9!%(B 
;;-------------------------------------------------------------------------
(require 'moccur-edit)

;;--------------------------------------------------------------------------
;;grep-edit
;;
;; M-x grep$B$G8!:w8e!$(B grep $B$N%P%C%U%!$rJT=8$G$-$^$9!%JT=8$9$k$H!$JT=8$7$?2U=j$N?'$,JQ$o$j$^$9!%(B
;; $BJT=8$,=*$o$C$?$i!$(BC-c C-e $B$H$9$k$H?'$N$D$$$?JQ99$N$_$,E,MQ$5$l$^$9!%JQ99$NGK4~$O!$(BC-c C-u $B$G$G$-$^$9!%(B
;; $B$^$?!$E,MQ$7$?$/$J$$JQ99$r%j!<%8%g%s$GA*Br$7!$(B C-c C-r $B$H$9$k$H!$%j!<%8%g%sFb$NJQ99$N$_$rGK4~$G$-$^$9!%(B
;;
;; $B$3$NJQ99$NE,MQ;~$K$O%P%C%U%!$NJ]B8$O$7$F$$$^$;$s!%(B
;; $BJ]B8A0$K@5$7$/JQ99$5$l$F$$$k$+3NG'$7$F$+$iJ]B8$7$F$/$@$5$$!%(B
;; $BJQ992U=j$O?'$rJQ$($F$^$9$N$G!$4JC1$K8+$D$+$k$H;W$$$^$9!%(B
;;
;; $B%(%i!<=hM}$J$I$O$[$H$s$I$7$F$$$^$;$s$N$G!$Cm0U$7$F;H$C$F$/$@$5$$!%(B 
;;-------------------------------------------------------------------------
(require 'grep-edit)

;;--------------------------------------------------------------------------
;; wdired
;;--------------------------------------------------------------------------
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;--------------------------------------------------------------------------
;; dired-details
;;--------------------------------------------------------------------------
(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "")

;;--------------------------------------------------------------------------
;; joseph-single-dired
;;--------------------------------------------------------------------------
(require 'joseph-single-dired)
(eval-after-load 'dired '(require 'joseph-single-dired))

;;--------------------------------------------------------------------------
;; google @delete
;;--------------------------------------------------------------------------
(load "google")

;;--------------------------------------------------------------------------
;; view-mode-key @delete
;;--------------------------------------------------------------------------
(load "view-mode-key")

;; C-xC-y$B$G(Bview-mode$B$N%H%0%k(B
(global-set-key "\C-x\C-y" 'toggle-view-mode)

;; $B6/D4$O2<@~I=<($K(B
;(setq hl-line-face 'underline)

;;--------------------------------------------------------------------------
;; tortoise-svn @delete
;;--------------------------------------------------------------------------
(require 'tortoise-svn)

;;--------------------------------------------------------------------------
;; rept-mode @delete
;;--------------------------------------------------------------------------
(require 'rept-mode)

; rept$B%U%!%$%k$r3+$$$?$i(Brept-mode$B$X(B
(add-to-list 'auto-mode-alist '("\\.rept$" . rept-mode))

; rept$B%U%!%$%k$NCV$->l=j$r;XDj(B
(setq rept-program-file "rept.bat")

;;--------------------------------------------------------------------------
;; ActionScript 3.0
;;-------------------------------------------------------------------------
(autoload 'actionscript-mode "actionscript-mode" "actionscript" t)

(setq auto-mode-alist
      (append '(("\\.as$" . actionscript-mode))
              auto-mode-alist))

;;--------------------------------------------------------------------------
;; text-translate @delete
;;-------------------------------------------------------------------------
;;(autoload 'text-translator "text-translator" "Text Translator" t)
(require 'text-translator)

(global-set-key "\C-x\M-t" 'text-translator)
(global-set-key "\C-x\M-T" 'text-translator-translate-last-string)

;; $B<+F0A*Br$K;HMQ$9$k4X?t$r@_Dj(B
(setq text-translator-auto-selection-func
      'text-translator-translate-by-auto-selection-enja)

;; $B%0%m!<%P%k%-!<$r@_Dj(B
(global-set-key "\C-xt" 'text-translator-translate-by-auto-selection)

;; $B%W%j%U%#%C%/%9%-!<$rJQ99$9$k>l9g(B.
;; (setq text-translator-prefix-key "\M-n")

;;--------------------------------------------------------------------------
;; auto-install
;; (install-elisp-from-emacswiki "auto-install.el")
;;--------------------------------------------------------------------------
(require 'auto-install)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;--------------------------------------------------------------------------
;; open-junk-file
;; (install-elisp-from-emacswiki "open-junk-file.el")
;;--------------------------------------------------------------------------
(require 'open-junk-file)
(setq open-junk-file-format "~/Documents/junk/%Y-%m%d-%H%M%S.")
(global-set-key "\C-xj" 'open-junk-file)

;--------------------------------------------------------------------------
;; autoinsert
;;--------------------------------------------------------------------------
(auto-insert-mode)
(setq auto-insert-directory "~/.emacs.d/insert/") ; $B:G8e$N(B / $B$OI,?\(B
(define-auto-insert "\\.rb$" "template.rb")
(define-auto-insert "\\.js$" "template.js")
(define-auto-insert "blog.\\txt$" "template-blog.txt")

;;--------------------------------------------------------------------------
;; $B%_%K%P%C%U%!>e$G8=:_%P%C%U%!L>$rA^F~$9$k(B
;; shell-command $BEy$N<B9T$KJXMx(B
;;-------------------------------------------------------------------------
(defun current-buffer-not-mini ()
  "Return current-buffer if current buffer is not the *mini-buffer*
  else return buffer before minibuf is activated."
  (if (not (window-minibuffer-p)) (current-buffer)
      (if (eq (get-lru-window) (next-window))
          (window-buffer (previous-window)) (window-buffer (next-window)))))

(defun insert-current-buffer-name ()
  (interactive)
  (insert (buffer-name (current-buffer-not-mini))))

(define-key minibuffer-local-map "\C-c\C-c" 'insert-current-buffer-name)

;;--------------------------------------------------------------------------
;; html-fold
;; (install-elisp "https://github.com/ataka/html-fold/raw/master/html-fold.el")
;;-------------------------------------------------------------------------
(autoload 'html-fold-mode "html-fold" "Minor mode for hiding and revealing elements." t)

;;--------------------------------------------------------------------------
;; haml
;; http://www.ftnk.jp/~fumi/cl/2009-05-02-3.html
;;-------------------------------------------------------------------------
; haml-mode
(require 'haml-mode)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))

;;sass-mode
(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))

;;scss-mode
(require 'scss-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(setq scss-compile-at-save nil)

;;--------------------------------------------------------------------------
;; popwin
;; (auto-install-from-url "https://github.com/m2ym/popwin-el/raw/master/popwin.el")
;;--------------------------------------------------------------------------
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
;; (setq special-display-function 'popwin:special-display-popup-window)

(push '("*Shell Command Output*" :height 20) popwin:special-display-config)
;(push '("*Shell Command Output*" :height 20 :position top) popwin:special-display-config)

(setq anything-samewindow nil)
(push '("*anything*"             :height 20) popwin:special-display-config)
(push '("*anything for files*"   :height 20) popwin:special-display-config)
(push '("*anything apropos*"     :height 30) popwin:special-display-config)
(push '("*anything kill-ring*"   :height 20) popwin:special-display-config)
(push '("*anything google*"      :height 20) popwin:special-display-config)
(push '("*anything git project*" :height 20) popwin:special-display-config)

(push '("*grep*" :height 20 :noselect t) popwin:special-display-config)

(push '("*scratch*")              popwin:special-display-config)
(push '("svnlog.txt")             popwin:special-display-config)
(push '("journal.txt" :regexp t)  popwin:special-display-config)

;; (push '("*sdic*") popwin:special-display-config) ; $B2?8N$+F0$+$J$$(B
;; (push '(dired-mode :position top) popwin:special-display-config) ; dired-jump-other-window (C-x 4 C-j)

;;--------------------------------------------------------------------------
;; JavaScript
;;
;; js2-20090723b.el ($B%@%&%s%m!<%I8e!"(B js2.el $B$K2~L>!"MW%P%$%H%3%s%Q%$%k(B)
;; http://code.google.com/p/js2-mode/downloads/detail?name=js2-20090723b.el&can=2&q=
;;
;; espresso.el
;; http://download-mirror.savannah.gnu.org/releases/espresso/espresso.el
;;-------------------------------------------------------------------------
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

; fixing indentation
; refer to http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
(autoload 'espresso-mode "espresso")

(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (espresso--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ espresso-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;; bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-js2-mode-hook ()
  (require 'espresso)
  (setq espresso-indent-level 2
        indent-tabs-mode nil
        c-basic-offset 2)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;;--------------------------------------------------------------------------
;; $BD>A0$K<B9T$7$?%7%'%k%3%^%s%I$r<B9T(B @delete
;;-------------------------------------------------------------------------
(defun shell-command-prev ()
  (interactive)
  (shell-command (car shell-command-history) nil nil))

(global-set-key (kbd "C-c C-c") 'shell-command-prev)

;;--------------------------------------------------------------------------
;; Add-on SDK
;;-------------------------------------------------------------------------
(defun cfx-start() 
  (interactive)
  (exec-shell "cd ~/app/addon-sdk-1.14; source bin/activate" nil))

(defun cfx-run() 
  (interactive)
  (exec-shell "cfx run" t))

(defun cfx-test() 
  (interactive)
  (exec-shell "cfx test" t))

;; (global-set-key (kbd "C-c C-c") 'cfx-test)
(global-set-key (kbd "C-c C-v") 'cfx-run)

;;--------------------------------------------------------------------------
;; cua-mode
;; $B6k7ANN0h$KBP$7$F%j%"%k%?%$%`$KJ8;zNs$NA^F~$,=PMh$?$j=PMh$k!#(B
;;
;; cua-mode$B3+;O(B .. $BNN0hA*Br$7$F!"(BC-Enter
;;-------------------------------------------------------------------------
(cua-mode t)
(setq cua-enable-cua-keys nil) ; $B$=$N$^$^$@$H(B C-x $B$,@Z$j<h$j$K$J$C$F$7$^$C$?$j$9$k$N$GL58z2=(B

;;--------------------------------------------------------------------------
;; cycle-buffer.el @delete
;;-------------------------------------------------------------------------
;; (autoload 'cycle-buffer "cycle-buffer" "Cycle forward." t)
;; (autoload 'cycle-buffer-backward "cycle-buffer" "Cycle backward." t)
;; (autoload 'cycle-buffer-permissive "cycle-buffer" "Cycle forward allowing *buffers*." t)
;; (autoload 'cycle-buffer-backward-permissive "cycle-buffer" "Cycle backward allowing *buffers*." t)
;; (autoload 'cycle-buffer-toggle-interesting "cycle-buffer" "Toggle if this buffer will be considered." t)

;; (global-set-key (kbd "M-l")       'cycle-buffer)
;; (global-set-key (kbd "M-m")       'cycle-buffer-backward)
;; ;; (global-set-key [(shift f9)]  'cycle-buffer-backward-permissive)
;; ;; (global-set-key [(shift f10)] 'cycle-buffer-permissive)

;;--------------------------------------------------------------------------
;; $BD>A0$N%P%C%U%!$K@Z$jBX$((B @delete
;;-------------------------------------------------------------------------
;;; last-buffer
(defvar last-buffer-saved nil)

;; last-buffer$B$GA*Br$7$J$$%P%C%U%!$r@_Dj(B
(defvar last-buffer-exclude-name-regexp
  (rx (or "*mplayer*" "*Completions*" "*Org Export/Publishing Help*"
          (regexp "^ "))))
(defun record-last-buffer ()
  (when (and (one-window-p)
             (not (eq (window-buffer) (car last-buffer-saved)))
             (not (string-match last-buffer-exclude-name-regexp
                                (buffer-name (window-buffer)))))
    (setq last-buffer-saved
          (cons (window-buffer) (car last-buffer-saved)))))
(add-hook 'window-configuration-change-hook 'record-last-buffer)

(defun switch-to-last-buffer ()
  (interactive)
  (condition-case nil
      (switch-to-buffer (cdr last-buffer-saved))
    (error (switch-to-buffer (other-buffer)))))

(defun switch-to-last-buffer-or-other-window ()
  (interactive)
  (if (one-window-p t)
      (switch-to-last-buffer)
    (other-window 1)))

;(global-set-key (kbd "C-t") 'switch-to-last-buffer-or-other-window)
;(global-set-key (kbd "M-l") 'switch-to-last-buffer)

;;--------------------------------------------------------------------------
;; Cocoa Emacs $B$N8@8l@_Dj(B
;;--------------------------------------------------------------------------
(when platform-darwin-p
  ;; $BF|K\8l@_Dj(B
  (set-language-environment 'Japanese)
  (prefer-coding-system 'utf-8)

  ;; Meta$B%-!<$r(BCommand$B%\%?%s$KJQ99(B
  ;; Carbon$B$+$i(BCocoa$B$X(B--Snow Leopard$B$G(BEmacs 23$B$r;H$&!J(B3$B!K(B - builder
  ;; http://builder.japan.zdnet.com/os-admin/sp_snow-leopard-09/20410578/
  (setq ns-command-modifier (quote meta))
  (setq ns-alternate-modifier (quote super))

  ;; Cocoa Emacs(Emacs23)$B$G$NF|K\8l%U%)%s%H@_Dj(B
  ;; http://macemacsjp.sourceforge.jp/index.php?MacFontSetting#h3b01bb4
  (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
  (set-fontset-font "fontset-menlokakugo" 'unicode (font-spec :family "Hiragino Kaku Gothic ProN" ) nil 'append)
  (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
  (setq face-font-rescale-alist '((".*Hiragino.*" . 1.2) (".*Menlo.*" . 1.0)))
  )

;;--------------------------------------------------------------------------
;; Cocoa Emacs$B$G%P%C%/%9%i%C%7%e$,>e<j$/F~NO=PMh$J$$BP:v(B
;;
;;   Mac$B$J(BEmacs$B$G%P%C%/%9%i%C%7%e$r4JC1$KF~NO$7$?$$(B - Watson$B$N%a%b(B
;;   http://d.hatena.ne.jp/Watson/20100207/1265476938
;;    
;;   Carbon Emacs $B$G!V(B\($B%P%C%/%9%i%C%7%e(B)$B!W$rF~NO$9$k(B - $B$"$$$W$i$W$i!((B
;;   http://d.hatena.ne.jp/june29/20080204/1202119521
;;--------------------------------------------------------------------------
(define-key global-map [?\(J\(B] [?\\])
(define-key global-map [?\C-(J\(B] [?\C-\\])
(define-key global-map [?\M-(J\(B] [?\M-\\])
(define-key global-map [?\C-\M-(J\(B] [?\C-\M-\\])

;;--------------------------------------------------------------------------
;; smartrep @delete
;;--------------------------------------------------------------------------
(require 'smartrep)

;;--------------------------------------------------------------------------
;; smartrep viewer @delete
;;--------------------------------------------------------------------------

;; ; $B%W%l%U%#%C%/%9%-!<$N@_Dj(B
;; (defvar ctl-t-map (make-keymap))
;; (define-key global-map "\C-t" ctl-t-map)

;; ; $B%-!<%P%$%s%I$N@_Dj(B
;; (smartrep-define-key
;;  global-map "C-t"
;;  '(
;;    ; main-window
;;    ("SPC" . 'scroll-up)
;;    ("b" . 'scroll-down)
;;    ("l" . 'forward-char)
;;    ("h" . 'backward-char)
;;    ("j" . (lambda () (scroll-up 1)))
;;    ("k" . (lambda () (scroll-up -1)))
;;    ("a" . (lambda () (beginning-of-buffer)))
;;    ("e" . (lambda () (end-of-buffer)))
;;    ("i" . 'keyboard-quit)
;;    ; other-window
;;    ("n" . 'scroll-other-window)
;;    ("N" . (lambda () (scroll-other-window '-)))
;;    ("m" . (lambda () (scroll-other-window 1)))
;;    ("," . (lambda () (scroll-other-window -1)))
;;    ("A" . (lambda () (beginning-of-buffer-other-window 0)))
;;    ("E" . (lambda () (end-of-buffer-other-window 0)))
;;    )
;;  )

;;--------------------------------------------------------------------------
;; jaunte.el - Emacs$B$G(BHit a Hint($B2~(B) @delete
;;--------------------------------------------------------------------------
(require 'jaunte)
;(global-set-key (kbd "C-c C-j") 'jaunte)
(global-set-key (kbd "M-l") 'jaunte)

;;--------------------------------------------------------------------------
;; zencoding @delete
;;--------------------------------------------------------------------------
;; (require 'zencoding-mode)
;; (add-hook 'html-mode-hook 'zencoding-mode)

;;--------------------------------------------------------------------------
;; Titanium @delete
;;--------------------------------------------------------------------------
;; (defun ti-send-run ()
;;   (setq proc (open-network-stream "titanium" nil "127.0.0.1" 9090))
;;   (process-send-string proc "GET /run HTTP/1.0\r\n\r\n")
;;   (sleep-for 1)
;;   (delete-process proc))

;; (defun reload-titanium ()
;;   (if (string-match "Resources" (buffer-file-name))
;;         (ti-send-run)))

;; (add-hook 'after-save-hook 'reload-titanium)

;;--------------------------------------------------------------------------
;; auto-shell-command
;;--------------------------------------------------------------------------
;; (load-file "~/Documents/auto-shell-command/auto-shell-command.el")
;; (require 'auto-shell-command)

;; $B%-!<%P%$%s%I$N@_Dj(B
(global-set-key (kbd "C-c C-m") 'ascmd:toggle)      ; Temporarily on/off auto-shell-command run
(global-set-key (kbd "C-c C-,") 'ascmd:popup)  ; Pop up '*Auto Shell Command*'
(global-set-key (kbd "C-c C-.") 'ascmd:exec)   ; Exec-command specify file name

;; $B7k2L$NDLCN$r(BGrowl$B$G9T$&(B
(when platform-darwin-p
  (defun ascmd:notify (msg) (deferred:process-shell (format "growlnotify -m %s -t emacs" msg))))

;; $B%(%i!<;~$N%]%C%W%"%C%W$r8+$d$9$/$9$k!#(B $B"((B (require 'popwin) $B$,I,MW$G$9!#(B
(push '("*Auto Shell Command*" :height 20 :noselect t) popwin:special-display-config)

;;--------------------------------------------------------------------------
;; duplicate-thing
;;   $B%+!<%=%k9T$rJ#@=$9$k!"HO0OA*Br;~$OHO0O$rJ#@=(B
;;--------------------------------------------------------------------------
(require 'duplicate-thing)
(global-set-key (kbd "M-c") 'duplicate-thing) ; $B85$N%-!<$O(Bcapitalize-word

;;--------------------------------------------------------------------------
;; lispxmp
;;--------------------------------------------------------------------------
(require 'lispxmp)
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;;--------------------------------------------------------------------------
;; paredit
;;--------------------------------------------------------------------------
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode--hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

;;--------------------------------------------------------------------------
;;yaml-mode
;;--------------------------------------------------------------------------
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$\\|\\.yaml$" . yaml-mode))

;;--------------------------------------------------------------------------
;;magit
;;--------------------------------------------------------------------------
(global-set-key (kbd "C-x v d") 'magit-status)

;;--------------------------------------------------------------------------
;;auto-highlight-symbol
;;--------------------------------------------------------------------------
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

;;--------------------------------------------------------------------------
;;auto-save-buffers-enhanced
;;--------------------------------------------------------------------------
(require 'auto-save-buffers-enhanced)
(setq auto-save-buffers-enhanced-interval 1) ; $B;XDj$N%"%$%I%kIC$GJ]B8(B
(auto-save-buffers-enhanced t)

;;--------------------------------------------------------------------------
;;milkode
;;--------------------------------------------------------------------------
(require 'moz)
(require 'milkode)
;; (global-set-key (kbd "M-g") 'milkode:search)

;;--------------------------------------------------------------------------
;;markdown
;;--------------------------------------------------------------------------
(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md$\\|\\.markdown$" . markdown-mode))

;; $BJQ99=PMh$J$$!&!&(B
;; (add-hook 'markdown-mode-hook
;;           '(lambda ()
;;              (define-key markdown-mode-map [M-n] 'scroll-next-10-line)
;;              (define-key markdown-mode-map [M-p] 'scroll-previous-10-line)))

;;--------------------------------------------------------------------------
;; expand-region
;;--------------------------------------------------------------------------
(require 'expand-region)
(global-set-key (kbd "C-@") 'er/expand-region)
(global-set-key (kbd "C-M-@") 'er/contract-region)

;;--------------------------------------------------------------------------
;; mark-multiple @delete
;;--------------------------------------------------------------------------
;; (require 'inline-string-rectangle)
;; (global-set-key (kbd "C-x r t") 'inline-string-rectangle)

;; (require 'mark-more-like-this)
;; (global-set-key (kbd "C-<") 'mark-previous-like-this)
;; (global-set-key (kbd "C->") 'mark-next-like-this)
;; ;; (global-set-key (kbd "C-M-m") 'mark-more-like-this) ; like the other two, but takes an argument (negative is previous)
;; (global-set-key (kbd "C-*") 'mark-all-like-this)

;; ;; (add-hook 'sgml-mode-hook
;; ;;           (lambda ()
;; ;;             (require 'rename-sgml-tag)
;; ;;             (define-key sgml-mode-map (kbd "C-c C-r") 'rename-sgml-tag)))
;; (add-hook 'html-mode-hook
;;           (lambda ()
;;             (require 'rename-sgml-tag)
;;             (define-key html-mode-map (kbd "C-c C-r") 'rename-sgml-tag)))

;;--------------------------------------------------------------------------
;; multiple-cursors
;;--------------------------------------------------------------------------
(require 'multiple-cursors)

(global-set-key (kbd "C-t") 'mc/mark-next-like-this)

;; (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;--------------------------------------------------------------------------
;; winden-window @delete
;;--------------------------------------------------------------------------
;; (require 'widen-window)
;; (global-widen-window-mode t)

;; ;; windmove-default-keybindings $B$KBP1~(B
;; (setq ww-advised-functions
;;       (append ww-advised-functions
;; 	      '(windmove-up
;; 		windmove-down
;; 		windmove-right
;; 		windmove-left)))

;; ;; anything$B$H$NAj@-$r=$@5(B
;; (defadvice anything (around disable-ww-mode activate)
;;   (ad-deactivate-regexp "widen-window")
;;   (unwind-protect
;;       ad-do-it
;;     (ad-activate-regexp "widen-window")))

;;--------------------------------------------------------------------------
;; anything-milkode
;;--------------------------------------------------------------------------
(require 'anything-milkode)
(setq anything-grep-multiline nil)                                            ; Use anything-grep single line mode

;; Shortcut setting
(global-set-key (kbd "M-g")     'anything-milkode)                                
(global-set-key (kbd "C-x a f") 'anything-milkode-files)

;; For popwin
(push '("*milkode*"                :height 20) popwin:special-display-config)
(push '("*anything milkode*"       :height 20) popwin:special-display-config) 
(push '("*anything milkode files*" :height 20) popwin:special-display-config)

;;--------------------------------------------------------------------------
;; anything-c-moccur
;;--------------------------------------------------------------------------
(require 'anything-c-moccur)
(define-key isearch-mode-map (kbd "M-o")   'anything-c-moccur-from-isearch)
(define-key isearch-mode-map (kbd "C-M-o") 'isearch-occur)
(push '("*anything moccur*"     :height 20) popwin:special-display-config) 

;;--------------------------------------------------------------------------
;; anything-patch
;;--------------------------------------------------------------------------
;; anything-c-source-ffap-line $B$,@5$7$/F0$+$J$$LdBj$r=$@5(B
(defun anything-c-shorten-home-path (files)
  "Replaces /home/user with ~."
  (let ((home (replace-regexp-in-string "\\\\" "/" ; stupid Windows...
                                        (getenv "HOME"))))
    (anything-transform-mapcar
     (lambda (file)
       (if (and (stringp file) (string-match home file))
           (replace-match "~" nil nil file)  ; $B=$@52U=j(B
         file))
     files)))

;; pop-tag-mark(M-*) $B$G%8%c%s%W@h$+$iLa$l$k$h$&$K(B
(defun anything-c-ffap-line-candidates ()
  (with-anything-current-buffer
    (anything-attrset 'ffap-line-location (anything-c-ffap-file-line-at-point)))
  (anything-aif (anything-attr 'ffap-line-location)
    (destructuring-bind (file . line) it
      (with-anything-current-buffer (ring-insert find-tag-marker-ring (point-marker))) ; find-tag-marker-ring$B$K%^!<%/$rA^F~(B
      ;; (with-anything-current-buffer (ring-insert global-mark-ring (point-marker))) ; find-tag-marker-ring$B$K%^!<%/$rA^F~(B
      ;; (with-anything-current-buffer (set-mark-command)) ; find-tag-marker-ring$B$K%^!<%/$rA^F~(B
      (list (cons (format "%s (line %d)" file line) file)))))

;;--------------------------------------------------------------------------
;; jump (jump-dls.el)
;;--------------------------------------------------------------------------
(require 'jump)
(add-hook
 'emacs-lisp-mode-hook
 '(lambda ()
    (define-key emacs-lisp-mode-map (kbd "M-j") 'jump-symbol-at-point)
    (define-key emacs-lisp-mode-map (kbd "M-*") 'jump-back)))

;;--------------------------------------------------------------------------
;; auto-complete
;;--------------------------------------------------------------------------
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)

;;--------------------------------------------------------------------------
;; jump-to-line
;;--------------------------------------------------------------------------
(require 'jump-to-line)
(global-set-key (kbd "C-c C-j") 'jump-to-line) ; Jump
(global-set-key (kbd "C-c b")   'jtl-back)

;; ;; unset c-mode's C-c C-b (c-submit-bug-report)
;; (add-hook
;;  'c-mode-common-hook
;;  '(lambda ()
;;     (local-unset-key (kbd "C-c C-b"))))

;;--------------------------------------------------------------------------
;; ffap (rubygems)
;;--------------------------------------------------------------------------
(defun ffap-ruby-mode (name)
  (shell-command-to-string
   (format "ruby -e 'require %%[rubygems];require %%[devel/which];require %%[%s];
print (which_library (%%[%s]))'" name name)))

(defun find-ruby-lib (name)
  (interactive "sRuby library name: ")
  (find-file (ffap-ruby-mode name)))

;ffap
(require 'ffap)
(add-to-list 'ffap-alist '(ruby-mode . ffap-ruby-mode))

;;--------------------------------------------------------------------------
;; all-ext
;;--------------------------------------------------------------------------
(require 'all-ext)

(eval-after-load "anything-c-moccur"
  '(progn
     (defun all-from-anything-moccur ()
       "Call `all' from `anything' content."
       (interactive)
       (anything-run-after-quit
        'all-from-anything-occur-internal "anything-moccur"
        anything-c-moccur-buffer anything-current-buffer))
     (define-key anything-c-moccur-anything-map (kbd "C-c C-a")
       'all-from-anything-moccur)))

;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;;--------------------------------------------------------------------------
;; $B4D6-8GM-$N@_Dj(B
;;-------------------------------------------------------------------------
(require 'private)

;;--------------------------------------------------------------------------
;; $B<+F0$GDI2C$5$l$?$b$N(B @delete
;;-------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
