;; Add local dir
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-1.3.1/")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen t)
 '(show-paren-mode t)
 ;;'(xterm-mouse-mode t)
)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(flymake-errline ((((class color)) (:background "black" :foreground "purple")))) 
 '(flymake-warnline ((((class color)) (:background "LightBlue2" :foreground "black")))) 
 )

;; Never use tabs
(setq-default indent-tabs-mode nil)

;; Show white space
(require 'show-wspace)
;;(add-hook 'python-mode-hook 'highlight-tabs)
;;(add-hook 'font-lock-mode-hook 'highlight-trailing-whitespace)

;; Put column number in the bar
(setq column-number-mode t)

;; Latex
(set-variable (quote latex-run-command) "pdflatex")
(defun tex-view ()
  (interactive)
  (tex-send-command "evince" (tex-append tex-print-file ".pdf")))

;; Speling
;;(setq flyspell-issue-welcome-flag nil)
;;(defun activate-flyspell () 
;;  "Turn on flyspell-mode and call flyspell-buffer." 
;;  (interactive) 
;;  ;; This next line REALLY slows buffer switching. 
;;  (flyspell-mode) 
;;  (flyspell-buffer))

;;(dolist (hook '(latex-mode-hook))
;;      (add-hook hook (lambda () (activate-flyspell))))

;; From here http://www.rwdev.eu/articles/emacspyeng
;;(require 'pycomplete)
;;(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;;(autoload 'python-mode "python-mode" "Python editing mode." t)
;;(autoload 'pymacs-load "pymacs" nil t)
;;(autoload 'pymacs-eval "pymacs" nil t)
;;(autoload 'pymacs-apply "pymacs")
;;(autoload 'pymacs-call "pymacs")
;;(setq interpreter-mode-alist(cons '("python" . python-mode)
;;                                  interpreter-mode-alist))

;; Yasnippet
(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")


;; Ropemacs (from http://stackoverflow.com/questions/2855378/ropemacs-usage-tutorial)
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(require 'python-mode)

(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

;;(require 'auto-complete)
;;(global-auto-complete-mode t)
;;(add-hook 'rope-open-project-hook 'ac-nropemacs-setup)


;; Indent
(setq-default c-basic-offset 4)

;; Default styles
(setq c-default-style
      '((other . "k&r")))


;;(require 'color-theme)
;;(color-theme-midnight)

;; No Toolbar
(tool-bar-mode -1)

;; Paren Match Pretty
(require 'paren)
(set-face-background 'show-paren-match-face (face-background 'default))
(set-face-foreground 'show-paren-match-face "#def")
(set-face-attribute 'show-paren-match-face nil :weight 'extra-bold)


;; Python Flymake
(defun flymake-create-temp-intemp (file-name prefix)
  "Return file name in temporary directory for checking FILE-NAME.
This is a replacement for `flymake-create-temp-inplace'. The
difference is that it gives a file name in
`temporary-file-directory' instead of the same directory as
FILE-NAME.

For the use of PREFIX see that function.

Note that not making the temporary file in another directory
\(like here) will not if the file you are checking depends on
relative paths to other files \(for the type of checks flymake
makes)."
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (let* ((name (concat
                (file-name-nondirectory
                 (file-name-sans-extension file-name))
                "_" prefix))
         (ext  (concat "." (file-name-extension file-name)))
         (temp-name (make-temp-file name nil ext))
         )
    (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
    temp-name))

(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-intemp))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "~/.emacs.d/epylint_brandyn"  (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-pyflakes-init)))
(load-library "flymake-cursor")
(add-hook 'find-file-hook 'flymake-find-file-hook)
(setq flymake-no-changes-timeout 99999999)


;; Git
;;(require 'git)

;; Cython
(require 'cython-mode)

;; Coq
(global-set-key (kbd "C-c C-j") 'proof-goto-point)

;; Column Marker
;;(require 'column-marker)
;;(add-hook 'font-lock-mode-hook (lambda () (interactive) (column-marker-1 80)))

;; Enable Restructued Text Editing
(require 'rst)
(add-hook 'text-mode-hook 'rst-text-mode-bindings)

;; Shell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(setq comint-prompt-read-only t)

;; iPython
;;(require 'ipython)
 (require 'anything-ipython)                                                                                                                                 
;;(define-key py-mode-map "\t" 'anything-ipython-complete)                                                                                         
(define-key py-shell-map "\t" 'anything-ipython-complete)                                                                                        
(define-key py-mode-map (kbd "C-c M") 'anything-ipython-import-modules-from-buffer)
(require 'anything-show-completion)
