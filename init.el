;; styling
(menu-bar-mode -1)
(setq inhibit-startup-screen t)
(setq frame-title-format "%b ; %f")

(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-default-font "Tamsyn-11")
(setq default-frame-alist '((font . "Tamsyn-11")
			    (vertical-scroll-bars . nil)))

(set-fontset-font "fontset-default" 'unicode "Siji")

(set-face-attribute 'vertical-border nil :foreground "#b0b0b0")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'base16-default t)
(global-visual-line-mode 1)

(desktop-save-mode 1)
(server-start)

;; elpa
(require 'package)
(add-to-list 'package-archives
                           '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
              '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'load-path "~/.emacs.d/lisp")

(setq package-list
    '(f use-package markdown-mode nix-mode magit haskell-mode))

; activate all the packages
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


(require 'misc)

;; temporary files
(setq
   backup-by-copying t      ; don't clobber symlinks
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(setq backup-directory-alist
`((".*" . "~/scratch/")))
(setq auto-save-file-name-transforms
          `((".*" "~/scratch" t)))

(setq-default fill-column 80)
(add-hook 'text-mode-hook 'auto-fill-mode)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")



;; email
(require 'f)
(let ((mu4epath
       (concat
        (f-dirname
         (file-truename
          (executable-find "mu")))
        "/../share/emacs/site-lisp/mu4e")))
  (when (and
         (string-prefix-p "/nix/store/" mu4epath)
         (file-directory-p mu4epath))
    (add-to-list 'load-path mu4epath)))

(require 'mu4e)

(setq mu4e-maildir "~/mail"
      user-mail-address "robb@rs.io"
      smtpmail-default-server "mercury.rs.io"
      smtpmail-smtp-service 587)

;; Now I set a list of 
(defvar my-mu4e-account-alist
  '(("rs.io"
     (user-mail-address "robb@rs.io")
     (user-full-name "robb")
     (mu4e-sent-folder "/rs.io/Sent")
     (mu4e-drafts-folder "/rs.io/Drafts")
     (user-mail-address "robb@rs.io")
     (smtpmail-smtp-user "robb@rs.io")
     (smtpmail-local-domain "rs.io")
     (smtpmail-default-smtp-server "mercury.rs.io")
     (smtpmail-smtp-server "mercury.rs.io")
     (smtpmail-smtp-service 587)
     )
    ("99theses"
     (user-mail-address "robert@99theses.com")
     (user-full-name "robert")
     (mu4e-sent-folder "/99theses/Sent")
     (mu4e-drafts-folder "/99theses/Drafts")
     (user-mail-address "robert@99theses.com")
     (smtpmail-smtp-user "robert@99theses.com")
     (smtpmail-local-domain "99theses.com")
     (smtpmail-default-smtp-server "mercury.rs.io")
     (smtpmail-smtp-server "mercury.rs.io")
     (smtpmail-smtp-service 587)
     )
     ;; Include any other accounts here ...
    ))

(setq mu4e-contexts
    `( ,(make-mu4e-context
         :name "rs.io"
         :match-func (lambda (msg) (when msg (mu4e-message-contact-field-matches msg :to "robb@rs.io")))
         :vars '((user-mail-address . "robb@rs.io")
		 (user-full-name . "robb")
		 (mu4e-sent-folder . "/rs.io/Sent")
		 (mu4e-drafts-folder . "/rs.io/Drafts")
		 (user-mail-address . "robb@rs.io")
		 (smtpmail-smtp-user . "robb@rs.io")
		 (smtpmail-local-domain . "rs.io")
		 (smtpmail-default-smtp-server . "mercury.rs.io")
		 (smtpmail-smtp-server . "mercury.rs.io")
		 (smtpmail-smtp-service . 587)))
       ,(make-mu4e-context
         :name "99theses"
         :match-func (lambda (msg) (when msg (mu4e-message-contact-field-matches msg :to "robert@99theses.com")))
         :vars '((user-mail-address . "robert@99theses.com")
		 (user-full-name . "robert")
		 (mu4e-sent-folder . "/99theses/Sent")
		 (mu4e-drafts-folder . "/99theses/Drafts")
		 (user-mail-address . "robert@99theses.com")
		 (smtpmail-smtp-user . "robert@99theses.com")
		 (smtpmail-local-domain . "99theses.com")
		 (smtpmail-default-smtp-server . "mercury.rs.io")
		 (smtpmail-smtp-server . "mercury.rs.io")
		 (smtpmail-smtp-service . 587)))))

;; org-mode
(require 'org-protocol)
(add-hook 'org-mode-hook 'turn-on-flyspell)
(add-hook 'flyspell-mode-hook 'flyspell-buffer)
(setq org-agenda-files (list "~/org"))
(setq org-log-done t)
(setq org-agenda-todo-ignore-scheduled t)
(setq org-agenda-log-mode t)
(setq org-default-notes-file "~/org/inbox.org")
(setq org-startup-indented t)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-span 1)
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 5))))
(setq org-enforce-todo-dependencies t)
(setq org-agenda-dim-blocked-tasks 'invisible)

(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'agenda))

;; save org files when TODO state changes so that files will be propagated to jupiter. 
(defmacro η (fnc)
  "Return function that ignores its arguments and invokes FNC."
  `(lambda (&rest _rest)
     (funcall ,fnc)))

(advice-add 'org-deadline       :after (η #'org-save-all-org-buffers))
(advice-add 'org-schedule       :after (η #'org-save-all-org-buffers))
(advice-add 'org-store-log-note :after (η #'org-save-all-org-buffers))
(advice-add 'org-todo           :after (η #'org-save-all-org-buffers))

;; open a capture frame from xmonad
(defadvice org-capture-finalize 
    (after delete-capture-frame activate)  
  "Advise capture-finalize to close the frame"  
  (if (equal "capture" (frame-parameter nil 'name))  
    (delete-frame)))

(defadvice org-capture-destroy 
    (after delete-capture-frame activate)  
  "Advise capture-destroy to close the frame"  
  (if (equal "capture" (frame-parameter nil 'name))  
    (delete-frame)))

(use-package noflet
  :ensure t)

(defun make-capture-todo-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")))
  (select-frame-by-name "capture")
  (delete-other-windows)
  (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
    (org-capture nil "t")))

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))

(defadvice org-capture-destroy
    (after delete-capture-frame activate)
  "Advise capture-destroy to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))

(add-hook 'org-capture-mode-hook
          'delete-other-windows)

(defadvice org-switch-to-buffer-other-window
  (after supress-window-splitting activate)
  "Delete the extra window if we're in a capture frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-other-windows)))

(defun make-capture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")))
  (select-frame-by-name "capture")
  (delete-other-windows)
  (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
    (org-capture)))

(defun make-agenda-frame ()
  "Create a new frame and run org-agenda."
  (interactive)
  (make-frame '((name . "todo-list")))
  (select-frame-by-name "todo-list")
  (delete-other-windows)
  (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
    (org-todo-list)))


;; wtf
(defun my-after-load-org ()
  (add-to-list 'org-modules 'org-habit)
  (add-to-list 'org-modules 'org-checklist))
(eval-after-load "org" '(my-after-load-org))
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks") "* TODO %?\n")
	("l" "Links" plain (file+headline "~/org/pub/links.org" "Links") "- [[%:link][%?]]\n")
	("w" "Web quote" plain (file+headline "~/org/pub/links.org" "Links") "- [[%:link][\"%i\"]] %?\n")
	("n" "Nut" entry (file+headline "~/org/nuts.org" "Web") "* [[%:link][\"%i\"]] %? %^g\n")
	("p" "PDF clipping" entry (file+headline "~/org/nuts.org" "PDFs") "* %(replace-regexp-in-string \"\n$\" \"\" (shell-command-to-string \"xdotool getwindowfocus getwindowname\")) %^g\n#+BEGIN_QUOTE\n%(shell-command-to-string \"xclip -o\")\n#+END_QUOTE\n")
	("m" "Meditation log" entry (file+headline "~/org/99theses.org" "Personal: Meditation Log") "* %T\n%?\n** Intentions\n\n** Reflection & Noticings\n\n" :clock-in t)
	("r" "Writing research" entry (file+headline "~/org/research.org" "Research") "* %?\n")
	("f" "Freeform writing" plain (file "~/org/freewrite.org") "* %t:\n\n %? \n\n----\n\n")
	("g" "Goals" plain (file+headline "~/org/goals.org" "Long") "* %t:\n\n %? \n\n----\n\n")
	("b" "Bucket List" entry (file+headline "~/org/someday.org" "Bucket List") "* %?\n")
	("u" "Ughs" plain (file "~/org/ugh.org") "%t: %? \n\n----\n\n")))

(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs" ((agenda "") (alltodo "")))
	("c" "creep" tags-todo "+creep")
	("d" "de"    tags-todo "+de")))

(setq org-todo-keywords
      '((type "TODO(t)" "BLOCKED(b)" "GOAL(g)" "|" "DONE(d)")))

(global-auto-revert-mode t)

(setq org-log-done 'time)

(require 'ox-publish)
(setq org-publish-project-alist
      '(
	("org-notes"
 :base-directory "~/org/pub"
 :base-extension "org"
 :publishing-directory "~/pub/"
 :recursive t
 :publishing-function org-html-publish-to-html
 :headline-levels 4             ; Just the default for this project.
 :auto-preamble t
 :auto-sitemap t
 :style "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />"
 :sitemap-filename "index.org" 
 :sitemap-title "rs.io" 
 )
	("org-static"
 :base-directory "~/org/pub/"
 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
 :publishing-directory "~/pub/"
 :recursive t
 :publishing-function org-publish-attachment
 )
("org" :components ("org-notes" "org-static"))
))

(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cr" 'org-remember)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

(setq org-extend-today-until 4)

;; man page hooks
;; (add-hook 'Man-mode-hook 'delete-other-windows)

;; markdown
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; global keybinds
(global-set-key "\C-z" 'undo)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-x\C-k" 'kill-region)
(global-unset-key [drag-mouse-1])
(global-unset-key [down-mouse-1])
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key "\C-cn" 'mc/mark-next-like-this)
(global-set-key "\C-cf" 'line-to-clipboard)
(global-set-key (kbd "RET") 'reindent-then-newline-and-indent)
(global-set-key "\C-cw" 'wc)
(put 'narrow-to-region 'disabled nil)
(global-set-key (kbd "\C-c \C-s") 'bs-eshell-switch-to-and-change-dir)
(global-set-key "\C-ch" 'hoogle)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/org/todo.org")))
 '(package-selected-packages
   (quote
    (noflet use-package sicp smooth-scrolling weechat fish-mode magit dumb-jump beeminder haskell-mode yasnippet yari wc-mode sml-mode smartparens slime sass-mode rvm ruby-tools rubocop rainbow-mode quack project-mode php-mode paredit org2blog nrepl markdown-mode magithub langtool inf-ruby helm ghc geiser flymake-easy dired+ color-theme)))
 '(quack-programs
   (quote
    ("mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi")))
 '(send-mail-function (quote smtpmail-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(put 'downcase-region 'disabled nil)
