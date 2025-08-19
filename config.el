;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)
;;(custom-theme-set-faces! 'doom-gruvbox
;;  '(default :background "#27232b")
;;  )
(add-to-list 'default-frame-alist '(background-color . "#27232b"))

(set-background-color "#27232b")
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;; Packages
(require 'org-roam-export)
(require 'org-id)
(require 'org-journal)
(require 'org-appear)
(require 'nyan-mode)
(require 'lsp-mode)
;;(require 'org-download)

(add-to-list 'load-path "~/scripts/emacs/qml-ts-mode/")
(require 'qml-ts-mode)
(use-package qml-ts-mode
  :after lsp-mode
  :config
  (add-to-list 'lsp-language-id-configuration '(qml-ts-mode . "qml-ts"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("qmlls"))
                    :activation-fn (lsp-activate-on "qml-ts")
                    :server-id 'qmlls))
  (add-hook 'qml-ts-mode-hook (lambda ()
                                (setq-local electric-indent-chars '(?\n ?\( ?\) ?{ ?} ?\[ ?\] ?\; ?,))
                                (lsp-deferred))))

(add-hook 'qml-ts-mode-hook 'smartparens-mode)


;;; Setup to allow me to toggle titlebar.
;;; Unsure if this works on MacOS.
(defvar titlebar-hidden nil
  "Whether the titlebar is hidden or not.
Any value means that the titlebar is hidden.
Used for the function `toggle-titlebar'.")

(defun toggle-titlebar()
  "Toggle the title bar.
Uses the variable `titlebar-hidden'.
Works by using `set-frame-parameter' on the `undecorated' tag."
  (interactive)
  (setq titlebar-hidden (not titlebar-hidden))
  (set-frame-parameter nil 'undecorated titlebar-hidden))

;;; Easy access to config files
(map! :leader
      (:prefix-map ("d" . "Custom Keybinds")
                   :desc "Doom Directory" "d" #'find-file("~/.config/doom/")
                   :desc "Doom Config" "c" (lambda () (interactive) (find-file "~/.config/doom/config.el"))
                   :desc "Doom Init" "i" (lambda () (interactive) (find-file "~/.config/doom/init.el"))
                   :desc "Reload Config" "r" (lambda () (interactive) (load-file "~/.config/doom/config.el"))
                   :desc "Doom Packages" "p" (lambda () (interactive) (find-file "~/.config/doom/packages.el"))
                   :desc "Toggle Titlebar" "t" (lambda () (interactive) (toggle-titlebar))
                   :desc "Org Home" "h" (lambda () (interactive)(find-file "~/org/home.org"))
                   :desc "What is this thing?" "l" #'lsp-describe-thing-at-point
                   :desc "Hide Properties" "o" (lambda() (interactive) (org-cycle-hide-drawers 'all))

      )
      (:prefix-map ("e" . "EMMS")
                   :desc "Play/Pause" "p" #'emms-pause
                   :desc "Back" "<" #'emms-previous
                   :desc "Next" ">" #'emms-next
                   )
      (:prefix-map ("#" . "EMMS")
                   :desc "Play/Pause" "#" #'emms-pause
                   :desc "Back" "'" #'emms-previous
                   :desc "Next" "RET" #'emms-next
                   :desc "Shuffle" "s" #'emms-shuffle
                   :desc "Unshuffle" "u" #'emms-playlist-sort-by-info-albumartist
                  )
)

;;; lsp-mode shortcuts
(map! :after lsp-mode
      :localleader
      :map lsp-mode-map
      :prefix ("l" : "lsp-mode")
      :desc "Describe thing at point" :n "l" #'lsp-describe-thing-at-point
)

;;; org-mode setup

;; create shortcuts
(map! :localleader
      :map org-mode-map
      :prefix ("m" : "roam")
      :desc "Create Link" "l" #'org-roam-node-insert
      :desc "Create Node" "n" #'org-roam-node-insert
      :desc "Go Back" "b" #'org-mark-ring-goto
      :desc "Find Node" "f" #'org-roam-node-find
      :desc "Toggle Roam Buffer" "o" #'org-roam-buffer-toggle

      :prefix ("a" : "+attachments")
      :desc "Paste image from clipboard" "p" #'yank-media
      )

;; setup capture templates for org-roam
(setq org-roam-capture-templates
      '(("d" "default" plain
         "%?"
         :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
         :unarrowed t)))

;; change settings for org-appear
(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-trigger 'always)

  (setq org-hide-emphasis-markers t)
  (setq org-appear-autoemphasis t)

  (setq org-link-descriptive t)
  (setq org-appear-autolinks t)

  (setq org-pretty-entities t)
  (setq org-appear-autoentities t)
  (setq org-appear-autosubmarkers t)

  (setq org-hidden-keywords t)
  (setq org-appear-autokeywords t)

  (setq org-appear-inside-latex t)
)

;; enable nyan-mode
(use-package! nyan-mode
  :hook (org-mode . nyan-mode))

;; enable org-fragtog
(use-package! org-fragtog
  :hook (org-mode . org-fragtog-mode))

;; org-roam setup
(setq org-roam-directory (file-truename "~/org"))
(org-roam-db-autosync-mode)
(use-package! org-appear
  )

;; display images as soon as i open an org-mode file
(add-hook 'org-mode-hook (lambda () (org-display-inline-images)))


;;; org-mode setup over


;;; emms setup
(emms-all)
(setq emms-info-functions '(emms-info-native emms-info-metaflac))
(setq emms-player-list '(emms-player-vlc emms-player-mpg321))
(emms-add-directory-tree "~/Music")
(setq emms-browser-covers 'emms-browser-cache-thumbnail)



(setq source-directory "/usr/share/emacs/30.1")

;;; Old version of toggle-titlebar
;; (defun hide-titlebar ()
;;   "Hide title bar from frame."
;;   (interactive)
;;   (set-frame-parameter nil 'undecorated t)
;;   (setq line-number-mode nil))
;;
;; (defun show-titlebar ()
;;   "Show title bar in frame."
;;   (interactive)
;;   (set-frame-parameter nil 'undecorated nil)
;;   (setq line-number-mode t))

;; Really weird error where backspacing the final char of a line freezes emacs.
;; This is supposed to fix it.
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; set transparency
(set-frame-parameter (selected-frame) 'alpha  '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

;;(after! org-download
;;  (setq org-download-method 'directory)
;;  (setq org-download-image-dir (concat (file-name-sans-extension (buffer-file-name)) "-img"))
;;  (setq org-download-image-org-width 600)
;;  (setq org-download-link-format "[[file:%s]]\n"
;;        org-download-abbreviate-filename-function #'file-relative-name)
;;  (setq org-download-link-format-function #'org-download-link-format-function-default))

(require 'org)

(defun org-cycle-hide-drawers (state)
  "Re-hide all drawers after a visibility state change."
  (when (and (derived-mode-p 'org-mode)
             (not (memq state '(overview folded contents))))
    (save-excursion
      (let* ((globalp (memq state '(contents all)))
             (beg (if globalp
                    (point-min)
                    (point)))
             (end (if globalp
                    (point-max)
                    (if (eq state 'children)
                      (save-excursion
                        (outline-next-heading)
                        (point))
                      (org-end-of-subtree t)))))
        (goto-char beg)
        (while (re-search-forward org-drawer-regexp end t)
          (save-excursion
            (beginning-of-line 1)
            (when (looking-at org-drawer-regexp)
              (let* ((start (1- (match-beginning 0)))
                     (limit
                       (save-excursion
                         (outline-next-heading)
                           (point)))
                     (msg (format
                            (concat
                              "org-cycle-hide-drawers:  "
                              "`:END:`"
                              " line missing at position %s")
                            (1+ start))))
                (if (re-search-forward "^[ \t]*:END:" limit t)
                  (outline-flag-region start (point-at-eol) t)
                  (user-error msg))))))))))


(provide 'config)
;;; config.el ends here
