(require 'auto-complete)

;; setup pymacs
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)

;; (defvar ac-ropemacs-loaded nil)
;; (defun ac-ropemacs-require ()
;;   (unless ac-ropemacs-loaded
;;     ;; Almost all people hate rope to use `C-x p'.
;;     (if (not (boundp 'ropemacs-global-prefix))
;;         (setq ropemacs-global-prefix nil))
;;     (pymacs-load "ropemacs" "rope-")
;;     (setq ropemacs-enable-autoimport t)
;;     (setq ac-ropemacs-loaded t)
;;     ;; ido initialization
;;     (require 'ido)
;;     (ido-init-completion-maps)
;;     (add-hook 'minibuffer-setup-hook 'ido-minibuffer-setup)
;;     (add-hook 'choose-completion-string-functions 'ido-choose-completion-string)
;;     (add-hook 'kill-emacs-hook 'ido-kill-emacs-hook)
;;     ;; new key binding
;;     (define-key ropemacs-local-keymap (kbd "C-c j") 'rope-jump-to-global)
;;     ))

;; (defvar ac-ropemacs-completions-cache nil)

;; (defvar ac-source-ropemacs
;;   '((init
;;      . (lambda ()
;;          (setq ac-ropemacs-completions-cache
;;                (mapcar
;;                 (lambda (completion)
;;                   (concat ac-prefix completion))
;;                 (ignore-errors
;;                   (rope-completions))))))
;;     (candidates . (lambda ()
;;                     (all-completions ac-prefix ac-ropemacs-completions-cache)))))

;; (defun ac-ropemacs-setup ()
;;   (ac-ropemacs-require)
;;   ;(setq ac-sources (append (list 'ac-source-ropemacs) ac-sources))
;;   (setq ac-omni-completion-sources '(("\\." ac-source-ropemacs)))
;;   (ropemacs-mode 1))

;; (defun ac-ropemacs-init ()
;;   (add-hook 'python-mode-hook 'ac-ropemacs-setup))

;; ropemacs Integration with auto-completion


(defun setup-ropemacs ()
  "Setup the ropemacs harness"
  (pymacs-load "ropemacs" "rope-")
  
  ;; Stops from erroring if there's a syntax err
  (setq ropemacs-codeassist-maxfixes 3)
  (setq ropemacs-guess-project t)
  (setq ropemacs-enable-autoimport t))


(defun ac-ropemacs-candidates ()
  (mapcar (lambda (completion)
            (concat ac-prefix completion))
          (rope-completions)))

(ac-define-source nropemacs
  '((candidates . ac-ropemacs-candidates)
    (symbol     . "p")))

(ac-define-source nropemacs-dot
  '((candidates . ac-ropemacs-candidates)
    (symbol     . "p")
    (prefix     . c-dot)
    (requires   . 0)))

(defun ac-nropemacs-setup ()
  (setq ac-sources (append '(ac-source-nropemacs
                             ac-source-nropemacs-dot) ac-sources)))
;;(defun ac-python-mode-setup ()
;;  (add-to-list 'ac-sources 'ac-source-yasnippet))

;(add-hook 'python-mode-hook 'ac-python-mode-setup)
(add-hook 'rope-open-project-hook 'ac-nropemacs-setup)


(provide 'auto-complete-python)