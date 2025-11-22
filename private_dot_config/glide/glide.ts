glide.prefs.set("toolkit.legacyUserProfileCustomizations.stylesheets", true);
glide.prefs.set("devtools.debugger.prompt-connection", false);
glide.prefs.set("media.videocontrols.picture-in-picture.audio-toggle.enabled", true);
glide.prefs.set("browser.tabs.insertAfterCurrent", false);
glide.prefs.set("browser.tabs.insertRelatedAfterCurrent", false);
glide.prefs.set("browser.uidensity", 1);
glide.prefs.set("browser.startup.page", 3);
glide.prefs.set("browser.warnOnQuitShortcut", false);

const plugins = [
	"https://addons.mozilla.org/firefox/downloads/file/4429158/kagi_search_for_firefox-0.7.6.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4602298/1password_x_password_manager-8.11.15.5.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4579487/readwise_highlighter-0.15.25.xpi",
	"https://addons.mozilla.org/firefox/downloads/file/4385912/icloud_hide_my_email-1.2.9.xpi",
];

for (const plugin of plugins) {
	glide.addons.install(plugin);
}

glide.unstable.include("glide.work.ts");

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

glide.keymaps.set("normal", "<leader>ff", "commandline_show tab ", { description: "Open tab switcher" });

glide.keymaps.set(
	"normal",
	"u",
	async () => {
		await browser.sessions.restore();
	},
	{ description: "Open recently closed tab" },
);

glide.keymaps.set(
	"normal",
	"/",
	async () => {
		await glide.keys.send("<d-f>");
	},
	{ description: "Search forward" },
);

type Address = `http://${string}` | `https://${string}`;
type GitHubParams = {
	addr: Address;
	org: string;
	repo: string;
	issue?: string;
};

function github_params(url: URL): GitHubParams | null {
	const PROJECTS_URL_PATTERN = /https:\/\/github(.*)\.com\/orgs\/(.+)\/projects\/(\d+)/;
	const DEFAULT_PATTERN = /https:\/\/github(.*)\.com\/(.+)\/(.+)/;

	const addr = `${url.protocol}//${url.host}` as Address;

	if (PROJECTS_URL_PATTERN.test(url.href)) {
		const match = url.href.match(PROJECTS_URL_PATTERN);
		if (!match) {
			return null;
		}

		const issueQuery = url.searchParams.get("issue") ?? "";
		if (!issueQuery) {
			return null;
		}

		const [org, repo, issue] = issueQuery.split("|");

		if (!org || !repo || !issue) {
			return null;
		}

		return { addr, org, repo, issue: issueQuery };
	}

	if (DEFAULT_PATTERN.test(url.href)) {
		const match = url.href.match(DEFAULT_PATTERN);
		if (!match) {
			return null;
		}

		const path = url.pathname.slice(1).split("/");
		if (path.length < 2) {
			return null;
		}

		const org = path[0];
		const repo = path[1];

		if (!org || !repo) {
			return null;
		}

		return { addr, org, repo };
	}

	return null;
}

// GitHub mappings.
glide.autocmds.create("UrlEnter", /https:\/\/github(.*)\.com/, () => {
	const must_github_params = <T>(fn: (params: GitHubParams) => T): T | undefined => {
		const params = github_params(glide.ctx.url);
		if (!params) {
			return;
		}

		return fn(params);
	};

	const with_issue_url = (
		fn: (args: { params: GitHubParams; issue_addr: string }) => void | Promise<void>,
	): void | Promise<void> => {
		return must_github_params((params) => {
			const { addr, org, repo, issue } = params;
			const repo_addr = `${addr}/${org}/${repo}`;
			if (!issue) {
				console.log("No issue specified, opening issues list", { params }, `${repo_addr}/issues`);
				return fn({ params, issue_addr: `${repo_addr}/issues` });
			}

			const issue_addr = `${addr}/${org}/${repo}/issues/${issue}`;
			return fn({ params, issue_addr });
		});
	};

	const with_repo_url = (
		fn: (args: { params: GitHubParams; repo_addr: string }) => void | Promise<void>,
	): void | Promise<void> => {
		return must_github_params((params) => {
			const { addr, org, repo } = params;
			const repo_addr = `${addr}/${org}/${repo}`;
			return fn({ params, repo_addr });
		});
	};

	const with_prs_url = (
		fn: (args: { params: GitHubParams; prs_addr: string }) => void | Promise<void>,
	): void | Promise<void> => {
		return must_github_params((params) => {
			const { addr, org, repo } = params;
			const prs_addr = `${addr}/${org}/${repo}/pulls`;
			return fn({ params, prs_addr });
		});
	};

	glide.buf.keymaps.set(
		"normal",
		"<C-g>i",
		async ({ tab_id }) => {
			with_issue_url(async ({ issue_addr }) => {
				console.log(">>>>>>> Navigating to issue:", issue_addr);
				await browser.tabs.update(tab_id, { url: issue_addr });
			});
		},
		{ description: "Open specific GitHub issue or issue list in the current tab" },
	);

	glide.buf.keymaps.set(
		"normal",
		"<C-g>I",
		async ({ tab_id }) => {
			with_issue_url(async ({ issue_addr }) => {
				await browser.tabs.create({
					url: issue_addr,
					active: true,
					openerTabId: tab_id,
				});
			});
		},
		{ description: "Open specific GitHub issue or issue list in a new tab" },
	);

	glide.buf.keymaps.set(
		"normal",
		"<C-g>r",
		async ({ tab_id }) => {
			with_repo_url(async ({ repo_addr }) => {
				await browser.tabs.update(tab_id, { url: repo_addr });
			});
		},
		{ description: "Open GitHub repo root in the current tab" },
	);

	glide.buf.keymaps.set(
		"normal",
		"<C-g>R",
		async ({ tab_id }) => {
			with_repo_url(async ({ repo_addr }) => {
				await browser.tabs.create({
					url: repo_addr,
					active: true,
					openerTabId: tab_id,
				});
			});
		},
		{ description: "Open GitHub repo root in the current tab" },
	);

	glide.buf.keymaps.set(
		"normal",
		"<C-g>p",
		async ({ tab_id }) => {
			with_prs_url(async ({ prs_addr }) => {
				await browser.tabs.update(tab_id, { url: prs_addr });
			});
		},
		{ description: "Open GitHub pull requests list in the current tab" },
	);

	glide.buf.keymaps.set(
		"normal",
		"<C-g>P",
		async ({ tab_id }) => {
			with_prs_url(async ({ prs_addr }) => {
				await browser.tabs.create({
					url: prs_addr,
					active: true,
					openerTabId: tab_id,
				});
			});
		},
		{ description: "Open GitHub pull requests list in a new tab" },
	);

	if (glide.ctx.url.hostname === "github.com") {
		glide.buf.keymaps.set(
			"normal",
			"<C-g>g",
			async ({ tab_id }) => {
				must_github_params(async (params) => {
					const { org, repo } = params;
					const url = `https://pkg.go.dev/github.com/${org}/${repo}`;
					await browser.tabs.update(tab_id, { url });
				});
			},
			{ description: "Open Go package documentation for this GitHub repo" },
		);

		glide.buf.keymaps.set(
			"normal",
			"<C-g>G",
			async ({ tab_id }) => {
				must_github_params(async (params) => {
					const { org, repo } = params;
					const url = `https://pkg.go.dev/github.com/${org}/${repo}`;
					await browser.tabs.create({
						url,
						active: true,
						openerTabId: tab_id,
					});
				});
			},
			{ description: "Open Go package documentation for this GitHub repo in a new tab" },
		);
	}
});

glide.keymaps.set(
	"normal",
	"wi",
	async () => {
		await glide.keys.send("<D-A-i>");
	},
	{ description: "Open devtools inspector" },
);

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

glide.keymaps.set(
	"normal",
	"<leader>go",
	async () => {
		await glide.keys.send("<D-S-k>");
	},
	{ description: "Focus on Okta extension" },
);

glide.keymaps.set("normal", "<C-,>", "blur");

// https://github.com/glide-browser/glide/discussions/114#discussioncomment-15009330
function on_tab_enter(
	pattern: glide.AutocmdPatterns["UrlEnter"],
	callback: (args: glide.AutocmdArgs["UrlEnter"]) => void | Promise<void>,
): void {
	let last_tab_id: number | undefined;
	glide.autocmds.create("UrlEnter", pattern, async (props) => {
		const is_tab_enter = last_tab_id !== props.tab_id;
		last_tab_id = props.tab_id;
		// only trigger on tab enter, not URL change within same tab
		if (is_tab_enter) {
			await callback(props);
		}
	});
}

// It's annoying to be in insert mode when switching tabs.
on_tab_enter({}, async ({ url }) => {
	if (url !== "about:newtab") {
		// HACK: sleep is needed when switching tabs quickly, otherwise `mode_change normal` may not take effect
		await new Promise((resolve) => setTimeout(resolve, 50));
		await glide.excmds.execute("mode_change normal");
	}
});

const cmd = glide.excmds.create({ name: "tab_edit", description: "Edit tabs in a text editor" }, async () => {
	const tabs = await browser.tabs.query({ pinned: false });

	const tab_lines = tabs.map((tab) => {
		const title = tab.title?.replace(/\n/g, " ") || "No Title";
		const url = tab.url || "about:blank";
		return `${tab.id}: ${title} (${url})`;
	});

	const mktempcmd = await glide.process.execute("mktemp", ["-t", "glide_tab_edit.XXXXXX"]);

	let stdout = "";
	for await (const chunk of mktempcmd.stdout) {
		stdout += chunk;
	}
	const temp_filepath = stdout.trim();

	tab_lines.unshift("// Delete the corresponding lines to close the tabs");
	tab_lines.unshift("// vim: ft=qute-tab-edit");
	tab_lines.unshift("");
	await glide.fs.write(temp_filepath, tab_lines.join("\n"));

	console.log("Temp file created at:", temp_filepath);

	const editcmd = await glide.process.execute("open", [
		"-W",
		"-a",
		"Ghostty",
		"-n",
		"--args",
		`--command=/opt/homebrew/bin/fish -c 'nvim "${temp_filepath}"'`,
		"--config-file=" + "~/.config/ghostty/config-qute",
		"--config-default-files=false",
		"--quit-after-last-window-closed=true",
	]);

	const cp = await editcmd.wait();
	if (cp.exit_code !== 0) {
		throw new Error(`Editor command failed with exit code ${cp.exit_code}`);
	}

	// read the edited file
	const edited_content = await glide.fs.read(temp_filepath, "utf8");
	const edited_lines = edited_content
		.split("\n")
		.filter((line) => line.trim().length > 0)
		.filter((line) => !line.startsWith("//"));

	const tabs_to_keep = edited_lines.map((line) => {
		const tab_id = line.split(":")[0];
		return Number(tab_id);
	});

	const tab_ids_to_close = tabs
		.filter((tab) => tab.id && !tabs_to_keep.includes(tab.id))
		.map((tab) => tab.id)
		.filter((id): id is number => id !== undefined);
	await browser.tabs.remove(tab_ids_to_close);
});

declare global {
	interface ExcmdRegistry {
		my_excmd: typeof cmd;
	}
}

glide.keymaps.set(
	"insert",
	"<C-x><C-x>",
	async () => {
		const is_editing = await glide.ctx.is_editing();
		if (!is_editing) {
			return;
		}

		const current_tab = await glide.tabs.active();
		const content = await glide.content.execute(
			// Runs in page context.
			() => {
				const elements = [];
				function get_frame_offset(frame) {
					if (frame === null) {
						// Dummy object with zero offset
						return {
							top: 0,
							right: 0,
							bottom: 0,
							left: 0,
							height: 0,
							width: 0,
						};
					}
					return frame.frameElement.getBoundingClientRect();
				}

				function add_offset_rect(base, offset) {
					return {
						top: base.top + offset.top,
						left: base.left + offset.left,
						bottom: base.bottom + offset.top,
						right: base.right + offset.left,
						height: base.height,
						width: base.width,
					};
				}

				function serialize_elem(elem, frame = null) {
					if (!elem) {
						return null;
					}

					const id = elements.length;
					elements[id] = elem;

					const caret_position = elem.selectionStart;

					// isContentEditable occasionally returns undefined.
					const is_content_editable = elem.isContentEditable || false;

					const out = {
						id: id,
						rects: [], // Gets filled up later
						caret_position: caret_position,
						is_content_editable: is_content_editable,
					};

					// Deal with various fun things which can happen in form elements
					// https://github.com/qutebrowser/qutebrowser/issues/2569
					// https://github.com/qutebrowser/qutebrowser/issues/2877
					// https://stackoverflow.com/q/22942689/2085149
					if (typeof elem.tagName === "string") {
						out.tag_name = elem.tagName;
					} else if (typeof elem.nodeName === "string") {
						out.tag_name = elem.nodeName;
					} else {
						out.tag_name = "";
					}

					if (typeof elem.className === "string") {
						out.class_name = elem.className;
					} else {
						// e.g. SVG elements
						out.class_name = "";
					}

					if (typeof elem.value === "string" || typeof elem.value === "number") {
						out.value = elem.value;
					} else {
						out.value = "";
					}

					if (typeof elem.outerHTML === "string") {
						out.outer_xml = elem.outerHTML;
					} else {
						out.outer_xml = "";
					}

					if (typeof elem.textContent === "string") {
						out.text = elem.textContent;
					} else if (typeof elem.text === "string") {
						out.text = elem.text;
					} // else: don't add the text at all

					const attributes = {};
					for (let i = 0; i < elem.attributes.length; ++i) {
						const attr = elem.attributes[i];
						attributes[attr.name] = attr.value;
					}
					out.attributes = attributes;

					const client_rects = elem.getClientRects();
					const frame_offset_rect = get_frame_offset(frame);

					for (let k = 0; k < client_rects.length; ++k) {
						const rect = client_rects[k];
						out.rects.push(add_offset_rect(rect, frame_offset_rect));
					}

					// console.log(JSON.stringify(out));

					return out;
				}

				function iframe_same_domain(frame) {
					try {
						frame.document; // eslint-disable-line no-unused-expressions
						return true;
					} catch (exc) {
						if (exc instanceof DOMException && exc.name === "SecurityError") {
							// FIXME:qtwebengine This does not work for cross-origin frames.
							return false;
						}
						throw exc;
					}
				}

				function call_if_frame(elem, func) {
					// Check if elem is a frame, and if so, call func on the window
					if ("contentWindow" in elem) {
						const frame = elem.contentWindow;
						if (iframe_same_domain(frame) && "frameElement" in elem.contentWindow) {
							return func(frame);
						}
					}
					return null;
				}

				function find_focused() {
					const elem = document.activeElement;

					if (!elem || elem === document.body) {
						// "When there is no selection, the active element is the page's
						// <body> or null."
						return null;
					}

					// Check if we got an iframe, and if so, recurse inside of it
					const frame_elem = call_if_frame(elem, (frame) => serialize_elem(frame.document.activeElement, frame));

					if (frame_elem !== null) {
						return frame_elem;
					}
					return serialize_elem(elem);
				}

				return find_focused();
			},
			{
				tab_id: current_tab.id,
			},
		);

		console.log("Content to edit:", content);
	},
	{ description: "Edit currently focused element in external browser" },
);
