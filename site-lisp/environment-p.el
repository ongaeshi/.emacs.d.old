; http://d.hatena.ne.jp/tomoya/20090807/124960130

(defun x->bool (elt) (not (not elt)))

;; emacs-version predicates
(setq emacs22-p (string-match "^22" emacs-version)
	  emacs23-p (string-match "^23" emacs-version)
	  emacs23.0-p (string-match "^23\.0" emacs-version)
	  emacs23.1-p (string-match "^23\.1" emacs-version)
	  emacs23.2-p (string-match "^23\.2" emacs-version))

;; system-type predicates
(setq darwin-p  (eq system-type 'darwin)
      ns-p      (eq window-system 'ns)
      carbon-p  (eq window-system 'mac)
      linux-p   (eq system-type 'gnu/linux)
      colinux-p (when linux-p
                  (let ((file "/proc/modules"))
                    (and
                     (file-readable-p file)
                     (x->bool
                      (with-temp-buffer
                        (insert-file-contents file)
                        (goto-char (point-min))
                        (re-search-forward "^cofuse\.+" nil t))))))
      cygwin-p  (eq system-type 'cygwin)
      nt-p      (eq system-type 'windows-nt)
      meadow-p  (featurep 'meadow)
      windows-p (or cygwin-p nt-p meadow-p))

(provide 'environment-p)
;;; environment-p.el ends here.

