;;; color-moccur.el ---  multi-buffer occur (grep) mode
;; -*- Mode: Emacs-Lisp -*-
;;
;; view-mode�̃L�[�o�C���f�B���O
;;
;;; �Q�l:
;; http://d.hatena.ne.jp/rubikitch/20081104/1225745862
;;
;; H, h, ? �w���v
;; ����	��������^����
;; <	�o�b�t�@�̐擪��
;; >	�o�b�t�@�̍Ō��
;; SPC	���ɃX�N���[��
;; RET     ��s���ɃX�N���[��
;; y	��s��ɃX�N���[��
;; %	��������%�ɔ��
;; g	�������̍s���ɔ��
;; .	�}�[�N��ݒ�
;; x	���݈ʒu�ƃ}�[�N�ʒu�Ɍ��݂Ɉړ�
;; @	�}�[�N�ʒu�ɔ��
;; C-x r SPC ���݈ʒu�����W�X�^�Ɋi�[
;; '	�w�背�W�X�^�ʒu�ɃW�����v
;; s	�C���N�������^������
;; r	�C���N�������^������(�t����)

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

;; �������ݕs�\�ȃt�@�C����view-mode�ŊJ���悤��
(defadvice find-file
  (around find-file-switch-to-view-file (file &optional wild) activate)
  (if (and (not (file-writable-p file))
           (not (file-directory-p file)))
      (view-file file)
    ad-do-it))

;; �������ݕs�\�ȏꍇ��view-mode�𔲂��Ȃ��悤��
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

;; view-mode��؂�ւ��A�܂�hl-line-mode�𖳌��ɂ���
(defun toggle-view-mode ()
  (interactive)
  (cond (view-mode
      (view-mode nil)
      (setq hl-line-mode nil))
    (t
      (view-mode))))


;; �����s�ړ�
(defun previous-window-line (n)
  (interactive "p")
  (let ((cur-col
         (- (current-column)
            (save-excursion (vertical-motion 0) (current-column)))))
    (vertical-motion (- n))
    (move-to-column (+ (current-column) cur-col)))
  (run-hooks 'auto-line-hook)
  )

;; �����s�ړ�
(defun next-window-line (n)
  (interactive "p")
  (let ((cur-col
         (- (current-column)
            (save-excursion (vertical-motion 0) (current-column)))))
    (vertical-motion n)
    (move-to-column (+ (current-column) cur-col)))
  (run-hooks 'auto-line-hook)
  )
