;; -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one)

(load! "stylix-colors")

(after! doom-themes
  (custom-set-faces!
    `(default :background ,stylix-base00)
    `(fringe :background ,stylix-base00)
    `(line-number :background ,stylix-base00)
    `(line-number-current-line :background ,stylix-base01)
    `(region :background ,stylix-base02)
    `(mode-line :background ,stylix-base01)
    `(mode-line-inactive :background ,stylix-base00)
    `(solaire-default-face :background ,stylix-base00)
    `(solaire-hl-line-face :background ,stylix-base01)
    `(vertical-border :background ,stylix-base00)
    `(header-line :background ,stylix-base00)))

(setq doom-font      (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-big-font  (font-spec :family "JetBrainsMono Nerd Font" :size 25))

(after! doom-themes
  (setq doom-themes-enable-bold   t
        doom-themes-enable-italic t))

(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")
(setq org-agenda-files '("~/org/agenda.org"))

(map! :g "M-H" #'centaur-tabs-backward
      :g "M-L" #'centaur-tabs-forward)

(map! :leader
      "SPC" #'find-file)

(after! vterm
  (define-key vterm-mode-map (kbd "C-S-v")
    (lambda () (interactive)
      (vterm-send-string (shell-command-to-string "wl-paste -n")))))

(map! :after vterm
      :map vterm-mode-map
      "M-<escape>" #'vterm-send-escape)

(map! "C-S-v" (cmd! (insert (shell-command-to-string "wl-paste -n"))))

(setq evil-ex-visual-char-range nil
      ;evil-ex-complete-emacs-commands nil
      evil-vsplit-window-right t
      evil-split-window-below t
      ;evil-kill-on-visual-paste nil
      )

(after! projectile
  (setq projectile-switch-project-action #'projectile-dired))

(use-package! msgpack)
(use-package! tramp-rpc)
(setq tramp-rpc-deploy-git-build-policy 'release)

(use-package! claude-code-ide
  :bind ("C-c C-g" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools

(use-package! caddyfile-mode
  :mode ("Caddyfile\\(?:\\..*\\)?\\'" . caddyfile-mode))

(use-package! prisma-ts-mode
  :mode "\\.prisma\\'")
;; formatter
(after! apheleia
  (setf (alist-get 'prisma-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'prisma-ts-mode apheleia-mode-alist) 'prettier))
;; syntax highlighter
(after! treesit
  (add-to-list 'treesit-language-source-alist
               '(prisma "https://github.com/victorhqc/tree-sitter-prisma"))
  (unless (treesit-language-available-p 'prisma)
    (treesit-install-language-grammar 'prisma)))
;; lsp
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(prisma-ts-mode . "prisma"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("prisma-language-server" "--stdio"))
    :activation-fn (lsp-activate-on "prisma")
    :server-id 'prisma-ls)))
(add-hook 'prisma-ts-mode-hook #'lsp-deferred)
