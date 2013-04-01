;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .emacs.d/init.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 文字コードはJISにしておかないと日本語がうまく表示されない

;; ロードパスを設定
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/auto-install")

;;環境による切り分け
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
;; 自作関数
;;-------------------------------------------------------------------------
(require 'my-functions)

;;--------------------------------------------------------------------------
;; 設定
;;-------------------------------------------------------------------------

;; コマンドメモ
;; M-l runs the command downcase-word   ;; 単語を小文字に変換
;; M-k runs the command upcase-word     ;; 単語を大文字に変換(カスタマイズしてます、元のコマンドは kill-sentence) 
;; M-c runs the command capitalize-word ;; 後続の単語の１文字目だけを大文字にする。
;; M-i runs the command tab-to-tab-stop ;; タブを挿入

(global-set-key "\M-k" 'upcase-word)

(ediff-toggle-multiframe)
;(setq initial-frame-alist '((top . 0) (left . 80) (width . 800) (height . 40)))

; セーブ後にファイル終端に改行を追加
(setq require-final-newline nil)

; 下を押しても改行をいれないための方法
(setq next-line-add-newlines nil)

; バックアップファイルを作らない (init.el~ みたいなやつ)
(setq make-backup-files nil)

; 画面や、フレームの幅に満たないウィンドウでも、テキストを折り返して表示する
;(setq truncate-partial-width-windows nil)
(setq truncate-partial-width-windows t)

;;; ツールバーを表示しない
(tool-bar-mode 0)

;; set abbrev-mode 置換モードの設定
(setq-default abbrev-mode t)
(quietly-read-abbrev-file)

;; 行番号の表示
(setq line-number-mode t)
(setq column-number-mode t)

;; サーチ/リプレイスなどで大文字と小文字を区別しない
(setq-default case-fold-search t)

;; 編集 mode の追加 (prolog mode は消える)
(setq auto-mode-alist
      (append '(("\\.c$"           . c-mode)	
		("\\.pl$"          . cperl-mode)
		("\\.cpp$"         . c++-mode)
		("\\.h$"           . c++-mode)
		("[Mm]akefile"     . makefile-mode)
		("\\.dat$\\|.mch$" . hexl-mode))
	      auto-mode-alist))

;; ミニバッファで前に打ち込んだ文字列を再利用したい (C-x ESC) (文字列の検索にC-p,C-nを割り当てる) 
;(define-key repeat-complex-command-map "\C-p"  'previous-complex-command)
;(define-key repeat-complex-command-map "\C-n"  'next-complex-command)

;; 対応する括弧を、強調表示する
(show-paren-mode t)

;; 起動時のカレントディレクトリの設定
(cd "~")

;; 動的補完のとき，パターンをそのまま展開する defaultでは， case-replaceの値が入っている
(setq dabbrev-case-replace nil)

;; ffap
(ffap-bindings)

;; ナロイングを有効に
(put 'narrow-to-region 'disabled nil)

;; transient-mark-mode
(setq transient-mark-mode t)

;;--------------------------------------------------------------------------
;; Emacsに必要なパスを通す 
;;-------------------------------------------------------------------------
;; http://sakito.jp/emacs/emacsshell.html#path
;; より下に記述した物が PATH の先頭に追加されます
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
                "/opt/local/bin" ;; これが/usr/binよりも下に書いてあればよい
                "/usr/local/bin"
                (expand-file-name "~/bin")
                (expand-file-name "~/bin/gnuplot")
                ))
    ;; PATH と exec-path に同じ物を追加します
    (when ;; (and 
        (file-exists-p dir) ;; (not (member dir exec-path)))
      (setenv "PATH" (concat dir ":" (getenv "PATH")))
      (setq exec-path (append (list dir) exec-path))))
  )

;;--------------------------------------------------------------------------
;; shell-mode
;;-------------------------------------------------------------------------
; .bashrcでcdやpushd,popdにエイリアスを貼る場合は、Emacs側にも伝えておく必要がある
; http://www.geocities.co.jp/SiliconValley-Bay/9285/EMACS-JA/emacs_412.html
;(setq shell-pushd-regexp "\\(cd\\|pushd\\)")
;(setq shell-popd-regexp "\\(bd\\|popd\\)")

;; shell-mode でエスケープを綺麗に表示
(when platform-darwin-p
  (autoload 'ansi-color-for-comint-mode-on "ansi-color"
    "Set `ansi-color-for-comint-mode' to t." t)
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on))

;;--------------------------------------------------------------------------
;; キーバインドの設定
;;-------------------------------------------------------------------------
; キーバインド
(global-unset-key "\C-h")
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\M-h" 'help-for-help)


; grepをキーバインド
(global-set-key "\M-g" 'grep)
(setq grep-command "gmilk ")
(setq grep-use-null-device nil)

; grep-find
(global-set-key "\C-x\C-g" 'grep-find)
(setq grep-find-command "gren ")

;元のキーバインドはない
(global-set-key "\C-cg" 'goto-line)

;置換
(global-set-key "\C-q" 'query-replace)
;; (global-set-key "\M-q" 'query-replace-regexp)
(global-set-key "\M-q" 'replace-string)

;最後のキーボードマクロを呼び出す
(global-set-key "\C-t" 'call-last-kbd-macro)

;なぜか、M-,は反応しない・・・
(global-set-key "\M-'" 'tags-loop-continue)

;;TAGSファイル内の関数や、変数名を補完する(なぜか\M-,は反応しない)
;;元のキーはback-to-indentation このコマンドは結構使えるかも...
(global-set-key "\M-m" 'complete-symbol)

;grep検索等で次の検索結果へ移動
(global-set-key "\M-o" 'next-error)

;他のウィンドウに移動
(global-set-key (kbd "C-;") 'other-window)

; Shift + 矢印キーでウィンドウ間を移動
(windmove-default-keybindings)

;ヘッダやソースファイルを開く
(global-set-key '[?\C-.] 'ff-find-other-file)

; バッファを開き直す
;; (global-set-key "\C-cb" 'revert-buffer)
(global-set-key "\C-cr" 'revert-buffer)

; 直前に実行したシェルコマンドを実行
(defun shell-command-prev ()
  (interactive)
  (shell-command (car shell-command-history) nil nil))

(global-set-key (kbd "C-c C-c") 'shell-command-prev)

;;--------------------------------------------------------------------------
;; Info-mode
;;-------------------------------------------------------------------------
;; キーバインドの変更
(add-hook 'Info-mode-hook
	  '(lambda () (define-key Info-mode-map [M-n] 'scroll-next-10-line)) ;元のキーは、clone-buffer
	  )

;;--------------------------------------------------------------------------
;; ウィンドウサイズ
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

; 行間を開ける量、これを調整することでかなり見え方が変わる
(setq-default line-spacing 1)

;;--------------------------------------------------------------------------
;; C, C++
;;-------------------------------------------------------------------------
;; ヒント
(defface hint-face '((t (:foreground "#c0c0c0"))) nil)

;; ヒントの表示(コピペ用:???)
 (defun display-hint ()
  (font-lock-add-keywords nil '(
    ("\n" 0 'hint-face prepend)
    ("\t" 0 'hint-face prepend)
    ("　" 0 'hint-face prepend)
  ))
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\n (vconcat "?\n"))
  (aset buffer-display-table ?\t (vconcat "^\t"))
  (aset buffer-display-table ?　 (vconcat "□"))
)

;; マジックナンバー
(defface danger-magic-number-face '((t (:foreground "#e00000"))) nil)

;; マジックナンバーの表示
(defun font-lock-add-magic-number ()
  (font-lock-add-keywords nil '(
    ("[^]A-Za-z0-9_\)]\\([-\\+]?0x[0-9a-fA-F]+\\|[-\\+]?[0-9.]+[fF]?\\)" 1 'danger-magic-number-face append)
  ))
)

;;; C++モードではマジックナンバーとヒントを表示
(add-hook 'c++-mode-hook
	  '(lambda ()
             (display-hint)
             (font-lock-add-magic-number)
	     ))

;; c++-modeキーバインディング
(add-hook 'c++-mode-hook
	  (function (lambda () (setq comment-column 40))))

(add-hook 'c++-mode-hook
	  '(lambda ()
	     (local-set-key "\C-cc" 'c-insert-function-comment)
	     (local-set-key "\C-cn" 'c-insert-name-comment)
	     (local-set-key "\C-ci" 'c-insert-if0-region)
	     (local-set-key "\C-c\C-u" 'codegen-update) ; 元のキーは、c-up-conditional @delete
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
; Meadow3になってからのような気がするが、何故かautoloadの設定が効かなくなってしまった
; requireすれば動くようになったのでとりあえずこれでしのぐ
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
(autoload 'sdic-describe-word "sdic" "英単語の意味を調べる" t nil)
(global-set-key "\C-cw" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "カーソルの位置の英単語の意味を調べる" t nil)
(global-set-key "\C-cW" 'sdic-describe-word-at-point)

;; 辞書ファイルの置き場所
(setq sdic-eiwa-dictionary-list '((sdicf-client "~/.emacs.d/site-lisp/sdic/gene.sdic")))
(setq sdic-waei-dictionary-list '((sdicf-client "~/.emacs.d/site-lisp/sdic/jedict.sdic")))

;;--------------------------------------------------------------------------
;; global @delete 
;;-------------------------------------------------------------------------
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-." 'gtags-find-tag)	;関数の定義元へ
         (local-set-key "\M-," 'gtags-find-rtag) ;関数の参照先へ
         (local-set-key "\M-m" 'gtags-find-symbol) ;変数の定義元/参照先へ
;         (local-set-key "\M-g" 'gtags-find-with-grep) ;タグを使ってgrep <-- 使いでがないので削除
	 (local-set-key "\M-]" 'gtags-next)
         ))

(add-hook 'c-mode-common-hook
          '(lambda()
             (gtags-mode 1) ;Cのソースを開いたら自動的にgtags-modeをon
             ))

; 次のシンボルに移動するためのキーボードマクロ
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
;vc-cvs-diffの時に追加するオプション
(setq vc-cvs-diff-switches '"-c")

;;--------------------------------------------------------------------------
;; vc-svn @delete
;;-------------------------------------------------------------------------
(add-to-list 'vc-handled-backends 'SVN)

;;--------------------------------------------------------------------------
;; 同一名バッファのパス名表示
;;-------------------------------------------------------------------------
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;--------------------------------------------------------------------------
;; recentf設定 自動セーブ付き
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

;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)

;; migemoがrequireできる環境ならmigemoを使う
(when (require 'migemo nil t) ;第三引数がnon-nilだとloadできなかった場合にエラーではなくnilを返す
  (setq moccur-use-migemo t))

;; dired時のmoccur
(add-hook 'dired-mode-hook
          '(lambda ()
             (local-set-key "O" 'dired-do-moccur)))

;;--------------------------------------------------------------------------
;; anything
;;-------------------------------------------------------------------------
(require 'anything-startup)

; anything-for-filesの内容をカスタマイズ、anything-c-source-locateを除外
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

;; 条件付き起動
(anything-complete-shell-history-setup-key (kbd "M-r")) ; C-r だと shell-mode の時に後方検索が出来なくなる

;; C-x a をanytingのプレフィックスに置き換える、というのは迷わないでよさそう
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
;; タブのかわりにスペースを使用
;;--------------------------------------------------------------------------
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)

;;--------------------------------------------------------------------------
;; emacsclientサーバーの起動
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
;; * 検索する
;;   dmoccur や moccur ， moccur-grep ， moccur-grep-find などで検索して結果を表示させます．
;;
;; * 編集モードに入る
;;   結果が表示されたところで，r(あるいはC-c C-i か C-x C-q でもいい) とします．すると，バッファが編集できるようになります．
;;
;; * 編集する
;;   後は編集するだけです．編集すると，編集した箇所には色がつきます．
;;
;; * 編集を適用する
;;   C-x C-s (あるいは C-c C-c か C-c C-f でも可能) とすると，色がついている変更のみが適用されます．
;;
;;   バッファの保存はしませんので，各ファイルを確認してから保存してください．変更した行には色がつきますので，比較的発見しやすいと思います．
;;
;; * 一部の変更のみ適用したくない
;;   適用したくない部分をリージョンで選択し，C-c C-r とします．そうすると，色が消えて，この変更は適用されなくなります．
;;
;; * すべての変更を破棄する
;;   すべての変更を適用したくない時には，C-x k(あるいは C-c C-k か C-c k か C-c C-u でも可能) とします．これで，すべての変更は無効になります． 
;;-------------------------------------------------------------------------
(require 'moccur-edit)

;;--------------------------------------------------------------------------
;;grep-edit
;;
;; M-x grepで検索後， grep のバッファを編集できます．編集すると，編集した箇所の色が変わります．
;; 編集が終わったら，C-c C-e とすると色のついた変更のみが適用されます．変更の破棄は，C-c C-u でできます．
;; また，適用したくない変更をリージョンで選択し， C-c C-r とすると，リージョン内の変更のみを破棄できます．
;;
;; この変更の適用時にはバッファの保存はしていません．
;; 保存前に正しく変更されているか確認してから保存してください．
;; 変更箇所は色を変えてますので，簡単に見つかると思います．
;;
;; エラー処理などはほとんどしていませんので，注意して使ってください． 
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

;; C-xC-yでview-modeのトグル
(global-set-key "\C-x\C-y" 'toggle-view-mode)

;; 強調は下線表示に
;(setq hl-line-face 'underline)

;;--------------------------------------------------------------------------
;; tortoise-svn @delete
;;--------------------------------------------------------------------------
(require 'tortoise-svn)

;;--------------------------------------------------------------------------
;; rept-mode @delete
;;--------------------------------------------------------------------------
(require 'rept-mode)

; reptファイルを開いたらrept-modeへ
(add-to-list 'auto-mode-alist '("\\.rept$" . rept-mode))

; reptファイルの置き場所を指定
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

;; 自動選択に使用する関数を設定
(setq text-translator-auto-selection-func
      'text-translator-translate-by-auto-selection-enja)

;; グローバルキーを設定
(global-set-key "\C-xt" 'text-translator-translate-by-auto-selection)

;; プリフィックスキーを変更する場合.
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
(setq auto-insert-directory "~/.emacs.d/insert/") ; 最後の / は必須
(define-auto-insert "\\.rb$" "template.rb")
(define-auto-insert "\\.js$" "template.js")
(define-auto-insert "blog.\\txt$" "template-blog.txt")

;;--------------------------------------------------------------------------
;; ミニバッファ上で現在バッファ名を挿入する
;; shell-command 等の実行に便利
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

;; (push '("*sdic*") popwin:special-display-config) ; 何故か動かない
;; (push '(dired-mode :position top) popwin:special-display-config) ; dired-jump-other-window (C-x 4 C-j)

;;--------------------------------------------------------------------------
;; JavaScript
;;
;; js2-20090723b.el (ダウンロード後、 js2.el に改名、要バイトコンパイル)
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
;; 直前に実行したシェルコマンドを実行 @delete
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
;; 矩形領域に対してリアルタイムに文字列の挿入が出来たり出来る。
;;
;; cua-mode開始 .. 領域選択して、C-Enter
;;-------------------------------------------------------------------------
(cua-mode t)
(setq cua-enable-cua-keys nil) ; そのままだと C-x が切り取りになってしまったりするので無効化

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
;; 直前のバッファに切り替え @delete
;;-------------------------------------------------------------------------
;;; last-buffer
(defvar last-buffer-saved nil)

;; last-bufferで選択しないバッファを設定
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
;; Cocoa Emacs の言語設定
;;--------------------------------------------------------------------------
(when platform-darwin-p
  ;; 日本語設定
  (set-language-environment 'Japanese)
  (prefer-coding-system 'utf-8)

  ;; MetaキーをCommandボタンに変更
  ;; CarbonからCocoaへ--Snow LeopardでEmacs 23を使う（3） - builder
  ;; http://builder.japan.zdnet.com/os-admin/sp_snow-leopard-09/20410578/
  (setq ns-command-modifier (quote meta))
  (setq ns-alternate-modifier (quote super))

  ;; Cocoa Emacs(Emacs23)での日本語フォント設定
  ;; http://macemacsjp.sourceforge.jp/index.php?MacFontSetting#h3b01bb4
  (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
  (set-fontset-font "fontset-menlokakugo" 'unicode (font-spec :family "Hiragino Kaku Gothic ProN" ) nil 'append)
  (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
  (setq face-font-rescale-alist '((".*Hiragino.*" . 1.2) (".*Menlo.*" . 1.0)))
  )

;;--------------------------------------------------------------------------
;; Cocoa Emacsでバックスラッシュが上手く入力出来ない対策
;;
;;   MacなEmacsでバックスラッシュを簡単に入力したい - Watsonのメモ
;;   http://d.hatena.ne.jp/Watson/20100207/1265476938
;;    
;;   Carbon Emacs で「\(バックスラッシュ)」を入力する - あいぷらぷら；
;;   http://d.hatena.ne.jp/june29/20080204/1202119521
;;--------------------------------------------------------------------------
(define-key global-map [?\\] [?\\])
(define-key global-map [?\C-\] [?\C-\\])
(define-key global-map [?\M-\] [?\M-\\])
(define-key global-map [?\C-\M-\] [?\C-\M-\\])

;;--------------------------------------------------------------------------
;; smartrep @delete
;;--------------------------------------------------------------------------
(require 'smartrep)

;;--------------------------------------------------------------------------
;; smartrep viewer @delete
;;--------------------------------------------------------------------------

;; ; プレフィックスキーの設定
;; (defvar ctl-t-map (make-keymap))
;; (define-key global-map "\C-t" ctl-t-map)

;; ; キーバインドの設定
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
;; jaunte.el - EmacsでHit a Hint(改) @delete
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

;; キーバインドの設定
(global-set-key (kbd "C-c C-m") 'ascmd:toggle)      ; Temporarily on/off auto-shell-command run
(global-set-key (kbd "C-c C-,") 'ascmd:popup)  ; Pop up '*Auto Shell Command*'
(global-set-key (kbd "C-c C-.") 'ascmd:exec)   ; Exec-command specify file name

;; 結果の通知をGrowlで行う
(when platform-darwin-p
  (defun ascmd:notify (msg) (deferred:process-shell (format "growlnotify -m %s -t emacs" msg))))

;; エラー時のポップアップを見やすくする。 ※ (require 'popwin) が必要です。
(push '("*Auto Shell Command*" :height 20 :noselect t) popwin:special-display-config)

;;--------------------------------------------------------------------------
;; duplicate-thing
;;   カーソル行を複製する、範囲選択時は範囲を複製
;;--------------------------------------------------------------------------
(require 'duplicate-thing)
(global-set-key (kbd "M-c") 'duplicate-thing) ; 元のキーはcapitalize-word

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
(setq auto-save-buffers-enhanced-interval 1) ; 指定のアイドル秒で保存
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

;; 変更出来ない・・
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

;; ;; windmove-default-keybindings に対応
;; (setq ww-advised-functions
;;       (append ww-advised-functions
;; 	      '(windmove-up
;; 		windmove-down
;; 		windmove-right
;; 		windmove-left)))

;; ;; anythingとの相性を修正
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
;; anything-c-source-ffap-line が正しく動かない問題を修正
(defun anything-c-shorten-home-path (files)
  "Replaces /home/user with ~."
  (let ((home (replace-regexp-in-string "\\\\" "/" ; stupid Windows...
                                        (getenv "HOME"))))
    (anything-transform-mapcar
     (lambda (file)
       (if (and (stringp file) (string-match home file))
           (replace-match "~" nil nil file)  ; 修正箇所
         file))
     files)))

;; pop-tag-mark(M-*) でジャンプ先から戻れるように
(defun anything-c-ffap-line-candidates ()
  (with-anything-current-buffer
    (anything-attrset 'ffap-line-location (anything-c-ffap-file-line-at-point)))
  (anything-aif (anything-attr 'ffap-line-location)
    (destructuring-bind (file . line) it
      (with-anything-current-buffer (ring-insert find-tag-marker-ring (point-marker))) ; find-tag-marker-ringにマークを挿入
      ;; (with-anything-current-buffer (ring-insert global-mark-ring (point-marker))) ; find-tag-marker-ringにマークを挿入
      ;; (with-anything-current-buffer (set-mark-command)) ; find-tag-marker-ringにマークを挿入
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
;; 環境固有の設定
;;-------------------------------------------------------------------------
(require 'private)

;;--------------------------------------------------------------------------
;; 自動で追加されたもの @delete
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
