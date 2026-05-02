_: {

  programs.agent-skills = {
    enable = true;

    sources.ast-grep = {
      input = "ast-grep-skill";
      subdir = "ast-grep/skills";
    };

    sources.my-skills = {
      path = ../../agents/skills;
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
