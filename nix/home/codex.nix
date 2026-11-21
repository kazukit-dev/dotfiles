_: {
  programs.codex = {
    enable = true;
    # 本体は packages.nix で llm-agents から入れている
    package = null;
    # Codex は信頼したプロジェクトや hooks の信頼状態を config.toml に書き込むので、
    # 読み取り専用にせず、宣言した値を switch のたびにマージする
    mutableSettings = true;

    settings = {
      model = "gpt-6.1-sol";
      model_reasoning_effort = "medium";
      personality = "pragmatic";
      service_tier = "default";

      # --approve-for-me と同じ組み合わせ。承認が要る操作は人に聞かずに自動レビューに判断させる
      approvals_reviewer = "auto_review";
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";

      # ローカルの otel-lgtm（nix run .#lgtm）に送る。プロンプトの本文は送らない
      otel = {
        exporter.otlp-grpc.endpoint = "http://localhost:4317";
        log_user_prompt = false;
      };
    };
  };
}
