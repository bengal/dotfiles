;; shortcuts to navigate windows and buffers
(global-set-key (kbd "M-e") 'ibuffer)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-k") 'delete-other-windows)
(global-set-key (kbd "M-n") 'next-buffer)
(global-set-key (kbd "M-p") 'previous-buffer)

;; useful programming shortcuts
(global-set-key (kbd "M-c") 'compile)
(global-set-key (kbd "M-g") 'goto-line)

;; M-{up,down} to scroll buffer
(defun scroll-down-in-place (n)
  (interactive "p")
  (previous-line n)
  (scroll-down n))
(defun scroll-up-in-place (n)
  (interactive "p")
  (next-line n)
  (scroll-up n))
(global-set-key [M-up] 'scroll-down-in-place)
(global-set-key [M-down] 'scroll-up-in-place)

;; disable selection highlighting
(setq transient-mark-mode nil)

;; whitespace mode
(require 'whitespace)
(setq whitespace-style (quote
  (face trailing space-after-tab space-before-tab indentation)))

;; use ibuffer for buffer menu
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; group items in ibuffer by type
(require 'ibuf-ext)
(setq ibuffer-default-sorting-mode 'alphabetic)
(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("emacs" (name . "^*"))
	       ("dired" (mode . dired-mode))
	       ("dev" (or
		       (name . "\\.c$")
		       (name . "\\.h$")
		       (name . "\\.sh$")
		       (name . "akefile$")))
	       ("gdb" (or
		       (mode . gdb-breakpoints-mode)
		       (mode . gdb-frames-mode)
		       (mode . gdb-inferior-io-mode)
		       (mode . gdb-locals-mode)
		       (mode . gdb-registers-mode)
		       (mode . gnus-custom-mode)
		       (mode . grep-mode)
		       (mode . gud-mode)))
))))
(add-hook 'ibuffer-mode-hook
	  (lambda ()
	    (ibuffer-switch-to-saved-filter-groups "default")))

;; default linux kernel indentation
(setq c-default-style "linux"
      c-basic-offset 8)

;; indent with 4 spaces
; (setq-default indent-tabs-mode nil)
; (setq tab-width 4)

;; integration with cscope to index C sources
(require 'xcscope)

;; Enable versioned files in a dedicated directory
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))
(setq delete-old-versions t)

;; echo keystrokes immediately
(setq echo-keystrokes 0.01)

;; display time in the modeline
; (setq display-time-24hr-format t)
; (setq display-time-day-and-date t)
; (display-time)

;; save position in files
(require 'saveplace)
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)

;; show column number in mode line
(column-number-mode 1)

;; disable menu-bar
(menu-bar-mode -1)

;; linum mode: show line numbers
; (require 'linum)
; (add-hook 'find-file-hook (lambda () (linum-mode 1)))

;; highlight matching parenthesis
(when (fboundp 'show-paren-mode)
  (show-paren-mode t)
  (setq show-paren-style 'parenthesis))

;; don't show startup screen
(custom-set-variables
 '(inhibit-startup-screen t))

;; fast access to recent files
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 20)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;;gdb default path for gud
; (setq gud-gdb-command-name "/usr/local/cross/arm32/bin/arm-linux-gnueabi-gdb --annotate=3")

;; darken regions in "#if 0"
(defun cpp-highlight-if-0/1 ()
  (interactive)
  (setq cpp-known-face '(background-color . "lightgray"))
  (setq cpp-unknown-face 'default)
  (setq cpp-face-type 'dark)
  (setq cpp-known-writable 't)
  (setq cpp-unknown-writable 't)
  (setq cpp-edit-list
	'((#("0" 0 1
	     (fontified nil))
	   (background-color . "lightgray")
	   nil
	   both nil)))
  (cpp-highlight-buffer t))
(defun cpp-darken-disabled ()
  (cpp-highlight-if-0/1)
  (add-hook 'after-save-hook 'cpp-highlight-if-0/1 'append 'local)
  )
(add-hook 'c-mode-common-hook 'cpp-darken-disabled)

;; dired: reuse directory buffer
(put 'dired-find-alternate-file 'disabled nil)
