;; https://github.com/Guilherme-Vasconcelos/dot-emacs
;; https://github.com/Guilherme-Vasconcelos/dot-emacs/blob/master/LICENSE

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(network-security-level 'paranoid)
 '(package-selected-packages '(slime flycheck neotree chess)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Init commands
(windmove-default-keybindings) ; shortcuts for moving windows
(menu-bar-mode -1) ; visual stuff (same for toggle-scroll and tool-bar)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(global-linum-mode t) ; display lines
(electric-pair-mode)

;; Emacs variables
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq require-final-newline t)
(setq-default show-trailing-whitespace t)
(setq-default indent-tabs-mode nil)

;; -=-=- Packages configurations -=-=-

;; Packages sources
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Packages to install
(defvar package-list
      '(neotree atom-one-dark-theme which-key centaur-tabs company
		projectile-rails ace-window multiple-cursors inf-ruby
		rainbow-delimiters slim-mode magit flycheck hl-todo
		dtrt-indent ivy slime projectile move-text
		indent-guide ws-butler))

(package-initialize)

;; Fetch list of available packages
(unless package-archive-contents
  (package-refresh-contents))

;; Install missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package nil)))

;; -=-=- Packages settings -=-=-
;; neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme 'nerd)

;; atom-one-dark-theme
(load-theme 'atom-one-dark t)

;; which-key
(require 'which-key)
(which-key-mode)

;; centaur-tabs
(require 'centaur-tabs)
(centaur-tabs-mode t)
(global-set-key (kbd "C-c <C-left>") 'centaur-tabs-backward)
(global-set-key (kbd "C-c <C-right>") 'centaur-tabs-forward)
(setq centaur-tabs-style "wave"
      centaur-tabs-height 32
      centaur-tabs-set-icons t
      centaur-tabs-set-modified-marker t
      centaur-tabs-show-navigation-buttons t
      centaur-tabs-set-bar 'under
      x-underline-at-descent-line t)
(centaur-tabs-headline-match)
(setq centaur-tabs-label-fixed-length 12)

;; company
(add-hook 'after-init-hook 'global-company-mode)

;; projectile-rails
(projectile-rails-global-mode)
(define-key projectile-rails-mode-map (kbd "C-c r") 'projectile-rails-command-map)
(add-hook 'after-init-hook 'inf-ruby-switch-setup)

;; projectile
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(dolist (dir-to-ignore '("node_modules" "log" "storage" "db" "tmp" "bin" "public"))
  (unless (member dir-to-ignore projectile-globally-ignored-directories)
    (add-to-list 'projectile-globally-ignored-directories dir-to-ignore)))

;; ace-window
(global-set-key (kbd "M-o") 'ace-window)

;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-s C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; slim-mode
(require 'slim-mode)

;; flycheck
;; may need to install system dependencies depending on which language
;; I am working with. e.g.: eslint, pylint etc.
(add-hook 'after-init-hook #'global-flycheck-mode)

;; hl-todo
(global-hl-todo-mode)

;; dtrt-indent
(dtrt-indent-global-mode)

;; ivy
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

;; slime
;; need to install corresponding compiler / interpreter
(setq inferior-lisp-program "clisp")

;; move-text
(require 'move-text)
(move-text-default-bindings)

;; indent-guide
(require 'indent-guide)
(indent-guide-global-mode)

;; ws-butler
(require 'ws-butler)
(add-hook 'prog-mode-hook #'ws-butler-mode)

;; -=-=- Misc -=-=-

;; Custom functions, hooks and advices

(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
	(make-directory dir t)))))

(defadvice projectile-rails-server (after run-webpack-dev-server (&rest _args) activate)
  "Run webpack-dev-server after a rails server has been run."
  (async-shell-command (concat (projectile-rails-root) "bin/webpack-dev-server")))

(defun eslint-fix-file-and-revert ()
  "Fix a JavaScript file with eslint and then revert the buffer."
  (interactive)
  (when (eq major-mode 'js-mode)
    (progn
      (shell-command (concat "eslint --fix " (buffer-file-name)))
      (revert-buffer t t))))

(add-hook 'js-mode-hook
	  (lambda ()
	    (add-hook 'after-save-hook 'eslint-fix-file-and-revert)))
