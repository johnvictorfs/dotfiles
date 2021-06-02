;; https://github.com/Guilherme-Vasconcelos/dot-emacs
;; https://github.com/Guilherme-Vasconcelos/dot-emacs/blob/94ed0587cde4bfddfad24132ea509b24fefde5d8/LICENSE

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

;; Automatically install packages:
;; https://stackoverflow.com/questions/10092322/how-to-automatically-install-emacs-packages-by-specifying-a-list-of-package-name

;; Packages sources
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Packages to install
(defvar package-list
      '(neotree atom-one-dark-theme which-key centaur-tabs company
		projectile-rails ace-window multiple-cursors inf-ruby
		rainbow-delimiters slim-mode magit flycheck hl-todo
		dtrt-indent ivy slime projectile move-text
		indent-guide ws-butler golden-ratio diminish
                typescript-mode))

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
;; atom-one-dark-theme
(defvar atom-one-dark-colors-alist
  (let* ((256color  (eq (display-color-cells (selected-frame)) 256))
         (colors `(("atom-one-dark-accent"   . "#528BFF")
                   ("atom-one-dark-fg"       . (if ,256color "color-248" "#ABB2BF"))
                   ("atom-one-dark-bg"       . (if ,256color "color-235" "#192330"))
                   ("atom-one-dark-bg-1"     . (if ,256color "color-234" "#121417"))
                   ("atom-one-dark-bg-hl"    . (if ,256color "color-236" "#2C323C"))
                   ("atom-one-dark-gutter"   . (if ,256color "color-239" "#4B5363"))
                   ("atom-one-dark-mono-1"   . (if ,256color "color-248" "#ABB2BF"))
                   ("atom-one-dark-mono-2"   . (if ,256color "color-244" "#828997"))
                   ("atom-one-dark-mono-3"   . (if ,256color "color-240" "#5C6370"))
                   ("atom-one-dark-cyan"     . "#56B6C2")
                   ("atom-one-dark-blue"     . "#61AFEF")
                   ("atom-one-dark-purple"   . "#C678DD")
                   ("atom-one-dark-green"    . "#98C379")
                   ("atom-one-dark-red-1"    . "#E06C75")
                   ("atom-one-dark-red-2"    . "#BE5046")
                   ("atom-one-dark-orange-1" . "#D19A66")
                   ("atom-one-dark-orange-2" . "#E5C07B")
                   ("atom-one-dark-gray"     . (if ,256color "color-237" "#3E4451"))
                   ("atom-one-dark-silver"   . (if ,256color "color-247" "#9DA5B4"))
                   ("atom-one-dark-black"    . (if ,256color "color-233" "#21252B"))
                   ("atom-one-dark-border"   . (if ,256color "color-232" "#181A1F")))))
    colors)
  "List of Atom One Dark colors.")
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
;; ATTENTION: may need to install system dependencies depending on which language
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
;; ATTENTION: need to install corresponding compiler / interpreter
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

;; golden-ratio
(require 'golden-ratio)
(golden-ratio-mode 1)

;; diminish
(require 'diminish)
(dolist (mode-to-diminish '(golden-ratio-mode ws-butler-mode rainbow-delimiters-mode
                                              centaur-tabs-mode indent-guide-mode
                                              which-key-mode))
  (when (boundp mode-to-diminish)
    (diminish mode-to-diminish)))

;; typescript-mode
(add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode))

;; -=-=- Misc -=-=-

;; Custom functions, hooks and advices

;; https://superuser.com/questions/131538/can-i-create-directories-that-dont-exist-while-creating-a-new-file-in-emacs
(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
	(make-directory dir t)))))

(defadvice projectile-rails-server (after run-webpack-dev-server (&rest _args) activate)
  "Run webpack-dev-server after a rails server has been run."
  (async-shell-command (concat (projectile-rails-root) "bin/webpack-dev-server")))

;; Adapted from: https://gist.github.com/ustun/73321bfcb01a8657e5b8
(defun eslint-fix-file-and-revert ()
  "Fix a JavaScript file with eslint and then revert the buffer."
  (interactive)
  (when (eq major-mode 'js-mode)
    (progn
      (shell-command (concat "eslint --fix " (buffer-file-name)))
      (revert-buffer t t)
      (when (package-installed-p 'centaur-tabs)  ;; FIXME: Temporary solution. Find out why centaur-tabs is not unmarking the buffer as modified.
        (centaur-tabs-after-modifying-buffer)))))

(add-hook 'js-mode-hook
	  (lambda ()
	    (add-hook 'after-save-hook #'eslint-fix-file-and-revert)))

(defun open-init-emacs-file ()
  "Open the Emacs init file."
  (interactive)
  (find-file user-init-file))

(global-set-key (kbd "C-c C-e") #'open-init-emacs-file)

;; Adapted from 'delete-trailing-whitespace', which can be found at 'simple.el'
(defun delete-trailing-lines-prog-mode ()
  "Delete trailing lines in the end of buffer when using 'prog-mode'."
  (save-match-data
    (save-excursion
      (and
       (derived-mode-p 'prog-mode)
       (= (goto-char (point-max)) (1+ (buffer-size)))
       (<= (skip-chars-backward "\n") -2)
       (region-modifiable-p (1+ (point)) (point-max))
       (delete-region (1+ (point)) (point-max))))))

(add-hook 'before-save-hook #'delete-trailing-lines-prog-mode)
