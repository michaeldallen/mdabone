# Multi-Repository Workspace Setup in GitHub Codespaces

This guide outlines how to set up the equivalent of a VS Code multi-root workspace (multiple repositories side-by-side) in a web-hosted GitHub Codespace using a **Control Repository** pattern. This control repository serves as the single entry point that orchestrates repository access, clones the secondary repositories, and configures VS Code to show them as separate workspace roots.

## Architecture & Layout

```
/workspaces/
  ├── workspace-hub/          <-- Your main entry-point / control repository
  │     ├── .devcontainer/
  │     │     └── devcontainer.json
  │     └── multi-repo.code-workspace
  ├── repo-a/                 <-- Cloned automatically on startup
  └── repo-b/                 <-- Cloned automatically on startup
```

---

## Step-by-Step Setup Plan

### Step 1: Create a "Control" Repository
On GitHub, create a new repository (e.g., `workspace-hub` or `my-codespace-workspace`). This repository can be public or private and will contain the configuration files to define the workspace.

### Step 2: Add `.devcontainer/devcontainer.json`
In your control repository, create a directory called `.devcontainer` and add a `devcontainer.json` file. 

This file:
1. Defines the base development environment image.
2. Declares the necessary permissions so GitHub Codespaces can access and clone the other repositories.
3. Automatically clones the other repositories into the persistent `/workspaces` directory.

#### Configuration Example (`.devcontainer/devcontainer.json`)
```json
{
  "name": "Multi-Repo Workspace",
  "image": "mcr.microsoft.com/devcontainers/universal:latest",
  "customizations": {
    "codespaces": {
      "repositories": {
        "your-organization-or-user/repo-a": {
          "permissions": {
            "contents": "write",
            "pull-requests": "write"
          }
        },
        "your-organization-or-user/repo-b": {
          "permissions": {
            "contents": "write",
            "pull-requests": "write"
          }
        }
      }
    }
  },
  "postCreateCommand": "bash -c 'for repo in repo-a repo-b; do [ ! -d /workspaces/$repo ] && git clone https://github.com/your-organization-or-user/$repo.git /workspaces/$repo || echo \"$repo already cloned\"; done'"
}
```

> [!NOTE]
> Replace `your-organization-or-user`, `repo-a`, and `repo-b` with your actual GitHub username/organization and repository names.
>
> Using a loop check (`[ ! -d /workspaces/$repo ]`) in the `postCreateCommand` ensures that if you rebuild or restart the Codespace, it won't crash trying to re-clone existing folders.

---

### Step 3: Create the VS Code Workspace Configuration
To make the secondary repositories appear as first-class, independent root folders in your VS Code sidebar, create a `.code-workspace` file in the root of your control repository (e.g., `multi-repo.code-workspace`):

```json
{
  "folders": [
    {
      "name": "Hub Configuration",
      "path": "."
    },
    {
      "name": "Repository A",
      "path": "../repo-a"
    },
    {
      "name": "Repository B",
      "path": "../repo-b"
    }
  ],
  "settings": {
    "git.autorefresh": true
  }
}
```

---

### Step 4: Launching and Authorizing the Codespace

1. **Commit and Push**: Commit and push `.devcontainer/devcontainer.json` and your `.code-workspace` file to your control repository on GitHub.
2. **Create the Codespace**: On your control repository page, click the green **Code** button, select the **Codespaces** tab, and click **Create codespace on main**.
3. **Grant Permissions**: Upon creation, GitHub will detect the requested permissions in `devcontainer.json` and display an authorization prompt:
   * **"Authorize Codespaces to access additional repositories..."**
   * Review the list and click **Authorize and continue**.
4. **Open the Workspace**:
   * Once the web editor loads, wait for the background `postCreateCommand` to finish cloning the other repositories.
   * Open the file tree, find your `.code-workspace` file, and open it.
   * A pop-up will appear in the bottom-right corner asking to open the workspace. Click **Open Workspace** (or run `Workspaces: Open Workspace from File...` in the Command Palette `Ctrl+Shift+P` / `Cmd+Shift+P`).
   * The editor will reload, and all of your repositories will be displayed side-by-side in the explorer sidebar with full Git capabilities!
