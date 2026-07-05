_: {

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

      my-skills = {
        path = ../../agents/skills;
      };
    };

    skills = {
      enableAll = [
        "ast-grep"
        "anthropic"
        "agent-browser"
        "my-skills"
      ];

      explicit.context7-cli = {
        from = "context7";
        path = "context7-cli";
        transform =
          { original, ... }:
          let
            patched =
              builtins.replaceStrings
                [
                  "description: Use the ctx7 CLI to fetch library documentation, manage AI coding skills, and configure Context7 MCP. Activate when the user mentions \"ctx7\" or \"context7\", needs current docs for any library, wants to install/search/generate skills, or needs to set up Context7 for their AI coding agent."
                  ''
                    Make sure the CLI is up to date before running commands:

                    ```bash
                    npm install -g ctx7@latest
                    ```

                    Or run directly without installing:

                    ```bash
                    npx ctx7@latest <command>
                    ```
                  ''
                  "npx ctx7@latest "
                ]
                [
                  "description: Use when the user asks for current docs or examples for a library/framework, says to use ctx7 or Context7, needs an API signature verified against up-to-date documentation, wants to search/install/list/remove Context7 skills, or wants to set up/remove Context7 MCP with the ctx7 CLI."
                  ''
                    The CLI is managed by Nix in this dotfiles repository. Use the
                    `ctx7` executable from the user's environment; do not install or
                    run it with `npm install -g`, `npx`, `pnpm dlx`, or similar
                    package-runner commands.

                    ```bash
                    ctx7 <command>
                    ```
                  ''
                  "ctx7 "
                ]
                original;
          in
          ''
            ${patched}
          '';
      };
    };

    targets = {
      claude = {
        enable = true;
        dest = ".config/claude/skills";
        structure = "symlink-tree";
      };

      codex = {
        enable = true;
        dest = ".config/codex/skills";
        structure = "symlink-tree";
      };
    };
  };

}
