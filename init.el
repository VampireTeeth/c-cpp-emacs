; start package.el with emacs
(require 'package)
; add MELPA to repository list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;initialize package.el
(package-initialize)


;installing a list of packages
(require 'cl)
(defvar prelude-packages
  ;;'(ack-and-a-half auctex clojure-mode coffee-mode deft expand-region
  ;;                 gist groovy-mode haml-mode haskell-mode inf-ruby
  ;;                 magit magithub markdown-mode paredit projectile python
  ;;                 sass-mode rainbow-mode scss-mode solarized-theme
  ;;                 volatile-highlights yaml-mode yari zenburn-theme)
  '(auto-complete yasnippet evil auto-complete-c-headers
		  flymake-google-cpplint helm autopair
		  highlight-parentheses ace-window auto-complete-clang
		  paredit iedit zenburn-theme)
  "A list of packages to ensure are installed at launch.")

(defun prelude-packages-installed-p ()
  (loop for p in prelude-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(unless (prelude-packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs Prelude is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p prelude-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;load the wombat theme
(load-theme 'wombat)

;start auto-complete with emacs
(require 'auto-complete)
;do default config for auto-complete
(require 'auto-complete-config)
(ac-config-default)


;start yasnippet with emacs
(require 'yasnippet)
(yas-global-mode 1)

;start evil-mode with emacs
(require 'evil)
(evil-mode 1)

;let's define a function which initializes auto-complete-c-headers
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/usr/include/c++/4.8"))

;add hooks for c/c++ mode to use auto-complete-c-headers
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;iedit configuration
(define-key global-map (kbd "C-c ;") 'iedit-mode)

;start flymake-google-cpplint-load
(defun my:flymake-google-init ()
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
  (flymake-google-cpplint-load))

;;(add-hook 'c++-mode-hook 'my:flymake-google-init)
;;(add-hook 'c-mode-hook 'my:flymake-google-init)

;helm-config configuration
(require 'helm-config)
(helm-mode 1)

;autopair configuration
(require 'autopair)
(add-hook 'prog-mode-hook 'autopair-mode)

;highlight parenthesis configuration
(require 'highlight-parentheses)
(global-highlight-parentheses-mode 1)
;;(add-hook 'prog-mode-hook 'highlight-parentheses-mode)


;Turn on Semantics (CEDET)
(semantic-mode 1)
;Let's define a function which adds semantic as a suggestion backend to auto complete
(defun my:add-semantic-to-autocomplete ()
  (add-to-list 'ac-sources 'ac-source-semantic))
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)


;ace-window config
(global-set-key (kbd "M-p") 'ace-window)

;start auto-complete-clang with emacs
(add-to-list 'ac-dictionary-directories (concat (getenv "HOME") "/.emacs.d/ac-dict"))
(require 'auto-complete-clang)
(setq ac-auto-start nil)
(setq ac-quick-help-delay 0.5)
;; (ac-set-trigger-key "TAB")
;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
(define-key ac-mode-map  [(control tab)] 'auto-complete)
(defun my:ac-config ()
  (add-to-list 'ac-sources 'ac-source-abbrev)
  (add-to-list 'ac-sources 'ac-source-dictionary)
  (add-to-list 'ac-sources 'ac-source-words-in-same-mode-buffers)
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
  (add-hook 'css-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(defun my:ac-cc-mode-setup ()
  (add-to-list 'ac-sources 'ac-source-clang)
  (add-to-list 'ac-sources 'ac-source-yasnippet))

(add-hook 'c-mode-common-hook 'my:ac-cc-mode-setup)
;; ac-source-gtags
(my:ac-config)

(setq ac-clang-flags
      (mapcar (lambda (item) (concat "-I" item))
	      (split-string
	       "
 /usr/include/c++/4.8
 /usr/include/x86_64-linux-gnu/c++/4.8
 /usr/include/c++/4.8/backward
 /usr/lib/gcc/x86_64-linux-gnu/4.8/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
")))

;misc configs
(setq make-backup-files nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
