{ lib, ... }:
{

  programs.agent-skills = {
    enable = true;

    sources = {
      ast-grep = {
        input = "ast-grep-skills";
        subdir = "ast-grep/skills";
      };

      anthropic = {
        input = "anthropic-skills";
        subdir = "skills";
      };

      context7 = {
        input = "context7-skills";
        subdir = "skills";
      };

      agent-browser = {
        input = "agent-browser-skills";
        subdir = "skills";
      };

      mizchi = {
        input = "mizchi-skills";
      };

      natural-japanese = {
        input = "natural-japanese-skills";
        subdir = "skills";
      };

      herdr = {
        input = "herdr-skills";
        subdir = "skills";
      };

      vercel = {
        input = "vercel-skills";
        subdir = "skills";
      };

      my-skills = {
        path = ../../agents/skills;
      };
    };

    skills = {
      enableAll = [
        "ast-grep"
        "anthropic"
        "agent-browser"
        "natural-japanese"
        "herdr"
        "my-skills"
      ];

      explicit = {
        empirical-prompt-tuning = {
          from = "mizchi";
          path = "empirical-prompt-tuning";
        };

        vercel-react-best-practices = {
          from = "vercel";
          path = "react-best-practices";
        };

        vercel-composition-patterns = {
          from = "vercel";
          path = "composition-patterns";
        };

        vercel-react-view-transitions = {
          from = "vercel";
          path = "react-view-transitions";
        };

        context7-cli = {
          from = "context7";
          path = "context7-cli";
          transform =
            { original, ... }:
            let
              installInstructions = ''
                Make sure the CLI is up to date before running commands:

                ```bash
                npm install -g ctx7@latest
                ```

                Or run directly without installing:

                ```bash
                npx ctx7@latest <command>
                ```
              '';
              nixManagedInstructions = ''
                The CLI is managed by Nix in this dotfiles repository. Use the
                `ctx7` executable from the user's environment; do not install or
                run it with `npm install -g`, `npx`, `pnpm dlx`, or similar
                package-runner commands.

                ```bash
                ctx7 <command>
                ```
              '';
            in
            if !lib.hasInfix installInstructions original then
              throw "agent-skills: the upstream context7-cli SKILL.md no longer contains the paragraph that installs ctx7 with npm install -g / npx. Review the context7-cli transform in nix/home/agent-skills.nix."
            else
              ''
                ${builtins.replaceStrings
                  [
                    installInstructions
                    "npx ctx7@latest "
                  ]
                  [
                    nixManagedInstructions
                    "ctx7 "
                  ]
                  original
                }
              '';
        };
      };
    };

    # rsync --delete で同期するので、Claude アプリが skills/synced に置くスキルと
    # Codex の .system は、除外しておかないと消される
    excludePatterns = [
      "/.system"
      "/synced"
    ];

    targets = {
      claude = {
        enable = true;
        dest = "~/.config/claude/skills";
        structure = "symlink-tree";
      };

      codex = {
        enable = true;
        dest = "~/.config/codex/skills";
        structure = "symlink-tree";
      };
    };
  };

}
