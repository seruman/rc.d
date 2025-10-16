glide.prefs.set("toolkit.legacyUserProfileCustomizations.stylesheets", true);
glide.prefs.set("devtools.debugger.prompt-connection", false);
glide.prefs.set("media.videocontrols.picture-in-picture.audio-toggle.enabled", true);
glide.prefs.set("browser.tabs.insertAfterCurrent", false);
glide.prefs.set("browser.tabs.insertRelatedAfterCurrent", false);
glide.prefs.set("browser.uidensity", 1);
glide.prefs.set("browser.startup.page", 3);
glide.prefs.set("browser.warnOnQuitShortcut", false);

glide.g.mapleader = "\\";
glide.o.hint_size = "16px";

glide.keymaps.set("normal", "o", "keys <D-l>", {
	description: "Focus the address bar",
});

glide.keymaps.set("normal", "<S-j>", "tab_next", {
	description: "Scroll down",
});

glide.keymaps.set("normal", "<S-k>", "tab_prev", {
	description: "Scroll down",
});

glide.keymaps.set("normal", "r", "reload", { description: "Reload the page" });
glide.keymaps.set("normal", "R", "reload_hard", { description: "Reload the page, bypass cache" });

glide.keymaps.set(
	"normal",
	"O",
	async ({ tab_id }) => {
		await browser.tabs.create({ active: true, openerTabId: tab_id });
		await glide.keys.send("<D-l>");
	},
	{ description: "Open a new tab and focus the address bar" },
);

glide.keymaps.set(
	"normal",
	"d",
	async ({ tab_id }) => {
		await browser.tabs.remove(tab_id);
	},
	{ description: "Close current tab" },
);

glide.keymaps.set("normal", "<C-]>", "forward", {
	description: "Go forward in history",
});
glide.keymaps.set("normal", "<C-[>", "back", {
	description: "Go back in history",
});

glide.keymaps.set(
	"normal",
	"u",
	async () => {
		await browser.sessions.restore();
	},
	{ description: "Open recently closed tab" },
);

glide.autocmds.create("UrlEnter", /https:\/\/github\.com\/.*\/.*/, () => {
	glide.buf.keymaps.set("normal", "<C-g>p", async ({ tab_id }) => {
		const path = glide.ctx.url.pathname;
		const { org, repo } = path.match(/^\/(?<org>[^/]+)\/(?<repo>[^/]+)/)?.groups ?? {};

		const pkggodev_url = `https://pkg.go.dev/github.com/${org}/${repo}`;
		await browser.tabs.create({
			url: pkggodev_url,
			active: true,
			openerTabId: tab_id,
		});
	});
});

glide.keymaps.set("normal", "wi", async () => {
	await glide.keys.send("<D-A-i>");
});

glide.keymaps.set("normal", "<Leader>pr", async () => {
	const cmd = await glide.process.execute("/opt/homebrew/bin/fish", ["-c", "ghwu"]);
	let stdout = "";
	for await (const chunk of cmd.stdout) {
		stdout += chunk;
	}

	const selection = stdout
		.split("\n")
		.map((s) => s.trim())
		.filter(Boolean);

	if (selection.length === 0) {
		return;
	}

	const url = selection[0];
	await browser.tabs.create({ url, active: true });
});

// Refocus the page when leaving the command mode.
// https://github.com/glide-browser/glide/discussions/30#discussioncomment-14661338
glide.autocmds.create("ModeChanged", "command:*", focus_page);
glide.keymaps.set("normal", "<Esc>", async () => {
	await glide.keys.send("<Esc>", { skip_mappings: true });

	if (await glide.ctx.is_editing()) {
		await focus_page();
	}
});

async function focus_page() {
	// HACK: defocus the editable element by focusing the address bar and then
	// refocusing the page
	await glide.keys.send("<F6>", { skip_mappings: true });
	await new Promise((resolve) => setTimeout(resolve, 100));
	// check insert mode for address bar
	if (glide.ctx.mode === "insert") {
		await glide.keys.send("<F6>", { skip_mappings: true });
	}
}
