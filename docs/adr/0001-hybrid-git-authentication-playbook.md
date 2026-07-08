# Playbook: Hybrid Git Authentication (Local Linux & GitHub Codespaces)

This guide configures a repository to seamlessly pull private submodules via **SSH** on a local Linux machine (using `ssh-agent`) and via **HTTPS** in browser-based GitHub Codespaces—using the exact same `.devcontainer` configuration.

## Setup Checklist

* [ ] [1. Configure GitHub Global Account Permissions](https://www.google.com/search?q=%231-configure-github-global-account-permissions)
* [ ] [2. Create the Dynamic Git Environment Script](https://www.google.com/search?q=%232-create-the-dynamic-git-environment-script)
* [ ] [3. Update the Devcontainer Configuration](https://www.google.com/search?q=%233-update-the-devcontainer-configuration)
* [ ] [4. Verify Local Machine Workflow](https://www.google.com/search?q=%234-verify-local-machine-workflow)
* [ ] [5. Verify Browser Codespace Workflow](https://www.google.com/search?q=%235-verify-browser-codespace-workflow)

---

## 1. Configure GitHub Global Account Permissions

*This step allows browser-based Codespaces to access your other private repositories using your browser session's secure token.*

1. Log into GitHub and click your profile picture (top-right corner) -> **Settings**.
2. In the left-hand sidebar, click on **Codespaces**.
3. Scroll down to the **Trusted repositories** section.
4. Select **All repositories** or choose **Selected repositories** and explicitly add the private repositories you intend to use as submodules.
5. Click **Save**.

---

## 2. Create the Dynamic Git Environment Script

*This script automatically runs when the container starts. It detects whether it is running in the cloud or locally, and rewrites Git URLs dynamically.*

1. Inside your repository, ensure you have a `.devcontainer/` directory.
2. Create a new file named `.devcontainer/setup-git.sh`.
3. Paste the following script into the file:

```bash
#!/bin/bash

# Check if the environment variable indicates a GitHub Codespace
if [ "$CODESPACES" = "true" ]; then
    echo "⚡ Environment: GitHub Codespaces detected."
    echo "🔄 Rewriting SSH submodule URLs to HTTPS to utilize Trusted Repositories token..."
    git config --global url."https://github.com/".insteadOf "git@github.com:"
else
    echo "💻 Environment: Local Docker Environment detected."
    echo "🔒 Leaving default SSH URL behavior intact to utilize local ssh-agent."
fi

```

4. **Crucial Step:** Mark the script as executable so the container can run it. In your local Linux terminal, run:
```bash
chmod +x .devcontainer/setup-git.sh

```



---

## 3. Update the Devcontainer Configuration

*This wires the script into your unified environment configuration so it triggers automatically.*

1. Open your `.devcontainer/devcontainer.json` file.
2. Add or append the `postCreateCommand` property to point to your new script:

```json
{
  "name": "My Hybrid Development Environment",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  
  // Triggers the environment detection script upon container creation
  "postCreateCommand": "./.devcontainer/setup-git.sh"
}

```

3. Commit `.devcontainer/devcontainer.json`, `.devcontainer/setup-git.sh`, and your `.gitmodules` (using standard `git@github.com:...` SSH paths) to your repository.

---

## 4. Verify Local Machine Workflow

*Ensure that nothing is broken on your local workstation.*

1. Open your terminal and ensure your local `ssh-agent` is active and holding your keys:
```bash
ssh-add -l

```


2. Open the project locally inside VS Code using the **Dev Containers** extension (*Reopen in Container*).
3. Open the integrated terminal inside the container and run:
```bash
git submodule update --init --recursive

```


4. Verify the console output of the build or check your git config inside the container (`git config --global --list`). It should **not** show any URL rewrites.

---

## 5. Verify Browser Codespace Workflow

*Ensure that the browser version seamlessly steps in when you are away from your machine.*

1. Navigate to your repository on GitHub via your browser.
2. Click the green **Code** button -> **Codespaces** tab -> **Create codespace on main**.
3. Once the browser-based VS Code environment finishes loading, open the integrated terminal.
4. Run the submodule update:
```bash
git submodule update --init --recursive

```


5. **Success Confirmation:** Git will transparently substitute the SSH paths for HTTPS paths, utilize your account's Trusted Repository permissions, and securely pull down your private submodules without prompting for keys.