# Nix: Too many open files

## エラー内容

`nix flake update` 実行時に以下のエラーが発生する。

```
error:
       … while updating the lock file of flake 'git+file:///Users/kazuki/dotfiles'
       … while updating the flake input 'nixpkgs'
       … while fetching the input 'github:nixos/nixpkgs/nixos-unstable'
       error: creating a blob stream object: failed to create temporary file
              '/Users/kazuki/.cache/nix/tarball-cache-v2/objects/streamed_git2_...': Too many open files
```

## 環境

- macOS (Darwin)
- Determinate Nix 3.x
- nix-darwin + home-manager

## 原因

macOS の `launchctl limit maxfiles` のデフォルトソフトリミットは **256** と非常に低い。nix-daemon はこの制限を継承して起動するため、nixpkgs のような大きな Git リポジトリをフェッチ・展開する際に上限に達する。

macOS 再起動直後でも発生するため、ファイルディスクリプタの蓄積ではなく、デフォルト値自体が不足していることが根本原因。dotfiles の設定量や flake input の数には依存しない。

この問題は Nix に限らず、macOS の開発ツール全般（Docker, Homebrew, Watchman/React Native, Vite 等）で広く報告されている。

### nix-darwin と Determinate Nix の関係

- nix-darwin は `modules/services/nix-daemon.nix` で `SoftResourceLimits.NumberOfFiles = 1048576` を設定している
- しかし Determinate Nix は独自に nix-daemon の launchd plist を管理するため、nix-darwin のこの設定が適用されない可能性がある
- [NixOS/nix#6557](https://github.com/NixOS/nix/issues/6557) では、`NumberOfFiles` が子プロセスに伝搬しない問題が報告されており、未解決

### macOS 13.5+ の制限

macOS 13.5 以降、SIP (System Integrity Protection) により `sudo launchctl limit maxfiles` がブロックされる。Apple は意図的な変更であるとしており、代替として以下を推奨している：

1. シェルプログラム → `ulimit` をプロファイルに設定
2. デーモン/エージェント → launchd plist にサービス単位で設定
3. 自作プログラム → コード内で `setrlimit` を呼ぶ

## 解決方法

### 1. ulimit をシェル設定に追加（推奨）

`.zshrc` 等に追加して、シェルから実行する Nix コマンドのリミットを恒久的に引き上げる。

```bash
ulimit -n 65536
```

### 2. ulimit の一時的な引き上げ

シェルセッション内で一時的に上限を引き上げてからコマンドを実行する。

```bash
ulimit -n 65536
nix flake update
```

### 3. nix-daemon の再起動

デーモンが蓄積したファイルディスクリプタをリセットする。再起動直後の場合は効果がない。

```bash
sudo launchctl stop org.nixos.nix-daemon
```

停止後、次の `nix` コマンド実行時にデーモンが自動で再起動される。

## 関連 Issue

### Nix 本体

| Issue | 概要 | 状態 |
|-------|------|------|
| [NixOS/nix PR #5726](https://github.com/NixOS/nix/pull/5726) | nix-daemon の launchd plist に `NumberOfFiles = 4096` を追加 | Merged |
| [NixOS/nix#6557](https://github.com/NixOS/nix/issues/6557) | 上記の設定が子プロセスに伝搬しない | Open |
| [NixOS/nix#8684](https://github.com/NixOS/nix/issues/8684) | `nix develop` で Too many open files | Open |
| [NixOS/nix#6007](https://github.com/NixOS/nix/issues/6007) | Ubuntu multi-user で同様の問題（systemd） | Closed |

### Determinate Nix

| Issue | 概要 | 状態 |
|-------|------|------|
| [DeterminateSystems/nix-installer#1669](https://github.com/DeterminateSystems/nix-installer/issues/1669) | macOS 26 で `nix flake update` が Too many open files | Open |

### nixpkgs / nix-darwin

| Issue | 概要 | 状態 |
|-------|------|------|
| [NixOS/nixpkgs#173657](https://github.com/NixOS/nixpkgs/issues/173657) | Darwin のデフォルト maxfiles を引き上げるべき | Closed |

### macOS エコシステム全般

| Issue | ツール | 概要 |
|-------|--------|------|
| [Homebrew/brew#9120](https://github.com/Homebrew/brew/issues/9120) | Homebrew | 依存関係の多いパッケージで Too many open files |
| [docker/for-mac#4950](https://github.com/docker/for-mac/issues/4950) | Docker | Docker Desktop で Too many open files |
| [docker/for-mac#6783](https://github.com/docker/for-mac/issues/6783) | Docker | ファイルディスクリプタが解放されない |
| [facebook/watchman#923](https://github.com/facebook/watchman/issues/923) | Watchman | React Native プロジェクトで EMFILE |
| [vitejs/vite#14100](https://github.com/vitejs/vite/discussions/14100) | Vite | macOS 13.5+ で maxfiles 変更不可 |
| [Apple Developer Forums #735798](https://developer.apple.com/forums/thread/735798) | Apple | SIP による `launchctl limit` ブロックの公式見解 |
