glide.prefs.set("toolkit.legacyUserProfileCustomizations.stylesheets", true);
glide.prefs.set("devtools.debugger.prompt-connection", false);
glide.prefs.set("media.videocontrols.picture-in-picture.audio-toggle.enabled", true);
glide.prefs.set("browser.tabs.insertAfterCurrent", true);
glide.prefs.set("browser.tabs.insertRelatedAfterCurrent", true);
glide.prefs.set("browser.uidensity", 1);
glide.prefs.set("browser.startup.page", 3);
glide.prefs.set("browser.warnOnQuitShortcut", false);

const plugins = [
	"https://addons.mozilla.org/firefox/downloads/file/4429158/kagi_search_for_firefox-0.7.6.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4602298/1password_x_password_manager-8.11.15.5.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4579487/readwise_highlighter-0.15.25.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4385912/icloud_hide_my_email-1.2.9.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4409277/prometheus_formatter-3.2.0.xpi",
];

for (const plugin of plugins) {
	glide.addons.install(plugin);
}

glide.include("glide.work.ts");
glide.include("github.glide.ts");
glide.include("commands.glide.ts");

glide.g.mapleader = "\\";
glide.o.hint_size = "16px";
glide.o.hint_chars = "asdfghjkl";

glide.keymaps.set(
	"normal",
	"<leader><C-r>",
	async () => {
		await browser.notifications.create({ type: "basic", title: "Glide", message: "Glide config reloaded" });
		await glide.excmds.execute("config_reload");
	},
	{ description: "Reload Glide config" },
);

glide.keymaps.set("normal", "<C-f>", "hint --location=browser-ui");

// Reset urlbar.openintab when leaving insert mode so normal navigation stays in current tab.
glide.autocmds.create("ModeChanged", "insert:*", async () => {
	glide.prefs.set("browser.urlbar.openintab", false);
});

glide.keymaps.set(
	"normal",
	"o",
	async () => {
		glide.prefs.set("browser.urlbar.openintab", false);
		const tab = await glide.tabs.active();
		if (tab.pinned) {
			glide.prefs.set("browser.urlbar.openintab", true);
		}
		await glide.keys.send("<D-l>");
	},
	{ description: "Focus the address bar" },
);

glide.keymaps.set(
	"normal",
	"O",
	async () => {
		glide.prefs.set("browser.urlbar.openintab", true);
		await glide.keys.send("<D-l>");
	},
	{ description: "Focus the address bar (open in new tab)" },
);

glide.keymaps.set("normal", "J", "tab_next", { description: "Next tab" });
glide.keymaps.set("normal", "K", "tab_prev", { description: "Previous tab" });
glide.keymaps.set("normal", "r", "reload", { description: "Reload the page" });
glide.keymaps.set("normal", "R", "reload_hard", { description: "Reload the page, bypass cache" });

glide.keymaps.set(
	"normal",
	"d",
	async ({ tab_id }) => {
		const tab = await browser.tabs.get(tab_id);

		if (tab.pinned) {
			browser.notifications.create({
				type: "basic",
				title: "Glide",
				message: "Cannot close a pinned tab",
			});
			return;
		}

		await glide.excmds.execute("tab_close");
	},
	{ description: "Close current tab, unless it's pinned" },
);

glide.keymaps.set("normal", "D", "tab_close", { description: "Close current tab" });

glide.keymaps.set("normal", "<C-]>", "forward", { description: "Go forward in history" });
glide.keymaps.set("normal", "<C-[>", "back", { description: "Go back in history" });
glide.keymaps.set("normal", "<leader>ff", "commandline_show tab ", { description: "Open tab switcher" });

glide.keymaps.set("normal", "u", "tab_reopen", { description: "Reopen recently closed tab" });

glide.keymaps.set("normal", "/", () => glide.findbar.open({ highlight_all: true, query: "" }), { description: "Search" });

glide.keymaps.set(
	"insert",
	"<CR>",
	async () => {
		if (glide.findbar.is_focused()) {
			await glide.keys.send("<CR>", { skip_mappings: true });
			await glide.excmds.execute("mode_change normal");
		} else {
			await glide.keys.send("<CR>", { skip_mappings: true });
		}
	},
	{ description: "Submit and exit to normal mode if in findbar" },
);

glide.keymaps.set(
	"normal",
	"n",
	async () => {
		if (glide.findbar.is_open()) {
			await glide.findbar.next_match();
		}
	},
	{ description: "Next search match" },
);

glide.keymaps.set(
	"normal",
	"N",
	async () => {
		if (glide.findbar.is_open()) {
			await glide.findbar.previous_match();
		}
	},
	{ description: "Previous search match" },
);

glide.keymaps.set(
	"normal",
	"<leader>nh",
	async () => {
		await glide.findbar.close();
		await browser.find.removeHighlighting();
	},
	{ description: "Close findbar and clear highlights" },
);

glide.keymaps.set(
	"normal",
	"wi",
	async () => {
		await glide.keys.send("<D-A-i>");
	},
	{ description: "Open devtools inspector" },
);

glide.keymaps.set(
	"normal",
	"<leader>go",
	async () => {
		await glide.keys.send("<D-S-k>");
	},
	{ description: "Focus on Okta extension" },
);

glide.keymaps.set("command", "<C-j>", "commandline_focus_next");
glide.keymaps.set("command", "<C-k>", "commandline_focus_back");

glide.keymaps.set(
	"normal",
	"<C-;>",
	async ({ tab_id }) => {
		const tab = await browser.tabs.get(tab_id);
		await browser.tabs.update(tab_id, { pinned: !tab.pinned });
	},
	{ description: "Toggle pin for current tab" },
);

glide.keymaps.set(
	"normal",
	"ym",
	async ({ tab_id }) => {
		const tab = await browser.tabs.get(tab_id);
		await navigator.clipboard.writeText(`[${tab.title}](${tab.url})`);
	},
	{ description: "Yank markdown link" },
);

glide.keymaps.set(
	"normal",
	"F",
	async ({ tab_id }) => {
		glide.hints.show({
			selector: "[href]",
			async action({ content }) {
				const href = await content.execute((target) => (target as HTMLAnchorElement).href);
				await browser.tabs.create({ url: href, active: false, openerTabId: tab_id });
			},
		});
	},
	{ description: "Open link in a new background tab" },
);

glide.keymaps.set(
	"normal",
	"<leader>tt",
	() => {
		const v = glide.o.native_tabs;
		if (["autohide", "show"].includes(v)) {
			glide.o.native_tabs = "hide";
			return;
		}
		glide.o.native_tabs = "show";
	},
	{ description: "Toggle tab bar" },
);

glide.keymaps.set("normal", "<leader>h", async () => {
	const entries = await browser.history.search({
		text: "",
		endTime: Date.now(),
		startTime: Date.now() - 7 * 24 * 60 * 60 * 1000, // last 7 days
		maxResults: 10000,
	});

	glide.commandline.show({
		title: "history",
		options: entries.map((entry) => ({
			label: `${entry.title} - ${entry.url}`,
			async execute() {
				const tab = await glide.tabs.get_first({
					url: entry.url,
				});
				if (tab) {
					await browser.tabs.update(tab.id, {
						active: true,
					});
				} else {
					await browser.tabs.create({
						active: true,
						url: entry.url,
					});
				}
			},
		})),
	});
});

glide.keymaps.set("normal", "<C-,>", "blur");
