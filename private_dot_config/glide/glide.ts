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

glide.keymaps.set(
	"normal",
	"<S-o>",
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
