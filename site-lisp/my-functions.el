;;; my-functions.el
;;
;; (require 'my-functions)

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

(provide 'my-functions)
;;; my-functions.el ends here.
