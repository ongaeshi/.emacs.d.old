;;; rept-mode.el --- Major mode for editing rept files

;; Copyright (C) 2009  ongaeshi

;; Author: ongaeshi
;;         
;; Keywords: rept
;; Version: 0.0.1

;; This file is not part of Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This is a major mode for editing files in the REPT
;; and useful REPT functions.

;;; Installation:

;; To install, just drop this file into a directory in your
;; `load-path' and (optionally) byte-compile it.
;;
;; To automatically handle files ending in '.rept', add something like:
;;
;;    (require 'rept-mode)
;;    (add-to-list 'auto-mode-alist '("\\.rept$" . rept-mode))
;;    (setq rept-program-file "~/rept/bin/rept.rb")
;;
;; to your .emacs file.
;;

;;; Code:


;; User definable variables

(defface rept-header-face
  '((((class color) (min-colors 88) (background light))
     :background "grey85")
    (((class color) (min-colors 88) (background dark))
     :background "grey45")
    (((class color) (background light))
     :foreground "blue1" :weight bold)
    (((class color) (background dark))
     :foreground "green" :weight bold)
    (t :weight bold))
  "rept-header-face"
  :group 'rept-mode)

(defvar rept-header-face 'rept-header-face)


;; Constants

(defconst rept-mode-version
  "0.0.1"
  "Version of `rept-mode.'")


;; Mode setup

(easy-mmode-defmap rept-mode-map
  '(("\C-c\C-c" . rept-exec)
    ("\C-c\C-u" . rept-undo)
    )
  "Keymap used in `rept-mode' buffers.")

(define-derived-mode rept-mode fundamental-mode "Rept"
  "Simple mode to edit REPT.

\\{rept-mode-map}"
  (set (make-local-variable 'font-lock-defaults) rept-font-lock-defaults))


;; Font-lock support

(setq rept-font-lock-keywords
  '(("^Args:" . rept-header-face)
    ("^Index:" . rept-header-face)
    ("^-->" . font-lock-string-face)
    ("ReptName[0-9]+" . (0 font-lock-keyword-face t t))
    ("reptName[0-9]+" . (0 font-lock-keyword-face t t))
    ("reptname[0-9]+" . (0 font-lock-keyword-face t t))
    ("REPTNAME[0-9]+" . (0 font-lock-keyword-face t t))
    ("rept_name[0-9]+" . (0 font-lock-keyword-face t t))
    ))

(setq rept-font-lock-defaults
  '(rept-font-lock-keywords t nil nil nil))


;; Functions

(defvar rept-program-file
  nil
  "")

(defun rept-common (rept-file command-list option)
  (compilation-start (concat rept-program-file " " option " " (expand-file-name rept-file) " " command-list)))

(defun rept-exec (rept-file command-list)
  (interactive
   (list (read-file-name (concat "[exec] Rept File(" (file-name-nondirectory (buffer-file-name)) ") : "))
	 (read-string "Rept Command: ")))
  (rept-common rept-file command-list ""))

(defun rept-undo (rept-file command-list)
  (interactive
   (list (read-file-name (concat "[undo] Rept File(" (file-name-nondirectory (buffer-file-name)) ") : "))
	 (read-string "Rept Command: ")))
  (rept-common rept-file command-list "-u -f"))

(defun rept-mode-version ()
  "Diplay version of `rept-mode'."
  (interactive)
  (message "rept-mode %s" rept-mode-version)
  rept-mode-version)

(provide 'rept-mode)

;;; rept-mode.el ends here
