(add-to-list 'load-path "~/.emacs.d/")

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
(global-set-key "\M-[1;3A" 'scroll-down-in-place) ;; inside tmux
(global-set-key "\M-[1;3B" 'scroll-up-in-place) ;; inside tmux

;; disable selection highlighting
(setq transient-mark-mode nil)

;; whitespace mode
(require 'whitespace)
(setq whitespace-style
      (quote (face trailing space-after-tab space-before-tab indentation)))

;; use ibuffer for buffer menu
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; group items in ibuffer by type
(require 'ibuf-ext)
(setq ibuffer-default-sorting-mode 'alphabetic)
(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("emacs" (name . "^*"))
	       ("dired" (mode . dired-mode))
	       ("source" (or
			  (name . "\\.c$")
			  (name . "\\.S$")
			  (name . "\\.s$")
			  (name . "\\.h$")
			  (name . "\\.sh$")
			  (name . "\\.mk$")
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

;; indent with tabs
(defun c-mode-linux()
  (interactive)
  (setq c-default-style "linux"
	c-basic-offset 8)
  (setq-default indent-tabs-mode t))

;; indent with 4 spaces
(defun c-mode-qemu()
  (interactive)
  (setq-default indent-tabs-mode nil)
  (setq c-default-style "linux"
	c-basic-offset 4))

(add-hook 'c-mode-common-hook 'c-mode-linux)
;(add-hook 'c-mode-common-hook 'c-mode-qemu)

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

(require 'open-resource)
(global-set-key "\C-\M-r" 'open-resource)

(setq open-resource-repository-directory "~/work/")
(setq open-resource-ignore-patterns (quote ("/target/" "~$" ".old$")))

;; Customizing colors used in diff mode
(defun custom-diff-colors ()
  "update the colors for diff faces"
  (set-face-attribute
   'diff-added nil :foreground "SeaGreen")
  (set-face-attribute
   'diff-removed nil :foreground "Red")
  (set-face-attribute
   'diff-hunk-header nil :foreground "purple")
  (set-face-attribute
   'diff-file-header nil :foreground "MediumBlue")
  (set-face-attribute
   'diff-header nil :foreground "purple"))
(eval-after-load "diff-mode" '(custom-diff-colors))

(setq large-file-warning-threshold 20000000)

;; global keybindings:
;; http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

;; shortcuts for navigating windows and buffers, optimized for dvorak layout :)
(define-key my-keys-minor-mode-map (kbd "M-o") 'other-window)
(define-key my-keys-minor-mode-map (kbd "M-k") 'delete-other-windows)
(define-key my-keys-minor-mode-map (kbd "M-e") 'ibuffer)
(define-key my-keys-minor-mode-map (kbd "M-n") 'next-buffer)
(define-key my-keys-minor-mode-map (kbd "M-p") 'previous-buffer)
(define-key my-keys-minor-mode-map (kbd "C-x C-b") 'ibuffer)

;; other shortcuts useful for programming
(define-key my-keys-minor-mode-map (kbd "M-c") 'compile)
(define-key my-keys-minor-mode-map (kbd "M-g") 'goto-line)
(define-key my-keys-minor-mode-map (kbd "M-r") 'rgrep)
(define-key my-keys-minor-mode-map (kbd "M-q") 'fill-paragraph)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

;; shell scripts indentation
(setq sh-basic-offset 8
      sh-indentation 8)
(setq-default sh-indent-for-case-label 0)
(setq-default sh-indent-for-case-alt '+)
