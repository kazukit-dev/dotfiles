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

      my-skills = {
        path = ../../agents/skills;
      };
    };

    skills.enableAll = true;

    targets = {
      claude = {
        enable = true;
        dest = ".config/claude/skills";
        structure = "link";
      };

      codex = {
        enable = true;
        dest = ".config/codex/skills";
        structure = "link";
      };
    };
  };

}
