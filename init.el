;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 文字コードはJISにしておかないと日本語がうまく表示されない

;; ロードパスを設定
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/auto-install")

;;--------------------------------------------------------------------------
;;自作関数
;;-------------------------------------------------------------------------

;;;****************************************************************
;; "C の演算子優先順位表を表示する。"
;;;****************************************************************
(defun cprec ()
  (interactive)
  (with-output-to-temp-buffer "*CPREC*"
    (princ "
      ()  []  ->  .
      !   ~   ++  --  -   (type)  *   &   sizeof         /* %right */
      *   /   %
      +   -
      <<  >>
      <   <=  >   >=
      ==  !=
      &
      ^
      |
      &&
      ||
      ?:                                                 /* %right */
      =   op=                                            /* %right */
      ,")))


;;****************************************************************
;; "C の型の幅、許容範囲を表示する"
;;****************************************************************
(defun ctype ()
  (interactive)
  (with-output-to-temp-buffer "*C-TYPE*"
    (princ "
	型名		バイト幅（ビット幅）
	char             1 byte   ( 8 bit)
	short            2 byte   (16 bit)
	int		 4 byte	  (32 bit)		host-name: scarfy
	long             4 byte   (32 bit)
	long int         4 byte   (32 bit)
	float            4 byte   (32 bit)
	double           8 byte   (64 bit)


	数値の型      数値の範囲                数値の型       数値の範囲
	signed char  -128 〜 +127               unsigned char  0 〜 255
	signed short -32768 〜 +32767           unsigned short 0 〜 65535
	signed long  -2147483648 〜 +2147483647 unsigned long  0 〜 4294967295


○ 算術変換
★ いずれかの被演算数が、long double なら、他方とも long double に変換
★ そうでないなら、片方の被演算数が double なら、他方も double に変換
★ そうでない時、両方の被演算数に対して整数への格上げが行われる（※１）
	・ 片方の被演算数が unsigned long int なら 他方も unsigned int 
	・ 片方の被演算数が long int 、他方が unsigned int の時（※２）
	・ 片方の被演算数が long int の時には、他方も long int
	・ 片方の被演算数が unsigned int であれば、他方も unsigned int 
	・ そうでない時には、両方の被演算数は、 型 int を持つ


※１	整数への格上げとは…
	元の型の全ての値が int で表せる時は、その値は int に変換される。
	そうでない時には、値は unsigned int に変換される。


※２	


     ")))


;;****************************************************************
;; 便利そうな公式
;;****************************************************************
(defun memo ()
  (interactive)
  (with-output-to-temp-buffer "*MEMO*"
    (princ "<<知っておくと便利そうなネタ>>
1. 平面状にかかれた図形の辺の数 = 面の数 + 頂点の数 - 1
2. 空間内の穴のない多面体の辺の数 = 面の数 + 頂点の数 - 2
")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;便利なカーソル移動
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;10行前に移動
(defun scroll-previous-10-line ()
  "10行前に移動"
  (interactive)
  (previous-line 10))
;(global-set-key "\C-\M-p" 'scroll-previous-10-line)
(global-set-key "\M-p" 'scroll-previous-10-line)


;;10行後ろに移動
(defun scroll-next-10-line ()
  "10行後ろに移動"
  (interactive)
  (next-line 10))
;(global-set-key "\C-\M-n" 'scroll-next-10-line)
(global-set-key "\M-n" 'scroll-next-10-line)

;;ラインをディスプレイの最上段に移動する
(defun line-to-top ()
  "Move current line to top of window."
  (interactive)
  (recenter 0))
(global-set-key (kbd "M-l") 'line-to-top) ; 元のキーは downcase-word

;;こんなキーバインドも使えるよ 例 f1キー ,→キー
;(global-set-key [f1] 'line-to-top)
;(global-set-key [right] 'line-to-top)

;;変なモード(IPA)を消そう
(global-unset-key "\C-]")
;;変わりにこれを入れる lisp-commandの補完
(global-set-key "\C-]" 'lisp-complete-symbol)

;;eval-expressionを使えるようにする(自動的に書かれた)
(put 'eval-expression 'disabled nil)

(defun yank-push()
	"yank-pop()の逆バージョン．ただし，先頭から最後尾にはいかない．"
	(interactive)
	(yank-pop -1))

;;元のキーは，upcase-word 単語を大文字に変換する 
(global-set-key "\M-u" 'yank-push)

(defun search-forward-val ()
	"c言語またはlispで次の変数名，関数名に移動する(簡易版)"
	(interactive)
	(search-forward-regexp "[a-zA-Z0-9-_.]+\\($\\|[][()+*/><=!|&^? \t;\",:{}]\\)" nil t 1)
	(goto-char (match-beginning 1)))
;;元のキーは，forward-word
;(global-set-key "\M-f" 'search-forward-val)

(defun search-backward-val ()
	"c言語またはlispで次の変数名，関数名に移動する(簡易版)"
	(interactive)
	(search-backward-regexp "\\(^\\|[][()+*/><=!|&^? \t\",:{}]\\)\\([a-zA-Z0-9-_.]+\\)" nil t 1)
	(goto-char (match-beginning 2)))
;;元のキーは， backward-word
;(global-set-key "\M-b" 'search-backward-val)

(defun copy-at-point (thing)
  (kill-new (thing-at-point thing))
  (end-of-thing thing))

(defun copy-defun ()
  (let (start end)
    (beginning-of-defun)
    (setq start (point))
    (end-of-defun)
    (setq end (point))
    (kill-ring-save start end)))

(defun context-copy ()
  (interactive)
  (if (not (null (thing-at-point 'symbol)))
      (copy-at-point 'symbol)
    (if (not (null (thing-at-point 'sexp)))
	(copy-at-point 'sexp)
      (copy-defun))))

;;元のキーは zap-to-char
(global-set-key "\C-z" 'context-copy)

(defun kill-at-point (thing)
  (let (start end)
    (beginning-of-thing thing)
    (setq start (point))
    (end-of-thing thing)
    (setq end (point))
    (kill-region start end)))

(defun kill-defun ()
  (let (start end)
    (beginning-of-defun)
    (setq start (point))
    (end-of-defun)
    (setq end (point))
    (kill-region start end)))

(defun context-kill ()
  (interactive)
  (if (not (null (thing-at-point 'symbol)))
      (kill-at-point 'symbol)
    (if (not (null (thing-at-point 'sexp)))
	(kill-at-point 'sexp)
      (kill-defun))))

;;元のキーは iconify-or-deiconify-frame(Suspend)
;(global-set-key "\M-z" 'context-kill)

(defun insert-format-time ()
  "タイムスタンプを挿入"
  (interactive)
  (insert (format-time-string "%Y/%m/%d" (current-time))))

(defun insert-format-time2 ()
  "タイムスタンプを挿入(時間付き)"
  (interactive)
  (insert (format-time-string "%Y%m%d%H%M" (current-time))))

;;ファイルの先頭にタイムスタンプ、ファイル名などを挿入
(defun c-insert-file-header ()
  "ファイルの先頭にタイムスタンプ、ファイル名などを挿入"
  (interactive)
  (goto-char (point-min))
  (insert "/* --------------------------------------------------------------------------\n")
  (insert "/**\n")
  (insert " * @file \n")
  (insert " * \n")
  (insert " */\n")
  )
  
;;cのコメントを入れる
(defun c-insert-function-comment ()
  "cのコメントを入れる"
  (interactive)
  (let ((begin (point)))
    (insert "// --------------------------------------------------------------------------\n")
    (insert "/**\n")
    (insert " *\n")
    (insert " */\n")
    (indent-region begin (point) nil)
    )
  )

;;選択範囲に対して何かしらのメッセージを挿入
(defun c-insert-message-region (beginMessage endMessage pointBegin pointEnd indent)
  "選択範囲に対して何かしらのメッセージを挿入"
  (let ((begin (make-marker))
	(end (make-marker)))
    (set-marker begin pointBegin)
    (set-marker end pointEnd)
    (goto-char begin)
    (insert beginMessage)
    (goto-char end)
    (insert endMessage)
    (if indent
	(indent-region begin (point) nil))
    )
  )

;;Doxygenの@nameコメントを追加
(defun c-insert-name-comment (name pointBegin pointEnd)
  "Doxygenの@nameコメントを追加"
  (interactive "sname(default None): \nr")
  (let (beginMessage)
    (if (equal name "")
	(setq beginMessage "/// @name \n/// @{\n")
      (setq beginMessage (concat "/// @name " name "\n/// @{\n")))
    (c-insert-message-region beginMessage "/// @}\n" pointBegin pointEnd t)
    )
  )

;; 選択範囲を#if 0〜#endifで囲む
(defun c-insert-if0-region (name pointBegin pointEnd)
  "選択範囲を#if 0〜#endifで囲む"
  (interactive "smacro name(default 0): \nr")
  (let (beginMessage)
    (if (equal name "")
	(setq beginMessage "#if 0\n")
      (setq beginMessage (concat "#if " name "\n")))
    (c-insert-message-region beginMessage "#endif\n" pointBegin pointEnd nil)
    )
  )

;;--------------------------------------------------------------------------
;;シェルコマンドの実行
;;-------------------------------------------------------------------------

;; 現在開いているバッファのファイル名を得る
(defun buffer-file-name-nondirectory ()
  (file-name-nondirectory (buffer-file-name))
  )

;; 現在開いているバッファのディレクトリ名を得る
(defun buffer-file-name-directory ()
  (file-name-directory (buffer-file-name))
  )

;; シェルを開いてコマンドを実行する
(defun exec-shell (command &optional silent-exec)
  (let ((buffer (current-buffer)))
    (shell)
    (insert-string command)
    (comint-send-input)
    (if (null silent-exec)
        ()
      (switch-to-buffer buffer)
      )
    )
  )

;;--------------------------------------------------------------------------
;;設定
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
(setq truncate-partial-width-windows nil)
;(setq truncate-partial-width-windows t)

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
      (append '(("\\.c$" . c-mode)	
		("\\.pl$" . cperl-mode)
		("\\.cpp$" . c++-mode)
		("\\.h$" . c++-mode)
		("[Mm]akefile" . makefile-mode)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;shell-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; .bashrcでcdやpushd,popdにエイリアスを貼る場合は、Emacs側にも伝えておく必要がある
; http://www.geocities.co.jp/SiliconValley-Bay/9285/EMACS-JA/emacs_412.html
;(setq shell-pushd-regexp "\\(cd\\|pushd\\)")
;(setq shell-popd-regexp "\\(bd\\|popd\\)")

;; shell-mode でエスケープを綺麗に表示
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
   "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;キーバインドの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
(global-set-key "\M-q" 'query-replace-regexp)

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
(global-set-key "\C-cb" 'revert-buffer)

; 直前に実行したシェルコマンドを実行
(defun shell-command-prev ()
  (interactive)
  (shell-command (car shell-command-history) nil nil))

(global-set-key (kbd "C-c C-c") 'shell-command-prev)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Info-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; キーバインドの変更
(add-hook 'Info-mode-hook
	  '(lambda () (define-key Info-mode-map [M-n] 'scroll-next-10-line)) ;元のキーは、clone-buffer
	  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ウィンドウサイズ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq default-frame-alist
      (append (list
	       '(top . 0)
	       '(left . 0)
	       '(width . 115)
	       '(height . 57)
	       )
               default-frame-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Font & Color
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'color-setting)

; 行間を開ける量、これを調整することでかなり見え方が変わる
(setq-default line-spacing 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; C, C++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	     (local-set-key "\C-c\C-u" 'codegen-update) ; 元のキーは、c-up-conditional
	     ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;dired
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; dired-x
(require 'dired-x)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;RUBY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$\\|\\.ru$\\|Rakefile$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))

; Meadow3になってからのような気がするが、何故かautoloadの設定が効かなくなってしまった
; requireすれば動くようになったのでとりあえずこれでしのぐ
;
;(autoload 'run-ruby "inf-ruby"
;  "Run an inferior Ruby process")
;(autoload 'inf-ruby-keys "inf-ruby"
;  "Set local key defs for inf-ruby in ruby-mode")
;(require 'inf-ruby)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;PHP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sdic-mode 用の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-path (cons "~/.emacs.d/site-lisp/sdic" load-path))
(autoload 'sdic-describe-word "sdic" "英単語の意味を調べる" t nil)
(global-set-key "\C-cw" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "カーソルの位置の英単語の意味を調べる" t nil)
(global-set-key "\C-cW" 'sdic-describe-word-at-point)

;; 辞書ファイルの置き場所
(setq sdic-eiwa-dictionary-list '((sdicf-client "~/.emacs.d/site-lisp/sdic/gene.sdic")))
(setq sdic-waei-dictionary-list '((sdicf-client "~/.emacs.d/site-lisp/sdic/jedict.sdic")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;global
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pukiwiki
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;vc-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;vc-cvs-diffの時に追加するオプション
(setq vc-cvs-diff-switches '"-c")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;vc-svn
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'vc-handled-backends 'SVN)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;同一名バッファのパス名表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;--------------------------------------------------------------------------
;; recentf設定 自動セーブ付き
;; (install-elisp-from-emacswiki "recentf-ext.el")
;;--------------------------------------------------------------------------
(setq recentf-max-saved-items 5000)
(recentf-mode 1)

(when (require 'recentf-ext nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;color-moccur
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;anything
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'anything-config)
(require 'anything-match-plugin)
(require 'anything-complete)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;anything-gtags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'anything-gtags)
;(setq anything-gtags-classify t) ; <-- これなんだろ？

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;anything-c-moccur
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'anything-c-moccur)

;; カスタマイズ可能変数の設定(M-x customize-group anything-c-moccur でも設定可能)
(setq anything-c-moccur-anything-idle-delay 0.2 ;`anything-idle-delay'
      anything-c-moccur-higligt-info-line-flag t ; `anything-c-moccur-dmoccur'などのコマンドでバッファの情報をハイライトする
      anything-c-moccur-enable-auto-look-flag t ; 現在選択中の候補の位置を他のwindowに表示する
      anything-c-moccur-enable-initial-pattern t) ; `anything-c-moccur-occur-by-moccur'の起動時にポイントの位置の単語を初期パターンにする

;;; キーバインドの割当(好みに合わせて設定してください)

;バッファ内検索
(global-set-key (kbd "C-x o") 'anything-c-moccur-occur-by-moccur)

;ディレクトリ
(global-set-key (kbd "C-x O") 'anything-c-moccur-dmoccur) 

;diredで選択したファイルに対して検索
(add-hook 'dired-mode-hook ;dired
          '(lambda ()
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))

; anything-mode中の移動処理
(add-hook 'anything-mode-hook
          '(lambda ()
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;anythingのキーバインドを設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-,") 'anything-at-point)
(global-set-key (kbd "C-c C-,") 'anything-resume)

(define-key anything-map "\C-\M-n" 'anything-next-source)
(define-key anything-map "\C-\M-p" 'anything-previous-source)
(define-key anything-map "\C-z"    'anything-execute-persistent-action)
(define-key anything-map "C-i"     'anything-select-action)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;実験的なanything-c-source
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun current-line ()
  "Return the vertical position of point..."
  (1+ (count-lines 1 (point))))

(defun max-line ()
  "Return the vertical position of point..."
  (save-excursion
    (goto-char (point-max))
    (current-line)))

;; 特定行に移動
(setq anything-c-source-goto-line
  '((name . "Goto line")
    (filtered-candidate-transformer . (lambda (candidates source)
					(if (string-match "^[0-9]*$" anything-pattern)
					    (with-current-buffer anything-current-buffer
					      (if (>= (max-line) (string-to-number anything-pattern))
						  (list (concat "line number: " anything-pattern))
						nil))
					  nil)
					))
    (action . (("Goto line" . (lambda (arg)
			       (if (string-match "[0-9]*$" arg)
				   (progn
				     (let ((line-number (string-to-number (match-string 0 arg))))
				       (goto-line line-number))))))))
    ))

;; mark-ring
(defvar anything-c-source-mark-ring
  '((name . "mark-ring")
    (candidates . anything-c-source-mark-ring-candidates)
    (action . (("Goto line" . (lambda (candidate)
                                (goto-line (string-to-number candidate))))))
    (persistent-action . (lambda (candidate)
                           (switch-to-buffer anything-current-buffer)
                           (goto-line (string-to-number candidate))
                           (set-window-start (get-buffer-window anything-current-buffer) (point))))))
(defun anything-c-source-mark-ring-candidates ()
  (with-current-buffer anything-current-buffer
    (let* ((marks (cons (mark-marker) mark-ring))
           (lines (mapcar (lambda (pos)
                            (save-excursion
                              (goto-char pos)
                              (beginning-of-line)
                              (let ((line  (car (split-string (thing-at-point 'line) "[\n\r]"))))
                                (when (string= "" line)
                                  (setq line  "<EMPTY LINE>"))
                                (format "%7d: %s" (line-number-at-pos) line))))
                          marks)))
      lines)))



;; global-mark-ring
(defvar anything-c-source-global-mark-ring
  '((name . "global-mark-ring")
    (candidates . anything-c-source-global-mark-ring-candidates)
    (action . (("Goto line" . (lambda (candidate)
                                (let ((items (split-string candidate ":")))
                                  (switch-to-buffer (second items))
                                  (goto-line (string-to-number (car items))))))))
    
    (persistent-action . (lambda (candidate)
                           (let ((items (split-string candidate ":")))
                             (switch-to-buffer (second items))
                             (goto-line (string-to-number (car items)))
                             (set-window-start (get-buffer-window anything-current-buffer) (point)))))))

(defun anything-c-source-global-mark-ring-candidates ()
  (let* ((marks global-mark-ring)
         (lines (mapcar (lambda (pos)
                          (if (or (string-match "^ " (format "%s" (marker-buffer pos)))
                                  (null (marker-buffer pos)))
                              nil
                            (save-excursion
                              (set-buffer (marker-buffer pos))
                              (goto-char pos)
                              (beginning-of-line)
                              (let ((line  (car (split-string (thing-at-point 'line) "[\n\r]"))))
                                (when (string= "" line)
                                  (setq line  "<EMPTY LINE>"))
                                (format "%7d:%s:    %s" (line-number-at-pos) (marker-buffer pos) line)))))
                        marks)))
    (delq nil lines)))

;; anythingから直接google検索(メニューを挟まない版)
(defvar anything-c-source-anything-google-fallback
  '((name . "Google fallback")
    (dummy)
    (action . (lambda (x) (google x t)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;anything-sourceを選択してanythingを起動するanything-source
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar anything-c-source-call-source
  `((name . "call source")
    (init . (lambda ()
              (with-current-buffer (anything-candidate-buffer 'global)
                (let ((sources (loop for sym being symbols
                                     for s = (symbol-name sym)
                                     when (string-match "^anything-c-source-" s)
                                     collect s)))
                  (insert (mapconcat 'identity sources "\n"))))))
    (candidates-in-buffer)
    (action . (("invoke anything with selected source" .
                (lambda (candidate)
                  (let ((source-sym (intern candidate)))
                    (when (anything-c-call-source-p source-sym)
                      (anything (list source-sym))))))
               ))))

(defun anything-c-call-source-p (sym)
  (let ((source (symbol-value sym)))
    (assq 'name source)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;anything、ページ切り替えの仕組み
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar anything-sources-list nil
  "anything sources list. for anything-select-sources-list")

(defun anything-select-sources-list (num)
  (anything-set-sources (nth num anything-sources-list)))

; anything-select-with-digit-shortcut とキーバインドが被ってしまっているが、他にいいキーバインドが見付からなかったのでやむなく・・・。
(define-key anything-map (kbd "C-1") '(lambda () (interactive) (anything-select-sources-list 0)))
(define-key anything-map (kbd "C-2") '(lambda () (interactive) (anything-select-sources-list 1)))
(define-key anything-map (kbd "C-3") '(lambda () (interactive) (anything-select-sources-list 2)))
(define-key anything-map (kbd "C-4") '(lambda () (interactive) (anything-select-sources-list 3)))
(define-key anything-map (kbd "C-5") '(lambda () (interactive) (anything-select-sources-list 4)))
(define-key anything-map (kbd "C-6") '(lambda () (interactive) (anything-select-sources-list 5)))
(define-key anything-map (kbd "C-7") '(lambda () (interactive) (anything-select-sources-list 6)))
(define-key anything-map (kbd "C-8") '(lambda () (interactive) (anything-select-sources-list 7)))
(define-key anything-map (kbd "C-9") '(lambda () (interactive) (anything-select-sources-list 8)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; anythingを利用して、rubyのプログラムをリアルタイムに実行させる
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun anything-c-has-print (input)
  (if (string-match "print\\|puts" input)
      t
    nil))

(defun anything-c-ruby-command (command)
  (if (anything-c-has-print command)
      command
    (concat "p " command)))

(defvar anything-c-source-ruby
  '((name . "ruby command")
    (candidates . (lambda ()
                    (start-process "ruby-process" nil
				   "ruby" "-e" (anything-c-ruby-command anything-input))))
    (requires-pattern . 3)
    (delayed)
    (action . (("Run Ruby" . (lambda (candidate)
			       (switch-to-buffer-other-window (get-buffer-create "*anything result*"))
			       (point-max)
			       (insert (concat (anything-c-ruby-command anything-input) "\n# -- result --\n"))
			       (start-process "ruby-process" "*anything result*"
					      "ruby" "-e" (anything-c-ruby-command anything-input))))))
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 仮引数を渡して起動すると、カーソル位置の単語を拾い出してanythingの入力に渡してくれます
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun anything-at-point (arg)
  (interactive "P")
  (if arg
      (anything nil (thing-at-point 'symbol))
    (anything)))

;;--------------------------------------------------------------------------
;; anything-include
;;--------------------------------------------------------------------------
(require 'anything-include)
(setq anything-include-max-saved-items 1000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;anythingソースの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ソースの設定
(setq anything-sources
      (list anything-c-source-buffers
            anything-c-source-goto-line
            anything-c-source-recentf
            anything-c-source-include
            anything-c-source-files-in-current-dir
            anything-c-source-gtags-select
            anything-c-source-emacs-commands
            anything-c-source-info-pages
            anything-c-source-bookmarks
	    ))

(setq anything-sources-for-file
      (list anything-c-source-locate))

(setq anything-sources-for-emacs
      (list anything-c-source-emacs-commands
	    anything-c-source-emacs-functions
            anything-c-source-apropos-emacs-variables
            anything-c-source-complex-command-history
	    anything-c-source-call-source))
  
(setq anything-sources-for-internet
      (list anything-c-source-anything-google-fallback))
  
(setq anything-sources-for-program
      (list anything-c-source-calculation-result
            anything-c-source-evaluation-result
            anything-c-source-ruby))

; anythingソースのリスト
; anything-select-sources-listのページ番号に対応する
(setq anything-sources-list
      (list anything-sources
	    anything-sources-for-file
	    anything-sources-for-emacs
	    anything-sources-for-internet
            anything-sources-for-program))

;;--------------------------------------------------------------------------
;; タブのかわりにスペースを使用
;;--------------------------------------------------------------------------
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)

;;--------------------------------------------------------------------------
;;emacsclient サーバーの起動
;;-------------------------------------------------------------------------
(server-start)

;;--------------------------------------------------------------------------
;;url-retrieve-synchronously
;;--------------------------------------------------------------------------
;(setq url-proxy-services
;      '(("http"     . "proxy.co.jp:8080")
;        ("no_proxy" . "proxy.co.jp\\|proxy2.co.jp")))

;;--------------------------------------------------------------------------
;;oddmuse
;;--------------------------------------------------------------------------
(require 'oddmuse)
;(setq url-proxy-services '(("http" . "proxy.co.jp:8080")))
(oddmuse-mode-initialize)

;;--------------------------------------------------------------------------
;;moccur-edit
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
;; wdired.el
;;--------------------------------------------------------------------------
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;--------------------------------------------------------------------------
;; google
;;--------------------------------------------------------------------------
(load "google")

;;--------------------------------------------------------------------------
;; view-mode-key
;;--------------------------------------------------------------------------
(load "view-mode-key")

;; C-xC-yでview-modeのトグル
(global-set-key "\C-x\C-y" 'toggle-view-mode)

;; 強調は下線表示に
;(setq hl-line-face 'underline)

;;--------------------------------------------------------------------------
;; tortoise-svn
;;--------------------------------------------------------------------------
(require 'tortoise-svn)

;;--------------------------------------------------------------------------
;; rept-mode
;;--------------------------------------------------------------------------
(require 'rept-mode)

; reptファイルを開いたらrept-modeへ
(add-to-list 'auto-mode-alist '("\\.rept$" . rept-mode))

; reptファイルの置き場所を指定
(setq rept-program-file "rept.bat")

;;--------------------------------------------------------------------------
;;ナロイングの設定
;;-------------------------------------------------------------------------
(put 'narrow-to-region 'disabled nil)

;;--------------------------------------------------------------------------
;;ActionScript3.0
;;-------------------------------------------------------------------------
(autoload 'actionscript-mode "actionscript-mode" "actionscript" t)

(setq auto-mode-alist
      (append '(("\\.as$" . actionscript-mode))
              auto-mode-alist))

;;--------------------------------------------------------------------------
;;text-translate
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
;;auto-install
;;(install-elisp-from-emacswiki "auto-install.el")
;;--------------------------------------------------------------------------
(require 'auto-install)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;--------------------------------------------------------------------------
;; open-junk-file.el
;; (install-elisp-from-emacswiki "open-junk-file.el")
;;--------------------------------------------------------------------------
(require 'open-junk-file)
(setq open-junk-file-format "~/Documents/junk/%Y-%m%d-%H%M%S.")
(global-set-key "\C-xj" 'open-junk-file)

;;--------------------------------------------------------------------------
;; transient-mark-mode
;;   C-sからそのままテキストコピーをよく使うので、やっぱりnilがいいや
;;--------------------------------------------------------------------------
(setq transient-mark-mode nil)

;;--------------------------------------------------------------------------
;; color-moccur
;; (install-elisp-from-emacswiki "color-moccur.el")
;;--------------------------------------------------------------------------
(require 'color-moccur)
(setq moccur-split-word t)

;--------------------------------------------------------------------------
;; autoinsert.el
;;--------------------------------------------------------------------------
(auto-insert-mode)
(setq auto-insert-directory "~/.emacs.d/insert/") ; 最後の / は必須
(define-auto-insert "\\.rb$" "template.rb")
(define-auto-insert "\\.js$" "template.js")
(define-auto-insert "blog.\\txt$" "template-blog.txt")

;;--------------------------------------------------------------------------
;;ミニバッファ上で現在バッファ名を挿入する
;;shell-command 等の実行に便利
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
;;javascript-mode
;;-------------------------------------------------------------------------
;; ; インデント幅
;; (setq javascript-indent-level 2)

;;--------------------------------------------------------------------------
;;html-fold
;;(install-elisp "https://github.com/ataka/html-fold/raw/master/html-fold.el")
;;-------------------------------------------------------------------------
(autoload 'html-fold-mode "html-fold" "Minor mode for hiding and revealing elements." t)

;;--------------------------------------------------------------------------
;;haml
;;http://www.ftnk.jp/~fumi/cl/2009-05-02-3.html
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
;; popwin.el
;; (auto-install-from-url "https://github.com/m2ym/popwin-el/raw/master/popwin.el")
;;--------------------------------------------------------------------------
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(setq special-display-function 'popwin:special-display-popup-window)

(push '("*Shell Command Output*" :height 20) popwin:special-display-config)
;(push '("*Shell Command Output*" :height 20 :position top) popwin:special-display-config)

(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)
(push '("*anything for files*" :height 20) popwin:special-display-config)

(push '("*scratch*") popwin:special-display-config)
(push '("svnlog.txt") popwin:special-display-config)
(push '("journal.txt" :regexp t) popwin:special-display-config)
;(push '("*grep*") popwin:special-display-config)
(push '("*sdic*") popwin:special-display-config) ; 何故か動かない
(push '(dired-mode :position top) popwin:special-display-config) ; dired-jump-other-window (C-x 4 C-j)

;;--------------------------------------------------------------------------
;;JavaScript
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
;;直前に実行したシェルコマンドを実行
;;-------------------------------------------------------------------------
(defun shell-command-prev ()
  (interactive)
  (shell-command (car shell-command-history) nil nil))

(global-set-key (kbd "C-c C-c") 'shell-command-prev)

;;--------------------------------------------------------------------------
;;Add-on SDK
;;-------------------------------------------------------------------------
(defun cfx-start() 
  (interactive)
  (exec-shell "cd ~/app/addon-sdk-1.2.1/; source bin/activate" nil))

(defun cfx-run() 
  (interactive)
  (exec-shell "cfx run" t))

(defun cfx-test() 
  (interactive)
  (exec-shell "cfx test" t))

;; (global-set-key (kbd "C-c C-c") 'cfx-test)
(global-set-key (kbd "C-c C-v") 'cfx-run)

;;--------------------------------------------------------------------------
;;cua-mode
;; 矩形領域に対してリアルタイムに文字列の挿入が出来たり出来る。
;;
;; cua-mode開始 .. 領域選択して、C-Enter
;;-------------------------------------------------------------------------
(cua-mode t)
(setq cua-enable-cua-keys nil) ; そのままだと C-x が切り取りになってしまったりするので無効化

;;--------------------------------------------------------------------------
;;cycle-buffer.el
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
;;直前のバッファに切り替え
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

(global-set-key (kbd "C-t") 'switch-to-last-buffer-or-other-window)
;(global-set-key (kbd "M-l") 'switch-to-last-buffer)

;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;;--------------------------------------------------------------------------
;;プロジェクト毎の専用設定
;;-------------------------------------------------------------------------
;(load-file "project.el")

