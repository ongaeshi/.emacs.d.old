;;; color-moccur.el ---  multi-buffer occur (grep) mode
;; -*- Mode: Emacs-Lisp -*-
;;
;; view-modeのキーバインディング
;;
;;; 参考:
;; http://d.hatena.ne.jp/rubikitch/20081104/1225745862
;;
;; H, h, ? ヘルプ
;; 数字	数引数を与える
;; <	バッファの先頭へ
;; >	バッファの最後へ
;; SPC	下にスクロール
;; RET     一行下にスクロール
;; y	一行上にスクロール
;; %	数引数の%に飛ぶ
;; g	数引数の行数に飛ぶ
;; .	マークを設定
;; x	現在位置とマーク位置に交互に移動
;; @	マーク位置に飛ぶ
;; C-x r SPC 現在位置をレジスタに格納
;; '	指定レジスタ位置にジャンプ
;; s	インクリメンタル検索
;; r	インクリメンタル検索(逆方向)

;;; Code:
(setq view-read-only t)

(defvar pager-keybind
      `( ;; vi-like
        ("h" . backward-word)
        ("l" . forward-word)
        ("j" . next-window-line)
        ("k" . previous-window-line)
        (";" . other-window)
        ("b" . scroll-down)
        (" " . scroll-up)
        ;; customize
        ("o" . occur-by-moccur)
        ("m" . moccur)
        ))

(defun define-many-keys (keymap key-table &optional includes)
  (let (key cmd)
    (dolist (key-cmd key-table)
      (setq key (car key-cmd)
            cmd (cdr key-cmd))
      (if (or (not includes) (member key includes))
        (define-key keymap key cmd))))
  keymap)

(defun view-mode-hook0 ()
  (define-many-keys view-mode-map pager-keybind)
  (hl-line-mode 1)
  (define-key view-mode-map " " 'scroll-up))

(add-hook 'view-mode-hook 'view-mode-hook0)

;; 書き込み不能なファイルはview-modeで開くように
(defadvice find-file
  (around find-file-switch-to-view-file (file &optional wild) activate)
  (if (and (not (file-writable-p file))
           (not (file-directory-p file)))
      (view-file file)
    ad-do-it))

;; 書き込み不能な場合はview-modeを抜けないように
(defvar view-mode-force-exit nil)
(defmacro do-not-exit-view-mode-unless-writable-advice (f)
  `(defadvice ,f (around do-not-exit-view-mode-unless-writable activate)
     (if (and (buffer-file-name)
              (not view-mode-force-exit)
              (not (file-writable-p (buffer-file-name))))
         (message "File is unwritable, so stay in view-mode.")
       ad-do-it)))

(do-not-exit-view-mode-unless-writable-advice view-mode-exit)
(do-not-exit-view-mode-unless-writable-advice view-mode-disable)

;; view-modeを切り替え、またhl-line-modeを無効にする
(defun toggle-view-mode ()
  (interactive)
  (cond (view-mode
      (view-mode nil)
      (setq hl-line-mode nil))
    (t
      (view-mode))))


;; 物理行移動
(defun previous-window-line (n)
  (interactive "p")
  (let ((cur-col
         (- (current-column)
            (save-excursion (vertical-motion 0) (current-column)))))
    (vertical-motion (- n))
    (move-to-column (+ (current-column) cur-col)))
  (run-hooks 'auto-line-hook)
  )

;; 物理行移動
(defun next-window-line (n)
  (interactive "p")
  (let ((cur-col
         (- (current-column)
            (save-excursion (vertical-motion 0) (current-column)))))
    (vertical-motion n)
    (move-to-column (+ (current-column) cur-col)))
  (run-hooks 'auto-line-hook)
  )
